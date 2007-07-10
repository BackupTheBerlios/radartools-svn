;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; READ AND INTERPRETATE THE DATA MANAGEMENT FILE
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
pro tool_box_color_table_management_file_read,state
	common rat, types, file, wid, config
	common channel, channel_names, channel_selec, color_flag, palettes, pnames

	state.color_main_name = widget_tree(state.color_root,value=line,/folder,/expanded)
	
	;Test the first case
	branch_wid = widget_tree(state.data_main_name,value=state.color_foldertype[0], /folder,/expanded)
	leaf_wid = widget_tree(branch_wid,value="Previous")
	
	; Test for the predefined case
	branch_wid = [branch_wid,widget_tree(state.data_main_name,value=state.color_foldertype[1], /folder,/expanded)]
	for ii=1,8 do leaf_wid = [leaf_wid,widget_tree(branch_wid[1],value=pnames[ii])]
	
	; Test for user defined palettes
	if n_elements(pnames) gt 8 then begin
		branch_wid = [branch_wid,widget_tree(state.data_main_name,value=state.color_foldertype[2], /folder,/expanded)]
		for ii=1,8 do leaf_wid = [leaf_wid,widget_tree(branch_wid[2],value=pnames[ii])]
	endif
	state.color_branch_wid    = ptr_new(branch_wid)
	state.color_leaf_wid      = ptr_new(leaf_wid) 
	state.color_main_name_realize = 1
	
end
