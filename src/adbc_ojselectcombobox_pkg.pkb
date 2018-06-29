create or replace package body adbc_ojselectcombobox_pkg is

  g_display_column constant pls_integer := 1;
  g_return_column  constant pls_integer := 2;
  g_group_column   constant pls_integer := 3;

  procedure render(p_item   in apex_plugin.t_item,
                   p_plugin in apex_plugin.t_plugin,
                   p_param  in apex_plugin.t_item_render_param,
                   p_result in out nocopy apex_plugin.t_item_render_result) is
    l_type          varchar2(50) := p_item.attribute_01;
    l_placeholder   varchar2(50) := p_item.attribute_02;
    l_name          varchar2(30);
    l_display_value varchar2(32767);
  
    -- value without the lov null value
    l_value varchar2(32767) := case
                                 when p_param.value = p_item.lov_null_value then
                                  null
                                 else
                                  p_param.value
                               end;
  
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
                                                           p_max_columns       => 3,
                                                           p_component_name    => p_item.name,
                                                           p_display_column_no => g_display_column,
                                                           p_search_column_no  => g_return_column,
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
      
      
   --   htp.p('<input type="hidden" id="' || p_item.name || '_HIDDEN" />');
      
      -- render the item for 
      sys.htp.prn('<input type="text" ' ||
                  apex_plugin_util.get_element_attributes(p_item           => p_item,
                                                          p_name           => l_name,
                                                          p_default_class  => 'apex-item-plugin u-hidden',
                                                          p_add_id         => false,
                                                          p_add_labelledby => true) ||
                  'id="' || p_item.name || '" ' || case when
                  p_item.is_required then 'required' else ''
                  end || '></input>');
    
      /* <input type="text" id="noiteminput" name="noiteminput" required class="u-hidden"/>*/
      
      -- render the container div 
      sys.htp.prn('<div ' || 'id="' || p_item.name || '_OJETCONTAINER" ' || 'class="apex-item-ojselect"' ||
                  'style="width:' || case when
                  p_item.element_width is not null then
                  p_item.element_width else 17 end || 'ch;">' || '</div>');
    
      -- render the container div 
      /*       sys.htp.prn('<div ' ||
      wwv_flow_plugin_util.get_element_attributes(p_item,
                                                  l_name,
                                                  'apex-item-ojselect apex-item-plugin',
                                                  false) ||
      'id="' || p_item.name || '" ' || 'style="width:' || case when
      p_item.element_width is not null then
      p_item.element_width else 17 end || 'ch;">' || '</div>');*/
    
      -- create the item
      apex_javascript.add_onload_code(p_code => 'widget.ojet.ojselectcombobox.create("' ||
                                                p_item.name || '", {' ||
                                                apex_javascript.add_attribute('ajaxIdentifier',
                                                                              apex_plugin.get_ajax_identifier,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('nullValue',
                                                                              p_item.lov_null_value,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('value',
                                                                              case
                                                                                when p_param.value is null then
                                                                                 ''
                                                                                else
                                                                                 ltrim(rtrim(c_escaped_value))
                                                                              end,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('component',
                                                                              l_type,
                                                                              true,
                                                                              true) ||
                                                apex_javascript.add_attribute('placeholder',
                                                                              l_placeholder,
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

  --==

  procedure validation(p_item   in apex_plugin.t_item,
                       p_plugin in apex_plugin.t_plugin,
                       p_param  in apex_plugin.t_item_validation_param,
                       p_result in out nocopy apex_plugin.t_item_validation_result) is
  begin
    logger.log('daar gaan we dan weer ');
    -- if p_item.is_required and p_param.value is null then
   -- p_result.message := '#LABEL# mag niet leeg zijn hoor.';
    -- end if;
  end validation;

  --==

  procedure ajax(p_item   in apex_plugin.t_item,
                 p_plugin in apex_plugin.t_plugin,
                 p_param  in apex_plugin.t_item_ajax_param,
                 p_result in out nocopy apex_plugin.t_item_ajax_result) is
  
    -- value without the lov null value
    l_value varchar2(32767) := case
                                 when apex_application.g_x01 =
                                      p_item.lov_null_value then
                                  null
                                 else
                                  apex_application.g_x01
                               end;
  
    l_column_value_list wwv_flow_plugin_util.t_column_value_list;
    l_value_found       boolean := false;
    l_group_value       varchar2(4000);
    l_last_group_value  varchar2(4000);
    l_open_group        boolean := false;
  begin
    --  logger.log('ajax ajax ');
  
    -- create list
    apex_json.open_array;
  
    -- get all values
    l_column_value_list := apex_plugin_util.get_data(p_sql_statement  => p_item.lov_definition,
                                                     p_min_columns    => 2,
                                                     p_max_columns    => 3,
                                                     p_component_name => p_item.name);
  
    -- loop through the result
    for i in 1 .. l_column_value_list(g_display_column).count loop
      -- if the current item value is in the list then the value is found
      l_value_found := (l_value = l_column_value_list(g_return_column)
                        (i) or l_value_found);
    
      -- if there is a group specified, handle the group list entry
      begin
        l_group_value := l_column_value_list(g_group_column) (i);
        if (l_group_value <> l_last_group_value) or
           (l_group_value is null and l_last_group_value is not null) or
           (l_group_value is not null and l_last_group_value is null) then
        
          -- close the group list entry
          if l_open_group then
            apex_json.close_array();
            apex_json.close_object();
            l_open_group := false;
          end if;
        
          -- add a group list entry
          --if l_group_value is not null then
          l_open_group := true;
          apex_json.open_object;
          apex_json.write('label', l_group_value, true);
          apex_json.open_array('children');
          --end if;
        
          l_last_group_value := l_group_value;
        end if;
      exception
        when no_data_found then
          null;
      end;
    
      -- add list entry
      apex_json.open_object;
      apex_json.write('value',
                      l_column_value_list(g_return_column) (i),
                      true);
      apex_json.write('label',
                      l_column_value_list(g_display_column) (i),
                      true);
      apex_json.close_object;
    end loop;
  
    -- close the group list entry when still open
    if l_open_group then
      apex_json.close_array();
      apex_json.close_object();
      l_open_group := false;
    end if;
  
    -- show at least the value if it hasn't been found in the database
    if (not l_value_found and l_value is not null and
       p_item.lov_display_extra) then
      -- add list entry
      apex_json.open_object;
      apex_json.write('value', l_value, true);
      apex_json.write('label', l_value, true);
      apex_json.close_object;
    end if;
  
    apex_json.close_array;
  
  end ajax;

begin
  -- Initialization
  null;
end adbc_ojselectcombobox_pkg;
/