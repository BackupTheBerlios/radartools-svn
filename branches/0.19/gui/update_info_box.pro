;------------------------------------------------------------------------
; RAT Module: update_info_box
;
; written by    : Andreas Reigber
; last revision : 14.Mar.2003
;------------------------------------------------------------------------
; Print file information at the bottom of the main window
;------------------------------------------------------------------------

pro update_info_box
	common rat, types, file, wid, config
	
	dimstr = strcompress(file.xdim)+' x'+strcompress(file.ydim)
	if file.dim ge 3 then dimstr = strcompress(file.zdim)+' x' + dimstr
	if file.dim ge 4 then dimstr = strcompress(file.vdim)+' x' + dimstr
	
	if	config.os eq 'windows' then newline = string(13B) + string(10B)
	if	config.os eq 'unix' then newline = string(10B)
	
	
;	infostr = file.info + '  ('+file.name+')'+ ' ('+config.undofile+')'+newline $
	infostr = file.info + newline $
	+ types[file.type] + newline $
	+ 'Dimensions :'+dimstr
	
	if file.mult gt 1 then infostr += ' , '+strcompress(file.mult,/rem)+' files'
	infostr += '  ('+types[file.var]+')'
	widget_control, wid.info, SET_VALUE = infostr
end
