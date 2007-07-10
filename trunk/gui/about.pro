pro about
	common rat, types, file, wid, config
	
	infostring = [ $
	'RAT - Radar Tools  (Version CVS-HEAD)',$
	'---------------------------------------------',$
	'(c) 2003-2006 Berlin University of Technology', $
	'Computer Vision and Remote Sensing Group',$
	'---------------------------------------------',$
	'Coordination & Main Programming:',$
   'Andreas Reigber, Stephane Guillaso,',$
   'Maxim Neumann & Marc Jaeger',$
	' ',$
	'Additional Programming: ',$
	'Franz Mayer, Marcus Saemmang, Jan-Christoph Unger',$
	'Thomas Weser, Oliver Bach, Bert Wolff',$
	'Andre Lehmann, Nicole Bouvier, Mathias Weller']
 	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='About RAT',/INFORMATION)
end
