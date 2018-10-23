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
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'[require jet]#PLUGIN_FILES#ojselectcombobox.js',
''))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#ojselectcombobox.css',
''))
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
,p_version_identifier=>'1.5'
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
,p_files_version=>51
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
wwv_flow_api.g_varchar2_table(1) := '2F2A206F6A2D73656C656374202A2F0A2E612D47562D636F6C756D6E4974656D207B0A20206865696768743A20313030253B20200A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374207B0A2020706F736974696F6E3A';
wwv_flow_api.g_varchar2_table(2) := '2072656C61746976653B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206D61782D77696474683A20313030253B0A20206D696E2D77696474683A2038656D3B0A202077696474683A20313030253B0A2020666F6E742D73697A653A';
wwv_flow_api.g_varchar2_table(3) := '203172656D3B0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F';
wwv_flow_api.g_varchar2_table(4) := '6A2D73656C6563742D63686F696365207B0A2020746578742D616C69676E3A206C6566743B0A2020636F6C6F723A20233333333B0A2F2A20206261636B67726F756E642D636F6C6F723A20236663666466653B2A2F0A20206261636B67726F756E642D63';
wwv_flow_api.g_varchar2_table(5) := '6F6C6F723A236639663966393B0A2020626F726465722D7374796C653A20736F6C69643B0A2020626F726465722D636F6C6F723A20236466646664663B0A2020626F726465722D77696474683A203170783B0A2020626F726465722D7261646975733A20';
wwv_flow_api.g_varchar2_table(6) := '3270783B0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0A20202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207472616E73706172656E743B0A20202D6D6F7A2D626F782D73697A696E673A20626F7264';
wwv_flow_api.g_varchar2_table(7) := '65722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A202F2A20646973706C61793A20626C6F636B3B2A2F0A20206F766572666C6F773A2068696464656E3B0A2020706F736974696F6E3A2072656C61746976653B0A2020';
wwv_flow_api.g_varchar2_table(8) := '77686974652D73706163653A206E6F777261703B0A20206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A2020746578742D6F766572666C6F773A20656C6C69707369733B0A20206865696768743A20322E32383672656D3B0A';
wwv_flow_api.g_varchar2_table(9) := '20206C696E652D6865696768743A20322E32383672656D3B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63686F696365202E6F6A2D73656C6563742D63686F73656E207B0A202062';
wwv_flow_api.g_varchar2_table(10) := '6F726465723A20303B0A20206F75746C696E653A20303B0A202077686974652D73706163653A206E6F777261703B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206F766572666C6F773A2068696464656E3B0A2020746578742D6F';
wwv_flow_api.g_varchar2_table(11) := '766572666C6F773A20656C6C69707369733B0A202077696474683A20313030253B0A2020626F782D736861646F773A206E6F6E653B0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A2062';
wwv_flow_api.g_varchar2_table(12) := '6F726465722D626F783B0A2020666F6E742D73697A653A20312E3272656D3B0A7D0A0A68746D6C3A6E6F74285B6469723D2272746C225D29202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63';
wwv_flow_api.g_varchar2_table(13) := '686F696365202E6F6A2D73656C6563742D6172726F77207B0A202072696768743A20303B0A7D0A0A2F2A206F6A2D636F6D626F626F78202A2F0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78207B0A2020706F736974';
wwv_flow_api.g_varchar2_table(14) := '696F6E3A2072656C61746976653B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A2020766572746963616C2D616C69676E3A206D6964646C653B0A20206D61782D77696474683A20313030253B0A20206D696E2D77696474683A203865';
wwv_flow_api.g_varchar2_table(15) := '6D3B0A202077696474683A20313030253B0A2020666F6E742D73697A653A203172656D3B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365207B0A2020746578';
wwv_flow_api.g_varchar2_table(16) := '742D616C69676E3A206C6566743B0A2020636F6C6F723A20233333333B0A2F2A20206261636B67726F756E642D636F6C6F723A20236663666466653B2A2F0A20206261636B67726F756E642D636F6C6F723A236639663966393B0A2020626F726465722D';
wwv_flow_api.g_varchar2_table(17) := '7374796C653A20736F6C69643B0A2020626F726465722D636F6C6F723A20236466646664663B0A2020626F726465722D77696474683A203170783B0A2020626F726465722D7261646975733A203270783B0A20202D7765626B69742D617070656172616E';
wwv_flow_api.g_varchar2_table(18) := '63653A206E6F6E653B0A20202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207472616E73706172656E743B0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A2062';
wwv_flow_api.g_varchar2_table(19) := '6F726465722D626F783B0A20206865696768743A20322E32383672656D3B0A20206C696E652D6865696768743A20322E32383672656D3B0A202F2A20646973706C61793A20626C6F636B3B2A2F0A20206F75746C696E653A20303B0A20206F766572666C';
wwv_flow_api.g_varchar2_table(20) := '6F773A2068696464656E3B0A2020706F736974696F6E3A2072656C61746976653B0A202077686974652D73706163653A206E6F777261703B0A20206261636B67726F756E642D636C69703A2070616464696E672D626F783B0A7D0A0A2E617065782D6974';
wwv_flow_api.g_varchar2_table(21) := '656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D696E707574207B0A202077696474683A20313030253B0A2020626F726465723A20303B0A202070616464';
wwv_flow_api.g_varchar2_table(22) := '696E673A20303B0A2020626F782D736861646F773A206E6F6E653B0A20206F75746C696E653A20303B0A2F2A20206261636B67726F756E642D636F6C6F723A20236663666466653B2A2F0A6261636B67726F756E642D636F6C6F723A236639663966393B';
wwv_flow_api.g_varchar2_table(23) := '0A636F6C6F723A20233333333B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206F766572666C6F773A2068696464656E3B0A202077686974652D73706163653A206E6F777261703B0A2020746578742D6F766572666C6F773A2065';
wwv_flow_api.g_varchar2_table(24) := '6C6C69707369733B0A2020666F6E742D73697A653A20312E3272656D3B0A20206F726465723A20303B0A7D0A0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F';
wwv_flow_api.g_varchar2_table(25) := '6A2D636F6D626F626F782D636C6561722D656E747279207B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A20206F75746C696E653A206E6F6E653B0A2020746578742D616C69676E3A2063656E7465723B0A2020766572746963616C2D';
wwv_flow_api.g_varchar2_table(26) := '616C69676E3A206D6964646C653B0A20206C696E652D6865696768743A20313030253B0A7D0A0A2F2A206F6A2D73656C656374202A2F0A2E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374207B0A202068656967';
wwv_flow_api.g_varchar2_table(27) := '6874203A20313030253B0A20206D617267696E2D626F74746F6D3A3070783B0A7D0A0A2020202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63686F696365207B0A2020202068';
wwv_flow_api.g_varchar2_table(28) := '65696768743A20313030253B0A20202F2A20646973706C61793A207461626C653B2A2F0A2020202077696474683A20313030253B0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A';
wwv_flow_api.g_varchar2_table(29) := '2D73656C6563742D63686F696365202E6F6A2D73656C6563742D63686F73656E207B0A202020206865696768743A20313030253B0A20202020766572746963616C2D616C69676E3A206D6964646C653B0A20202020646973706C61793A207461626C652D';
wwv_flow_api.g_varchar2_table(30) := '63656C6C3B0A20202020746578742D616C69676E3A206C6566743B0A2020202070616464696E672D6C6566743A203870783B0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A2D73';
wwv_flow_api.g_varchar2_table(31) := '656C6563742D63686F696365202E6F6A2D73656C6563742D6172726F77207B0A202020206C696E652D6865696768743A2032656D3B0A20207D0A0A2F2A206F6A2D636F6D626F626F78202A2F0A20202E612D4947202E617065782D6974656D2D6F6A7365';
wwv_flow_api.g_varchar2_table(32) := '6C656374202E6F6A2D636F6D626F626F78207B0A20202020686569676874203A20313030253B0A202020206D617267696E2D626F74746F6D3A3070783B0A20207D0A20200A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A';
wwv_flow_api.g_varchar2_table(33) := '2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365207B0A202020206865696768743A20313030253B0A20202F2A2020646973706C61793A207461626C653B2A2F0A2020202077696474683A20313030253B0A202020207061646469';
wwv_flow_api.g_varchar2_table(34) := '6E673A203070783B0A20202020626F726465723A203070783B0A20207D0A20200A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F6A2D636F';
wwv_flow_api.g_varchar2_table(35) := '6D626F626F782D696E707574207B0A2020202020206865696768743A20313030253B0A20202020766572746963616C2D616C69676E3A206D6964646C653B0A20202020646973706C61793A207461626C652D63656C6C3B0A20202020746578742D616C69';
wwv_flow_api.g_varchar2_table(36) := '676E3A206C6566743B0A202020202F2A70616464696E673A203070783B2A2F0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A2D636F6D626F626F782D63686F696365202E6F';
wwv_flow_api.g_varchar2_table(37) := '6A2D636F6D626F626F782D636C6561722D656E747279207B0A2020202020646973706C61793A207461626C652D63656C6C3B0A20207D0A0A20202E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F78202E6F6A';
wwv_flow_api.g_varchar2_table(38) := '2D636F6D626F626F782D63686F696365202E6F6A2D636F6D626F626F782D6172726F77207B0A202020206C696E652D6865696768743A2032656D3B0A207D0A20200A202E617065782D6974656D2D6F6A73656C6563743A666F6375732C202E6F6A2D7365';
wwv_flow_api.g_varchar2_table(39) := '6C6563743A666F6375732C202E6F6A2D73656C6563742D63686F6963653A666F6375732C202E6F6A2D636F6D626F626F783A666F6375732C202E6F6A2D636F6D626F626F782D63686F6963653A666F6375732C202E6F6A2D636F6D626F626F782D696E70';
wwv_flow_api.g_varchar2_table(40) := '75743A666F6375732C0A202E617065782D6974656D2D6F6A73656C6563743A666F6375732D77697468696E2C202E6F6A2D73656C6563743A666F6375732D77697468696E2C202E6F6A2D73656C6563742D63686F6963653A666F6375732D77697468696E';
wwv_flow_api.g_varchar2_table(41) := '2C202E6F6A2D636F6D626F626F783A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D63686F6963653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732D77697468696E207B0A20206F';
wwv_flow_api.g_varchar2_table(42) := '75746C696E653A20303B0A7D0A0A2F2A206966206572726F72206368616E676520746F206170657820626F72646572207374796C65202A2F0A2E617065782D6974656D2D706C7567696E202E617065782D706167652D6974656D2D6572726F72207B0A20';
wwv_flow_api.g_varchar2_table(43) := '2020206261636B67726F756E642D636F6C6F723A202366666621696D706F7274616E743B0A2020626F726465722D636F6C6F723A202365623635363221696D706F7274616E743B0A7D0A2F2A2069662073656C6563746564206368616E676520746F2061';
wwv_flow_api.g_varchar2_table(44) := '70657820626F72646572207374796C65202A2F0A2E617065782D6974656D2D6F6A73656C6563743A666F6375732C202E6F6A2D73656C6563743A666F6375732C202E6F6A2D73656C6563742D63686F6963653A666F6375732C202E6F6A2D636F6D626F62';
wwv_flow_api.g_varchar2_table(45) := '6F783A666F6375732C202E6F6A2D636F6D626F626F782D63686F6963653A666F6375732C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732C0A202E617065782D6974656D2D6F6A73656C6563743A666F6375732D77697468696E2C202E6F';
wwv_flow_api.g_varchar2_table(46) := '6A2D73656C6563743A666F6375732D77697468696E2C202E6F6A2D73656C6563742D63686F6963653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F783A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D63686F6963';
wwv_flow_api.g_varchar2_table(47) := '653A666F6375732D77697468696E2C202E6F6A2D636F6D626F626F782D696E7075743A666F6375732D77697468696E207B0A202020206261636B67726F756E642D636F6C6F723A202366666621696D706F7274616E743B0A2020626F726465722D636F6C';
wwv_flow_api.g_varchar2_table(48) := '6F723A202330353732434521696D706F7274616E743B0A7D0A0A2E617065782D6974656D2D6F6A73656C6563743A686F7665722C202E6F6A2D73656C6563743A686F7665722C202E6F6A2D73656C6563742D63686F6963653A686F7665722C202E6F6A2D';
wwv_flow_api.g_varchar2_table(49) := '6C697374626F782D64726F703A686F7665722C202E6F6A2D636F6D626F626F783A686F7665722C202E6F6A2D636F6D626F626F782D63686F6963653A686F7665722C202E6F6A2D636F6D626F626F782D696E7075743A686F766572207B0A20206261636B';
wwv_flow_api.g_varchar2_table(50) := '67726F756E642D636F6C6F723A202366666621696D706F7274616E743B0A7D0A0A2F2A2073657474696E677320666F722073747265746368206974656D73202A2F0A2E742D466F726D2D2D73747265746368496E70757473202E742D466F726D2D666965';
wwv_flow_api.g_varchar2_table(51) := '6C64436F6E7461696E6572202E617065782D6974656D2D6F6A73656C6563742C202E742D466F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E70757473202E617065782D6974656D2D6F6A73656C656374207B0A2020666C65783A';
wwv_flow_api.g_varchar2_table(52) := '20313B0A20206D696E2D77696474683A20303B0A7D0A0A2F2A206368616E6765207468652064726F70646F776E2069636F6E202A2F0A2E617065782D6974656D2D6F6A73656C656374202E6F6A2D636F6D626F626F782D6F70656E2D69636F6E3A626566';
wwv_flow_api.g_varchar2_table(53) := '6F72652C202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C6563742D6F70656E2D69636F6E3A6265666F7265207B0A2020636F6E74656E743A20225C65363036223B0A20207472616E73666F726D3A20726F74617465283930646567';
wwv_flow_api.g_varchar2_table(54) := '293B0A7D200A0A2F2A207768656E207363726F6C6C696E6720746865206C697374626F782073686F756C6420676F20756E64657220746865207061676520686561646572202A2F0A2E6F6A2D6C697374626F782D64726F702D6C61796572207B0A20207A';
wwv_flow_api.g_varchar2_table(55) := '2D696E6465783A203830303B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(5350084376700044)
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
wwv_flow_api.g_varchar2_table(2) := '62737472696E6728726571756972652E732E636F6E74657874732E5F2E636F6E6669672E70617468732E6F6A732E6C617374496E6465784F6628222F6F7261636C656A65742F2229202B2031310D0A202020202C20726571756972652E732E636F6E7465';
wwv_flow_api.g_varchar2_table(3) := '7874732E5F2E636F6E6669672E70617468732E6F6A732E6C617374496E6465784F6628222F6A732F2229293B0D0A616462632E6170705F6964203D20617065782E6974656D282770466C6F77496427292E67657456616C756528293B0D0A616462632E61';
wwv_flow_api.g_varchar2_table(4) := '70705F706167655F6964203D20617065782E6974656D282770466C6F7753746570496427292E67657456616C756528293B0D0A616462632E6170705F626173655F75726C203D20617065785F696D675F646972202B20276C69627261726965732F6F7261';
wwv_flow_api.g_varchar2_table(5) := '636C656A65742F27202B20616462632E6A65745F76657273696F6E202B20272F6A732F273B0D0A616462632E6170705F626173655F6373735F75726C203D20617065785F696D675F646972202B20276C69627261726965732F6F7261636C656A65742F27';
wwv_flow_api.g_varchar2_table(6) := '202B20616462632E6A65745F76657273696F6E202B20272F6373732F273B0D0A616462632E6B6F203D207B7D3B0D0A0D0A2F2F6C6F6164206B6E6F636B6F75742062656361757365205B72657175697265206A65745D2066726F6D206170657820646F65';
wwv_flow_api.g_varchar2_table(7) := '736E27740D0A726571756972656A732E636F6E666967280D0A202020207B0D0A202020202020202070617468733A0D0A20202020202020207B0D0A202020202020202020202020276B6E6F636B6F7574273A20616462632E6170705F626173655F75726C';
wwv_flow_api.g_varchar2_table(8) := '202B20276C6962732F6B6E6F636B6F75742F6B6E6F636B6F75742D332E342E30272C0D0A20202020202020202020202027637373273A20616462632E6170705F626173655F75726C202B20276C6962732F726571756972652D6373732F6373732E6D696E';
wwv_flow_api.g_varchar2_table(9) := '270D0A20202020202020207D2C0D0A202020207D0D0A293B0D0A0D0A2F2F637265617465206F7220726575736520676C6F62616C2077696467657420666F7220616C6C20746865206F6A657420636F6D706F6E656E74730D0A7661722077696467657420';
wwv_flow_api.g_varchar2_table(10) := '3D20776964676574207C7C207B7D3B0D0A7769646765742E6F6A6574203D2077696E646F772E6F6A6574207C7C207B7D3B0D0A0D0A2F2F63726561746520746865206F6A73656C656374636F6D626F626F78206F626A6563740D0A7769646765742E6F6A';
wwv_flow_api.g_varchar2_table(11) := '65742E6F6A73656C656374636F6D626F626F78203D202866756E6374696F6E202864656275672C207574696C2C207365727665722C206974656D2C206D65737361676529207B0D0A202020207661722064656661756C744F7074696F6E73203D207B0D0A';
wwv_flow_api.g_varchar2_table(12) := '202020202020202076616C75653A2027272C0D0A20202020202020206F7074696F6E733A20275B5D272C0D0A2020202020202020636F6D706F6E656E743A20276F6A53656C656374272C0D0A2020202020202020706C616365686F6C6465723A2027272C';
wwv_flow_api.g_varchar2_table(13) := '0D0A202020202020202064697361626C65643A2066616C73652C0D0A20202020202020206D756C7469706C653A2066616C73650D0A202020207D3B0D0A0D0A20202020766172206974656D73203D205B5D3B0D0A202020207661722074656D704974656D';
wwv_flow_api.g_varchar2_table(14) := '203D207B7D3B0D0A0D0A202020206C6574205F637265617465203D2066756E6374696F6E20286974656D49642C206F7074696F6E7329207B0D0A20202020202020202F2F20636F7079206F7074696F6E7320616E64206170706C792064656661756C7473';
wwv_flow_api.g_varchar2_table(15) := '0D0A20202020202020206F7074696F6E73203D20242E657874656E6428747275652C207B7D2C2064656661756C744F7074696F6E732C206F7074696F6E73293B0D0A20202020202020206F7074696F6E732E76616C7565203D207574696C2E746F417272';
wwv_flow_api.g_varchar2_table(16) := '6179286F7074696F6E732E76616C756520213D3D202727203F206F7074696F6E732E76616C7565203A206E756C6C293B0D0A0D0A20202020202020202F2F444F4D206974656D202831207065722067726964290D0A202020202020202076617220697465';
wwv_flow_api.g_varchar2_table(17) := '6D24203D202428272327202B206974656D4964202B20275F4F4A4554434F4E5441494E455227293B0D0A20202020202020207661722076616C69646974794974656D24203D202428272327202B206974656D4964293B0D0A0D0A20202020202020202F2F';
wwv_flow_api.g_varchar2_table(18) := '706C7567696E20646174610D0A202020202020202076617220766965774D6F64656C203D207B7D3B0D0A0D0A20202020202020202F2F696E746572616374697665206772696420646174610D0A2020202020202020766172206967203D207B7D3B0D0A20';
wwv_flow_api.g_varchar2_table(19) := '2020202020202069672E6772696424203D206974656D242E636C6F7365737428272E742D4952522D726567696F6E2729207C7C205B5D3B0D0A202020202020202069672E697347726964203D2069672E67726964242E6C656E677468203D3D3D20313B0D';
wwv_flow_api.g_varchar2_table(20) := '0A202020202020202069672E64617461203D206E756C6C3B0D0A0D0A20202020202020206966202869672E69734772696429207B0D0A20202020202020202020202069672E67726964242E6F6E2822696E74657261637469766567726964766965776D6F';
wwv_flow_api.g_varchar2_table(21) := '64656C637265617465222C2066756E6374696F6E20286576656E742C2063757272656E745669657729207B0D0A2020202020202020202020202020202069672E697347726964203D20747275653B0D0A2020202020202020202020202020202069672E77';
wwv_flow_api.g_varchar2_table(22) := '6964676574203D20617065782E726567696F6E286576656E742E63757272656E745461726765742E6964292E77696467657428293B0D0A2020202020202020202020202020202069672E636F6C756D6E203D2069672E7769646765742E696E7465726163';
wwv_flow_api.g_varchar2_table(23) := '746976654772696428276F7074696F6E272C2027636F6E66696727292E636F6C756D6E732E66696C7465722861203D3E207B2072657475726E20612E7374617469634964203D3D3D206974656D4964207D293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(24) := '2069672E636F6C756D6E4E616D65203D2027273B0D0A0D0A202020202020202020202020202020202F2F746F646F3A20636865636B2069662074686973206974656D20697320696E207468652069670D0A20202020202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(25) := '2869672E636F6C756D6E2E6C656E677468203E203029207B0D0A202020202020202020202020202020202020202069672E636F6C756D6E4E616D65203D2069672E636F6C756D6E5B305D2E6E616D653B0D0A202020202020202020202020202020207D0D';
wwv_flow_api.g_varchar2_table(26) := '0A2020202020202020202020207D293B0D0A0D0A2020202020202020202020202F2F74686973206576656E74206F6E6C79206669726573207768656E207374617274696E6720746F20656469742074686520696E74657261637469766520677269642072';
wwv_flow_api.g_varchar2_table(27) := '6F770D0A20202020202020202020202069672E67726964242E6F6E282761706578626567696E7265636F726465646974272C2066756E6374696F6E20286576656E742C206461746129207B0D0A202020202020202020202020202020202F2F7361766520';
wwv_flow_api.g_varchar2_table(28) := '7468652065646974696E67207265636F7264206461746120676C6F62616C6C7920696E2074686520706C7567696E0D0A2020202020202020202020202020202069672E64617461203D20646174613B0D0A2020202020202020202020207D293B0D0A2020';
wwv_flow_api.g_varchar2_table(29) := '2020202020207D0D0A0D0A20202020202020202F2F696E697469616C697A65207669657720616E6420766965776D6F64656C0D0A202020202020202072657175697265285B276F6A732F6F6A636F7265272C20276B6E6F636B6F7574272C20276A717565';
wwv_flow_api.g_varchar2_table(30) := '7279272C20276F6A732F6F6A6B6E6F636B6F7574272C20276F6A732F6F6A73656C656374636F6D626F626F78270D0A2020202020202020202020202C20276373732127202B20616462632E6170705F626173655F6373735F75726C202B20276C6962732F';
wwv_flow_api.g_varchar2_table(31) := '6F6A2F7627202B20616462632E6A65745F76657273696F6E202B20272F616C74612F6F6A2D616C74612D6E6F7461672D6D696E2E637373275D2C0D0A20202020202020202020202066756E6374696F6E20286F6A2C206B6F2C202429207B0D0A20202020';
wwv_flow_api.g_varchar2_table(32) := '2020202020202020202020202F2F6D616B65206B6E6F636B6F757420676C6F62616C20746F2067657420746F20746865206D6F64756C6520646174610D0A20202020202020202020202020202020616462632E6B6F203D206B6F3B0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(33) := '20202020202020202020202F2F696E7374616E74696174652074686520766965774D6F64656C206F66207468697320766965770D0A20202020202020202020202020202020766965774D6F64656C203D206E6577202866756E6374696F6E202829207B0D';
wwv_flow_api.g_varchar2_table(34) := '0A20202020202020202020202020202020202020207661722073656C66203D20746869733B0D0A202020202020202020202020202020202020202073656C662E76616C756573203D206B6F2E6F627365727661626C654172726179285B5D293B0D0A0D0A';
wwv_flow_api.g_varchar2_table(35) := '202020202020202020202020202020202020202073656C662E6F7074696F6E73203D206B6F2E6F627365727661626C654172726179284A534F4E2E7061727365286F7074696F6E732E6F7074696F6E7329293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(36) := '202020202073656C662E636F6D706F6E656E74203D206F7074696F6E732E636F6D706F6E656E743B0D0A202020202020202020202020202020202020202073656C662E706C616365686F6C646572203D206F7074696F6E732E706C616365686F6C646572';
wwv_flow_api.g_varchar2_table(37) := '3B0D0A202020202020202020202020202020202020202073656C662E64697361626C6564203D206B6F2E6F627365727661626C65286F7074696F6E732E64697361626C6564293B0D0A202020202020202020202020202020202020202073656C662E6D75';
wwv_flow_api.g_varchar2_table(38) := '6C7469706C65203D206F7074696F6E732E6D756C7469706C653B0D0A0D0A202020202020202020202020202020202020202073656C662E646973706C617956616C7565466F72203D2066756E6374696F6E202876616C756529207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(39) := '20202020202020202020202020202020206C657420646973706C617956616C756573203D205B5D3B0D0A2020202020202020202020202020202020202020202020206C65742064617461417272203D2073656C662E6F7074696F6E7328293B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(40) := '20202020202020202020202020202020202020202020206C65742076616C75654172726179203D207574696C2E746F41727261792876616C7565293B0D0A20202020202020202020202020202020202020202020202076616C75654172726179203D2076';
wwv_flow_api.g_varchar2_table(41) := '616C756541727261792E66696C7465722866756E6374696F6E202876616C29207B0D0A2020202020202020202020202020202020202020202020202020202072657475726E2076616C2026262076616C20213D3D2027273B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(42) := '20202020202020202020202020207D293B0D0A20202020202020202020202020202020202020202020202076616C75654172726179203D2076616C756541727261792E6D617028537472696E67293B0D0A0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '2020202020202076616C756541727261792E666F7245616368282876616C75652C20696E64657829203D3E207B0D0A202020202020202020202020202020202020202020202020202020206C6574206C6162656C203D2027273B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(44) := '202020202020202020202020202020202020202069662028646174614172722E6C656E677468203E203020262620747970656F6620646174614172722E6368696C6472656E20213D3D2027756E646566696E65642729207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(45) := '202020202020202020202020202020202020202020202F2F776520686176652067726F7570730D0A20202020202020202020202020202020202020202020202020202020202020206C6574206461746147726F7570203D20646174614172722E66696E64';
wwv_flow_api.g_varchar2_table(46) := '2867726F7570203D3E2067726F75702E6368696C6472656E2E66696E64286F7074696F6E203D3E206F7074696F6E2E76616C7565203D3D3D2076616C756529293B0D0A202020202020202020202020202020202020202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(47) := '6620286461746147726F757029207B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202F2F776527766520666F756E64207468652076616C75650D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '20202020202020202020202020206C6162656C203D206461746147726F75702E6368696C6472656E2E66696E64286F7074696F6E203D3E206F7074696F6E2E76616C7565203D3D3D2076616C7565292E6C6162656C3B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(49) := '20202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F776520646F';
wwv_flow_api.g_varchar2_table(50) := '6E277420686176652067726F7570730D0A20202020202020202020202020202020202020202020202020202020202020206C6574206F626A656374203D20646174614172722E66696E64286F7074696F6E203D3E206F7074696F6E2E76616C7565203D3D';
wwv_flow_api.g_varchar2_table(51) := '3D2076616C7565293B0D0A2020202020202020202020202020202020202020202020202020202020202020696620286F626A65637429207B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202F2F77652776';
wwv_flow_api.g_varchar2_table(52) := '6520666F756E64207468652076616C75650D0A2020202020202020202020202020202020202020202020202020202020202020202020206C6162656C203D206F626A6563742E6C6162656C3B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202020202020202020696620286C6162656C203D3D20272729207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(54) := '20202020202020202020202020202020202020202020202020206C6162656C203D2076616C75653B0D0A202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(55) := '20646973706C617956616C7565732E70757368286C6162656C293B0D0A2020202020202020202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020202020202020202072657475726E20646973706C61795661';
wwv_flow_api.g_varchar2_table(56) := '6C7565733B0D0A20202020202020202020202020202020202020207D3B202F2F646973706C617956616C7565466F720D0A0D0A202020202020202020202020202020202020202073656C662E636F6E7374727563744F7074696F6E203D2066756E637469';
wwv_flow_api.g_varchar2_table(57) := '6F6E2028444F4D636F6E7461696E65722C206F7074696F6E29207B0D0A202020202020202020202020202020202020202020202020766172206368696C645370616E203D20646F63756D656E742E637265617465456C656D656E7428277370616E27293B';
wwv_flow_api.g_varchar2_table(58) := '0D0A202020202020202020202020202020202020202020202020696620286F7074696F6E2E69636F6E202626206F7074696F6E2E69636F6E2E6D61746368282F5C2F2F2929207B0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(59) := '20766172206368696C64496D67203D20646F63756D656E742E637265617465456C656D656E742827696D6727293B0D0A202020202020202020202020202020202020202020202020202020206368696C64496D672E736574417474726962757465282773';
wwv_flow_api.g_varchar2_table(60) := '7263272C206F7074696F6E2E69636F6E293B0D0A202020202020202020202020202020202020202020202020202020206368696C64496D672E7365744174747269627574652827726F6C65272C202770726573656E746174696F6E27293B0D0A20202020';
wwv_flow_api.g_varchar2_table(61) := '2020202020202020202020202020202020202020202020206368696C64496D672E73657441747472696275746528277374796C65272C2027766572746963616C2D616C69676E3A6D6964646C6527293B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '202020202020202020206368696C645370616E2E617070656E644368696C64286368696C64496D67293B0D0A2020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '2020202020206368696C645370616E2E7365744174747269627574652827636C617373272C206F7074696F6E2E69636F6E293B0D0A2020202020202020202020202020202020202020202020207D0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(64) := '20202020444F4D636F6E7461696E65722E617070656E644368696C64286368696C645370616E293B0D0A202020202020202020202020202020202020202020202020444F4D636F6E7461696E65722E617070656E644368696C6428646F63756D656E742E';
wwv_flow_api.g_varchar2_table(65) := '637265617465546578744E6F646528272027202B206F7074696F6E2E6C6162656C29293B0D0A0D0A20202020202020202020202020202020202020202020202072657475726E20444F4D636F6E7461696E65723B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(66) := '2020202020207D202F2F636F6E7374727563744F7074696F6E0D0A0D0A202020202020202020202020202020202020202073656C662E636F6E7374727563744772704F7074696F6E203D2066756E6374696F6E20286F7074696F6E29207B0D0A20202020';
wwv_flow_api.g_varchar2_table(67) := '202020202020202020202020202020202020202072657475726E20646F63756D656E742E637265617465546578744E6F6465286F7074696F6E2E6C6162656C293B0D0A20202020202020202020202020202020202020207D202F2F636F6E737472756374';
wwv_flow_api.g_varchar2_table(68) := '4772704F7074696F6E0D0A0D0A0D0A20202020202020202020202020202020202020202F2F646566696E65207468652066756E6374696F6E20746F20636F6E7665727420746865206F7074696F6E73204A534F4E20746F20612048544D4C206C69737420';
wwv_flow_api.g_varchar2_table(69) := '284A45542076322E302E32206F6E6C79290D0A202020202020202020202020202020202020202073656C662E6C69737452656E6465726572203D2066756E6374696F6E20286461746129207B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(70) := '20207661722067726F75704C697374203D20646F63756D656E742E637265617465456C656D656E742827756C27293B0D0A20202020202020202020202020202020202020202020202067726F75704C6973742E7365744174747269627574652827696427';
wwv_flow_api.g_varchar2_table(71) := '2C206974656D4964202B20275F4C49535427293B0D0A0D0A202020202020202020202020202020202020202020202020646174612E666F72456163682866756E6374696F6E20286974656D29207B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(72) := '20202020202020207661722067726F75704974656D203D20646F63756D656E742E637265617465456C656D656E7428276C6927293B0D0A0D0A20202020202020202020202020202020202020202020202020202020696620286974656D2E6368696C6472';
wwv_flow_api.g_varchar2_table(73) := '656E29207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F6974277320612067726F75700D0A20202020202020202020202020202020202020202020202020202020202020202F2F6372656174652067726F75';
wwv_flow_api.g_varchar2_table(74) := '70207469746C65206E6F64650D0A20202020202020202020202020202020202020202020202020202020202020207661722067726F75705469746C65203D20646F63756D656E742E637265617465456C656D656E74282764697627293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(75) := '20202020202020202020202020202020202020202020202020202067726F75705469746C652E617070656E644368696C642873656C662E636F6E7374727563744772704F7074696F6E286974656D29293B0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(76) := '202020202020202020202020202020766172206368696C6472656E4C697374203D20646F63756D656E742E637265617465456C656D656E742827756C27293B0D0A0D0A20202020202020202020202020202020202020202020202020202020202020202F';
wwv_flow_api.g_varchar2_table(77) := '2F63726561746520616C6C206368696C6420656E74726965730D0A20202020202020202020202020202020202020202020202020202020202020206974656D2E6368696C6472656E2E666F72456163682866756E6374696F6E20286974656D29207B0D0A';
wwv_flow_api.g_varchar2_table(78) := '202020202020202020202020202020202020202020202020202020202020202020202020766172206368696C644974656D203D20646F63756D656E742E637265617465456C656D656E7428276C6927293B0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(79) := '202020202020202020202020202020202020206368696C644974656D2E73657441747472696275746528276F6A2D646174612D76616C7565272C206974656D2E76616C7565293B0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(80) := '2020202020202020206368696C644974656D203D2073656C662E636F6E7374727563744F7074696F6E286368696C644974656D2C206974656D293B0D0A202020202020202020202020202020202020202020202020202020202020202020202020636869';
wwv_flow_api.g_varchar2_table(81) := '6C6472656E4C6973742E617070656E644368696C64286368696C644974656D293B0D0A20202020202020202020202020202020202020202020202020202020202020207D293B0D0A0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(82) := '2020202020202F2F61646420616C6C20746F2067726F7570206974656D0D0A202020202020202020202020202020202020202020202020202020202020202067726F75704974656D2E617070656E644368696C642867726F75705469746C65293B0D0A20';
wwv_flow_api.g_varchar2_table(83) := '2020202020202020202020202020202020202020202020202020202020202067726F75704974656D2E617070656E644368696C64286368696C6472656E4C697374293B0D0A202020202020202020202020202020202020202020202020202020207D2065';
wwv_flow_api.g_varchar2_table(84) := '6C7365207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F6974277320612073696E676C6520656E7472790D0A20202020202020202020202020202020202020202020202020202020202020202F2F63726561';
wwv_flow_api.g_varchar2_table(85) := '746520656E7472790D0A202020202020202020202020202020202020202020202020202020202020202067726F75704974656D2E73657441747472696275746528276F6A2D646174612D76616C7565272C206974656D2E76616C7565293B0D0A20202020';
wwv_flow_api.g_varchar2_table(86) := '2020202020202020202020202020202020202020202020202020202067726F75704974656D203D2073656C662E636F6E7374727563744F7074696F6E2867726F75704974656D2C206974656D293B0D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(87) := '20202020202020207D0D0A0D0A2020202020202020202020202020202020202020202020202020202067726F75704C6973742E617070656E644368696C642867726F75704974656D293B0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(88) := '7D293B0D0A0D0A202020202020202020202020202020202020202020202020646F63756D656E742E626F64792E617070656E644368696C642867726F75704C697374293B0D0A20202020202020202020202020202020202020207D202F2F6C6973745265';
wwv_flow_api.g_varchar2_table(89) := '6E64657265720D0A0D0A20202020202020202020202020202020202020202F2F646566696E65207468652066756E6374696F6E20746F2072656E64657220746865206F7074696F6E2C2063616C6C65642062792074686520636F6D706F6E656E7420284A';
wwv_flow_api.g_varchar2_table(90) := '45542076342E322E30206F6E6C79290D0A202020202020202020202020202020202020202073656C662E6F7074696F6E52656E6465726572203D2066756E6374696F6E20286F7074696F6E436F6E7465787429207B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(91) := '2020202020202020202020766172206C6162656C4E6F6465203D20646F63756D656E742E637265617465456C656D656E74282764697627293B0D0A0D0A202020202020202020202020202020202020202020202020696620286F7074696F6E436F6E7465';
wwv_flow_api.g_varchar2_table(92) := '78742E6C65616629207B0D0A202020202020202020202020202020202020202020202020202020202F2F6974277320612073696E676C6520656E7472790D0A202020202020202020202020202020202020202020202020202020206C6162656C4E6F6465';
wwv_flow_api.g_varchar2_table(93) := '203D2073656C662E636F6E7374727563744F7074696F6E286C6162656C4E6F64652C206F7074696F6E436F6E746578742E64617461293B0D0A2020202020202020202020202020202020202020202020207D20656C7365207B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(94) := '202020202020202020202020202020202020202F2F6974277320612067726F757020656E7472790D0A202020202020202020202020202020202020202020202020202020206C6162656C4E6F64652E617070656E644368696C642873656C662E636F6E73';
wwv_flow_api.g_varchar2_table(95) := '74727563744772704F7074696F6E286F7074696F6E436F6E746578742E6461746129293B0D0A2020202020202020202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020202020202020202072657475726E207B20';
wwv_flow_api.g_varchar2_table(96) := '696E736572743A206C6162656C4E6F6465207D3B0D0A20202020202020202020202020202020202020207D202F2F6F7074696F6E52656E64657265720D0A0D0A202020202020202020202020202020202020202073656C662E76616C7565732E73756273';
wwv_flow_api.g_varchar2_table(97) := '63726962652866756E6374696F6E202876616C75657329207B0D0A20202020202020202020202020202020202020202020202076616C69646974794974656D242E76616C2876616C756573293B0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(98) := '2020206966202869672E6973477269642026262069672E6461746120213D3D206E756C6C29207B0D0A202020202020202020202020202020202020202020202020202020202F2F74686520706C7567696E206461746120686173206368616E6765642C20';
wwv_flow_api.g_varchar2_table(99) := '7570646174652074686520696E7465726163746976652067726964207265636F72640D0A20202020202020202020202020202020202020202020202020202020766172206D6F64656C203D2069672E646174612E6D6F64656C3B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(100) := '202020202020202020202020202020202020202076617220726563203D2069672E646174612E7265636F72643B0D0A2020202020202020202020202020202020202020202020202020202076617220646973706C617956616C756573203D2073656C662E';
wwv_flow_api.g_varchar2_table(101) := '646973706C617956616C7565466F722876616C756573293B0D0A20202020202020202020202020202020202020202020202020202020766172206E657756616C75653B0D0A20202020202020202020202020202020202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(102) := '28216F7074696F6E732E6D756C7469706C6529207B0D0A20202020202020202020202020202020202020202020202020202020202020206E657756616C7565203D207B20763A2076616C7565735B305D2C20643A20646973706C617956616C7565735B30';
wwv_flow_api.g_varchar2_table(103) := '5D207D3B0D0A202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020202020202020202020206E657756616C7565203D207B20763A2076616C7565732C20';
wwv_flow_api.g_varchar2_table(104) := '643A20646973706C617956616C756573207D3B0D0A202020202020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020202020202020206D6F64656C2E73657456616C7565287265632C20';
wwv_flow_api.g_varchar2_table(105) := '69672E636F6C756D6E4E616D652C206E657756616C7565293B0D0A2020202020202020202020202020202020202020202020202020202069672E64617461203D206E756C6C3B0D0A0D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(106) := '2020766172206576656E74203D206A51756572792E4576656E742822666F6375736F757422293B0D0A202020202020202020202020202020202020202020202020202020206576656E742E6F6A5265616479203D20747275653B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(107) := '20202020202020202020202020202020202020206974656D242E74726967676572286576656E74293B0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(108) := '20202020202020202020207D293B202F2F6E657720766965774D6F64656C0D0A0D0A202020202020202020202020202020207661722072656E6465724A4554436F6D706F6E656E74203D2066756E6374696F6E202829207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(109) := '20202020202020202020766172204A4554436F6D706F6E656E743B0D0A20202020202020202020202020202020202020207377697463682028616462632E6A65745F76657273696F6E29207B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(110) := '2020636173652027322E302E32273A0D0A202020202020202020202020202020202020202020202020202020204A4554436F6D706F6E656E74203D20273C64697620646174612D62696E643D226F6A436F6D706F6E656E743A207B27202B0D0A20202020';
wwv_flow_api.g_varchar2_table(111) := '2020202020202020202020202020202020202020202020202020202027636F6D706F6E656E743A636F6D706F6E656E7427202B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F272C6F7074696F6E733A6F7074';
wwv_flow_api.g_varchar2_table(112) := '696F6E7327202B0D0A2020202020202020202020202020202020202020202020202020202020202020272C6C6973743A5C2727202B206974656D4964202B20275F4C4953545C2727202B0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(113) := '2020202020202020272C76616C75653A76616C75657327202B0D0A2020202020202020202020202020202020202020202020202020202020202020272C706C616365686F6C6465723A706C616365686F6C64657227202B0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(114) := '202020202020202020202020202020202020202020272C64697361626C65643A64697361626C656427202B0D0A2020202020202020202020202020202020202020202020202020202020202020272C6D756C7469706C653A6D756C7469706C6527202B0D';
wwv_flow_api.g_varchar2_table(115) := '0A2020202020202020202020202020202020202020202020202020202020202020277D222F3E273B0D0A20202020202020202020202020202020202020202020202020202020627265616B3B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(116) := '2020636173652027342E322E30273A0D0A2020202020202020202020202020202020202020202020202020202076617220636F6D706F6E656E744E616D653B0D0A2020202020202020202020202020202020202020202020202020202073776974636820';
wwv_flow_api.g_varchar2_table(117) := '286F7074696F6E732E636F6D706F6E656E7429207B0D0A20202020202020202020202020202020202020202020202020202020202020206361736520276F6A53656C656374273A0D0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(118) := '202020202020202020696620286F7074696F6E732E6D756C7469706C6529207B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636F6D706F6E656E744E616D65203D20276F6A2D73656C656374';
wwv_flow_api.g_varchar2_table(119) := '2D6D616E79273B0D0A2020202020202020202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636F6D706F';
wwv_flow_api.g_varchar2_table(120) := '6E656E744E616D65203D20276F6A2D73656C6563742D6F6E65273B0D0A2020202020202020202020202020202020202020202020202020202020202020202020207D0D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(121) := '20202020627265616B3B0D0A20202020202020202020202020202020202020202020202020202020202020206361736520276F6A436F6D626F626F78273A0D0A202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(122) := '696620286F7074696F6E732E6D756C7469706C6529207B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636F6D706F6E656E744E616D65203D20276F6A2D636F6D626F626F782D6D616E79273B';
wwv_flow_api.g_varchar2_table(123) := '0D0A2020202020202020202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020202020202020202020202020202020202020202020636F6D706F6E656E744E616D';
wwv_flow_api.g_varchar2_table(124) := '65203D20276F6A2D636F6D626F626F782D6F6E65273B0D0A2020202020202020202020202020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020202020202020202020202020202020202062';
wwv_flow_api.g_varchar2_table(125) := '7265616B3B0D0A202020202020202020202020202020202020202020202020202020202020202064656661756C743A0D0A2020202020202020202020202020202020202020202020202020202020202020202020207468726F7720275468697320747970';
wwv_flow_api.g_varchar2_table(126) := '65206F6620636F6D706F6E656E74206973206E6F7420737570706F727465642E273B0D0A202020202020202020202020202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202020202020202020202020204A4554';
wwv_flow_api.g_varchar2_table(127) := '436F6D706F6E656E74203D20273C27202B20636F6D706F6E656E744E616D65202B20272027202B0D0A2020202020202020202020202020202020202020202020202020202020202020276F7074696F6E733D225B5B6F7074696F6E735D5D222027202B0D';
wwv_flow_api.g_varchar2_table(128) := '0A20202020202020202020202020202020202020202020202020202020202020202776616C75653D7B7B76616C7565737D7D20222027202B0D0A202020202020202020202020202020202020202020202020202020202020202027706C616365686F6C64';
wwv_flow_api.g_varchar2_table(129) := '65723D7B7B706C616365686F6C6465727D7D2027202B0D0A20202020202020202020202020202020202020202020202020202020202020202764697361626C65643D7B7B64697361626C65647D7D2027202B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(130) := '20202020202020202020202020202020276F7074696F6E2D72656E64657265723D225B5B6F7074696F6E52656E64657265725D5D2227202B0D0A2020202020202020202020202020202020202020202020202020202020202020272F3E273B0D0A202020';
wwv_flow_api.g_varchar2_table(131) := '20202020202020202020202020202020202020202020202020627265616B3B0D0A20202020202020202020202020202020202020202020202064656661756C743A0D0A202020202020202020202020202020202020202020202020202020204A4554436F';
wwv_flow_api.g_varchar2_table(132) := '6D706F6E656E74203D20273C7370616E3E546869732076657273696F6E206F66204A4554206973206E6F7420737570706F727465642E3C2F7370616E3E273B0D0A20202020202020202020202020202020202020207D0D0A0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(133) := '2020202020202020202072657475726E204A4554436F6D706F6E656E743B0D0A202020202020202020202020202020207D202F2F72656E6465724A4554436F6D706F6E656E740D0A0D0A202020202020202020202020202020202F2F696E7374616E7469';
wwv_flow_api.g_varchar2_table(134) := '6174652074686520766965772062792065646974696E672074686520636F6E7461696E6572206D6164652062792074686520706C7567696E20504C2F53514C20636F64650D0A202020202020202020202020202020206966202869672E69734772696429';
wwv_flow_api.g_varchar2_table(135) := '207B0D0A20202020202020202020202020202020202020206974656D242E6F6E2827666F637573696E272C2066756E6374696F6E20286529207B0D0A2020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A202020';
wwv_flow_api.g_varchar2_table(136) := '20202020202020202020202020202020207D290D0A2020202020202020202020202020202020202020202020202E6F6E2827666F6375736F7574272C2066756E6374696F6E20286529207B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(137) := '20202020206966202821652E6F6A526561647929207B0D0A2020202020202020202020202020202020202020202020202020202020202020652E73746F7050726F7061676174696F6E28293B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(138) := '2020202020207D0D0A202020202020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A2020202020202020202020202020202020202020202020207D290D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(139) := '20202E6F6E28276B6579646F776E272C2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A2020202020202020202020202020202020202020202020207D29';
wwv_flow_api.g_varchar2_table(140) := '0D0A2020202020202020202020202020202020202020202020202E6F6E28276B65797570272C2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202020202020202020202020202F2F64656275676765723B0D0A20202020';
wwv_flow_api.g_varchar2_table(141) := '20202020202020202020202020202020202020207D290D0A2020202020202020202020202020202020202020202020202E6F6E2827636C69636B272C2066756E6374696F6E20286529207B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(142) := '20202020202F2F64656275676765723B0D0A2020202020202020202020202020202020202020202020207D293B0D0A0D0A20202020202020202020202020202020202020206974656D242E77726170496E6E65722872656E6465724A4554436F6D706F6E';
wwv_flow_api.g_varchar2_table(143) := '656E74293B0D0A20202020202020202020202020202020202020206974656D242E63737328277769647468272C20273130302527293B0D0A20202020202020202020202020202020202020206974656D242E706172656E7428292E637373282768656967';
wwv_flow_api.g_varchar2_table(144) := '6874272C20273130302527293B0D0A202020202020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020202020206974656D242E77726170496E6E65722872656E6465724A4554436F6D706F6E656E74293B0D0A20';
wwv_flow_api.g_varchar2_table(145) := '2020202020202020202020202020207D3B0D0A0D0A20202020202020202020202020202020617065782E7365727665722E706C7567696E286F7074696F6E732E616A61784964656E7469666965722C207B7D2C207B2064617461547970653A20276A736F';
wwv_flow_api.g_varchar2_table(146) := '6E27207D290D0A20202020202020202020202020202020202020202E7468656E2866756E6374696F6E20286461746129207B0D0A2020202020202020202020202020202020202020202020202F2F706F70756C6174652074686520766965776D6F64656C';
wwv_flow_api.g_varchar2_table(147) := '207769746820646174610D0A202020202020202020202020202020202020202020202020766965774D6F64656C2E6F7074696F6E732864617461293B0D0A202020202020202020202020202020202020202020202020766965774D6F64656C2E76616C75';
wwv_flow_api.g_varchar2_table(148) := '6573286F7074696F6E732E76616C7565293B0D0A0D0A2020202020202020202020202020202020202020202020202F2F7072657061726520746865206C697374206F7074696F6E73206265666F7265206B6E6F636B6F7574206973206163746976617465';
wwv_flow_api.g_varchar2_table(149) := '640D0A2020202020202020202020202020202020202020202020207377697463682028616462632E6A65745F76657273696F6E29207B0D0A20202020202020202020202020202020202020202020202020202020636173652027322E302E32273A0D0A20';
wwv_flow_api.g_varchar2_table(150) := '20202020202020202020202020202020202020202020202020202020202020766965774D6F64656C2E6C69737452656E64657265722864617461293B0D0A2020202020202020202020202020202020202020202020202020202020202020627265616B3B';
wwv_flow_api.g_varchar2_table(151) := '0D0A20202020202020202020202020202020202020202020202020202020636173652027342E322E30273A0D0A2020202020202020202020202020202020202020202020202020202020202020627265616B3B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(152) := '2020202020202020207D0D0A0D0A2020202020202020202020202020202020202020202020202F2F6163746976617465206B6E6F636B6F757420666F7220746865207669657720616E6420766965776D6F64656C20746F206265636F6D65206163746976';
wwv_flow_api.g_varchar2_table(153) := '650D0A2020202020202020202020202020202020202020202020206B6F2E6170706C7942696E64696E677328766965774D6F64656C2C206974656D245B305D293B0D0A20202020202020202020202020202020202020207D2C2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(154) := '6461746129207B0D0A202020202020202020202020202020202020202020202020646174612E726573706F6E73654A534F4E203D207B206572726F723A2022496E76616C696420416A61782063616C6C2122207D0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(155) := '2020202020207D293B0D0A2020202020202020202020207D202F2F63616C6C6261636B0D0A2020202020202020293B202F2F726571756972650D0A0D0A20202020202020202F2F637265617465207468652061706578206974656D206F75747369646520';
wwv_flow_api.g_varchar2_table(156) := '7468652063616C6C6261636B2066756E6374696F6E0D0A20202020202020202F2F666F722074686520696E74657261637469766520677269643A207468657265206973206F6E6C79206F6E6520706572206772696420636F6C756D6E0D0A202020202020';
wwv_flow_api.g_varchar2_table(157) := '20206974656D2E637265617465286974656D49642C207B0D0A2020202020202020202020206E756C6C56616C75653A206F7074696F6E732E6E756C6C56616C75652C0D0A20202020202020202020202073657456616C75653A2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(158) := '76616C756529207B0D0A20202020202020202020202020202020696620282176616C756529207B0D0A202020202020202020202020202020202020202076616C7565203D2027273B0D0A202020202020202020202020202020207D0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(159) := '20202020202020202020202F2F7265736574207468652073656C65637465642064617461207265636F72640D0A2020202020202020202020202020202069672E64617461203D206E756C6C3B0D0A0D0A202020202020202020202020202020202F2F7379';
wwv_flow_api.g_varchar2_table(160) := '6E6368726F6E697365207468652076616C7565206F66207468652061706578206974656D20776974682074686520766965774D6F64656C0D0A202020202020202020202020202020207661722076616C75654172726179203D207574696C2E746F417272';
wwv_flow_api.g_varchar2_table(161) := '61792876616C7565293B0D0A2020202020202020202020202020202076616C75654172726179203D2076616C756541727261792E66696C7465722866756E6374696F6E202876616C29207B0D0A2020202020202020202020202020202020202020726574';
wwv_flow_api.g_varchar2_table(162) := '75726E2076616C2026262076616C20213D3D2027273B0D0A202020202020202020202020202020207D293B0D0A2020202020202020202020202020202076616C75654172726179203D2076616C756541727261792E6D617028537472696E67293B0D0A20';
wwv_flow_api.g_varchar2_table(163) := '202020202020202020202020202020766965774D6F64656C2E76616C7565732876616C75654172726179293B0D0A2020202020202020202020207D2C0D0A20202020202020202020202067657456616C75653A2066756E6374696F6E202829207B0D0A20';
wwv_flow_api.g_varchar2_table(164) := '2020202020202020202020202020207661722076616C7565203D206F7074696F6E732E76616C75653B0D0A2020202020202020202020202020202069662028766965774D6F64656C2E76616C75657329207B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(165) := '202020202F2F72657475726E207468652076616C7565206F6620746865206974656D2066726F6D2074686520766965774D6F64656C0D0A202020202020202020202020202020202020202076616C7565203D20766965774D6F64656C2E76616C75657328';
wwv_flow_api.g_varchar2_table(166) := '293B0D0A202020202020202020202020202020207D0D0A0D0A2020202020202020202020202020202069662028216F7074696F6E732E6D756C7469706C6529207B0D0A202020202020202020202020202020202020202076616C7565203D2076616C7565';
wwv_flow_api.g_varchar2_table(167) := '5B305D3B0D0A202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020696620282176616C756529207B0D0A202020202020202020202020202020202020202076616C7565203D2027273B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(168) := '202020202020207D0D0A0D0A2020202020202020202020202020202072657475726E2076616C75653B0D0A2020202020202020202020207D2C0D0A20202020202020202020202064697361626C653A2066756E6374696F6E20286529207B0D0A20202020';
wwv_flow_api.g_varchar2_table(169) := '2020202020202020202020202F2F64697361626C6520746865206974656D0D0A20202020202020202020202020202020766965774D6F64656C2E64697361626C65642874727565293B0D0A2020202020202020202020207D2C0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(170) := '202020656E61626C653A2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202F2F656E61626C6520746865206974656D0D0A20202020202020202020202020202020766965774D6F64656C2E64697361626C65642866616C';
wwv_flow_api.g_varchar2_table(171) := '7365293B0D0A2020202020202020202020207D2C0D0A202020202020202020202020646973706C617956616C7565466F723A2066756E6374696F6E202876616C756529207B0D0A2020202020202020202020202020202069662028766965774D6F64656C';
wwv_flow_api.g_varchar2_table(172) := '2E76616C75657329207B0D0A20202020202020202020202020202020202020202F2F736561726368207468652072657475726E2076616C756520696E2074686520766965774D6F64656C20616E642072657475726E2074686520646973706C6179207661';
wwv_flow_api.g_varchar2_table(173) := '6C75650D0A20202020202020202020202020202020202020207661722076616C75654172726179203D207574696C2E746F41727261792876616C7565293B0D0A202020202020202020202020202020202020202076616C75654172726179203D2076616C';
wwv_flow_api.g_varchar2_table(174) := '756541727261792E66696C7465722866756E6374696F6E202876616C29207B0D0A20202020202020202020202020202020202020202020202072657475726E2076616C2026262076616C20213D3D2027273B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(175) := '202020207D293B0D0A202020202020202020202020202020202020202076616C75654172726179203D2076616C756541727261792E6D617028537472696E67293B0D0A0D0A20202020202020202020202020202020202020202F2F72657475726E207468';
wwv_flow_api.g_varchar2_table(176) := '6520646973706C617956616C7565206F6620746865206974656D2066726F6D2074686520766965774D6F64656C0D0A2020202020202020202020202020202020202020766965774D6F64656C2E646973706C617956616C7565466F722876616C75654172';
wwv_flow_api.g_varchar2_table(177) := '726179293B0D0A202020202020202020202020202020207D0D0A0D0A20202020202020202020202020202020696620282176616C756529207B0D0A202020202020202020202020202020202020202076616C7565203D2027273B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(178) := '20202020202020207D0D0A0D0A2020202020202020202020202020202072657475726E2076616C75653B0D0A2020202020202020202020207D0D0A20202020202020207D293B202F2F6974656D2E6372656174650D0A0D0A20202020202020202F2F696E';
wwv_flow_api.g_varchar2_table(179) := '697469616C697A652074686973206974656D0D0A202020202020202074656D704974656D2E6964203D206974656D49643B0D0A202020202020202074656D704974656D2E6F7074696F6E73203D206F7074696F6E733B0D0A202020202020202074656D70';
wwv_flow_api.g_varchar2_table(180) := '4974656D2E61706578203D206974656D286974656D4964293B0D0A202020202020202074656D704974656D2E6E6F6465203D2076616C69646974794974656D243B0D0A202020202020202074656D704974656D2E73657444617461203D2066756E637469';
wwv_flow_api.g_varchar2_table(181) := '6F6E20286461746129207B0D0A2020202020202020202020206974656D286974656D4964292E73657456616C7565282727293B0D0A202020202020202020202020766965774D6F64656C2E6F7074696F6E732864617461290D0A20202020202020207D3B';
wwv_flow_api.g_varchar2_table(182) := '0D0A202020202020202074656D704974656D2E67657444617461203D2066756E6374696F6E202829207B0D0A20202020202020202020202072657475726E20766965774D6F64656C2E6F7074696F6E7328293B0D0A20202020202020207D3B0D0A202020';
wwv_flow_api.g_varchar2_table(183) := '20202020206974656D732E707573682874656D704974656D293B0D0A202020202020202074656D704974656D203D207B7D3B0D0A202020207D3B202F2F5F6372656174650D0A0D0A2020202072657475726E207B0D0A2020202020202020637265617465';
wwv_flow_api.g_varchar2_table(184) := '3A205F6372656174650D0A20202020202020202C206974656D733A206974656D730D0A20202020202020202C20696E666F3A2066756E6374696F6E202829207B2072657475726E20276F6A53656C656374436F6D626F626F7820706C7567696E20666F72';
wwv_flow_api.g_varchar2_table(185) := '204F4A45542076322E302E32202F2076342E322E3027207D0D0A20202020202020202C2076657273696F6E3A2066756E6374696F6E202829207B2072657475726E2027312E3527207D0D0A202020207D3B0D0A0D0A7D2928617065782E64656275672C20';
wwv_flow_api.g_varchar2_table(186) := '617065782E7574696C2C20617065782E7365727665722C20617065782E6974656D2C20617065782E6D657373616765293B0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(5351374109025834)
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
