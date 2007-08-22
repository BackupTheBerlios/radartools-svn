pro inwork
	common rat, types, file, wid, config
	
	infostring = [ $
	'  Coming soon: This module','is currently under development']
 	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='Info',/INFORMATION)
end
