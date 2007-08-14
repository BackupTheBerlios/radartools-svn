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
	'Stephane Guillaso, Franz Mayer, ',$
	'Marcus Saemmang, Jan-Christoph Unger',$
	'Thomas Weser, Oliver Bach, Bert Wolff',$
	'Andre Lehmann, Nicole Bouvier, Mathias Weller']
 	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='About RAT',/INFORMATION)
end
