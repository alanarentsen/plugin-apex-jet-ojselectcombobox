set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.3.00.05'
,p_default_workspace_id=>1830796136045863
,p_default_application_id=>111
,p_default_owner=>'SANDBOX'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/com_adbc_apex_jet_ojselectcombobox
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(11027934334240450)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.ADBC.APEX.JET.OJSELECTCOMBOBOX'
,p_display_name=>'Select List OJET'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'[require jet]#PLUGIN_FILES#ojselectcombobox.js'
,p_css_file_urls=>'#PLUGIN_FILES#ojselectcombobox.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  g_display_column constant pls_integer := 1;',
'  g_return_column  constant pls_integer := 2;',
'  g_group_column   constant pls_integer := 3;',
'  g_icon_column    constant pls_integer := 4;',
'',
'  procedure render(p_item   in apex_plugin.t_item,',
'                   p_plugin in apex_plugin.t_plugin,',
'                   p_param  in apex_plugin.t_item_render_param,',
'                   p_result in out nocopy apex_plugin.t_item_render_result) is',
'    l_type          varchar2(50) := p_item.attribute_01;',
'    l_placeholder   varchar2(50) := p_item.attribute_02;',
'    l_multiple      varchar2(50) := p_item.attribute_03;',
'',
'    l_values apex_application_global.vc_arr2;',
'    l_display_values apex_application_global.vc_arr2;',
'',
'    l_name          varchar2(30);',
'    l_display_value varchar2(32767);',
'  ',
'    -- value without the lov null value',
'    l_value varchar2(32767) := p_param.value;',
'  ',
'    c_escaped_value constant varchar2(32767) := apex_escape.html_attribute(p_param.value);',
'  begin',
'    if wwv_flow.g_debug then',
'      apex_plugin_util.debug_page_item(p_plugin              => p_plugin,',
'                                       p_page_item           => p_item,',
'                                       p_value               => p_param.value,',
'                                       p_is_readonly         => p_param.is_readonly,',
'                                       p_is_printer_friendly => p_param.is_printer_friendly);',
'    end if;',
'  ',
'    if (p_param.is_readonly or p_param.is_printer_friendly) then',
'      apex_plugin_util.print_hidden_if_readonly(p_item_name           => p_item.name,',
'                                                p_value               => p_param.value,',
'                                                p_is_readonly         => p_param.is_readonly,',
'                                                p_is_printer_friendly => p_param.is_printer_friendly);',
'      if l_multiple = ''Y'' then',
'        l_values := apex_util.string_to_table(p_string    => l_value',
'                                             ,p_separator => '':'');',
'                                          ',
'        -- get the display value',
'        l_display_values := apex_plugin_util.get_display_data(p_sql_statement     => p_item.lov_definition,',
'                                                             p_min_columns       => 2,',
'                                                             p_max_columns       => 4,',
'                                                             p_component_name    => p_item.name,',
'                                                             p_display_column_no => g_display_column,',
'                                                             p_search_column_no  => g_return_column,',
'                                                             p_search_value_list => l_values,',
'                                                             p_display_extra     => p_item.lov_display_extra);',
'                                                                                                                          ',
'         l_display_value := apex_util.table_to_string(p_table  => l_display_values',
'                                                     ,p_string => '','');',
'      else',
'        -- get the display value',
'        l_display_value := apex_plugin_util.get_display_data(p_sql_statement     => p_item.lov_definition,',
'                                                             p_min_columns       => 2,',
'                                                             p_max_columns       => 4,',
'                                                             p_component_name    => p_item.name,',
'                                                             p_display_column_no => g_display_column,',
'                                                             p_search_column_no  => g_return_column,',
'                                                             p_search_string     => l_value,',
'                                                             p_display_extra     => p_item.lov_display_extra);',
'      end if;',
'    ',
'      -- emit display span with the value',
'      apex_plugin_util.print_display_only(p_item_name        => p_item.name,',
'                                          p_display_value    => l_display_value,',
'                                          p_show_line_breaks => false,',
'                                          p_escape           => true,',
'                                          p_attributes       => p_item.element_attributes);',
'    else',
'      l_name := apex_plugin.get_input_name_for_item;',
'      ',
'      -- render the item for ',
'      sys.htp.prn(''<input type="text" '' ||',
'                  apex_plugin_util.get_element_attributes(p_item           => p_item,',
'                                                          p_name           => l_name,',
'                                                          p_default_class  => ''apex-item-plugin u-hidden'',',
'                                                          p_add_id         => false,',
'                                                          p_add_labelledby => true) ||',
'                  ''id="'' || p_item.name || ''" '' || case when',
'                  p_item.is_required then ''required'' else ''''',
'                  end || ''></input>'');',
'          ',
'      -- render the container div ',
'      sys.htp.prn(''<div '' || ''id="'' || p_item.name || ''_OJETCONTAINER" '' || ''class="apex-item-ojselect"'' ||',
'                  ''style="width:'' || case when',
'                  p_item.element_width is not null then',
'                  p_item.element_width else 17 end || ''ch;">'' || ''</div>'');',
'    ',
'      -- create the item',
'      apex_javascript.add_onload_code(p_code => ''widget.ojet.ojselectcombobox.create("'' ||',
'                                                p_item.name || ''", {'' ||',
'                                                apex_javascript.add_attribute(''ajaxIdentifier'',',
'                                                                              apex_plugin.get_ajax_identifier,',
'                                                                              true,',
'                                                                              true) ||',
'                                                apex_javascript.add_attribute(''value'',',
'                                                                              case',
'                                                                                when p_param.value is null then',
'                                                                                 ''''',
'                                                                                else',
'                                                                                 ltrim(rtrim(c_escaped_value))',
'                                                                              end,',
'                                                                              true,',
'                                                                              true) ||',
'                                                apex_javascript.add_attribute(''component'',',
'                                                                              l_type,',
'                                                                              true,',
'                                                                              true) ||',
'                                                apex_javascript.add_attribute(''placeholder'',',
'                                                                              l_placeholder,',
'                                                                              true,',
'                                                                              true) ||',
'                                                apex_javascript.add_attribute(''multiple'',',
'                                                                              case when l_multiple = ''Y'' then true else false end,',
'                                                                              true,',
'                                                                              false) ||',
'                                                ''});'');',
'    ',
'    end if;',
'  ',
'    p_result.is_navigable := (not p_param.is_readonly = false and',
'                             not p_param.is_printer_friendly);',
'  end render;',
'',
'  --==',
'',
'  procedure metadata(p_item   in apex_plugin.t_item,',
'                     p_plugin in apex_plugin.t_plugin,',
'                     p_param  in apex_plugin.t_item_meta_data_param,',
'                     p_result in out nocopy apex_plugin.t_item_meta_data_result) is',
'  begin',
'    p_result.escape_output := false;',
'  end metadata;',
'',
'  --==',
'',
'  procedure ajax(p_item   in apex_plugin.t_item,',
'                 p_plugin in apex_plugin.t_plugin,',
'                 p_param  in apex_plugin.t_item_ajax_param,',
'                 p_result in out nocopy apex_plugin.t_item_ajax_result) is',
'  ',
'    l_value varchar2(32767) := apex_application.g_x01;',
'  ',
'    l_column_value_list wwv_flow_plugin_util.t_column_value_list;',
'    l_value_found       boolean := false;',
'    l_icon_value        varchar2(4000);',
'    l_group_value       varchar2(4000);',
'    l_last_group_value  varchar2(4000);',
'    l_open_group        boolean := false;',
'  begin',
'    -- create list',
'    apex_json.open_array;',
'  ',
'    -- get all values',
'    l_column_value_list := apex_plugin_util.get_data(p_sql_statement  => p_item.lov_definition,',
'                                                     p_min_columns    => 2,',
'                                                     p_max_columns    => 4,',
'                                                     p_component_name => p_item.name);',
'  ',
'    -- loop through the result',
'    for i in 1 .. l_column_value_list(g_display_column).count loop',
'      -- if the current item value is in the list then the value is found',
'      l_value_found := (l_value = l_column_value_list(g_return_column)',
'                        (i) or l_value_found);',
'    ',
'      -- if there is a group specified, handle the group list entry',
'      begin',
'        l_group_value := l_column_value_list(g_group_column) (i);',
'        if (l_group_value <> l_last_group_value) or',
'           (l_group_value is null and l_last_group_value is not null) or',
'           (l_group_value is not null and l_last_group_value is null) then',
'        ',
'          -- close the group list entry',
'          if l_open_group then',
'            apex_json.close_array();',
'            apex_json.close_object();',
'            l_open_group := false;',
'          end if;',
'        ',
'          -- add a group list entry',
'          --if l_group_value is not null then',
'          l_open_group := true;',
'          apex_json.open_object;',
'          apex_json.write(''label'', l_group_value, true);',
'          apex_json.open_array(''children'');',
'          --end if;',
'        ',
'          l_last_group_value := l_group_value;',
'        end if;',
'      exception',
'        when no_data_found then',
'          null;',
'      end;',
'    ',
'      -- add list entry',
'      apex_json.open_object;',
'      apex_json.write(''value'',',
'                      l_column_value_list(g_return_column) (i),',
'                      true);',
'      apex_json.write(''label'',',
'                      l_column_value_list(g_display_column) (i),',
'                      true);',
'      ',
'      begin',
'         apex_json.write(''icon'',',
'                         l_column_value_list(g_icon_column) (i),',
'                         true);                      ',
'      exception',
'         when no_data_found then',
'            null;',
'      end;',
' ',
'      apex_json.close_object;',
'    end loop;',
'  ',
'    -- close the group list entry when still open',
'    if l_open_group then',
'      apex_json.close_array();',
'      apex_json.close_object();',
'      l_open_group := false;',
'    end if;',
'  ',
'    -- show at least the value if it hasn''t been found in the database',
'    if (not l_value_found and l_value is not null and',
'       p_item.lov_display_extra) then',
'      -- add list entry',
'      apex_json.open_object;',
'      apex_json.write(''value'', l_value, true);',
'      apex_json.write(''label'', l_value, true);',
'      apex_json.write(''icon'', '''', true);',
'      apex_json.close_object;',
'    end if;',
'  ',
'    apex_json.close_array;',
'  ',
'  end ajax;'))
,p_api_version=>2
,p_render_function=>'render'
,p_meta_data_function=>'metadata'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:ENCRYPT:LOV:CASCADING_LOV'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>false
,p_version_identifier=>'1.4'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/oraclejet/2.0.2/css/libs/oj/v2.0.2/alta/oj-alta-notag-min.css',
'#PLUGIN_FILES#ojselectcombobox.css',
'',
'',
'[require jet]#PLUGIN_FILES#ojselectcombobox.js',
'',
'or',
'',
'/i/adbc/plugin-apex-jet-ojselectcombobox/oj-alta-notag-min-v2.0.2.css',
'/i/adbc/plugin-apex-jet-ojselectcombobox/ojselectcombobox.css',
'',
'[require jet]/i/adbc/plugin-apex-jet-ojselectcombobox/ojselectcombobox.js'))
,p_files_version=>47
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11028165339240455)
,p_plugin_id=>wwv_flow_api.id(11027934334240450)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Component Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'ojSelect'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11028416058240457)
,p_plugin_attribute_id=>wwv_flow_api.id(11028165339240455)
,p_display_sequence=>10
,p_display_value=>'ojSelect'
,p_return_value=>'ojSelect'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11028936646240458)
,p_plugin_attribute_id=>wwv_flow_api.id(11028165339240455)
,p_display_sequence=>20
,p_display_value=>'ojCombobox'
,p_return_value=>'ojCombobox'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11029381588240458)
,p_plugin_id=>wwv_flow_api.id(11027934334240450)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Placeholder'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8603515974591793)
,p_plugin_id=>wwv_flow_api.id(11027934334240450)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Multi-select'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(11030123584240464)
,p_plugin_id=>wwv_flow_api.id(11027934334240450)
,p_name=>'LOV'
,p_sql_min_column_count=>2
,p_sql_max_column_count=>2
,p_supported_ui_types=>'DESKTOP'
,p_depending_on_has_to_exist=>true
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A206F6A2D73656C656374202A2F0A2E612D47562D636F6C756D6E4974656D207B0A20206865696768743A20313030253B20200A7D0A0A2E617065782D6974656D2D6F6A73656C656374207B0A202077696474683A203130302521696D706F7274616E';
wwv_flow_api.g_varchar2_table(2) := '740A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374207B0A2020706F736974696F6E3A2072656C61746976653B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206D61782D77696474683A203130';
wwv_flow_api.g_varchar2_table(3) := '30253B0A20206D696E2D77696474683A2038656D3B0A202077696474683A20313030253B0A2020666F6E742D73697A653A203172656D3B0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A';
wwv_flow_api.g_varchar2_table(4) := '20626F726465722D626F783B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63686F696365207B0A2020746578742D616C69676E3A206C6566743B0A2020636F6C6F723A2023333333';
wwv_flow_api.g_varchar2_table(5) := '3B0A2F2A20206261636B67726F756E642D636F6C6F723A20236663666466653B2A2F0A20206261636B67726F756E642D636F6C6F723A236632663266323B0A2020626F726465722D7374796C653A20736F6C69643B0A2020626F726465722D636F6C6F72';
wwv_flow_api.g_varchar2_table(6) := '3A20236439643964393B0A2020626F726465722D77696474683A203170783B0A2020626F726465722D7261646975733A203270783B0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0A20202D7765626B69742D7461702D68696768';
wwv_flow_api.g_varchar2_table(7) := '6C696768742D636F6C6F723A207472616E73706172656E743B0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A2020646973706C61793A20626C6F636B3B';
wwv_flow_api.g_varchar2_table(8) := '0A20206F766572666C6F773A2068696464656E3B0A2020706F736974696F6E3A2072656C61746976653B0A202077686974652D73706163653A206E6F777261703B0A20206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A2020';
wwv_flow_api.g_varchar2_table(9) := '746578742D6F766572666C6F773A20656C6C69707369733B0A20206865696768743A20322E32383672656D3B0A20206C696E652D6865696768743A20322E32383672656D3B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C';
wwv_flow_api.g_varchar2_table(10) := '656374202E6F6A2D73656C6563742D63686F696365202E6F6A2D73656C6563742D63686F73656E207B0A2020626F726465723A20303B0A20206F75746C696E653A20303B0A202077686974652D73706163653A206E6F777261703B0A2020646973706C61';
wwv_flow_api.g_varchar2_table(11) := '793A20696E6C696E652D626C6F636B3B0A20206F766572666C6F773A2068696464656E3B0A2020746578742D6F766572666C6F773A20656C6C69707369733B0A202077696474683A20313030253B0A2020626F782D736861646F773A206E6F6E653B0A20';
wwv_flow_api.g_varchar2_table(12) := '202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A2020666F6E742D73697A653A20312E3272656D3B0A7D0A0A0A2F2A206F6A2D636F6D626F626F78202A2F0A2E';
wwv_flow_api.g_varchar2_table(13) := '617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78207B0A2020706F736974696F6E3A2072656C61746976653B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A2020766572746963616C2D616C69676E3A206D';
wwv_flow_api.g_varchar2_table(14) := '6964646C653B0A20206D61782D77696474683A20313030253B0A20206D696E2D77696474683A2038656D3B0A202077696474683A20313030253B0A2020666F6E742D73697A653A203172656D3B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374';
wwv_flow_api.g_varchar2_table(15) := '202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365207B0A2020746578742D616C69676E3A206C6566743B0A2020636F6C6F723A20233333333B0A2F2A20206261636B67726F756E642D636F6C6F723A2023666366646665';
wwv_flow_api.g_varchar2_table(16) := '3B2A2F0A20206261636B67726F756E642D636F6C6F723A236632663266323B0A2020626F726465722D7374796C653A20736F6C69643B0A2020626F726465722D636F6C6F723A20236439643964393B0A2020626F726465722D77696474683A203170783B';
wwv_flow_api.g_varchar2_table(17) := '0A2020626F726465722D7261646975733A203270783B0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0A20202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207472616E73706172656E743B0A20202D6D6F';
wwv_flow_api.g_varchar2_table(18) := '7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A20206865696768743A20322E32383672656D3B0A20206C696E652D6865696768743A20322E32383672656D3B0A202064';
wwv_flow_api.g_varchar2_table(19) := '6973706C61793A20626C6F636B3B0A20206F75746C696E653A20303B0A20206F766572666C6F773A2068696464656E3B0A2020706F736974696F6E3A2072656C61746976653B0A202077686974652D73706163653A206E6F777261703B0A20206261636B';
wwv_flow_api.g_varchar2_table(20) := '67726F756E642D636C69703A2070616464696E672D626F783B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D696E707574';
wwv_flow_api.g_varchar2_table(21) := '207B0A202077696474683A20313030253B0A2020626F726465723A20303B0A202070616464696E673A20303B0A2020626F782D736861646F773A206E6F6E653B0A20206F75746C696E653A20303B0A2F2A20206261636B67726F756E642D636F6C6F723A';
wwv_flow_api.g_varchar2_table(22) := '20236663666466653B2A2F0A6261636B67726F756E642D636F6C6F723A236632663266323B0A636F6C6F723A20233333333B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206F766572666C6F773A2068696464656E3B0A20207768';
wwv_flow_api.g_varchar2_table(23) := '6974652D73706163653A206E6F777261703B0A2020746578742D6F766572666C6F773A20656C6C69707369733B0A2020666F6E742D73697A653A20312E3272656D3B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F62';
wwv_flow_api.g_varchar2_table(24) := '6F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D636C6561722D656E747279207B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206F75746C696E653A206E6F6E653B0A2020746578742D61';
wwv_flow_api.g_varchar2_table(25) := '6C69676E3A2063656E7465723B0A2020766572746963616C2D616C69676E3A206D6964646C653B0A20206C696E652D6865696768743A20313030253B0A7D0A0A2F2A206F6A2D73656C656374202A2F0A2E612D4947202E617065782D6974656D2D6F6A73';
wwv_flow_api.g_varchar2_table(26) := '656C656374202E6F6A2D73656C656374207B0A2020686569676874203A20313030253B0A20206D617267696E2D626F74746F6D3A3070783B0A7D0A0A2020202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C65637420';
wwv_flow_api.g_varchar2_table(27) := '2E6F6A2D73656C6563742D63686F696365207B0A202020206865696768743A20313030253B0A20202020646973706C61793A207461626C653B0A2020202077696474683A20313030253B0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F';
wwv_flow_api.g_varchar2_table(28) := '6A73656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63686F696365202E6F6A2D73656C6563742D63686F73656E207B0A202020206865696768743A20313030253B0A20202020766572746963616C2D616C69676E3A206D6964646C';
wwv_flow_api.g_varchar2_table(29) := '653B0A20202020646973706C61793A207461626C652D63656C6C3B0A20202020746578742D616C69676E3A206C6566743B0A2020202070616464696E672D6C6566743A203870783B0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F6A73';
wwv_flow_api.g_varchar2_table(30) := '656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63686F696365202E6F6A2D73656C6563742D6172726F77207B0A202020206C696E652D6865696768743A2032656D3B0A20207D0A0A2F2A206F6A2D636F6D626F626F78202A2F0A20';
wwv_flow_api.g_varchar2_table(31) := '202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78207B0A20202020686569676874203A20313030253B0A202020206D617267696E2D626F74746F6D3A3070783B0A20207D0A20200A20202E612D4947202E';
wwv_flow_api.g_varchar2_table(32) := '617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365207B0A202020206865696768743A20313030253B0A20202020646973706C61793A207461626C653B0A2020202077696474';
wwv_flow_api.g_varchar2_table(33) := '683A20313030253B0A20207D0A20200A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D696E707574207B0A2020';
wwv_flow_api.g_varchar2_table(34) := '202020206865696768743A20313030253B0A20202020766572746963616C2D616C69676E3A206D6964646C653B0A20202020646973706C61793A207461626C652D63656C6C3B0A20202020746578742D616C69676E3A206C6566743B0A20207D0A0A2020';
wwv_flow_api.g_varchar2_table(35) := '2E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D636C6561722D656E747279207B0A2020202020646973706C61793A20';
wwv_flow_api.g_varchar2_table(36) := '7461626C652D63656C6C3B0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D6172726F77207B0A20';
wwv_flow_api.g_varchar2_table(37) := '2020206C696E652D6865696768743A2032656D3B0A207D0A20200A202E617065782D6974656D2D6F6A73656C6563743A666F6375732C202E6F6A2D73656C6563743A666F6375732C202E6F6A2D73656C6563742D63686F6963653A666F6375732C202E6F';
wwv_flow_api.g_varchar2_table(38) := '6A2D636F6D626F626F783A666F6375732C202E6F6A2D636F6D626F626F782D63686F6963653A666F6375732C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732C0A202E617065782D6974656D2D6F6A73656C6563743A666F6375732D7769';
wwv_flow_api.g_varchar2_table(39) := '7468696E2C202E6F6A2D73656C6563743A666F6375732D77697468696E2C202E6F6A2D73656C6563742D63686F6963653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F783A666F6375732D77697468696E2C202E6F6A2D636F6D626F62';
wwv_flow_api.g_varchar2_table(40) := '6F782D63686F6963653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732D77697468696E207B0A20206F75746C696E653A20303B0A7D0A0A2F2A2069662073656C6563746564206368616E676520746F20';
wwv_flow_api.g_varchar2_table(41) := '6170657820626F72646572207374796C65202A2F0A2E617065782D6974656D2D6F6A73656C6563743A666F6375732C202E6F6A2D73656C6563743A666F6375732C202E6F6A2D73656C6563742D63686F6963653A666F6375732C202E6F6A2D636F6D626F';
wwv_flow_api.g_varchar2_table(42) := '626F783A666F6375732C202E6F6A2D636F6D626F626F782D63686F6963653A666F6375732C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732C0A202E617065782D6974656D2D6F6A73656C6563743A666F6375732D77697468696E2C202E';
wwv_flow_api.g_varchar2_table(43) := '6F6A2D73656C6563743A666F6375732D77697468696E2C202E6F6A2D73656C6563742D63686F6963653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F783A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D63686F69';
wwv_flow_api.g_varchar2_table(44) := '63653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732D77697468696E207B0A202020206261636B67726F756E642D636F6C6F723A202366666621696D706F7274616E743B0A2020626F726465722D636F';
wwv_flow_api.g_varchar2_table(45) := '6C6F723A202332353738636621696D706F7274616E743B0A7D0A0A2E617065782D6974656D2D6F6A73656C6563743A686F7665722C202E6F6A2D73656C6563743A686F7665722C202E6F6A2D73656C6563742D63686F6963653A686F7665722C202E6F6A';
wwv_flow_api.g_varchar2_table(46) := '2D6C697374626F782D64726F703A686F7665722C202E6F6A2D636F6D626F626F783A686F7665722C202E6F6A2D636F6D626F626F782D63686F6963653A686F7665722C202E6F6A2D636F6D626F626F782D696E7075743A686F766572207B0A2020626163';
wwv_flow_api.g_varchar2_table(47) := '6B67726F756E642D636F6C6F723A202366666621696D706F7274616E743B0A7D0A0A2F2A2073657474696E677320666F722073747265746368206974656D73202A2F0A2E742D466F726D2D2D73747265746368496E70757473202E742D466F726D2D6669';
wwv_flow_api.g_varchar2_table(48) := '656C64436F6E7461696E6572202E617065782D6974656D2D6F6A73656C6563742C202E742D466F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E70757473202E617065782D6974656D2D6F6A73656C656374207B0A2020666C6578';
wwv_flow_api.g_varchar2_table(49) := '3A20313B0A20206D696E2D77696474683A20303B0A7D0A0A2F2A206368616E6765207468652064726F70646F776E2069636F6E202A2F0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F782D6F70656E2D69636F6E3A6265';
wwv_flow_api.g_varchar2_table(50) := '666F72652C202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C6563742D6F70656E2D69636F6E3A6265666F7265207B0A2020636F6E74656E743A20225C65363036223B0A20207472616E73666F726D3A20726F746174652839306465';
wwv_flow_api.g_varchar2_table(51) := '67293B0A7D200A0A2F2A207768656E207363726F6C6C696E6720746865206C697374626F782073686F756C6420676F20756E64657220746865207061676520686561646572202A2F0A2E6F6A2D6C697374626F782D64726F702D6C61796572207B0A2020';
wwv_flow_api.g_varchar2_table(52) := '7A2D696E6465783A203830303B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(5297318597297929)
,p_plugin_id=>wwv_flow_api.id(11027934334240450)
,p_file_name=>'ojselectcombobox.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2275736520737472696374223B0D0A0D0A7661722061646263203D2061646263207C7C207B7D3B0D0A616462632E6A65745F76657273696F6E203D20726571756972652E732E636F6E74657874732E5F2E636F6E6669672E70617468732E6F6A732E7375';
wwv_flow_api.g_varchar2_table(2) := '62737472696E6728726571756972652E732E636F6E74657874732E5F2E636F6E6669672E70617468732E6F6A732E6C617374496E6465784F6628222F6F7261636C656A65742F2229202B2031310D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(3) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202C726571756972652E732E636F6E74657874732E5F2E636F6E6669672E70617468732E6F6A732E6C617374496E6465784F6628222F6A73';
wwv_flow_api.g_varchar2_table(4) := '2F2229293B0D0A616462632E6170705F6964203D20617065782E6974656D282770466C6F77496427292E67657456616C756528293B0D0A616462632E6170705F706167655F6964203D20617065782E6974656D282770466C6F7753746570496427292E67';
wwv_flow_api.g_varchar2_table(5) := '657456616C756528293B0D0A616462632E6170705F626173655F75726C203D20617065785F696D675F646972202B20276C69627261726965732F6F7261636C656A65742F27202B20616462632E6A65745F76657273696F6E202B20272F6A732F273B0D0A';
wwv_flow_api.g_varchar2_table(6) := '616462632E6170705F626173655F6373735F75726C203D20617065785F696D675F646972202B20276C69627261726965732F6F7261636C656A65742F27202B20616462632E6A65745F76657273696F6E202B20272F6373732F273B0D0A616462632E6B6F';
wwv_flow_api.g_varchar2_table(7) := '203D207B7D3B0D0A0D0A2F2F6C6F6164206B6E6F636B6F75742062656361757365205B72657175697265206A65745D2066726F6D206170657820646F65736E27740D0A726571756972656A732E636F6E666967280D0A202020207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(8) := '2070617468733A0D0A20202020202020207B0D0A202020202020202020202020276B6E6F636B6F7574273A20616462632E6170705F626173655F75726C202B20276C6962732F6B6E6F636B6F75742F6B6E6F636B6F75742D332E342E30272C0D0A202020';
wwv_flow_api.g_varchar2_table(9) := '20202020202020202027637373273A20616462632E6170705F626173655F75726C202B20276C6962732F726571756972652D6373732F6373732E6D696E270D0A20202020202020207D2C0D0A202020207D0D0A293B0D0A0D0A2F2F637265617465206F72';
wwv_flow_api.g_varchar2_table(10) := '20726575736520676C6F62616C2077696467657420666F7220616C6C20746865206F6A657420636F6D706F6E656E74730D0A76617220776964676574203D20776964676574207C7C207B7D3B0D0A7769646765742E6F6A6574203D2077696E646F772E6F';
wwv_flow_api.g_varchar2_table(11) := '6A6574207C7C207B7D3B0D0A0D0A2F2F63726561746520746865206F6A73656C656374636F6D626F626F78206F626A6563740D0A7769646765742E6F6A65742E6F6A73656C656374636F6D626F626F78203D202866756E6374696F6E202864656275672C';
wwv_flow_api.g_varchar2_table(12) := '207574696C2C207365727665722C206974656D2C206D65737361676529207B0D0A202020207661722064656661756C744F7074696F6E73203D207B0D0A202020202020202076616C75653A2027272C0D0A20202020202020206F7074696F6E733A20275B';
wwv_flow_api.g_varchar2_table(13) := '5D272C0D0A2020202020202020636F6D706F6E656E743A20276F6A53656C656374272C0D0A2020202020202020706C616365686F6C6465723A2027272C0D0A202020202020202064697361626C65643A2066616C73652C0D0A20202020202020206D756C';
wwv_flow_api.g_varchar2_table(14) := '7469706C653A2066616C73650D0A202020207D3B0D0A0D0A20202020766172206974656D73203D205B5D3B0D0A202020207661722074656D704974656D203D207B7D3B0D0A0D0A202020206C6574205F637265617465203D2066756E6374696F6E202869';
wwv_flow_api.g_varchar2_table(15) := '74656D49642C206F7074696F6E7329207B0D0A20202020202020202F2F20636F7079206F7074696F6E7320616E64206170706C792064656661756C74730D0A20202020202020206F7074696F6E73203D20242E657874656E6428747275652C207B7D2C20';
wwv_flow_api.g_varchar2_table(16) := '64656661756C744F7074696F6E732C206F7074696F6E73293B0D0A20202020202020206F7074696F6E732E76616C7565203D207574696C2E746F4172726179286F7074696F6E732E76616C756520213D3D202727203F206F7074696F6E732E76616C7565';
wwv_flow_api.g_varchar2_table(17) := '203A206E756C6C293B0D0A0D0A20202020202020202F2F444F4D206974656D202831207065722067726964290D0A2020202020202020766172206974656D24203D202428272327202B206974656D4964202B20275F4F4A4554434F4E5441494E45522729';
wwv_flow_api.g_varchar2_table(18) := '3B0D0A20202020202020207661722076616C69646974794974656D24203D202428272327202B206974656D4964293B0D0A0D0A20202020202020202F2F706C7567696E20646174610D0A202020202020202076617220766965774D6F64656C203D207B7D';
wwv_flow_api.g_varchar2_table(19) := '3B0D0A0D0A20202020202020202F2F696E746572616374697665206772696420646174610D0A2020202020202020766172206967203D207B7D3B0D0A202020202020202069672E6772696424203D206974656D242E636C6F7365737428272E742D495252';
wwv_flow_api.g_varchar2_table(20) := '2D726567696F6E2729207C7C205B5D3B0D0A202020202020202069672E697347726964203D2069672E67726964242E6C656E677468203D3D3D20313B0D0A202020202020202069672E64617461203D206E756C6C3B0D0A0D0A2020202020202020696620';
wwv_flow_api.g_varchar2_table(21) := '2869672E69734772696429207B0D0A20202020202020202020202069672E67726964242E6F6E2822696E74657261637469766567726964766965776D6F64656C637265617465222C2066756E6374696F6E20286576656E742C2063757272656E74566965';
wwv_flow_api.g_varchar2_table(22) := '7729207B0D0A2020202020202020202020202020202069672E697347726964203D20747275653B0D0A2020202020202020202020202020202069672E776964676574203D20617065782E726567696F6E286576656E742E63757272656E74546172676574';
wwv_flow_api.g_varchar2_table(23) := '2E6964292E77696467657428293B0D0A2020202020202020202020202020202069672E636F6C756D6E203D2069672E7769646765742E696E7465726163746976654772696428276F7074696F6E272C2027636F6E66696727292E636F6C756D6E732E6669';
wwv_flow_api.g_varchar2_table(24) := '6C7465722861203D3E207B2072657475726E20612E7374617469634964203D3D3D206974656D4964207D293B0D0A2020202020202020202020202020202069672E636F6C756D6E4E616D65203D2027273B0D0A0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(25) := '202F2F746F646F3A20636865636B2069662074686973206974656D20697320696E207468652069670D0A202020202020202020202020202020206966202869672E636F6C756D6E2E6C656E677468203E203029207B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '2020202020202069672E636F6C756D6E4E616D65203D2069672E636F6C756D6E5B305D2E6E616D653B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A0D0A2020202020202020202020202F2F7468697320';
wwv_flow_api.g_varchar2_table(27) := '6576656E74206F6E6C79206669726573207768656E207374617274696E6720746F20656469742074686520696E746572616374697665206772696420726F770D0A20202020202020202020202069672E67726964242E6F6E282761706578626567696E72';
wwv_flow_api.g_varchar2_table(28) := '65636F726465646974272C2066756E6374696F6E20286576656E742C206461746129207B0D0A202020202020202020202020202020202F2F73617665207468652065646974696E67207265636F7264206461746120676C6F62616C6C7920696E20746865';
wwv_flow_api.g_varchar2_table(29) := '20706C7567696E0D0A2020202020202020202020202020202069672E64617461203D20646174613B0D0A2020202020202020202020207D293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F696E697469616C697A65207669657720616E';
wwv_flow_api.g_varchar2_table(30) := '6420766965776D6F64656C0D0A202020202020202072657175697265285B276F6A732F6F6A636F7265272C20276B6E6F636B6F7574272C20276A7175657279272C20276F6A732F6F6A6B6E6F636B6F7574272C20276F6A732F6F6A73656C656374636F6D';
wwv_flow_api.g_varchar2_table(31) := '626F626F78270D0A202020202020202020202020202020202C276373732127202B20616462632E6170705F626173655F6373735F75726C202B20276C6962732F6F6A2F7627202B20616462632E6A65745F76657273696F6E202B20272F616C74612F6F6A';
wwv_flow_api.g_varchar2_table(32) := '2D616C74612D6E6F7461672D6D696E2E637373275D2C0D0A20202020202020202020202066756E6374696F6E20286F6A2C206B6F2C202429207B0D0A202020202020202020202020202020202F2F6D616B65206B6E6F636B6F757420676C6F62616C2074';
wwv_flow_api.g_varchar2_table(33) := '6F2067657420746F20746865206D6F64756C6520646174610D0A20202020202020202020202020202020616462632E6B6F203D206B6F3B0D0A0D0A202020202020202020202020202020202F2F646566696E65207468652066756E6374696F6E20746F20';
wwv_flow_api.g_varchar2_table(34) := '636F6E7665727420746865206F7074696F6E73204A534F4E20746F20612048544D4C206C6973740D0A2020202020202020202020202020202076617220636F6E7374727563744C697374203D2066756E6374696F6E20286461746129207B0D0A20202020';
wwv_flow_api.g_varchar2_table(35) := '202020202020202020202020202020207661722067726F75704C697374203D20646F63756D656E742E637265617465456C656D656E742827756C27293B0D0A202020202020202020202020202020202020202067726F75704C6973742E73657441747472';
wwv_flow_api.g_varchar2_table(36) := '696275746528276964272C206974656D4964202B20275F4C49535427293B0D0A0D0A2020202020202020202020202020202020202020646174612E666F72456163682866756E6374696F6E20286974656D29207B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(37) := '202020202020202020207661722067726F75704974656D203D20646F63756D656E742E637265617465456C656D656E7428276C6927293B0D0A0D0A202020202020202020202020202020202020202020202020696620286974656D2E6368696C6472656E';
wwv_flow_api.g_varchar2_table(38) := '29207B0D0A202020202020202020202020202020202020202020202020202020207661722067726F75705469746C65203D20646F63756D656E742E637265617465456C656D656E74282764697627293B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(39) := '2020202020202020202067726F75705469746C652E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F6465286974656D2E6C6162656C29293B0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '766172206368696C6472656E4C697374203D20646F63756D656E742E637265617465456C656D656E742827756C27293B0D0A0D0A202020202020202020202020202020202020202020202020202020206974656D2E6368696C6472656E2E666F72456163';
wwv_flow_api.g_varchar2_table(41) := '682866756E6374696F6E20286974656D29207B0D0A2020202020202020202020202020202020202020202020202020202020202020766172206368696C644974656D203D20646F63756D656E742E637265617465456C656D656E7428276C6927293B0D0A';
wwv_flow_api.g_varchar2_table(42) := '20202020202020202020202020202020202020202020202020202020202020206368696C644974656D2E73657441747472696275746528276F6A2D646174612D76616C7565272C206974656D2E76616C7565293B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '202020202020202020202020202020202020766172206368696C645370616E203D20646F63756D656E742E637265617465456C656D656E7428277370616E27293B0D0A202020202020202020202020202020202020202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(44) := '6620286974656D2E69636F6E202626206974656D2E69636F6E2E6D61746368282F5C2F2F2929207B200D0A202020202020202020202020202020202020202020202020202020202020202020202020766172206368696C64496D67203D20646F63756D65';
wwv_flow_api.g_varchar2_table(45) := '6E742E637265617465456C656D656E742827696D6727293B0D0A2020202020202020202020202020202020202020202020202020202020202020202020206368696C64496D672E7365744174747269627574652827737263272C206974656D2E69636F6E';
wwv_flow_api.g_varchar2_table(46) := '293B0D0A2020202020202020202020202020202020202020202020202020202020202020202020206368696C64496D672E7365744174747269627574652827726F6C65272C202770726573656E746174696F6E27293B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(47) := '2020202020202020202020202020202020202020202020206368696C64496D672E73657441747472696275746528277374796C65272C2027766572746963616C2D616C69676E3A6D6964646C6527293B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '2020202020202020202020202020202020206368696C645370616E2E617070656E644368696C64286368696C64496D67293B0D0A20202020202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(49) := '2020202020202020202020202020202020202020202020202020202020206368696C645370616E2E7365744174747269627574652827636C617373272C206974656D2E69636F6E293B0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '202020202020207D0D0A20202020202020202020202020202020202020202020202020202020202020206368696C644974656D2E617070656E644368696C64286368696C645370616E293B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '2020202020202020206368696C644974656D2E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F646528272027202B206974656D2E6C6162656C29293B0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '20202020202020206368696C6472656E4C6973742E617070656E644368696C64286368696C644974656D293B0D0A202020202020202020202020202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '20202020202020202067726F75704974656D2E617070656E644368696C642867726F75705469746C65293B0D0A2020202020202020202020202020202020202020202020202020202067726F75704974656D2E617070656E644368696C64286368696C64';
wwv_flow_api.g_varchar2_table(54) := '72656E4C697374293B0D0A2020202020202020202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020202020202020202067726F75704974656D2E73657441747472696275746528276F6A2D';
wwv_flow_api.g_varchar2_table(55) := '646174612D76616C7565272C206974656D2E76616C7565293B0D0A20202020202020202020202020202020202020202020202020202020766172206368696C645370616E203D20646F63756D656E742E637265617465456C656D656E7428277370616E27';
wwv_flow_api.g_varchar2_table(56) := '293B0D0A20202020202020202020202020202020202020202020202020202020696620286974656D2E69636F6E202626206974656D2E69636F6E2E6D61746368282F5C2F2F2929207B200D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(57) := '2020202020202020766172206368696C64496D67203D20646F63756D656E742E637265617465456C656D656E742827696D6727293B0D0A20202020202020202020202020202020202020202020202020202020202020206368696C64496D672E73657441';
wwv_flow_api.g_varchar2_table(58) := '74747269627574652827737263272C206974656D2E69636F6E293B0D0A20202020202020202020202020202020202020202020202020202020202020206368696C64496D672E7365744174747269627574652827726F6C65272C202770726573656E7461';
wwv_flow_api.g_varchar2_table(59) := '74696F6E27293B0D0A20202020202020202020202020202020202020202020202020202020202020206368696C64496D672E73657441747472696275746528277374796C65272C2027766572746963616C2D616C69676E3A6D6964646C6527293B0D0A20';
wwv_flow_api.g_varchar2_table(60) := '202020202020202020202020202020202020202020202020202020202020206368696C645370616E2E617070656E644368696C64286368696C64496D67293B0D0A202020202020202020202020202020202020202020202020202020207D20656C736520';
wwv_flow_api.g_varchar2_table(61) := '7B0D0A20202020202020202020202020202020202020202020202020202020202020206368696C645370616E2E7365744174747269627574652827636C617373272C206974656D2E69636F6E293B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '20202020202020207D0D0A2020202020202020202020202020202020202020202020202020202067726F75704974656D2E617070656E644368696C64286368696C645370616E293B0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '202067726F75704974656D2E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F646528272027202B206974656D2E6C6162656C29293B0D0A2020202020202020202020202020202020202020202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(64) := '2020202020202020202020202020202020202020202067726F75704C6973742E617070656E644368696C642867726F75704974656D293B0D0A20202020202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(65) := '20202020646F63756D656E742E626F64792E617070656E644368696C642867726F75704C697374293B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F696E7374616E746961746520746865207669';
wwv_flow_api.g_varchar2_table(66) := '65774D6F64656C206F66207468697320766965770D0A20202020202020202020202020202020766965774D6F64656C203D206E6577202866756E6374696F6E202829207B0D0A20202020202020202020202020202020202020207661722073656C66203D';
wwv_flow_api.g_varchar2_table(67) := '20746869733B0D0A202020202020202020202020202020202020202073656C662E76616C756573203D206B6F2E6F627365727661626C654172726179285B5D293B0D0A0D0A202020202020202020202020202020202020202073656C662E6F7074696F6E';
wwv_flow_api.g_varchar2_table(68) := '73203D206B6F2E6F627365727661626C654172726179284A534F4E2E7061727365286F7074696F6E732E6F7074696F6E7329293B0D0A202020202020202020202020202020202020202073656C662E636F6D706F6E656E74203D206B6F2E6F6273657276';
wwv_flow_api.g_varchar2_table(69) := '61626C65286F7074696F6E732E636F6D706F6E656E74293B0D0A202020202020202020202020202020202020202073656C662E706C616365686F6C646572203D206B6F2E6F627365727661626C65286F7074696F6E732E706C616365686F6C646572293B';
wwv_flow_api.g_varchar2_table(70) := '0D0A202020202020202020202020202020202020202073656C662E64697361626C6564203D206B6F2E6F627365727661626C65286F7074696F6E732E64697361626C6564293B0D0A202020202020202020202020202020202020202073656C662E6D756C';
wwv_flow_api.g_varchar2_table(71) := '7469706C65203D206B6F2E6F627365727661626C65286F7074696F6E732E6D756C7469706C65293B0D0A0D0A202020202020202020202020202020202020202073656C662E646973706C617956616C7565466F72203D2066756E6374696F6E202876616C';
wwv_flow_api.g_varchar2_table(72) := '75657329207B0D0A2020202020202020202020202020202020202020202020206C657420646973706C617956616C756573203D205B5D3B0D0A2020202020202020202020202020202020202020202020206C65742064617461417272203D2073656C662E';
wwv_flow_api.g_varchar2_table(73) := '6F7074696F6E7328293B0D0A0D0A20202020202020202020202020202020202020202020202076616C7565732E666F7245616368282876616C75652C20696E64657829203D3E207B0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(74) := '20206C6574206C6162656C203D2027273B0D0A2020202020202020202020202020202020202020202020202020202069662028646174614172722E6C656E677468203E203020262620747970656F6620646174614172722E6368696C6472656E29207B0D';
wwv_flow_api.g_varchar2_table(75) := '0A20202020202020202020202020202020202020202020202020202020202020202F2F776520686176652067726F7570730D0A20202020202020202020202020202020202020202020202020202020202020206C6574206461746147726F7570203D2064';
wwv_flow_api.g_varchar2_table(76) := '6174614172722E66696E642867726F7570203D3E2067726F75702E6368696C6472656E2E66696E64286F7074696F6E203D3E206F7074696F6E2E76616C7565203D3D3D2076616C756529293B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '20202020202020202020696620286461746147726F757029207B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202F2F776527766520666F756E64207468652076616C75650D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(78) := '202020202020202020202020202020202020202020202020206C6162656C203D206461746147726F75702E6368696C6472656E2E66696E64286F7074696F6E203D3E206F7074696F6E2E76616C7565203D3D3D2076616C7565292E6C6162656C3B0D0A20';
wwv_flow_api.g_varchar2_table(79) := '202020202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(80) := '202020202F2F776520646F6E277420686176652067726F7570730D0A20202020202020202020202020202020202020202020202020202020202020206C6574206F626A656374203D20646174614172722E66696E64286F7074696F6E203D3E206F707469';
wwv_flow_api.g_varchar2_table(81) := '6F6E2E76616C7565203D3D3D2076616C7565293B0D0A2020202020202020202020202020202020202020202020202020202020202020696620286F626A65637429207B0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(82) := '20202020202F2F776527766520666F756E64207468652076616C75650D0A2020202020202020202020202020202020202020202020202020202020202020202020206C6162656C203D206F626A6563742E6C6162656C3B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(83) := '2020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202020202020202020696620286C6162656C203D3D202727';
wwv_flow_api.g_varchar2_table(84) := '29207B0D0A20202020202020202020202020202020202020202020202020202020202020206C6162656C203D2076616C75653B0D0A202020202020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(85) := '202020202020202020202020646973706C617956616C7565732E70757368286C6162656C293B0D0A2020202020202020202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202020202020202020207265747572';
wwv_flow_api.g_varchar2_table(86) := '6E20646973706C617956616C7565733B0D0A20202020202020202020202020202020202020207D3B0D0A0D0A202020202020202020202020202020202020202073656C662E76616C7565732E7375627363726962652866756E6374696F6E202876616C75';
wwv_flow_api.g_varchar2_table(87) := '657329207B0D0A20202020202020202020202020202020202020202020202076616C69646974794974656D242E76616C2876616C756573293B0D0A2020202020202020202020202020202020202020202020206966202869672E69734772696420262620';
wwv_flow_api.g_varchar2_table(88) := '69672E6461746120213D3D206E756C6C29207B0D0A202020202020202020202020202020202020202020202020202020202F2F74686520706C7567696E206461746120686173206368616E6765642C207570646174652074686520696E74657261637469';
wwv_flow_api.g_varchar2_table(89) := '76652067726964207265636F72640D0A20202020202020202020202020202020202020202020202020202020766172206D6F64656C203D2069672E646174612E6D6F64656C3B0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(90) := '76617220726563203D2069672E646174612E7265636F72643B0D0A2020202020202020202020202020202020202020202020202020202076617220646973706C617956616C756573203D2073656C662E646973706C617956616C7565466F722876616C75';
wwv_flow_api.g_varchar2_table(91) := '6573293B0D0A20202020202020202020202020202020202020202020202020202020766172206E657756616C75653B0D0A2020202020202020202020202020202020202020202020202020202069662028216F7074696F6E732E6D756C7469706C652920';
wwv_flow_api.g_varchar2_table(92) := '7B0D0A20202020202020202020202020202020202020202020202020202020202020206E657756616C7565203D207B20763A2076616C7565735B305D2C20643A20646973706C617956616C7565735B305D207D3B0D0A0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(93) := '202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020202020202020202020206E657756616C7565203D207B20763A2076616C7565732C20643A20646973706C617956616C756573207D';
wwv_flow_api.g_varchar2_table(94) := '3B0D0A202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020206D6F64656C2E73657456616C7565287265632C2069672E636F6C756D6E4E616D652C206E6577';
wwv_flow_api.g_varchar2_table(95) := '56616C7565293B0D0A2020202020202020202020202020202020202020202020202020202069672E64617461203D206E756C6C3B0D0A0D0A20202020202020202020202020202020202020202020202020202020766172206576656E74203D206A517565';
wwv_flow_api.g_varchar2_table(96) := '72792E4576656E742822666F6375736F757422293B0D0A202020202020202020202020202020202020202020202020202020206576656E742E6F6A5265616479203D20747275653B0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(97) := '20206974656D242E74726967676572286576656E74293B0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A202020202020202020202020202020207D293B202F2F6E';
wwv_flow_api.g_varchar2_table(98) := '657720766965774D6F64656C0D0A0D0A202020202020202020202020202020202F2F696E7374616E74696174652074686520766965772062792065646974696E672074686520636F6E7461696E6572206D6164652062792074686520706C7567696E2050';
wwv_flow_api.g_varchar2_table(99) := '4C2F53514C20636F64650D0A202020202020202020202020202020206966202869672E69734772696429207B0D0A20202020202020202020202020202020202020206974656D242E6F6E2827666F637573696E272C2066756E6374696F6E20286529207B';
wwv_flow_api.g_varchar2_table(100) := '0D0A2020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A20202020202020202020202020202020202020207D290D0A2020202020202020202020202020202020202020202020202E6F6E2827666F6375736F7574';
wwv_flow_api.g_varchar2_table(101) := '272C2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202020202020202020202020206966202821652E6F6A526561647929207B0D0A2020202020202020202020202020202020202020202020202020202020202020652E';
wwv_flow_api.g_varchar2_table(102) := '73746F7050726F7061676174696F6E28293B0D0A202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(103) := '202020202020202020202020202020207D290D0A2020202020202020202020202020202020202020202020202E6F6E28276B6579646F776E272C2066756E6374696F6E20286529207B0D0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(104) := '2020202F2F64656275676765723B0D0A2020202020202020202020202020202020202020202020207D290D0A2020202020202020202020202020202020202020202020202E6F6E28276B65797570272C2066756E6374696F6E20286529207B0D0A202020';
wwv_flow_api.g_varchar2_table(105) := '202020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A2020202020202020202020202020202020202020202020207D290D0A2020202020202020202020202020202020202020202020202E6F6E2827636C69636B';
wwv_flow_api.g_varchar2_table(106) := '272C2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A2020202020202020202020202020202020202020202020207D293B0D0A0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(107) := '20202020202020202020206974656D242E77726170496E6E657228273C64697620646174612D62696E643D226F6A436F6D706F6E656E743A207B27202B0D0A20202020202020202020202020202020202020202020202027636F6D706F6E656E743A636F';
wwv_flow_api.g_varchar2_table(108) := '6D706F6E656E7427202B0D0A2020202020202020202020202020202020202020202020202F2F272C6F7074696F6E733A6F7074696F6E7327202B0D0A202020202020202020202020202020202020202020202020272C6C6973743A5C2727202B20697465';
wwv_flow_api.g_varchar2_table(109) := '6D4964202B20275F4C4953545C2727202B0D0A202020202020202020202020202020202020202020202020272C76616C75653A76616C75657327202B0D0A202020202020202020202020202020202020202020202020272C706C616365686F6C6465723A';
wwv_flow_api.g_varchar2_table(110) := '706C616365686F6C64657227202B0D0A202020202020202020202020202020202020202020202020272C64697361626C65643A64697361626C656427202B0D0A202020202020202020202020202020202020202020202020272C6D756C7469706C653A6D';
wwv_flow_api.g_varchar2_table(111) := '756C7469706C6527202B0D0A202020202020202020202020202020202020202020202020277D222F3E27293B0D0A20202020202020202020202020202020202020206974656D242E63737328277769647468272C20273130302527293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(112) := '2020202020202020202020202020206974656D242E706172656E7428292E6373732827686569676874272C20273130302527293B0D0A202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(113) := '6974656D242E77726170496E6E657228273C64697620646174612D62696E643D226F6A436F6D706F6E656E743A207B27202B0D0A20202020202020202020202020202020202020202020202027636F6D706F6E656E743A636F6D706F6E656E7427202B0D';
wwv_flow_api.g_varchar2_table(114) := '0A2020202020202020202020202020202020202020202020202F2F272C6F7074696F6E733A6F7074696F6E7327202B0D0A202020202020202020202020202020202020202020202020272C6C6973743A5C2727202B206974656D4964202B20275F4C4953';
wwv_flow_api.g_varchar2_table(115) := '545C2727202B0D0A202020202020202020202020202020202020202020202020272C76616C75653A76616C75657327202B0D0A202020202020202020202020202020202020202020202020272C706C616365686F6C6465723A706C616365686F6C646572';
wwv_flow_api.g_varchar2_table(116) := '27202B0D0A202020202020202020202020202020202020202020202020272C64697361626C65643A64697361626C656427202B0D0A202020202020202020202020202020202020202020202020272C6D756C7469706C653A6D756C7469706C6527202B0D';
wwv_flow_api.g_varchar2_table(117) := '0A202020202020202020202020202020202020202020202020277D222F3E27293B0D0A202020202020202020202020202020207D3B0D0A0D0A20202020202020202020202020202020617065782E7365727665722E706C7567696E286F7074696F6E732E';
wwv_flow_api.g_varchar2_table(118) := '616A61784964656E7469666965722C207B7D2C207B2064617461547970653A20276A736F6E27207D290D0A20202020202020202020202020202020202020202E7468656E2866756E6374696F6E20286461746129207B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(119) := '2020202020202020202020202F2F6163746976617465206B6E6F636B6F757420666F7220746865207669657720616E6420766965776D6F64656C20746F206265636F6D65206163746976650D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(120) := '20766965774D6F64656C2E6F7074696F6E732864617461293B0D0A202020202020202020202020202020202020202020202020766965774D6F64656C2E76616C756573286F7074696F6E732E76616C7565293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(121) := '202020202020202020636F6E7374727563744C6973742864617461293B0D0A2020202020202020202020202020202020202020202020206B6F2E6170706C7942696E64696E677328766965774D6F64656C2C206974656D245B305D293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(122) := '2020202020202020202020202020207D2C2066756E6374696F6E20286461746129207B0D0A202020202020202020202020202020202020202020202020646174612E726573706F6E73654A534F4E203D207B6572726F723A2022496E76616C696420416A';
wwv_flow_api.g_varchar2_table(123) := '61782063616C6C21227D200D0A20202020202020202020202020202020202020207D293B0D0A2020202020202020202020207D202F2F63616C6C6261636B0D0A2020202020202020293B202F2F726571756972650D0A0D0A20202020202020202F2F6372';
wwv_flow_api.g_varchar2_table(124) := '65617465207468652061706578206974656D206F757473696465207468652063616C6C6261636B2066756E6374696F6E0D0A20202020202020202F2F666F722074686520696E74657261637469766520677269643A207468657265206973206F6E6C7920';
wwv_flow_api.g_varchar2_table(125) := '6F6E6520706572206772696420636F6C756D6E0D0A20202020202020206974656D2E637265617465286974656D49642C207B0D0A2020202020202020202020206E756C6C56616C75653A206F7074696F6E732E6E756C6C56616C75652C0D0A2020202020';
wwv_flow_api.g_varchar2_table(126) := '2020202020202073657456616C75653A2066756E6374696F6E202876616C756529207B0D0A20202020202020202020202020202020696620282176616C756529207B0D0A202020202020202020202020202020202020202076616C7565203D2027273B0D';
wwv_flow_api.g_varchar2_table(127) := '0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F7265736574207468652073656C65637465642064617461207265636F72640D0A2020202020202020202020202020202069672E64617461203D206E75';
wwv_flow_api.g_varchar2_table(128) := '6C6C3B0D0A0D0A202020202020202020202020202020202F2F73796E6368726F6E697365207468652076616C7565206F66207468652061706578206974656D20776974682074686520766965774D6F64656C0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(129) := '7661722076616C75654172726179203D207574696C2E746F41727261792876616C7565293B0D0A2020202020202020202020202020202076616C75654172726179203D2076616C756541727261792E66696C7465722866756E6374696F6E202876616C29';
wwv_flow_api.g_varchar2_table(130) := '207B0D0A202020202020202020202020202020202020202072657475726E2076616C2026262076616C20213D3D2027273B0D0A202020202020202020202020202020207D293B0D0A2020202020202020202020202020202076616C75654172726179203D';
wwv_flow_api.g_varchar2_table(131) := '2076616C756541727261792E6D617028537472696E67293B0D0A20202020202020202020202020202020766965774D6F64656C2E76616C7565732876616C75654172726179293B0D0A2020202020202020202020207D2C0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(132) := '2067657456616C75653A2066756E6374696F6E202829207B0D0A202020202020202020202020202020207661722076616C7565203D206F7074696F6E732E76616C75653B0D0A2020202020202020202020202020202069662028766965774D6F64656C2E';
wwv_flow_api.g_varchar2_table(133) := '76616C75657329207B0D0A20202020202020202020202020202020202020202F2F72657475726E207468652076616C7565206F6620746865206974656D2066726F6D2074686520766965774D6F64656C0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(134) := '202076616C7565203D20766965774D6F64656C2E76616C75657328293B0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020202020202069662028216F7074696F6E732E6D756C7469706C6529207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(135) := '202020202020202020202020202076616C7565203D2076616C75655B305D3B0D0A202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020696620282176616C756529207B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(136) := '202020202076616C7565203D2027273B0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020202020202072657475726E2076616C75653B0D0A2020202020202020202020207D2C0D0A2020202020202020202020206469';
wwv_flow_api.g_varchar2_table(137) := '7361626C653A2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202F2F64697361626C6520746865206974656D0D0A20202020202020202020202020202020766965774D6F64656C2E64697361626C65642874727565293B';
wwv_flow_api.g_varchar2_table(138) := '0D0A2020202020202020202020207D2C0D0A202020202020202020202020656E61626C653A2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202F2F656E61626C6520746865206974656D0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(139) := '2020202020766965774D6F64656C2E64697361626C65642866616C7365293B0D0A2020202020202020202020207D2C0D0A202020202020202020202020646973706C617956616C7565466F723A2066756E6374696F6E202876616C756529207B0D0A2020';
wwv_flow_api.g_varchar2_table(140) := '20202020202020202020202020202F2F736561726368207468652072657475726E2076616C756520696E2074686520766965774D6F64656C20616E642072657475726E2074686520646973706C61792076616C75650D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(141) := '2020207661722076616C75654172726179203D207574696C2E746F41727261792876616C7565293B0D0A2020202020202020202020202020202076616C75654172726179203D2076616C756541727261792E66696C7465722866756E6374696F6E202876';
wwv_flow_api.g_varchar2_table(142) := '616C29207B0D0A202020202020202020202020202020202020202072657475726E2076616C2026262076616C20213D3D2027273B0D0A202020202020202020202020202020207D293B0D0A2020202020202020202020202020202076616C756541727261';
wwv_flow_api.g_varchar2_table(143) := '79203D2076616C756541727261792E6D617028537472696E67293B0D0A0D0A2020202020202020202020202020202072657475726E20766965774D6F64656C2E646973706C617956616C7565466F722876616C75654172726179293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(144) := '2020202020207D0D0A20202020202020207D293B202F2F6974656D2E6372656174650D0A0D0A20202020202020202F2F696E697469616C697A652074686973206974656D0D0A202020202020202074656D704974656D2E6964203D206974656D49643B0D';
wwv_flow_api.g_varchar2_table(145) := '0A202020202020202074656D704974656D2E6F7074696F6E73203D206F7074696F6E733B0D0A202020202020202074656D704974656D2E61706578203D206974656D286974656D4964293B0D0A202020202020202074656D704974656D2E6E6F6465203D';
wwv_flow_api.g_varchar2_table(146) := '2076616C69646974794974656D243B0D0A202020202020202074656D704974656D2E73657444617461203D2066756E6374696F6E20286461746129207B0D0A2020202020202020202020206974656D286974656D4964292E73657456616C756528272729';
wwv_flow_api.g_varchar2_table(147) := '3B0D0A202020202020202020202020766965774D6F64656C2E6F7074696F6E732864617461290D0A20202020202020207D3B0D0A202020202020202074656D704974656D2E67657444617461203D2066756E6374696F6E202829207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(148) := '20202020202072657475726E20766965774D6F64656C2E6F7074696F6E7328293B0D0A20202020202020207D3B0D0A20202020202020206974656D732E707573682874656D704974656D293B0D0A202020202020202074656D704974656D203D207B7D3B';
wwv_flow_api.g_varchar2_table(149) := '0D0A202020207D3B202F2F5F6372656174650D0A0D0A2020202072657475726E207B0D0A20202020202020206372656174653A205F6372656174650D0A20202020202020202C206974656D733A206974656D730D0A20202020202020202C20696E666F3A';
wwv_flow_api.g_varchar2_table(150) := '2066756E6374696F6E202829207B2072657475726E20276F6A53656C656374436F6D626F626F7820706C7567696E20666F72204F4A45542076322E302E3227207D0D0A20202020202020202C2076657273696F6E3A2066756E6374696F6E202829207B20';
wwv_flow_api.g_varchar2_table(151) := '72657475726E2027312E3427207D0D0A202020207D3B0D0A0D0A7D2928617065782E64656275672C20617065782E7574696C2C20617065782E7365727665722C20617065782E6974656D2C20617065782E6D657373616765293B0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(5327612936113979)
,p_plugin_id=>wwv_flow_api.id(11027934334240450)
,p_file_name=>'ojselectcombobox.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
