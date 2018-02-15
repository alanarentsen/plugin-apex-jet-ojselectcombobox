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
widget.ojet.ojselectcombobox = (function (debug, util, server, item) {
    var defaultOptions = {
        value: '',
        options: "[]",
        component: 'ojSelect',
        placeholder: '',
        disabled: false
    };

    var items = [];
    var tempItem = {};

    let _create = function (itemId, options) {
        // copy options and apply defaults
        options = $.extend(true, {}, defaultOptions, options);

        //DOM item (1 per grid)
        var item$ = $('#' + itemId);

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
                    self.value = ko.observable(options.value);
                    self.options = ko.observableArray(JSON.parse(options.options));
                    self.component = ko.observable(options.component);
                    self.placeholder = ko.observable(options.placeholder);
                    self.disabled = ko.observable(false);

                    self.displayValueFor = function (value) {
                        let object = self.options().filter(a => { return a.value === value })[0];
                        return typeof object === 'undefined' ? '' : object.label;
                    };

                    self.value.subscribe(function (value) {
                        if (ig.isGrid && ig.data !== null) {
                            //console.log('we need to set this value: ' + value[0]);
                            //the plugin data has changed, update the interactive grid record
                            var model = ig.data.model;
                            var rec = ig.data.record;
                            var displayValue = self.displayValueFor(value[0]);
                            var newValue = { v: value[0], d: displayValue };
                            model.setValue(rec, ig.columnName, newValue);
                            ig.data = null;
                        }
                    });
                })(); //new viewModel

                //instantiate the view by editing the container made by the plugin PL/SQL code
                if (ig.isGrid) {
                    item$.wrapInner('<select data-bind="ojComponent: {component:component,' +
                        'options:options,' +
                        'value:value,' +
                        'placeholder:placeholder,' +
                        'disabled:disabled,' +
                        //'optionChange:function (e,d) {console.log(\'optionChange: \'); console.log(d);},' +
                        'rootAttributes:{style: \'max-width:100%; height:100%; margin:0px\'}}">' +
                        '</select>');
                    item$.css('width', '100%');
                    item$.parent().css('height', '100%');
                } else {
                    item$.wrapInner('<select data-bind="ojComponent: {component:component,' +
                        'options:options,' +
                        'value:value,' +
                        'placeholder:placeholder,' +
                        'disabled:disabled,' +
                        'rootAttributes:{style: \'margin:0px\'}}">' +
                        '</select>');
                };

                //activate knockout for the view and viewmodel to become active
                ko.applyBindings(viewModel, item$[0]);
            } //callback
        ); //require

        //create the apex item outside the callback function
        //for the interactive grid: there is only one per grid column
        item.create(itemId, {
            setValue: function (value) {
                //console.log('setValue: ' + value);
                //reset the selected data record
                ig.data = null;

                //synchronise the value of the apex item with the viewModel
                viewModel.value([value]);
            },
            getValue: function () {
                //console.log('getValue: ' + viewModel.value());
                //return the value of the item from the viewModel
                return viewModel.value()[0];
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
        , version: function () { return '1.0' }
    };
})(apex.debug, apex.util, apex.server, apex.item);
