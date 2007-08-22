pro exit_rat
	common rat, types, file, wid, config
	common rit, pars
	infotext = ['Thank you for making a simple',$
	            '    program very happy !     ']

;	if config.debug ne 1 then $ ;; sorry, i just took it out for not popping up every time during programming. maxim, 08/06
	                            ;; that's ok, but maybe better do it in your private version. anderl 01/07
        if ~config.batch then $
           info = DIALOG_MESSAGE(infotext, /cancel, DIALOG_PARENT = wid.base, TITLE='Exit RAT')

	if config.batch || info ne "Cancel" then begin

;  ; cleaning up tempdir

		file_delete,config.tempdir,/allow_nonexistent,/quiet,/recursive

; delete main window

		widget_control, /destroy, wid.base

; free pointers from parameters sturcture

		heap_free, pars

             endif

end
