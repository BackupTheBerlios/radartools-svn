pro dummy
	common rat, types, file, wid, config
	
	infostring = [ $
	'Not yet implemented']
 	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='Dummy',/INFORMATION)
end
