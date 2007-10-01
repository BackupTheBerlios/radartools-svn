;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; External RAT Module: rat_plugin_template
; last modified by : Maxim Neumann
; last revision    : 27.09.2007
; A first draft for a RAT plugin.
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

pro rat_plugin_test,CALLED=called,PLUGIN_INFO=plugin_info,HELP=HELP
  common rat, types, file, wid, config

  if arg_present(plugin_info) then begin
     plugin_info={menu_name:"Universal PolInSAR Parameter Inversion",menu_pos:"polinsar"}
     return
  endif
  if keyword_set(HELP) then begin
     ret=dialog_message(["Fun plugin.","It is not serious!"],dialog_parent=wid.base, $
                        /INFO,TITLE="Help on the 'PolInSAR UPI' plugin")
     return
  endif

  ret=dialog_message(["You should have known it!", $
                      '', $
                      "There is no universal parameter inversion possible!", $
                      "At least with the current state of the art of PolInSAR..."],dialog_parent=wid.base, $
                     TITLE="You should have known it!")

end


;;; save,"rat_plugin_test",f="rat_plugin_test.sav",/rout
