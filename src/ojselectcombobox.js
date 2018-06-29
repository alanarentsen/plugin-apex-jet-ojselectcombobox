"use strict";

//load knockout because [require jet] from apex doesn't
requirejs.config(
    {
        paths:
        {
            'knockout': './oraclejet/2.0.2/js/libs/knockout/knockout-3.4.0',
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
        disabled: false
    };

    var items = [];
    var tempItem = {};

    let _create = function (itemId, options) {

        // console.log(itemId);
        // console.log(options);

        // copy options and apply defaults
        options = $.extend(true, {}, defaultOptions, options);
        var defaultValue = options.value.toString();

        //DOM item (1 per grid)
        var item$ = $('#' + itemId + '_OJETCONTAINER');
        var validityItem$ = $('#'+ itemId);

        //plugin data
        var viewModel = {};

        //interactive grid data
        var ig = {};
        ig.grid$ = item$.closest('.t-IRR-region') || [];
        ig.isGrid = ig.grid$.length === 1;
        ig.data = null;

        if (ig.isGrid) {
            ig.grid$.on("interactivegridviewmodelcreate", function (event, currentView) {
                //console.log('interactivegridviewmodelcreate');
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
            //item$.parent().parent().parent().on('apexbeginrecordedit', function (event, data) {
            ig.grid$.on('apexbeginrecordedit', function (event, data) {
                //console.log('apexbeginrecordedit');
                //save the editing record data globally in the plugin
                ig.data = data;
            });
        }

        //initialize view and viewmodel
        require(['ojs/ojcore', 'knockout', 'jquery', 'ojs/ojknockout', 'ojs/ojselectcombobox'],
            function (oj, ko, $) {
                //instantiate the viewModel of this view
                viewModel = new (function () {
                    var self = this;
                    self.values = ko.observableArray([]);//([options.value.toString()]);
                    self.value = ko.pureComputed({
                        read: function () {
                            return parseInt(this.values()[0]) || '';
                        },
                        write: function (values) {
                            if (values) {
                                this.values([values.toString()]); //in case of one selection its an number otherwise an array we dont use multiple selection
                            } else {
                                this.values(values);
                            }
                        },
                        owner: this
                    }).extend({ notify: 'always' });

                    self.options = ko.observableArray(JSON.parse(options.options));
                    self.component = ko.observable(options.component);
                    self.placeholder = ko.observable(options.placeholder);
                    self.disabled = ko.observable(false);

                    self.displayValueFor = function (value) {
                        let label = value.toString();
                        let strValue = label;
                        if (strValue) {
                            let dataArr = self.options();
                            label = 'displayValue not found! (' + strValue + ')';
                            if (dataArr.length > 0 && typeof dataArr.children) {
                                //we have groups
                                let dataGroup = dataArr.find(group => group.children.find(option => option.value === strValue));
                                if (dataGroup) {
                                    //we've found the value
                                    label = dataGroup.children.find(option => option.value === strValue).label;
                                }
                            } else {
                                //we don't have groups
                                let object = dataArr.find(option => option.value === strValue);
                                if (object) {
                                    //we've found the value
                                    label = object.label;
                                }
                            }
                        };

                        return label;
                    };

                    self.value.subscribe(function (value) {
                        validityItem$.val(value);
                        if (ig.isGrid && ig.data !== null) {
                            //console.log('we need to set this value: ' + value);
                            //the plugin data has changed, update the interactive grid record
                            var model = ig.data.model;
                            var rec = ig.data.record;
                            var displayValue = self.displayValueFor(value);
                            var newValue = { v: value.toString(), d: displayValue };
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
                        ',options:options' +
                        ',value:values' +
                        ',placeholder:placeholder' +
                        ',disabled:disabled' +
                        ',multiple:false' +
                        '}"/>');
                    item$.css('width', '100%');
                    item$.parent().css('height', '100%');
                } else {
                    item$.wrapInner('<div data-bind="ojComponent: {' + 
                        'component:component' +
                        ',options:options' +
                        ',value:values' +
                        ',placeholder:placeholder' +
                        ',disabled:disabled' +
                        ',multiple:false' + 
                        '}"/>');
                };


                //activate knockout for the view and viewmodel to become active
                ko.applyBindings(viewModel, item$[0]);
                //viewModel.options([{value: '1', label: 'option1'}, {value: '2', label: 'option2'}]);
                //viewModel.values(["1","2"]);

                apex.server.plugin(options.ajaxIdentifier, {}, { dataType: 'json' })
                    .then(function (data) {
                        //success
                        viewModel.options(data);
                        viewModel.value(options.value);
                    }, function (data) {
                        //failure
                        debugger;
                        //data.responseJSON = {error: "Invalid Ajax call!"} 
                    });
            } //callback
        ); //require

        //create the apex item outside the callback function
        //for the interactive grid: there is only one per grid column
        item.create(itemId, {
            nullValue: options.nullValue,
            setValue: function (value) {
                console.log('setValue: ' + value);
                //reset the selected data record
                ig.data = null;

                //synchronise the value of the apex item with the viewModel
                viewModel.value(value);
            },
            getValue: function () {
                var value = defaultValue;
                if (viewModel.value) {
                    //return the value of the item from the viewModel
                    value = viewModel.value().toString();
                }
                //console.log('getValue: ' + value);

                return value;
            },
            disable: function (e) {
                //console.log('disable');
                //disable the item
                viewModel.disabled(true);
            },
            enable: function (e) {
                //console.log('enable');
                //enable the item
                viewModel.disabled(false);
            },
            displayValueFor: function (value) {
                //console.log('displayValueFor: ' + value + ' (viewModel value: ' + viewModel.value() + ')');
                //search the return value in the viewModel and return the display value
                return viewModel.displayValueFor(value);
            }
        }); //item.create

        //initialize this item
        tempItem.id = itemId;
        tempItem.options = options;
        tempItem.apex = item(item$);
        tempItem.node = item$;
        tempItem.setData = function (data) { tempItem.apex.setValue(''); viewModel.options(data) };
        tempItem.getData = function () { return viewModel.options(); };
        items.push(tempItem);
        tempItem = {};
    }; //_create

    return {
        create: _create
        , items: items
        , info: function () { return 'ojSelectCombobox plugin for OJET v2.0.2' }
        , version: function () { return '1.3' }
    };

})(apex.debug, apex.util, apex.server, apex.item, apex.message);
