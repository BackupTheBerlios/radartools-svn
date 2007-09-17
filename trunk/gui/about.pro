;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: about
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

pro about
	common rat, types, file, wid, config
	
	infostring = [ $
	'RAT - Radar Tools  (Version SVN-HEAD)',$
	'---------------------------------------------',$
	'(c) 2003-2007 by the RAT development team',$ 
	'---------------------------------------------',$
	'Current coordination & main programming:',$
   'Andreas Reigber, Maxim Neumann & Marc Jaeger',$
	' ',$
	'Additional programming: ',$
	'Markus Steiof, Stephane Guillaso, Franz Mayer, ',$
	'Marcus Saemmang, Jan-Christoph Unger',$
	'Thomas Weser, Oliver Bach, Bert Wolff',$
	'Andre Lehmann, Nicole Bouvier, Mathias Weller']
 	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='About RAT',/INFORMATION)
end
