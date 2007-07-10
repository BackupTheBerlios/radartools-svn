pro select_channels_new_color_tab,data=data
	common rat, types, file, wid, config
	common channel, channel_names, channel_selec, color_flag
	
  generate_preview,/redisplay,/nodefault,/color_table
end
