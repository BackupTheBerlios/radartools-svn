pro contact
	common rat, types, file, wid, config
	
	infostring = [ $
	'Contact the RAT developers:', $
	'', $
	'Mailing list     : https://lists.berlios.de/mailman/listinfo/radartools-users', $
	'RAT development  : https://developer.berlios.de/projects/radartools/', $
	'Bug reports      : https://developer.berlios.de/bugs/?group_id=8644', $
	'Main RAT website : http://www.cv.tu-berlin.de/rat/', $
	'',$
	'For questions concerning the usage of RAT, please use the mailing list.',$
	'If you want to contribute something, please use the development portal to',$
	'contact one of the main authors.']
	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='Contact information',/INFORMATION)
end
