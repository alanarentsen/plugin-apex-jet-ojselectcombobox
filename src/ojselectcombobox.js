"use strict";

var adbc = adbc || {};
adbc.jet_version = require.s.contexts._.config.paths.ojs.substring(require.s.contexts._.config.paths.ojs.lastIndexOf("/oraclejet/") + 11
    , require.s.contexts._.config.paths.ojs.lastIndexOf("/js/"));
adbc.app_id = apex.item('pFlowId').getValue();
adbc.app_page_id = apex.item('pFlowStepId').getValue();
adbc.app_base_url = apex_img_dir + 'libraries/oraclejet/' + adbc.jet_version + '/js/';
adbc.app_base_css_url = apex_img_dir + 'libraries/oraclejet/' + adbc.jet_version + '/css/';
adbc.ko = {};

//load knockout because [require jet] from apex doesn't
requirejs.config(
    {
        paths:
        {
            'knockout': adbc.app_base_url + 'libs/knockout/knockout-3.4.0',
            'css': adbc.app_base_url + 'libs/require-css/css.min'
        },
    }
);

//create or reuse global widget for all the ojet components
var widget = widget || {};
widget.ojet = window.ojet || {};

//create the ojselectcombobox object
widget.ojet.ojselectcombobox = (function (debug, util, server, item, message) {
    var defaultOptions = {
        value: '',
        options: '[]',
        component: 'ojSelect',
        placeholder: '',
        disabled: false,
        multiple: false
    };

    var items = [];
    var tempItem = {};

    let _create = function (itemId, options) {
        // copy options and apply defaults
        options = $.extend(true, {}, defaultOptions, options);
        options.value = util.toArray(options.value !== '' ? options.value : null);

        //DOM item (1 per grid)
        var item$ = $('#' + itemId + '_OJETCONTAINER');
        var validityItem$ = $('#' + itemId);

        //plugin data
        var viewModel = {};

        //interactive grid data
        var ig = {};
        ig.grid$ = item$.closest('.t-IRR-region') || [];
        ig.isGrid = ig.grid$.length === 1;
        ig.data = null;

        if (ig.isGrid) {
            ig.grid$.on("interactivegridviewmodelcreate", function (event, currentView) {
                ig.isGrid = true;
                ig.widget = apex.region(event.currentTarget.id).widget();
                ig.column = ig.widget.interactiveGrid('option', 'config').columns.filter(a => { return a.staticId === itemId });
                ig.columnName = '';

                //todo: check if this item is in the ig
                if (ig.column.length > 0) {
                    ig.columnName = ig.column[0].name;
                }
            });

            //this event only fires when starting to edit the interactive grid row
            ig.grid$.on('apexbeginrecordedit', function (event, data) {
                //save the editing record data globally in the plugin
                ig.data = data;
            });
        }

        //initialize view and viewmodel
        require(['ojs/ojcore', 'knockout', 'jquery', 'ojs/ojknockout', 'ojs/ojselectcombobox'
            , 'css!' + adbc.app_base_css_url + 'libs/oj/v' + adbc.jet_version + '/alta/oj-alta-notag-min.css'],
            function (oj, ko, $) {
                //make knockout global to get to the module data
                adbc.ko = ko;

                //instantiate the viewModel of this view
                viewModel = new (function () {
                    var self = this;
                    self.values = ko.observableArray([]);

                    self.options = ko.observableArray(JSON.parse(options.options));
                    self.component = options.component;
                    self.placeholder = options.placeholder;
                    self.disabled = ko.observable(options.disabled);
                    self.multiple = options.multiple;

                    self.displayValueFor = function (value) {
                        let displayValues = [];
                        let dataArr = self.options();

                        let valueArray = util.toArray(value);
                        valueArray = valueArray.filter(function (val) {
                            return val && val !== '';
                        });
                        valueArray = valueArray.map(String);

                        valueArray.forEach((value, index) => {
                            let label = '';
                            if (dataArr.length > 0 && typeof dataArr.children) {
                                //we have groups
                                let dataGroup = dataArr.find(group => group.children.find(option => option.value === value));
                                if (dataGroup) {
                                    //we've found the value
                                    label = dataGroup.children.find(option => option.value === value).label;
                                }
                            } else {
                                //we don't have groups
                                let object = dataArr.find(option => option.value === value);
                                if (object) {
                                    //we've found the value
                                    label = object.label;
                                }
                            }

                            if (label == '') {
                                label = value;
                            }
                            displayValues.push(label);
                        });

                        return displayValues;
                    }; //displayValueFor

                    self.constructOption = function (DOMcontainer, option) {
                        var childSpan = document.createElement('span');
                        if (option.icon && option.icon.match(/\//)) {
                            var childImg = document.createElement('img');
                            childImg.setAttribute('src', option.icon);
                            childImg.setAttribute('role', 'presentation');
                            childImg.setAttribute('style', 'vertical-align:middle');
                            childSpan.appendChild(childImg);
                        } else {
                            childSpan.setAttribute('class', option.icon);
                        }
                        DOMcontainer.appendChild(childSpan);
                        DOMcontainer.appendChild(document.createTextNode(' ' + option.label));

                        return DOMcontainer;
                    } //constructOption

                    self.constructGrpOption = function (option) {
                        return document.createTextNode(option.label);
                    } //constructGrpOption


                    //define the function to convert the options JSON to a HTML list (JET v2.0.2 only)
                    self.listRenderer = function (data) {
                        var groupList = document.createElement('ul');
                        groupList.setAttribute('id', itemId + '_LIST');

                        data.forEach(function (item) {
                            var groupItem = document.createElement('li');

                            if (item.children) {
                                //it's a group
                                //create group title node
                                var groupTitle = document.createElement('div');
                                groupTitle.appendChild(self.constructGrpOption(item));
                                var childrenList = document.createElement('ul');

                                //create all child entries
                                item.children.forEach(function (item) {
                                    var childItem = document.createElement('li');
                                    childItem.setAttribute('oj-data-value', item.value);
                                    childItem = self.constructOption(childItem, item);
                                    childrenList.appendChild(childItem);
                                });

                                //add all to group item
                                groupItem.appendChild(groupTitle);
                                groupItem.appendChild(childrenList);
                            } else {
                                //it's a single entry
                                //create entry
                                groupItem.setAttribute('oj-data-value', item.value);
                                groupItem = self.constructOption(groupItem, item);
                            }

                            groupList.appendChild(groupItem);
                        });

                        document.body.appendChild(groupList);
                    } //listRenderer

                    //define the function to render the option, called by the component (JET v4.2.0 only)
                    self.optionRenderer = function (optionContext) {
                        var labelNode = document.createElement('div');

                        if (optionContext.leaf) {
                            //it's a single entry
                            labelNode = self.constructOption(labelNode, optionContext.data);
                        } else {
                            //it's a group entry
                            labelNode.appendChild(self.constructGrpOption(optionContext.data));
                        }

                        return { insert: labelNode };
                    } //optionRenderer

                    self.values.subscribe(function (values) {
                        validityItem$.val(values);
                        if (ig.isGrid && ig.data !== null) {
                            //the plugin data has changed, update the interactive grid record
                            var model = ig.data.model;
                            var rec = ig.data.record;
                            var displayValues = self.displayValueFor(values);
                            var newValue;
                            if (!options.multiple) {
                                newValue = { v: values[0], d: displayValues[0] };
                            } else {
                                newValue = { v: values, d: displayValues };
                            }
                            model.setValue(rec, ig.columnName, newValue);
                            ig.data = null;

                            var event = jQuery.Event("focusout");
                            event.ojReady = true;
                            item$.trigger(event);
                        }
                    });
                }); //new viewModel

                var renderJETComponent = function () {
                    var JETComponent;
                    switch (adbc.jet_version) {
                        case '2.0.2':
                            JETComponent = '<div data-bind="ojComponent: {' +
                                'component:component' +
                                //',options:options' +
                                ',list:\'' + itemId + '_LIST\'' +
                                ',value:values' +
                                ',placeholder:placeholder' +
                                ',disabled:disabled' +
                                ',multiple:multiple' +
                                '}"/>';
                            break;
                        case '4.2.0':
                            var componentName;
                            switch (options.component) {
                                case 'ojSelect':
                                    if (options.multiple) {
                                        componentName = 'oj-select-many';
                                    } else {
                                        componentName = 'oj-select-one';
                                    }
                                    break;
                                case 'ojCombobox':
                                    if (options.multiple) {
                                        componentName = 'oj-combobox-many';
                                    } else {
                                        componentName = 'oj-combobox-one';
                                    }
                                    break;
                                default:
                                    throw 'This type of component is not supported.';
                            }

                            JETComponent = '<' + componentName + ' ' +
                                'options="[[options]]" ' +
                                'value={{values}} " ' +
                                'placeholder={{placeholder}} ' +
                                'disabled={{disabled}} ' +
                                'option-renderer="[[optionRenderer]]"' +
                                '/>';
                            break;
                        default:
                            JETComponent = '<span>This version of JET is not supported.</span>';
                    }

                    return JETComponent;
                } //renderJETComponent

                //instantiate the view by editing the container made by the plugin PL/SQL code
                if (ig.isGrid) {
                    item$.on('focusin', function (e) {
                        //debugger;
                    })
                        .on('focusout', function (e) {
                            if (!e.ojReady) {
                                e.stopPropagation();
                            }
                            //debugger;
                        })
                        .on('keydown', function (e) {
                            //debugger;
                        })
                        .on('keyup', function (e) {
                            //debugger;
                        })
                        .on('click', function (e) {
                            //debugger;
                        });

                    item$.wrapInner(renderJETComponent);
                    item$.css('width', '100%');
                    item$.parent().css('height', '100%');
                } else {
                    item$.wrapInner(renderJETComponent);
                };

                apex.server.plugin(options.ajaxIdentifier, {}, { dataType: 'json' })
                    .then(function (data) {
                        //populate the viewmodel with data
                        viewModel.options(data);
                        viewModel.values(options.value);

                        //prepare the list options before knockout is activated
                        switch (adbc.jet_version) {
                            case '2.0.2':
                                viewModel.listRenderer(data);
                                break;
                            case '4.2.0':
                                break;
                        }

                        //activate knockout for the view and viewmodel to become active
                        ko.applyBindings(viewModel, item$[0]);
                    }, function (data) {
                        data.responseJSON = { error: "Invalid Ajax call!" }
                    });
            } //callback
        ); //require

        //create the apex item outside the callback function
        //for the interactive grid: there is only one per grid column
        item.create(itemId, {
            nullValue: options.nullValue,
            setValue: function (value) {
                if (!value) {
                    value = '';
                }

                //reset the selected data record
                ig.data = null;

                //synchronise the value of the apex item with the viewModel
                var valueArray = util.toArray(value);
                valueArray = valueArray.filter(function (val) {
                    return val && val !== '';
                });
                valueArray = valueArray.map(String);
                viewModel.values(valueArray);
            },
            getValue: function () {
                var value = options.value;
                if (viewModel.values) {
                    //return the value of the item from the viewModel
                    value = viewModel.values();
                }

                if (!options.multiple) {
                    value = value[0];
                }

                if (!value) {
                    value = '';
                }

                return value;
            },
            disable: function (e) {
                //disable the item
                viewModel.disabled(true);
            },
            enable: function (e) {
                //enable the item
                viewModel.disabled(false);
            },
            displayValueFor: function (value) {
                //search the return value in the viewModel and return the display value
                var valueArray = util.toArray(value);
                valueArray = valueArray.filter(function (val) {
                    return val && val !== '';
                });
                valueArray = valueArray.map(String);

                return viewModel.displayValueFor(valueArray);
            }
        }); //item.create

        //initialize this item
        tempItem.id = itemId;
        tempItem.options = options;
        tempItem.apex = item(itemId);
        tempItem.node = validityItem$;
        tempItem.setData = function (data) {
            item(itemId).setValue('');
            viewModel.options(data)
        };
        tempItem.getData = function () {
            return viewModel.options();
        };
        items.push(tempItem);
        tempItem = {};
    }; //_create

    return {
        create: _create
        , items: items
        , info: function () { return 'ojSelectCombobox plugin for OJET v2.0.2 / v4.2.0' }
        , version: function () { return '1.5' }
    };

})(apex.debug, apex.util, apex.server, apex.item, apex.message);
