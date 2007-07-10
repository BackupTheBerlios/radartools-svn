pro color_update_current_table,data=ind
	common rat, types, file, wid, config
	common channel, channel_names, channel_selec, color_flag
	if xregistered('tool_box') ne 0 then begin
  		event = LookupManagedWidget('tool_box')
		widget_control, event, get_uvalue=state, /no_copy
  		tvlct,r,g,b,/get
		modifyct,(*state.color_list_name).pos[ind],(*state.color_list_name).table_name[ind],r,g,b,file=config.prefdir+'user_color.tbl'
		color_display_current_table,state.color_draw,(*state.color_list_name).pos[ind],(*state.color_list_name).ncolor[ind]
		widget_control, event, set_uvalue=state, /no_copy
	endif
end
