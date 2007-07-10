function scale3d,inarr,xdim,ydim
	siz  = size(inarr)
	dim  = siz[1]
	anzx = siz[2]
	anzy = siz[3]
	if xdim le anzx and ydim le anzy then begin
		smmx = floor(anzx / xdim) 
		smmy = floor(anzy / ydim)
		arr  = congrid(smooth(inarr,[1,smmx,smmy],/ed),dim,xdim,ydim) 
	endif else begin
		arr  = congrid(inarr,dim,xdim,ydim) 
	endelse
	return,arr
end
