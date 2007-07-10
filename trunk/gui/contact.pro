pro contact
	common rat, types, file, wid, config
	
	infostring = [ $
	'RAT Team', $
	'', $
	'Berlin University of Technology', $
	'Computer Vision and Remote Sensing',$
	'Franklinstrasse 28/29 (FR3-1)',$
	'D-10587 Berlin, Germany',$
	'',$
	'Web:   http://www.cv.tu-berlin.de/rat/',$
 	'Email: anderl@cs.tu-berlin.de']
	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='Contact information',/INFORMATION)
end
