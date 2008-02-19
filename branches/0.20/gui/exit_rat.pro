;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: exit_rat
;------------------------------------------------------------------------
; The contents of this file are subject to the Mozilla Public License
; Version 1.1 (the "License"); you may not use this file except in
; compliance with the License. You may obtain a copy of the License at
; http://www.mozilla.org/MPL/
;
; Software distributed under the License is distributed on an "AS IS"
; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
; License for the specific language governing rights and limitations
; under the License.
;
; The Initial Developer of the Original Code is the RAT development team.
; All Rights Reserved.
;------------------------------------------------------------------------
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
