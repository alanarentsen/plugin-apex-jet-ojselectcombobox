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
,p_default_application_id=>106
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
 p_id=>wwv_flow_api.id(3135065635554079)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.ADBC.APEX.JET.OJSELECTCOMBOBOX'
,p_display_name=>'Select List OJET'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'[require jet]#PLUGIN_FILES#ojselectcombobox.js'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/oraclejet/2.0.2/css/libs/oj/v2.0.2/alta/oj-alta-notag-min.css',
'#PLUGIN_FILES#ojselectcombobox.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render(p_item   in apex_plugin.t_item,',
'                 p_plugin in apex_plugin.t_plugin,',
'                 p_param  in apex_plugin.t_item_render_param,',
'                 p_result in out nocopy apex_plugin.t_item_render_result) is',
'  l_type          varchar2(50) := p_item.attribute_01;',
'  l_placeholder   varchar2(50) := p_item.attribute_02;',
'  ',
'  l_name          varchar2(30);',
'  l_display_value varchar2(32767);',
'',
'  c_display_column constant pls_integer := 1;',
'  c_return_column  constant pls_integer := 2;',
'  c_group_column   constant pls_integer := 3;',
'',
'  -- value without the lov null value',
'  l_value varchar2(32767) := case',
'                               when p_param.value = p_item.lov_null_value then',
'                                null',
'                               else',
'                                p_param.value',
'                             end;',
'  l_options           clob;',
'  l_column_value_list wwv_flow_plugin_util.t_column_value_list;',
'  l_value_found       boolean := false;',
'  l_group_value       varchar2(4000);',
'  l_last_group_value  varchar2(4000);',
'  l_open_group        boolean := false;',
'',
'  c_escaped_value constant varchar2(32767) := apex_escape.html_attribute(p_param.value);',
'begin',
'  if wwv_flow.g_debug then',
'    apex_plugin_util.debug_page_item(p_plugin              => p_plugin,',
'                                     p_page_item           => p_item,',
'                                     p_value               => p_param.value,',
'                                     p_is_readonly         => p_param.is_readonly,',
'                                     p_is_printer_friendly => p_param.is_printer_friendly);',
'  end if;',
'',
'  if (p_param.is_readonly or p_param.is_printer_friendly) then',
'    apex_plugin_util.print_hidden_if_readonly(p_item_name           => p_item.name,',
'                                              p_value               => p_param.value,',
'                                              p_is_readonly         => p_param.is_readonly,',
'                                              p_is_printer_friendly => p_param.is_printer_friendly);',
'  ',
'    -- get the display value',
'    l_display_value := apex_plugin_util.get_display_data(p_sql_statement     => p_item.lov_definition,',
'                                                         p_min_columns       => 2,',
'                                                         p_max_columns       => 3,',
'                                                         p_component_name    => p_item.name,',
'                                                         p_display_column_no => c_display_column,',
'                                                         p_search_column_no  => c_return_column,',
'                                                         p_search_string     => l_value,',
'                                                         p_display_extra     => p_item.lov_display_extra);',
'  ',
'    -- emit display span with the value',
'    apex_plugin_util.print_display_only(p_item_name        => p_item.name,',
'                                        p_display_value    => l_display_value,',
'                                        p_show_line_breaks => false,',
'                                        p_escape           => true,',
'                                        p_attributes       => p_item.element_attributes);',
'  else',
'    l_name := apex_plugin.get_input_name_for_item;',
'  ',
'    -- create list',
'    apex_json.initialize_clob_output;',
'    apex_json.open_array;',
'  ',
'    -- add extra list entry with null value to the list ',
'    if p_item.lov_display_null then',
'      -- add list entry      ',
'      apex_json.open_object;',
'      apex_json.write(''value'', '''');',
'      apex_json.write(''label'', '''');',
'      apex_json.close_object;',
'      ',
'      -- we have to tell the APEX JS framework which value should be considered as NULL',
'      if p_item.lov_null_value is not null then',
'        apex_javascript.add_onload_code (p_code => ''apex.widget.initPageItem('' || apex_javascript.add_value(p_item.name) ||',
'                                                   ''{ '' || apex_javascript.add_attribute(''nullValue'', p_item.lov_null_value, true, false) || ''});'' );',
'      end if;',
'    end if;',
'  ',
'    -- get all values',
'    l_column_value_list := apex_plugin_util.get_data(p_sql_statement  => p_item.lov_definition,',
'                                                     p_min_columns    => 2,',
'                                                     p_max_columns    => 3,',
'                                                     p_component_name => p_item.name);',
'  ',
'    -- loop through the result',
'    for i in 1 .. l_column_value_list(c_display_column).count loop',
'      -- if the current item value is in the list then the value is found',
'      l_value_found := (l_value = l_column_value_list(c_return_column)',
'                        (i) or l_value_found);',
'    ',
'      -- if there is a group specified, handle the group list entry',
'      begin',
'        l_group_value := l_column_value_list(c_group_column)(i);',
'        if (l_group_value <> l_last_group_value) or',
'           (l_group_value is     null and l_last_group_value is not null) or',
'           (l_group_value is not null and l_last_group_value is     null)',
'        then',
'          -- close the group list entry',
'          if l_open_group then',
'            apex_json.close_array();',
'            apex_json.close_object();',
'            l_open_group := false;',
'          end if;',
'',
'          -- add a group list entry',
'          if l_group_value is not null then',
'            l_open_group := true;',
'            apex_json.open_object;',
'            apex_json.write(''label'', l_group_value);',
'            apex_json.open_array(''children'');',
'          end if;',
'',
'          l_last_group_value := l_group_value;',
'        end if;',
'      exception',
'        when no_data_found then ',
'          null;',
'      end;',
'      ',
'      -- add list entry',
'      apex_json.open_object;',
'      apex_json.write(''value'', l_column_value_list(c_return_column) (i));',
'      apex_json.write(''label'', l_column_value_list(c_display_column) (i));',
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
'      apex_json.write(''value'', l_value);',
'      apex_json.write(''label'', l_value);',
'      apex_json.close_object;',
'      ',
'      -- We have to tell the APEX JS framework which value should be considered as NULL',
'      if p_item.lov_null_value is not null then',
'        apex_javascript.add_onload_code(p_code => ''apex.widget.initPageItem('' || apex_javascript.add_value(p_item.name) ||',
'                                                  ''{ '' || apex_javascript.add_attribute(''nullValue'', p_item.lov_null_value, true, false) || ''});'' );',
'      end if;',
'    end if;',
'  ',
'    apex_json.close_array;',
'    l_options := apex_json.get_clob_output;',
'  ',
'    -- render the container div ',
'    sys.htp.prn(''<div'' ||',
'                wwv_flow_plugin_util.get_element_attributes(p_item,',
'                                                            l_name,',
'                                                            ''apex-item-ojselect apex-item-plugin'',',
'                                                            false) ||',
'                ''id="'' || p_item.name || ''" '' || ''>'' || ''</div>'');',
'  ',
'    -- create the item',
'    apex_javascript.add_onload_code(p_code => ''widget.ojet.ojselectcombobox.create("'' ||',
'                                              p_item.name || ''", {'' ||',
'                                              apex_javascript.add_attribute(''value'',',
'                                                                            case',
'                                                                              when p_param.value is null then',
'                                                                               ''''',
'                                                                              else',
'                                                                               ltrim(rtrim(c_escaped_value))',
'                                                                            end,',
'                                                                            true,',
'                                                                            true) ||',
'                                              apex_javascript.add_attribute(''options'',',
'                                                                            l_options,',
'                                                                            true,',
'                                                                            true) ||',
'                                              apex_javascript.add_attribute(''component'',',
'                                                                            l_type,',
'                                                                            true,',
'                                                                            true) ||',
'                                              apex_javascript.add_attribute(''placeholder'',',
'                                                                            l_placeholder,',
'                                                                            true,',
'                                                                            true) ||',
'                                              apex_javascript.add_attribute(''nullValue'',',
'                                                                            p_item.lov_null_value,',
'                                                                            true,',
'                                                                            false) ||',
'                                              ''});'');',
'  end if;',
'',
'  p_result.is_navigable := (not p_param.is_readonly = false and',
'                           not p_param.is_printer_friendly);',
'end render;',
'',
'procedure metadata(p_item   in apex_plugin.t_item,',
'                   p_plugin in apex_plugin.t_plugin,',
'                   p_param  in apex_plugin.t_item_meta_data_param,',
'                   p_result in out nocopy apex_plugin.t_item_meta_data_result) is',
'begin',
'  p_result.escape_output := false;',
'end metadata;',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_meta_data_function=>'metadata'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:ELEMENT_OPTION:ENCRYPT:LOV'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>false
,p_version_identifier=>'1.1'
,p_files_version=>38
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3135296640554084)
,p_plugin_id=>wwv_flow_api.id(3135065635554079)
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
 p_id=>wwv_flow_api.id(3135547359554086)
,p_plugin_attribute_id=>wwv_flow_api.id(3135296640554084)
,p_display_sequence=>10
,p_display_value=>'ojSelect'
,p_return_value=>'ojSelect'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3136067947554087)
,p_plugin_attribute_id=>wwv_flow_api.id(3135296640554084)
,p_display_sequence=>20
,p_display_value=>'ojCombobox'
,p_return_value=>'ojCombobox'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3136512889554087)
,p_plugin_id=>wwv_flow_api.id(3135065635554079)
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
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(3137254885554093)
,p_plugin_id=>wwv_flow_api.id(3135065635554079)
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
wwv_flow_api.g_varchar2_table(1) := '2F2A20746865206F6A2D73656C6563742D63686F69636520656C656D656E74206973206372656174656420766961206B6E6F636B6F7574200A202020736F20746865206373732063616E206F6E6C79206265207365742061667465727761726473202A2F';
wwv_flow_api.g_varchar2_table(2) := '0A2E612D4947202E617065782D6974656D2D6F6A73656C656374202E6F6A2D73656C656374202E6F6A2D73656C6563742D63686F696365207B0A2020686569676874203A20313030253B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(3138347251598563)
,p_plugin_id=>wwv_flow_api.id(3135065635554079)
,p_file_name=>'ojselectcombobox.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2275736520737472696374223B0D0A0D0A2F2F6C6F6164206B6E6F636B6F75742062656361757365205B72657175697265206A65745D2066726F6D206170657820646F65736E27740D0A726571756972656A732E636F6E666967280D0A202020207B0D0A';
wwv_flow_api.g_varchar2_table(2) := '202020202020202070617468733A0D0A2020202020202020202020207B0D0A20202020202020202020202020202020276B6E6F636B6F7574273A20272E2F6F7261636C656A65742F322E302E322F6A732F6C6962732F6B6E6F636B6F75742F6B6E6F636B';
wwv_flow_api.g_varchar2_table(3) := '6F75742D332E342E30272C0D0A2020202020202020202020207D2C0D0A202020207D0D0A293B0D0A0D0A2F2F637265617465206F7220726575736520676C6F62616C2077696467657420666F7220616C6C20746865206F6A657420636F6D706F6E656E74';
wwv_flow_api.g_varchar2_table(4) := '730D0A76617220776964676574203D20776964676574207C7C207B7D3B0D0A7769646765742E6F6A6574203D2077696E646F772E6F6A6574207C7C207B7D3B0D0A0D0A2F2F63726561746520746865206F6A73656C656374636F6D626F626F78206F626A';
wwv_flow_api.g_varchar2_table(5) := '6563740D0A7769646765742E6F6A65742E6F6A73656C656374636F6D626F626F78203D202866756E6374696F6E202864656275672C207574696C2C207365727665722C206974656D29207B0D0A202020207661722064656661756C744F7074696F6E7320';
wwv_flow_api.g_varchar2_table(6) := '3D207B0D0A202020202020202076616C75653A2027272C0D0A20202020202020206F7074696F6E733A20225B5D222C0D0A2020202020202020636F6D706F6E656E743A20276F6A53656C656374272C0D0A2020202020202020706C616365686F6C646572';
wwv_flow_api.g_varchar2_table(7) := '3A2027272C0D0A202020202020202064697361626C65643A2066616C73650D0A202020207D3B0D0A0D0A20202020766172206974656D73203D205B5D3B0D0A202020207661722074656D704974656D203D207B7D3B0D0A0D0A202020206C6574205F6372';
wwv_flow_api.g_varchar2_table(8) := '65617465203D2066756E6374696F6E20286974656D49642C206F7074696F6E7329207B0D0A20202020202020202F2F20636F7079206F7074696F6E7320616E64206170706C792064656661756C74730D0A20202020202020206F7074696F6E73203D2024';
wwv_flow_api.g_varchar2_table(9) := '2E657874656E6428747275652C207B7D2C2064656661756C744F7074696F6E732C206F7074696F6E73293B0D0A0D0A20202020202020202F2F444F4D206974656D202831207065722067726964290D0A2020202020202020766172206974656D24203D20';
wwv_flow_api.g_varchar2_table(10) := '2428272327202B206974656D4964293B0D0A0D0A20202020202020202F2F706C7567696E20646174610D0A202020202020202076617220766965774D6F64656C203D207B7D3B0D0A0D0A20202020202020202F2F696E7465726163746976652067726964';
wwv_flow_api.g_varchar2_table(11) := '20646174610D0A2020202020202020766172206967203D207B7D3B0D0A202020202020202069672E6772696424203D206974656D242E636C6F7365737428272E742D4952522D726567696F6E2729207C7C205B5D3B0D0A202020202020202069672E6973';
wwv_flow_api.g_varchar2_table(12) := '47726964203D2069672E67726964242E6C656E677468203D3D3D20313B0D0A202020202020202069672E64617461203D206E756C6C3B0D0A0D0A20202020202020206966202869672E69734772696429207B0D0A20202020202020202020202069672E67';
wwv_flow_api.g_varchar2_table(13) := '726964242E6F6E2822696E74657261637469766567726964766965776D6F64656C637265617465222C2066756E6374696F6E20286576656E742C2063757272656E745669657729207B0D0A202020202020202020202020202020202F2F636F6E736F6C65';
wwv_flow_api.g_varchar2_table(14) := '2E6C6F672827696E74657261637469766567726964766965776D6F64656C63726561746527293B0D0A2020202020202020202020202020202069672E697347726964203D20747275653B0D0A2020202020202020202020202020202069672E7769646765';
wwv_flow_api.g_varchar2_table(15) := '74203D20617065782E726567696F6E286576656E742E63757272656E745461726765742E6964292E77696467657428293B0D0A2020202020202020202020202020202069672E636F6C756D6E203D2069672E7769646765742E696E746572616374697665';
wwv_flow_api.g_varchar2_table(16) := '4772696428276F7074696F6E272C2027636F6E66696727292E636F6C756D6E732E66696C7465722861203D3E207B2072657475726E20612E7374617469634964203D3D3D206974656D4964207D293B0D0A2020202020202020202020202020202069672E';
wwv_flow_api.g_varchar2_table(17) := '636F6C756D6E4E616D65203D2027273B0D0A0D0A202020202020202020202020202020202F2F746F646F3A20636865636B2069662074686973206974656D20697320696E207468652069670D0A202020202020202020202020202020206966202869672E';
wwv_flow_api.g_varchar2_table(18) := '636F6C756D6E2E6C656E677468203E203029207B0D0A202020202020202020202020202020202020202069672E636F6C756D6E4E616D65203D2069672E636F6C756D6E5B305D2E6E616D653B0D0A202020202020202020202020202020207D0D0A202020';
wwv_flow_api.g_varchar2_table(19) := '2020202020202020207D293B0D0A0D0A2020202020202020202020202F2F74686973206576656E74206F6E6C79206669726573207768656E207374617274696E6720746F20656469742074686520696E746572616374697665206772696420726F770D0A';
wwv_flow_api.g_varchar2_table(20) := '2020202020202020202020202F2F6974656D242E706172656E7428292E706172656E7428292E706172656E7428292E6F6E282761706578626567696E7265636F726465646974272C2066756E6374696F6E20286576656E742C206461746129207B0D0A20';
wwv_flow_api.g_varchar2_table(21) := '202020202020202020202069672E67726964242E6F6E282761706578626567696E7265636F726465646974272C2066756E6374696F6E20286576656E742C206461746129207B0D0A202020202020202020202020202020202F2F636F6E736F6C652E6C6F';
wwv_flow_api.g_varchar2_table(22) := '67282761706578626567696E7265636F72646564697427293B0D0A202020202020202020202020202020202F2F73617665207468652065646974696E67207265636F7264206461746120676C6F62616C6C7920696E2074686520706C7567696E0D0A2020';
wwv_flow_api.g_varchar2_table(23) := '202020202020202020202020202069672E64617461203D20646174613B0D0A2020202020202020202020207D293B0D0A20202020202020207D0D0A0D0A20202020202020202F2F696E697469616C697A65207669657720616E6420766965776D6F64656C';
wwv_flow_api.g_varchar2_table(24) := '0D0A202020202020202072657175697265285B276F6A732F6F6A636F7265272C20276B6E6F636B6F7574272C20276A7175657279272C20276F6A732F6F6A6B6E6F636B6F7574272C20276F6A732F6F6A73656C656374636F6D626F626F78275D2C0D0A20';
wwv_flow_api.g_varchar2_table(25) := '202020202020202020202066756E6374696F6E20286F6A2C206B6F2C202429207B0D0A202020202020202020202020202020202F2F696E7374616E74696174652074686520766965774D6F64656C206F66207468697320766965770D0A20202020202020';
wwv_flow_api.g_varchar2_table(26) := '202020202020202020766965774D6F64656C203D206E6577202866756E6374696F6E202829207B0D0A20202020202020202020202020202020202020207661722073656C66203D20746869733B0D0A202020202020202020202020202020202020202073';
wwv_flow_api.g_varchar2_table(27) := '656C662E76616C7565203D206B6F2E6F627365727661626C65286F7074696F6E732E76616C7565293B0D0A202020202020202020202020202020202020202073656C662E6F7074696F6E73203D206B6F2E6F627365727661626C654172726179284A534F';
wwv_flow_api.g_varchar2_table(28) := '4E2E7061727365286F7074696F6E732E6F7074696F6E7329293B0D0A202020202020202020202020202020202020202073656C662E636F6D706F6E656E74203D206B6F2E6F627365727661626C65286F7074696F6E732E636F6D706F6E656E74293B0D0A';
wwv_flow_api.g_varchar2_table(29) := '202020202020202020202020202020202020202073656C662E706C616365686F6C646572203D206B6F2E6F627365727661626C65286F7074696F6E732E706C616365686F6C646572293B0D0A202020202020202020202020202020202020202073656C66';
wwv_flow_api.g_varchar2_table(30) := '2E64697361626C6564203D206B6F2E6F627365727661626C652866616C7365293B0D0A0D0A202020202020202020202020202020202020202073656C662E646973706C617956616C7565466F72203D2066756E6374696F6E202876616C756529207B0D0A';
wwv_flow_api.g_varchar2_table(31) := '2020202020202020202020202020202020202020202020206C6574206F626A656374203D2073656C662E6F7074696F6E7328292E66696C7465722861203D3E207B2072657475726E20612E76616C7565203D3D3D2076616C7565207D295B305D3B0D0A20';
wwv_flow_api.g_varchar2_table(32) := '202020202020202020202020202020202020202020202072657475726E20747970656F66206F626A656374203D3D3D2027756E646566696E656427203F202727203A206F626A6563742E6C6162656C3B0D0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '20207D3B0D0A0D0A202020202020202020202020202020202020202073656C662E76616C75652E7375627363726962652866756E6374696F6E202876616C756529207B0D0A2020202020202020202020202020202020202020202020206966202869672E';
wwv_flow_api.g_varchar2_table(34) := '6973477269642026262069672E6461746120213D3D206E756C6C29207B0D0A202020202020202020202020202020202020202020202020202020202F2F636F6E736F6C652E6C6F6728277765206E65656420746F2073657420746869732076616C75653A';
wwv_flow_api.g_varchar2_table(35) := '2027202B2076616C75655B305D293B0D0A202020202020202020202020202020202020202020202020202020202F2F74686520706C7567696E206461746120686173206368616E6765642C207570646174652074686520696E7465726163746976652067';
wwv_flow_api.g_varchar2_table(36) := '726964207265636F72640D0A20202020202020202020202020202020202020202020202020202020766172206D6F64656C203D2069672E646174612E6D6F64656C3B0D0A2020202020202020202020202020202020202020202020202020202076617220';
wwv_flow_api.g_varchar2_table(37) := '726563203D2069672E646174612E7265636F72643B0D0A2020202020202020202020202020202020202020202020202020202076617220646973706C617956616C7565203D2073656C662E646973706C617956616C7565466F722876616C75655B305D29';
wwv_flow_api.g_varchar2_table(38) := '3B0D0A20202020202020202020202020202020202020202020202020202020766172206E657756616C7565203D207B20763A2076616C75655B305D2C20643A20646973706C617956616C7565207D3B0D0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(39) := '2020202020202020206D6F64656C2E73657456616C7565287265632C2069672E636F6C756D6E4E616D652C206E657756616C7565293B0D0A2020202020202020202020202020202020202020202020202020202069672E64617461203D206E756C6C3B0D';
wwv_flow_api.g_varchar2_table(40) := '0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020202020207D293B0D0A202020202020202020202020202020207D2928293B202F2F6E657720766965774D6F64656C0D0A0D0A202020202020';
wwv_flow_api.g_varchar2_table(41) := '202020202020202020202F2F696E7374616E74696174652074686520766965772062792065646974696E672074686520636F6E7461696E6572206D6164652062792074686520706C7567696E20504C2F53514C20636F64650D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(42) := '2020202020206966202869672E69734772696429207B0D0A20202020202020202020202020202020202020206974656D242E77726170496E6E657228273C73656C65637420646174612D62696E643D226F6A436F6D706F6E656E743A207B636F6D706F6E';
wwv_flow_api.g_varchar2_table(43) := '656E743A636F6D706F6E656E742C27202B0D0A202020202020202020202020202020202020202020202020276F7074696F6E733A6F7074696F6E732C27202B0D0A2020202020202020202020202020202020202020202020202776616C75653A76616C75';
wwv_flow_api.g_varchar2_table(44) := '652C27202B0D0A20202020202020202020202020202020202020202020202027706C616365686F6C6465723A706C616365686F6C6465722C27202B0D0A2020202020202020202020202020202020202020202020202764697361626C65643A6469736162';
wwv_flow_api.g_varchar2_table(45) := '6C65642C27202B0D0A2020202020202020202020202020202020202020202020202F2F276F7074696F6E4368616E67653A66756E6374696F6E2028652C6429207B636F6E736F6C652E6C6F67285C276F7074696F6E4368616E67653A205C27293B20636F';
wwv_flow_api.g_varchar2_table(46) := '6E736F6C652E6C6F672864293B7D2C27202B0D0A20202020202020202020202020202020202020202020202027726F6F74417474726962757465733A7B7374796C653A205C276D61782D77696474683A313030253B206865696768743A313030253B206D';
wwv_flow_api.g_varchar2_table(47) := '617267696E3A3070785C277D7D223E27202B0D0A202020202020202020202020202020202020202020202020273C2F73656C6563743E27293B0D0A20202020202020202020202020202020202020206974656D242E63737328277769647468272C202731';
wwv_flow_api.g_varchar2_table(48) := '30302527293B0D0A20202020202020202020202020202020202020206974656D242E706172656E7428292E6373732827686569676874272C20273130302527293B0D0A202020202020202020202020202020207D20656C7365207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(49) := '202020202020202020202020206974656D242E77726170496E6E657228273C73656C65637420646174612D62696E643D226F6A436F6D706F6E656E743A207B636F6D706F6E656E743A636F6D706F6E656E742C27202B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '202020202020202020202020276F7074696F6E733A6F7074696F6E732C27202B0D0A2020202020202020202020202020202020202020202020202776616C75653A76616C75652C27202B0D0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '27706C616365686F6C6465723A706C616365686F6C6465722C27202B0D0A2020202020202020202020202020202020202020202020202764697361626C65643A64697361626C65642C27202B0D0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '202027726F6F74417474726962757465733A7B7374796C653A205C276D617267696E3A3070785C277D7D223E27202B0D0A202020202020202020202020202020202020202020202020273C2F73656C6563743E27293B0D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '202020207D3B0D0A0D0A202020202020202020202020202020202F2F6163746976617465206B6E6F636B6F757420666F7220746865207669657720616E6420766965776D6F64656C20746F206265636F6D65206163746976650D0A202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '202020202020206B6F2E6170706C7942696E64696E677328766965774D6F64656C2C206974656D245B305D293B0D0A2020202020202020202020207D202F2F63616C6C6261636B0D0A2020202020202020293B202F2F726571756972650D0A0D0A202020';
wwv_flow_api.g_varchar2_table(55) := '20202020202F2F637265617465207468652061706578206974656D206F757473696465207468652063616C6C6261636B2066756E6374696F6E0D0A20202020202020202F2F666F722074686520696E74657261637469766520677269643A207468657265';
wwv_flow_api.g_varchar2_table(56) := '206973206F6E6C79206F6E6520706572206772696420636F6C756D6E0D0A20202020202020206974656D2E637265617465286974656D49642C207B0D0A20202020202020202020202073657456616C75653A2066756E6374696F6E202876616C75652920';
wwv_flow_api.g_varchar2_table(57) := '7B0D0A202020202020202020202020202020202F2F636F6E736F6C652E6C6F67282773657456616C75653A2027202B2076616C7565293B0D0A202020202020202020202020202020202F2F7265736574207468652073656C656374656420646174612072';
wwv_flow_api.g_varchar2_table(58) := '65636F72640D0A2020202020202020202020202020202069672E64617461203D206E756C6C3B0D0A0D0A202020202020202020202020202020202F2F73796E6368726F6E697365207468652076616C7565206F66207468652061706578206974656D2077';
wwv_flow_api.g_varchar2_table(59) := '6974682074686520766965774D6F64656C0D0A20202020202020202020202020202020766965774D6F64656C2E76616C7565285B76616C75655D293B0D0A2020202020202020202020207D2C0D0A20202020202020202020202067657456616C75653A20';
wwv_flow_api.g_varchar2_table(60) := '66756E6374696F6E202829207B0D0A202020202020202020202020202020202F2F636F6E736F6C652E6C6F67282767657456616C75653A2027202B20766965774D6F64656C2E76616C75652829293B0D0A202020202020202020202020202020202F2F72';
wwv_flow_api.g_varchar2_table(61) := '657475726E207468652076616C7565206F6620746865206974656D2066726F6D2074686520766965774D6F64656C0D0A2020202020202020202020202020202072657475726E20766965774D6F64656C2E76616C756528295B305D3B0D0A202020202020';
wwv_flow_api.g_varchar2_table(62) := '2020202020207D2C0D0A20202020202020202020202064697361626C653A2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202F2F636F6E736F6C652E6C6F67282764697361626C6527293B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '2020202020202F2F64697361626C6520746865206974656D0D0A20202020202020202020202020202020766965774D6F64656C2E64697361626C65642874727565293B0D0A2020202020202020202020207D2C0D0A202020202020202020202020656E61';
wwv_flow_api.g_varchar2_table(64) := '626C653A2066756E6374696F6E20286529207B0D0A202020202020202020202020202020202F2F636F6E736F6C652E6C6F672827656E61626C6527293B0D0A202020202020202020202020202020202F2F656E61626C6520746865206974656D0D0A2020';
wwv_flow_api.g_varchar2_table(65) := '2020202020202020202020202020766965774D6F64656C2E64697361626C65642866616C7365293B0D0A2020202020202020202020207D2C0D0A202020202020202020202020646973706C617956616C7565466F723A2066756E6374696F6E202876616C';
wwv_flow_api.g_varchar2_table(66) := '756529207B0D0A202020202020202020202020202020202F2F636F6E736F6C652E6C6F672827646973706C617956616C7565466F723A2027202B2076616C7565202B20272028766965774D6F64656C2076616C75653A2027202B20766965774D6F64656C';
wwv_flow_api.g_varchar2_table(67) := '2E76616C75652829202B20272927293B0D0A202020202020202020202020202020202F2F736561726368207468652072657475726E2076616C756520696E2074686520766965774D6F64656C20616E642072657475726E2074686520646973706C617920';
wwv_flow_api.g_varchar2_table(68) := '76616C75650D0A2020202020202020202020202020202072657475726E20766965774D6F64656C2E646973706C617956616C7565466F722876616C7565293B0D0A2020202020202020202020207D0D0A20202020202020207D293B202F2F6974656D2E63';
wwv_flow_api.g_varchar2_table(69) := '72656174650D0A0D0A20202020202020202F2F696E697469616C697A652074686973206974656D0D0A202020202020202074656D704974656D2E6964203D206974656D49643B0D0A202020202020202074656D704974656D2E6F7074696F6E73203D206F';
wwv_flow_api.g_varchar2_table(70) := '7074696F6E733B0D0A202020202020202074656D704974656D2E61706578203D206974656D286974656D24293B0D0A202020202020202074656D704974656D2E6E6F6465203D206974656D243B0D0A202020202020202074656D704974656D2E73657444';
wwv_flow_api.g_varchar2_table(71) := '617461203D2066756E6374696F6E20286461746129207B2074656D704974656D2E617065782E73657456616C7565282727293B20766965774D6F64656C2E6F7074696F6E73286461746129207D3B0D0A202020202020202074656D704974656D2E676574';
wwv_flow_api.g_varchar2_table(72) := '44617461203D2066756E6374696F6E202829207B2072657475726E20766965774D6F64656C2E6F7074696F6E7328293B207D3B0D0A20202020202020206974656D732E707573682874656D704974656D293B0D0A202020202020202074656D704974656D';
wwv_flow_api.g_varchar2_table(73) := '203D207B7D3B0D0A202020207D3B202F2F5F6372656174650D0A0D0A2020202072657475726E207B0D0A20202020202020206372656174653A205F6372656174650D0A20202020202020202C206974656D733A206974656D730D0A20202020202020202C';
wwv_flow_api.g_varchar2_table(74) := '20696E666F3A2066756E6374696F6E202829207B2072657475726E20276F6A53656C656374436F6D626F626F7820706C7567696E20666F72204F4A45542076322E302E3227207D0D0A20202020202020202C2076657273696F6E3A2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(75) := '202829207B2072657475726E2027312E3027207D0D0A202020207D3B0D0A7D2928617065782E64656275672C20617065782E7574696C2C20617065782E7365727665722C20617065782E6974656D293B0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(3138663343598564)
,p_plugin_id=>wwv_flow_api.id(3135065635554079)
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
