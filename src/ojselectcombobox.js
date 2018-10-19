"use strict";

var adbc = adbc || {};
adbc.jet_version = require.s.contexts._.config.paths.ojs.substring(require.s.contexts._.config.paths.ojs.lastIndexOf("/oraclejet/") + 11
                                                                  ,require.s.contexts._.config.paths.ojs.lastIndexOf("/js/"));
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
                ,'css!' + adbc.app_base_css_url + 'libs/oj/v' + adbc.jet_version + '/alta/oj-alta-notag-min.css'],
            function (oj, ko, $) {
                //make knockout global to get to the module data
                adbc.ko = ko;

                //define the function to convert the options JSON to a HTML list
                var constructList = function (data) {
                    var groupList = document.createElement('ul');
                    groupList.setAttribute('id', itemId + '_LIST');

                    data.forEach(function (item) {
                        var groupItem = document.createElement('li');

                        if (item.children) {
                            var groupTitle = document.createElement('div');
                            groupTitle.appendChild(document.createTextNode(item.label));
                            var childrenList = document.createElement('ul');

                            item.children.forEach(function (item) {
                                var childItem = document.createElement('li');
                                childItem.setAttribute('oj-data-value', item.value);
                                var childSpan = document.createElement('span');
                                if (item.icon && item.icon.match(/\//)) { 
                                    var childImg = document.createElement('img');
                                    childImg.setAttribute('src', item.icon);
                                    childImg.setAttribute('role', 'presentation');
                                    childImg.setAttribute('style', 'vertical-align:middle');
                                    childSpan.appendChild(childImg);
                                } else {
                                    childSpan.setAttribute('class', item.icon);
                                }
                                childItem.appendChild(childSpan);
                                childItem.appendChild(document.createTextNode(' ' + item.label));
                                childrenList.appendChild(childItem);
                            });

                            groupItem.appendChild(groupTitle);
                            groupItem.appendChild(childrenList);
                        } else {
                            groupItem.setAttribute('oj-data-value', item.value);
                            var childSpan = document.createElement('span');
                            if (item.icon && item.icon.match(/\//)) { 
                                var childImg = document.createElement('img');
                                childImg.setAttribute('src', item.icon);
                                childImg.setAttribute('role', 'presentation');
                                childImg.setAttribute('style', 'vertical-align:middle');
                                childSpan.appendChild(childImg);
                            } else {
                                childSpan.setAttribute('class', item.icon);
                            }
                            groupItem.appendChild(childSpan);
                            groupItem.appendChild(document.createTextNode(' ' + item.label));
                        }

                        groupList.appendChild(groupItem);
                    });

                    document.body.appendChild(groupList);
                }

                //instantiate the viewModel of this view
                viewModel = new (function () {
                    var self = this;
                    self.values = ko.observableArray([]);

                    self.options = ko.observableArray(JSON.parse(options.options));
                    self.component = ko.observable(options.component);
                    self.placeholder = ko.observable(options.placeholder);
                    self.disabled = ko.observable(options.disabled);
                    self.multiple = ko.observable(options.multiple);

                    self.displayValueFor = function (values) {
                        let displayValues = [];
                        let dataArr = self.options();

                        values.forEach((value, index) => {
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
                    };

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

                    item$.wrapInner('<div data-bind="ojComponent: {' +
                        'component:component' +
                        //',options:options' +
                        ',list:\'' + itemId + '_LIST\'' +
                        ',value:values' +
                        ',placeholder:placeholder' +
                        ',disabled:disabled' +
                        ',multiple:multiple' +
                        '}"/>');
                    item$.css('width', '100%');
                    item$.parent().css('height', '100%');
                } else {
                    item$.wrapInner('<div data-bind="ojComponent: {' +
                        'component:component' +
                        //',options:options' +
                        ',list:\'' + itemId + '_LIST\'' +
                        ',value:values' +
                        ',placeholder:placeholder' +
                        ',disabled:disabled' +
                        ',multiple:multiple' +
                        '}"/>');
                };

                apex.server.plugin(options.ajaxIdentifier, {}, { dataType: 'json' })
                    .then(function (data) {
                        //activate knockout for the view and viewmodel to become active
                        viewModel.options(data);
                        viewModel.values(options.value);
                        constructList(data);
                        ko.applyBindings(viewModel, item$[0]);
                    }, function (data) {
                        data.responseJSON = {error: "Invalid Ajax call!"} 
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
        , info: function () { return 'ojSelectCombobox plugin for OJET v2.0.2' }
        , version: function () { return '1.4' }
    };

})(apex.debug, apex.util, apex.server, apex.item, apex.message);
