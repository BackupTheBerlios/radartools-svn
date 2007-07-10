pro license
	common rat, types, file, wid, config
	
	infostring = [ $
'RAT - Terms of Use',$
'----------------------------------------------------------------------',$
'RAT can be used free of charge, for non-commercial and commercial',$
'applications. However, this software is POSTCARDWARE. This means, ',$
'that after an evaluation period, it is REQUIRED TO REGISTER each ',$
'copy of the software by simply sending a postcard to the RAT team ',$
'(local motives preferred). An address can be found in the menu ',$
'via help->contact.',$ 
' ',$
'The software is provided "as is", without warranty of any kind, ',$
'express or implied, including but not limited to the warranties of ',$
'merchantability, fitness for a particular purpose and noninfringement.',$
'In no event shall the authors or copyright holders be liable for any ',$
'claim, damages or other liability, whether in an action of contract, ',$
'tort or otherwise, arising from, out of or in connection with the ',$
'software or the use or other dealings in the software.',$
'',$
'Further details of the license can be found in the file LICENSE,',$
'distributed together with RAT.']
 	
	dummy=DIALOG_MESSAGE(infostring,DIALOG_PARENT = wid.base, TITLE='License',/INFORMATION)
end



