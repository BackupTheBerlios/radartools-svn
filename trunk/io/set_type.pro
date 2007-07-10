pro set_type,files
	common rat, types, file, wid, config
	
	nfiles = n_elements(files)
	for i=0,nfiles-1 do begin
	
		openr,ddd,files[i],/get_lun,/xdr
		dim  = 0l
		var  = 0l
		readu,ddd,dim
		siz=lonarr(dim)
		readu,ddd,siz
		readu,ddd,var
		free_lun,ddd
		
		openw,ddd,files[i],/get_lun,/xdr,/append
		point_lun,ddd,0l
		writeu, ddd, dim
		writeu, ddd, siz
		writeu, ddd, var
		writeu,ddd,file.type
		free_lun,ddd
	endfor
	
end
