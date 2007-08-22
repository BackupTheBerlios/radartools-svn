function scale2d,inarr,xdim,ydim
	common rat, types, file, wid, config

	siz  = size(inarr)
	anzx = siz[1]
	anzy = siz[2]

        if anzx eq xdim && anzy eq ydim then return, inarr

        if xdim le anzx and ydim le anzy and not (file.type ge 400 and file.type lt 500) then begin
           smmx = floor(anzx / xdim) < (anzx-1)
           smmy = floor(anzy / ydim) < (anzy-1)
           if (anzx mod xdim eq 0 || xdim mod anzx eq 0) && (anzy mod ydim eq 0 || ydim mod anzy eq 0) $
           then arr  = rebin  (smooth(inarr,[smmx,smmy],/ed),xdim,ydim) $
           else arr  = congrid(smooth(inarr,[smmx,smmy],/ed),xdim,ydim) 
        endif else begin
           if (anzx mod xdim eq 0 || xdim mod anzx eq 0) && (anzy mod ydim eq 0 || ydim mod anzy eq 0) $
           then arr  = rebin  (inarr,xdim,ydim) $
           else arr  = congrid(inarr,xdim,ydim) 
        endelse
        return,arr
end
