function scale2dpha,inarr,xdim,ydim
	siz  = size(inarr)
	anzx = siz[1]
	anzy = siz[2]
	if xdim le anzx and ydim le anzy then begin
		smmx = floor(anzx / xdim) < anzx-1
		smmy = floor(anzy / ydim) < anzy-1
		arr  = atan(congrid(smooth(exp(complex(0,inarr)),[smmx,smmy],/ed),xdim,ydim),/phase)
	endif else begin
		arr  = atan(congrid(exp(complex(0,inarr)),xdim,ydim),/phase)
	endelse
	return,arr
end
