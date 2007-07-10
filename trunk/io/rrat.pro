;------------------------------------------------------------------------------ 
;------------------------------------------------------------------------------ 
; Autor: Andreas Reigber
; Datum: 25.9.2003
;
; read an array in RAT (Radar Tool) format
;
; Aufruf: 	rarr,filename,array
; Keywords:	INFO  - here you find the comment (Default = "unknown content")
;           NOXDR - do not use /XDR
;           HEADER- read only header, in array you get the open LUN.
;           BLOCK - read only this block of the data [X1,Y1,DX,DY]
;           PREVIEW - read the preview image if existing otherwise return -1
;
;------------------------------------------------------------------------------ 
;------------------------------------------------------------------------------ 


pro rrat,file,bild,INFO=info,NOXDR=noxdr,HEADER=header,BLOCK=block,TYPE=type,PREVIEW=preview,FILETYPE=filetype,MT=mt,MULTI=multi, $
         VAR=var,N_DIMENSIONS=dim,DIMENSIONS=siz ;; to get easier some informatin, in accordance to size() (except of VAR) (mn,18.08.06)
;	catch, error	
;  	if error ne 0 then begin
;  		bild = -1
;  		return
;  	endif
;  	
;  	if keyword_set(header) and keyword_set(block) then begin
;  		print," Combination of /HEADER und /BLOCK is stupid"
;  		return
;  	endif 
;  
	if keyword_set(noxdr) then xflag=0 else xflag=1
	
 	
	dim  = 0l
	var  = 0l
	type = 0l
	pointeur_preview = long64(0)
	dummy= 0l
	multi= 0l
	info = bytarr(80)  
	openr,ddd,file,/get_lun,xdr=xflag
	readu,ddd,dim
        siz=lonarr(dim)
        readu,ddd,siz
        readu,ddd,var
	readu,ddd,type
	readu,ddd,pointeur_preview
	readu,ddd,multi
        readu,ddd,info 
        info = strtrim(string(info))
	filetype=type
	multi >= 1
	
	if keyword_set(preview) then begin
		if pointeur_preview eq 0 then begin
			bild = -1
			free_lun,ddd
		endif else begin
			point_lun,ddd,pointeur_preview
			;--> read header
			xdim=0l
			ydim=0l
			dummy=0l
			readu,ddd,xdim,ydim,dummy,dummy,dummy,dummy,dummy,dummy
			case dim of 
				2: bild = bytarr(multi,xdim,ydim)
				3: bild = bytarr(multi,siz[0],xdim,ydim)
				4: bild = bytarr(multi,siz[0],siz[1],xdim,ydim)
			endcase
			readu,ddd,bild
			free_lun,ddd
			bild = reform(bild)
		endelse
		return
	endif
	
	if arg_present(header) then begin
		bild = ddd
		header = [dim,siz,var]
		if multi gt 1 and arg_present(mt) then begin

			mt = replicate({mfile : "", file1 : "", file2 : "", lun1 : 0l, lun2 : 0l, dim : dim, size : lonarr(dim), type : 0l, var : 0l, ptr : long64(0), info : bytarr(80) },multi)
			ifile = ""
			itype = 0l
			iptr  = long64(0)
			for i=0,multi-1 do begin
				readu,ddd,ifile
				mt[i].mfile = file
				mt[i].file1 = ifile
				mt[i].file2 = ifile
				openr,ilun,ifile,/get_lun,/xdr
				readu,ilun,dim
				mt[i].dim = dim
				siz=lonarr(dim)
				readu,ilun,siz
				mt[i].size = siz
 				readu,ilun,var
				mt[i].var = var
				readu,ilun,itype
				mt[i].type = itype
				readu,ilun,iptr
				mt[i].ptr  = iptr
				mt[i].lun1 = ilun
				point_lun,ilun,108+dim*4
			endfor
			bild = mt.lun1
		endif else begin
			mt = -1
;			multi = {file1 : "", file2 : "", lun1 : ddd, lun2 : 0l, dim : dim, size : siz, type : type, var : var, ptr : pointeur_preview, info : info }
		endelse
		
	endif else begin
		if keyword_set(block) then begin
			bits=[0,1,4,8,4,8,8,0,0,16,0,0,4,4,8,8]
			ch_fac = 1
			for i=0,dim-3 do ch_fac = ch_fac * siz[i]
			point_lun,-ddd,pos
			point_lun,ddd,pos+long64(block[1])*long64(siz[dim-2])*long64(bits[var])*ch_fac
			size = intarr(4) + 1
			size[4-dim] = siz
			size[3] = block[3]
			siz = size
		endif
		case var of 
			1:  bild=make_array(/byte,dimension=siz)
			2:  bild=make_array(/int,dimension=siz)
			3:  bild=make_array(/long,dimension=siz)
			4:  bild=make_array(/float,dimension=siz)
			5:  bild=make_array(/double,dimension=siz)
			6:  bild=make_array(/complex,dimension=siz)
			9:  bild=make_array(/dcomplex,dimension=siz)
			12: bild=make_array(/uint,dimension=siz)
			13: bild=make_array(/ulong,dimension=siz)
			14: bild=make_array(/l64,dimension=siz)
			15: bild=make_array(/ul64,dimension=siz)
			else: begin
				print,'Arraytyp nicht erkannt (Falsches Format ??)'
				return
			end
		endcase
	   readu,ddd,bild
	   free_lun,ddd
		if keyword_set(block) then bild = reform(bild[*,*,block[0]:block[0]+block[2]-1,*])
	endelse
end
