;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; KEYWORD
; - TYPE:     replace the current file.type
; - C_FLAG:   replace the current color_flag
; - SELECT:   replace the current channel_selec
; - DIM:      replace the current file.dim
; - ARR_SIZE: replace file.vdim,file.zdim,file.xdim,file.ydim should be a 4 element array
; this keyword should be call only if you want to display a short byte image for small preview
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

pro channel_default,type=type,select=select,dim=dim,arr_size=arr_size,c_flag=c_flag
	common rat, types, file, wid, config
	common channel, channel_names, channel_selec, color_flag
	

	;--> Initialisation
	if not keyword_set(dim) then dim=file.dim
	if not keyword_set(type) then begin
		flag_select = 1
		type = file.type
	endif else flag_select=0
	if not keyword_set(type) then type=file.type
	if not keyword_set(arr_size) then arr_size = [file.vdim,file.zdim,file.xdim,file.ydim]
	vdim = arr_size[0]
	zdim = arr_size[1]
	xdim = arr_size[2]
	ydim = arr_size[3]
;  	if file.dim ge 3 then begin
;  		channel_selec = [0,1,2] 
;  		color_flag = 1
;  	endif else begin
;  		channel_selec = 0 	
;  		color_flag = 0
;  	endelse
	if dim ge 3 then begin
           if vdim eq zdim && vdim ge 3 then select = [0,zdim+1,2*zdim+2] $
           else select = [0,1,2]
           select <= (vdim*zdim-1) ; if only two channels are available for instance
           c_flag = 1
	endif else begin
		select = 0
		c_flag = 0
	endelse
	if file.mult gt 1 then begin
		dim = 3
		select = [0,1,2]
		select <= (file.mult-1) ; if only two channels are available for instance
		c_flag = 1
	endif

;  	channel_names = strarr(file.vdim * file.zdim)
;  	for i=0,file.vdim*file.zdim-1 do begin
;  			if file.vdim gt 1 then channel_names[i] = ' Channel '+strcompress((i mod file.vdim)+1,/remove)+'/'+strcompress((i / file.vdim)+1,/remove)
;  			if file.vdim eq 1 then channel_names[i] = ' Channel '+strcompress(i+1,/remove)
;  	endfor
	names = strarr(vdim * zdim)
	for i=0,vdim*zdim-1 do begin
			if vdim gt 1 then names[i] = ' Channel '+strcompress((i mod vdim)+1,/remove)+'/'+strcompress((i / vdim)+1,/remove)
			if vdim eq 1 then names[i] = ' Channel '+strcompress(i+1,/remove)
	endfor
	
;  	case file.type of
	case type of
		120 : begin
;  			channel_names = ['Angular Second Moment','Contrast','Entropy','Inverse Difference Moment','Correlation','Dissimilarity','Maxium Probability','Mean','Variance','Cluster Shade','Cluster Prominence']
;  			channel_selec = [8,3,1]
			names = ['Angular Second Moment','Contrast','Entropy','Inverse Difference Moment','Correlation','Dissimilarity','Maxium Probability','Mean','Variance','Cluster Shade','Cluster Prominence']
			select = [8,3,1]
		end
		200 : begin
;  			channel_names = ['HH','VV','HV','VH']
;  			channel_selec = [1,2,0]
			names = (zdim EQ 3) ? ['HH','VV','XX'] : ['HH','VV','HV','VH']
			select = [1,2,0]
		end
		201 : begin
;  			channel_names = channel_names 
;  			channel_selec = [1,2,0]
			select = [1,2,0]
		end
		202 : begin
;  			channel_names = channel_names 
;  			channel_selec = [1,2,0]
			select = [1,2,0]
		end
		208 : begin
;  			channel_names = channel_names 
;  			channel_selec = [1,2,0]
			select = [1,2,0]
		end
		209 : begin
;  			channel_names = channel_names
;  			channel_selec = [1,2,0]
			select = [1,2,0]
		end
		210 : begin
;  			channel_names = (file.zdim EQ 3) ? ['HH+VV','HH-VV','2HV'] : ['HH+VV','HH-VV','HV+VH','i*(HV-VH)']
;  			channel_selec = [1,2,0]
			names = (zdim EQ 3) ? ['HH+VV','HH-VV','2HV'] : ['HH+VV','HH-VV','HV+VH','i*(HV-VH)']
			select = [1,2,0]
		end
		211 : begin
;  			channel_names = ['Double Bounce','Volume','Surface']
;  			channel_selec = [0,1,2]
			names = ['Double Bounce','Volume','Surface']
			select = [0,1,2]
                        if file.vdim gt 1 then begin
                           names = [names[0]+' track'+strcompress(indgen(file.zdim)), $
                                    names[1]+' track'+strcompress(indgen(file.zdim)), $
                                    names[2]+' track'+strcompress(indgen(file.zdim))]
                        endif
		end
		212 : begin
;  			channel_names = channel_names
;  			channel_selec = [0,1,2]
			select = [0,1,2]
		end
		213 : begin
;  			channel_names = ['Sphere','Diplane','Helix']
;  			channel_selec = [0,1,2]
			names = ['Sphere','Diplane','Helix']
			select = [0,1,2]
;                        select = [1,2,0] ; from a paper by J.S.Lee
                        if file.vdim gt 1 then begin
                           names = [names[0]+' track'+strcompress(indgen(file.zdim)), $
                                    names[1]+' track'+strcompress(indgen(file.zdim)), $
                                    names[2]+' track'+strcompress(indgen(file.zdim))]
;                           select=[0,file.zdim,2*file.zdim]
                        endif
		end
		214 : begin
;  				if file.vdim eq 4 then begin
;  					channel_names = ['Eigenvector 1 (val1)','Eigenvector 1 (val2)','Eigenvector 1 (val3)',$
;  								 		 'Eigenvector 2 (val1)','Eigenvector 2 (val2)','Eigenvector 2 (val3)',$
;  								 		 'Eigenvector 3 (val1)','Eigenvector 3 (val2)','Eigenvector 3 (val3)',$
;  								 		 'Eigenvalue 1','Eigenvalue 2','Eigenvalue 3']
;  					channel_selec = [9,10,11]
;  				endif 
;  				if file.vdim eq 5 then begin
;  					channel_names = ['Eigenvector 1 (val1)','Eigenvector 1 (val2)','Eigenvector 1 (val3)','Eigenvector 1 (val4)',$
;  								 		  'Eigenvector 2 (val1)','Eigenvector 2 (val2)','Eigenvector 2 (val3)','Eigenvector 2 (val4)',$
;  								 		  'Eigenvector 3 (val1)','Eigenvector 3 (val2)','Eigenvector 3 (val3)','Eigenvector 3 (val4)',$
;  								 		  'Eigenvector 4 (val1)','Eigenvector 4 (val2)','Eigenvector 4 (val3)','Eigenvector 4 (val4)',$
;  								 		 'Eigenvalue 1','Eigenvalue 2','Eigenvalue 3','Eigenvalue 4']
;  					channel_selec = [17,18,19]
;  				endif 
				if vdim eq 4 then begin
					names = ['Eigenvector 1 (val1)','Eigenvector 1 (val2)','Eigenvector 1 (val3)','Eigenvalue 1',$
								'Eigenvector 2 (val1)','Eigenvector 2 (val2)','Eigenvector 2 (val3)','Eigenvalue 2',$
								'Eigenvector 3 (val1)','Eigenvector 3 (val2)','Eigenvector 3 (val3)','Eigenvalue 3']
					select = [3,7,11]
				endif 
				if vdim eq 5 then begin
					names = ['Eigenvector 1 (val1)','Eigenvector 1 (val2)','Eigenvector 1 (val3)','Eigenvector 1 (val4)','Eigenvalue 1',$
								'Eigenvector 2 (val1)','Eigenvector 2 (val2)','Eigenvector 2 (val3)','Eigenvector 2 (val4)','Eigenvalue 2',$
								'Eigenvector 3 (val1)','Eigenvector 3 (val2)','Eigenvector 3 (val3)','Eigenvector 3 (val4)','Eigenvalue 3',$
								'Eigenvector 4 (val1)','Eigenvector 4 (val2)','Eigenvector 4 (val3)','Eigenvector 4 (val4)','Eigenvalue 4']
					select = [16,17,18]
				endif 
		end
		233 : begin
			select = [0,1,2]
                        if file.vdim eq 3 && file.zdim gt 1 then $
                           names = ['Entropy'+strcompress(indgen(file.zdim)),'Alpha'+strcompress(indgen(file.zdim)),'Anisotropy'+strcompress(indgen(file.zdim))] $
                        else $
                           names = ['Entropy','Alpha','Anisotropy']
                     end
		234 : begin
                   	str = ['Alpha 1','Alpha 2','Alpha 3','Beta 1','Beta 2','Beta 3','Gamma 1','Gamma 2','Gamma 3','Delta 1','Delta 2','Delta 3']
                        if file.vdim eq 3*4 && file.zdim gt 1 then begin
                           names = strarr(4*3,file.zdim)
                           for i=0,file.zdim-1 do $
                              names[*,i] = str+' track'+strcompress(i)
                           names=reform(transpose(names),/overwrite)
                        endif else $
                           names = ['Alpha 1','Alpha 2','Alpha 3','Beta 1','Beta 2','Beta 3','Gamma 1','Gamma 2','Gamma 3','Delta 1','Delta 2','Delta 3']
			select = [0,1,2]
		end
		220 : begin
;  			if file.vdim eq 3 then begin
;  				channel_names = ['C_11','C_21','C_31','C_12','C_22','C_32','C_13','C_23','C_33']
;  				channel_selec = [4,8,0]
;  			endif
;  			if file.vdim eq 4 then begin
;  				channel_names = ['C_11','C_21','C_31','C_41','C_12','C_22','C_32','C_42','C_13','C_23','C_33','C_43','C_14','C_24','C_34','C_44']
;  				channel_selec = [5,10,0]
;  			endif
			if vdim eq 3 then begin
				names = ['C_11','C_21','C_31','C_12','C_22','C_32','C_13','C_23','C_33']
				select = [4,8,0]
			endif
			if vdim eq 4 then begin
				names = ['C_11','C_21','C_31','C_41','C_12','C_22','C_32','C_42','C_13','C_23','C_33','C_43','C_14','C_24','C_34','C_44']
				select = [5,10,0]
			endif
		end
                221 : begin
;        	 if file.vdim eq 3 then begin
;        		  channel_names = ['T_11','T_21','T_31','T_12','T_22','T_32','T_13','T_23','T_33']
;        		  channel_selec = [4,8,0]
;        	 endif
;        	 if file.vdim eq 4 then begin
;        		  channel_names = ['T_11','T_21','T_31','T_41','T_12','T_22','T_32','T_42','T_13','T_23','T_33','T_43','T_14','T_24','T_34','T_44']
;        		  channel_selec = [5,10,0]
;        	 endif
                   if vdim eq 3 then begin
                      names = ['T_11','T_21','T_31','T_12','T_22','T_32','T_13','T_23','T_33']
                      select = [4,8,0]
                   endif
                   if vdim eq 4 then begin
                      names = ['T_11','T_21','T_31','T_41','T_12','T_22','T_32','T_42','T_13','T_23','T_33','T_43','T_14','T_24','T_34','T_44']
                      select = [5,10,0]
                   endif
                end
		222 : begin
			if vdim eq 3 then begin
				names = ['C_11','C_21','C_31','C_12','C_22','C_32','C_13','C_23','C_33']
				select = [4,8,0]
			endif
			if vdim eq 4 then begin
				names = ['C_11','C_21','C_31','C_41','C_12','C_22','C_32','C_42','C_13','C_23','C_33','C_43','C_14','C_24','C_34','C_44']
				select = [5,10,0]
			endif
		end
                216 : begin     ; Moriyama decomp.
;        	 channel_names = ['Double bounce', 'Surface', 'Volume', 'Urban/Nature']
;        	 channel_selec = [0, 1, 2]
                   names = ['Double bounce', 'Surface', 'Volume', 'Urban/Nature']
                   select = [0, 1, 2]
                end
                280 : begin
;  			channel_names = channel_names
;  			channel_selec = [0,0,1]
			select = [0,0,1]
		end
		300 : begin
;  			channel_names = ['Master track','Slave track']
;  			channel_selec = [0,0,1]
			names = ['Master track','Slave track']
			select = [0,0,1]
			c_flag    = 1
		end
;  		404 : channel_names = ['forest','surface','double']
		404 : names = ['forest','surface','double']
                411 : begin
                    names = ['Mean intensity', 'Homogeneity mask']
                    select = [0,1,1]
                end
;  		500 : begin
;  			str1 = ['HH Track 1','VV Track 1','HV Track 1','VH Track 1']
;  			str2 = ['HH Track 2','VV Track 2','HV Track 2','VH Track 2']
;  			if file.zdim eq 3 then begin
;  				str1 = str1[0:2]
;  				str2 = str2[0:2]
;  			endif
;  			channel_names = [str1, str2] 
;  			channel_selec = [1,2,0]


                500 : begin
                   str1 = ['HH','VV',(vdim eq 3?'sq2HV':['HV','VH'])]
                   names = str1 + '0'
                   for i=1,zdim-1 do $
                      names = [names,str1+strcompress(i,/R)]
                   select = [1,2,0]
                end
                501 : begin
                   str1 = ['HH+VV','HH-VV',(vdim eq 3?'2*HV':['HV+VH','i(HV-VH)'])]
                   names = str1 + '0'
                   for i=1,zdim-1 do $
                      names = [names,str1+strcompress(i,/R)]
                   select = [1,2,0]
                end
                502 : begin
                   str1 = ['XX','YY',(vdim eq 3?'sq2XY':['XY','YX'])]
                   names = str1 + ' 0'
                   for i=1,zdim-1 do $
                      names = [names,str1+strcompress(i,/R)]
                   select = [1,2,0]
                end
                503 : begin
                   str1 = ['XX+YY','XX-YY',(vdim eq 3?'2*XY':['XY+YX','i(XY-YX)'])]
                   names = str1 + '0'
                   for i=1,zdim-1 do $
                      names = [names,str1+strcompress(i,/R)]
                   select = [1,2,0]
                end

; 		500 : begin
; 			str1 = ['HH Track 1','VV Track 1','HV Track 1','VH Track 1']
; 			str2 = ['HH Track 2','VV Track 2','HV Track 2','VH Track 2']
; 			if zdim eq 3 then begin
; 				str1 = str1[0:2]
; 				str2 = str2[0:2]
; 			endif
; 			names = [str1, str2] 
; 			select = [1,2,0]
; 		end
;                 501 : begin
;                    str1 = (zdim EQ 3) ? ['HH1+VV1','HH1-VV1','2*HV1'] : ['HH1+VV1','HH1-VV1','HV1+VH1','i*(HV1-VH1)']
;                    str2 = (zdim EQ 3) ? ['HH2+VV2','HH2-VV2','2*HV2'] : ['HH2+VV2','HH2-VV2','HV2+VH2','i*(HV2-VH2)']
;                    names  = [str1,str2]
;                    select =[1,2,0]
;                 end
; 		502 : begin
; 			str1 = ['XX1','YY1','XY1','YX1']
; 			str2 = ['XX2','YY2','XY2','YX2']
; 			if zdim eq 3 then begin
; 				str1 = str1[0:2]
; 				str2 = str2[0:2]
; 			endif
; 			names = [str1, str2] 
; 			select = [1,2,0]
; 		end
;                 503 : begin
;                    str1 = (zdim EQ 3) ? ['XX1+YY1','XX1-YY1','2*XY1'] : ['XX1+YY1','XX1-YY1','XY1+YX1','i*(XY1-YX1)']
;                    str2 = (zdim EQ 3) ? ['XX2+YY2','XX2-YY2','2*XY2'] : ['XX2+YY2','XX2-YY2','XY2+YX2','i*(XY2-YX2)']
;                    names  = [str1,str2]
;                    select =[1,2,0]
;                 end

		510 : begin
                   n_pol  = vdim mod 3 eq 0? 3L: 4L & n_tr = zdim/n_pol ;file.zdim/n_pol
                   pol = ['HH','VV',(n_pol eq 3?'sq2HV':['HV','VH'])]
                   str = pol+'0'
                   for i=1,n_tr-1 do str = [str,pol+strcompress(i,/R)] 
                   names = strarr(vdim,zdim)
                   for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+' '+str[z]
                   select = [zdim+1,2*zdim+2,0]
                end
		511 : begin
                   n_pol  = vdim mod 3 eq 0? 3L: 4L & n_tr = zdim/n_pol
                   pol = ['HH+VV','HH-VV',(n_pol eq 3?'2*HV':['HV+VH','i(HV-VH)'])]
                   str = pol+'0'
                   for i=1,n_tr-1 do str = [str,pol+strcompress(i,/R)]
                   names = strarr(vdim,zdim)
                   for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+' '+str[z]
                   select = [zdim+1,2*zdim+2,0]
                end
                512 : begin
                   n_pol  = vdim mod 3 eq 0? 3L: 4L & n_tr = zdim/n_pol
                   pol = ['XX','YY',(n_pol eq 3?'sq2XY':['XY','YX'])]
                   str = pol+'0'
                   for i=1,n_tr-1 do str = [str,pol+strcompress(i,/R)]
                   names = strarr(vdim,zdim)
                   for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+' '+str[z]
                   select = [zdim+1,2*zdim+2,0]
                end
                513 : begin
                   n_pol  = vdim mod 3 eq 0? 3L: 4L & n_tr = zdim/n_pol
                   pol = ['XX+YY','XX-YY',(n_pol eq 3?'2*XY':['XY+YX','i(XY-YX)'])]
                   str = pol+'0'
                   for i=1,n_tr-1 do str = [str,pol+strcompress(i,/R)]
                   names = strarr(vdim,zdim)
                   for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+' '+str[z]
                   select = [zdim+1,2*zdim+2,0]
                end
		514 : begin
                   n_pol  = vdim mod 3 eq 0? 3L: 4L & n_tr = zdim/n_pol
                   pol = 'Pol'+strcompress(indgen(n_pol),/R)
                   str = pol+'0'
                   for i=1,n_tr-1 do str = [str,pol+strcompress(i,/R)]
                   names = strarr(vdim,zdim)
                   for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+' '+str[z]
                   select = [zdim+1+n_pol,2*zdim+2+n_pol,n_pol]
                end
; 		510 : begin
; 			pol = ['HH','VV','HV','VH']
; 			str1 = ''
; 			str2 = ''
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'1']
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'2']
; 			str1 = str1[1:*]
; 			for i=0,vdim-1 do for j=0,zdim-1 do str2 = [str2,str1[i]+' * conj('+str1[j]+')']
; 			names = str2[1:*]
; 			select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		511 : begin
; 			pol = ['HH+VV','HH-VV','HV+VH','i(HV-VH)']
; 			str1 = '' & str2 = ''
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'1']
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'2']
; 			str1 = str1[1:*]
; 			for i=0,vdim-1 do for j=0,zdim-1 do str2 = [str2,str1[i]+' * conj('+str1[j]+')']
; 			names = str2[1:*]
; 			select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		512 : begin
; 			pol = ['XX','YY','XY','YX']
; 			str1 = '' & str2 = ''
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'1']
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'2']
; 			str1 = str1[1:*]
; 			for i=0,vdim-1 do for j=0,zdim-1 do str2 = [str2,str1[i]+' * conj('+str1[j]+')']
; 			names = str2[1:*]
; 			select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		513 : begin
; 			pol = ['XX+YY','XX-YY','XY+YX','i(XY-YX)']
; 			str1 = '' & str2 = ''
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'1']
; 			for i=0,zdim/2-1 do str1 = [str1,pol[i]+'2']
; 			str1 = str1[1:*]
; 			for i=0,vdim-1 do for j=0,zdim-1 do str2 = [str2,str1[i]+' * conj('+str1[j]+')']
; 			names = str2[1:*]
; 			select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		514 : begin ; polin + mb
; 			npol= vdim mod 3 eq 0? 3L: 4L
; 			pol = 'Pol'+strcompress(indgen(npol),/R) 
;                         str = pol+'0'
;                         for i=1,vdim/npol-1 do str = [str,pol+strcompress(i,/R)]
;                         names = strarr(vdim,zdim)
;                         for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+str[z]
;                         select = [file.zdim+1+npol,2*file.zdim+2+npol,npol]
;                      end

                530 : begin
                   names = strarr(zdim*vdim)
                   for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='coh'+strcompress(i,/r)+strcompress(j,/r)
                   if zdim*vdim ge 3 then select = [0,1,2]
                end
                532 : begin  ;; besause of alternative channel selection (mn,08/06)
                   names = strarr(zdim*vdim)
                   for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='optcoh'+strcompress(i,/r)+strcompress(j,/r)
                   if zdim*vdim ge 3 then select = [1,0,2]  ;; besause of alternative channel selection (mn,08/06)
                end
;                 530 : begin
;                    names = strarr(zdim*vdim)
;                    for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='coh'+strcompress(i,/r)+strcompress(j,/r)
;                    if zdim*vdim ge 3 && vdim ne zdim then select = [1,2,0]
;                 end
                531 : begin
                   names = strarr(zdim*vdim)
                   for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='coh'+strcompress(i,/r)+strcompress(j,/r)
                   if zdim*vdim ge 3 && vdim ne zdim then select = [1,2,0]
                end
;                 532 : begin  ;; besause of alternative channel selection (mn,08/06)
;                    names = strarr(zdim*vdim)
;                    for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='coh'+strcompress(i,/r)+strcompress(j,/r)
;                    if zdim*vdim ge 3 then select = [1,0,2]  ;; besause of alternative channel selection (mn,08/06)
;                 end
                540 : begin
                   names1 = ['A1','A2','Hint','Aint']
                   names = strarr(zdim*vdim)
                   for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]=names1[i]+'bl'+strcompress(j,/R) 
                   select = [1,0,0]
                end
                600 : begin
                   names = 'SubAp '+strcompress(indgen(zdim),/R) 
                end
                601 : begin
                   str1 = 'Ch'+strcompress(indgen(vdim),/R)
                   names = str1 + ' SubAp0'
                   for i=1,zdim-1 do $
                      names = [names,str1+' SubAp'+strcompress(i,/R)]
                   if vdim*zdim ge 3 then select = [0,1,2] $
                   else if vdim*zdim ge 2 then select = [0,1,1] $
                   else select=[0,0,0]
                end
                604 : begin
                   str1 = 'Ch'+strcompress(indgen(vdim),/R)
                   names = str1 + ' SubAp0'
                   for i=1,zdim-1 do $
                      names = [names,str1+' SubAp'+strcompress(i,/R)]
                   select = [1,2,0]
                end
                605 : begin
                   str1 = 'Ch'+strcompress(indgen(vdim),/R)
                   names = str1 + ' SubAp0'
                   for i=1,zdim-1 do $
                      names = [names,str1+' SubAp'+strcompress(i,/R)]
                   select = [1,2,0]
                end
                610 : begin
                   md = sqrt(vdim) ; matrix dim
                   str1 = 'Ch'+strcompress(indgen(md),/R)
                   str2 = strarr(md,md)
                   for i=0,md-1 do for j=0,md-1 do str2[i,j] = str1[i]+str1[j]+'*'
                   names = str2[*] + ' SubAp0'
                   for i=1,zdim-1 do $
                      names = [names,str2[*]+' SubAp'+strcompress(i,/R)]
                   select = [md+1,2*md+2,0]
                end

                615 : begin
                   str1 = 'ChSubAp'+strcompress(indgen(vdim),/R)
                   names = strarr(vdim,vdim)
                   for i=0,vdim-1 do for j=0,vdim-1 do names[i,j] = str1[i]+str1[j]+'*'
                   select = [vdim+1,2*vdim+2,0]
                end

;                 800 : begin
;                    str1 = ['HH','VV',(vdim eq 3?'HV':['HV','VH'])]
;                    names = str1 + ' Track0'
;                    for i=1,zdim-1 do $
;                       names = [names,str1+' Track'+strcompress(i,/R)]
;                    select = [1,2,0]
;                 end
;                 801 : begin
;                    str1 = 'Pol'+strcompress(indgen(vdim),/R)
;                    names = str1 + ' Track0'
;                    for i=1,zdim-1 do $
;                       names = [names,str1+' Track'+strcompress(i,/R)]
;                    select = [1,2,0]
;                 end
;                 802 : begin
;                    str1 = 'Pol'+strcompress(indgen(vdim),/R)
;                    names = str1 + ' Track0'
;                    for i=1,zdim-1 do $
;                       names = [names,str1+' Track'+strcompress(i,/R)]
;                    select = [1,2,0]
;                 end
;                 803 : begin
;                    str1 = 'Pol'+strcompress(indgen(vdim),/R)
;                    names = str1 + ' Track0'
;                    for i=1,zdim-1 do $
;                       names = [names,str1+' Track'+strcompress(i,/R)]
;                    select = [1,2,0]
;                 end

; 		810 : begin
; 			pol = ['HH','VV','HV']
;                         str = pol+'0'
;                         for i=1,vdim/3-1 do str = [str,pol+strcompress(i,/R)] 
;                         names = strarr(vdim,zdim)
;                         for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+str[z]
;                         select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		811 : begin
; 			pol = ['Pol0','Pol1','Pol2']
;                         str = pol+'0'
;                         for i=1,vdim/3-1 do str = [str,pol+strcompress(i,/R)]
;                         names = strarr(vdim,zdim)
;                         for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+str[z]
;                         select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		812 : begin
; 			pol = ['Pol0','Pol1','Pol2']
;                         str = pol+'0'
;                         for i=1,vdim/3-1 do str = [str,pol+strcompress(i,/R)]
;                         names = strarr(vdim,zdim)
;                         for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+str[z]
;                         select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		813 : begin
; 			pol = ['Pol0','Pol1','Pol2']
;                         str = pol+'0'
;                         for i=1,vdim/3-1 do str = [str,pol+strcompress(i,/R)]
;                         names = strarr(vdim,zdim)
;                         for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+str[z]
;                         select = [file.zdim+1,2*file.zdim+2,0]
;                      end
; 		814 : begin
; 			npol= vdim mod 3 eq 0? 3L: 4L
; 			pol = 'Pol'+strcompress(indgen(npol),/R) 
;                         str = pol+'0'
;                         for i=1,vdim/npol-1 do str = [str,pol+strcompress(i,/R)]
;                         names = strarr(vdim,zdim)
;                         for v=0,vdim-1 do for z=0,zdim-1 do names[v,z]=str[v]+str[z]
;                         select = [file.zdim+1+npol,2*file.zdim+2+npol,npol]
;                      end
;                 830 : begin
;                    names = strarr(zdim*vdim)
;                    for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='coh'+strcompress(i,/r)+strcompress(j,/r)
;                    if zdim*vdim ge 3 then select = [0,1,2]
;                 end
;                 832 : begin  ;; besause of alternative channel selection (mn,08/06)
;                    names = strarr(zdim*vdim)
;                    for j=0,zdim-1 do for i=0,vdim-1 do names[i+j*vdim]='coh'+strcompress(i,/r)+strcompress(j,/r)
;                    if zdim*vdim ge 3 then select = [1,0,2]  ;; besause of alternative channel selection (mn,08/06)
;                 end


		else : begin
;  			for i=0,file.vdim-1 do $
;  				for j=0,file.zdim-1 do $
;  					channel_names[i*file.zdim+j] = 'Channel '+strcompress(i*file.zdim+j+1)
			for i=0,vdim-1 do $
				for j=0,zdim-1 do $
					names[i*zdim+j] = 'Channel '+strcompress(i*zdim+j+1)
		end
	endcase
	
	if flag_select eq 1 then begin
		channel_selec = select
		channel_names = names
		color_flag = c_flag
	endif
end
