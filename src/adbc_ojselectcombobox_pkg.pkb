create or replace package body adbc_ojselectcombobox_pkg is

  procedure render(p_item   in apex_plugin.t_item,
                   p_plugin in apex_plugin.t_plugin,
                   p_param  in apex_plugin.t_item_render_param,
                   p_result in out nocopy apex_plugin.t_item_render_result) is
    l_type          varchar2(50) := p_item.attribute_01;
    l_placeholder   varchar2(50) := p_item.attribute_02;
    l_name          varchar2(30);
    l_display_value varchar2(32767);
  
    c_display_column constant pls_integer := 1;
    c_return_column  constant pls_integer := 2;
  
    -- value without the lov null value
    l_value varchar2(32767) := case
                                 when p_param.value = p_item.lov_null_value then
                                  null
                                 else
                                  p_param.value
                               end;
    l_options           clob;
    l_column_value_list wwv_flow_plugin_util.t_column_value_list;
    l_value_found       boolean := false;
  
    c_escaped_value constant varchar2(32767) := apex_escape.html_attribute(p_param.value);
  begin
    if wwv_flow.g_debug then
      apex_plugin_util.debug_page_item(p_plugin              => p_plugin,
                                       p_page_item           => p_item,
                                       p_value               => p_param.value,
                                       p_is_readonly         => p_param.is_readonly,
                                       p_is_printer_friendly => p_param.is_printer_friendly);
    end if;
  
    if (p_param.is_readonly or p_param.is_printer_friendly) then
      apex_plugin_util.print_hidden_if_readonly(p_item_name           => p_item.name,
                                                p_value               => p_param.value,
                                                p_is_readonly         => p_param.is_readonly,
                                                p_is_printer_friendly => p_param.is_printer_friendly);
    
      -- get the display value
      l_display_value := apex_plugin_util.get_display_data(p_sql_statement     => p_item.lov_definition,
                                                           p_min_columns       => 2,
                                                           p_max_columns       => 2,
                                                           p_component_name    => p_item.name,
                                                           p_display_column_no => c_display_column,
                                                           p_search_column_no  => c_return_column,
                                                           p_search_string     => l_value,
                                                           p_display_extra     => p_item.lov_display_extra);
    
      -- emit display span with the value
      apex_plugin_util.print_display_only(p_item_name        => p_item.name,
                                          p_display_value    => l_display_value,
                                          p_show_line_breaks => false,
                                          p_escape           => true,
                                          p_attributes       => p_item.element_attributes);
    else
      l_name := apex_plugin.get_input_name_for_item;
    
      -- create list
      apex_json.initialize_clob_output;
      apex_json.open_array;
    
      -- add extra list entry with null value to the list 
      if p_item.lov_display_null then
        -- add list entry      
        apex_json.open_object;
        apex_json.write('value', '');
        apex_json.write('label', '');
        apex_json.close_object;
      end if;
    
      -- get all values
      l_column_value_list := apex_plugin_util.get_data(p_sql_statement  => p_item.lov_definition,
                                                       p_min_columns    => 2,
                                                       p_max_columns    => 2,
                                                       p_component_name => p_item.name);
    
      -- loop through the result
      for i in 1 .. l_column_value_list(c_display_column).count loop
        -- if the current item value is in the list then the value is found
        l_value_found := (l_value = l_column_value_list(c_return_column)
                          (i) or l_value_found);
      
        -- add list entry
        apex_json.open_object;
        apex_json.write('value', l_column_value_list(c_return_column) (i));
        apex_json.write('label', l_column_value_list(c_display_column) (i));
        apex_json.close_object;
      end loop;
    
      -- show at least the value if it hasn't been found in the database
      if (not l_value_found and l_value is not null and
         p_item.lov_display_extra) then
        -- add list entry
        apex_json.open_object;
        apex_json.write('value', l_value);
        apex_json.write('label', l_value);
        apex_json.close_object;
      end if;
    
      apex_json.close_array;
      l_options := apex_json.get_clob_output;
    
      -- render the container div 
      sys.htp.prn('<div' ||
                  wwv_flow_plugin_util.get_element_attributes(p_item,
                                                              l_name,
                                                              'apex-item-ojselect apex-item-plugin',
                                                              false) ||
                  'id="' || p_item.name || '" ' || '>' || '</div>');
    
      -- create the item
      apex_javascript.add_onload_code(p_code => 'widget.ojet.ojselectcombobox.create("' ||
                                                p_item.name || '", {' ||
                                                apex_javascript.add_attribute('value',
                                                                              case
                                                                                when p_param.value is null then
                                                                                 ''
                                                                                else
                                                                                 ltrim(rtrim(c_escaped_value))
                                                                              end,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('options',
                                                                              l_options,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('component',
                                                                              l_type,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('placeholder',
                                                                              l_placeholder,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('nullValue',
                                                                              p_item.lov_null_value,
                                                                              true,
                                                                              false) ||
                                                '});');
    end if;
  
    p_result.is_navigable := (not p_param.is_readonly = false and
                             not p_param.is_printer_friendly);
  end render;

  --==

  procedure metadata(p_item   in apex_plugin.t_item,
                     p_plugin in apex_plugin.t_plugin,
                     p_param  in apex_plugin.t_item_meta_data_param,
                     p_result in out nocopy apex_plugin.t_item_meta_data_result) is
  begin
    p_result.escape_output := false;
  end metadata;

begin
  -- Initialization
  null;
end adbc_ojselectcombobox_pkg;
/
