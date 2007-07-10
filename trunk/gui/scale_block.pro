function scale_block,INBLOCK,xprev,yprev,trick,FULL=full

  common rat, types, file, wid, config
  
  if (size(inblock,/dim))[0] eq 1 then $
     inblock = reform(inblock,/overwrite)
  siz     = size(inblock)

;;; simple case: no rescaling
  if xprev eq file.xdim && yprev eq siz[siz[0]] then $
     case trick of
     1: begin
        siz = size(inblock,/dim)
        outblock = make_array([2l,siz[1:siz[0]]],type=4l)
        outblock[0,*,*,*,*] = abs (inblock)
        outblock[1,*,*,*,*] = atan(inblock,/phase)
        return, outblock
     end
     2: return, inblock
     3: return, atan(inblock,/phase)
     else: return, abs(float(inblock))
  endcase

  case file.dim of

;----------------------
; 2D image
;----------------------

     2: begin    
        inblock = reform(inblock)
        case trick of
           1: begin             ; complex image				
              outblock = make_array([2l,xprev,yprev],type=4l)
              if keyword_set(full) then begin
                 outblock[0,*,*] = abs(inblock)
                 outblock[1,*,*] = atan(inblock,/phase)
              endif else begin
                 outblock[0,*,*] = scale2d(abs(inblock),xprev,yprev)
                 outblock[1,*,*] = scale2dpha(reform(atan(inblock,/phase)),xprev,yprev)
              endelse
           end
           2:    if keyword_set(full) then outblock = inblock else outblock = scale2dpha(inblock,xprev,yprev)
           3:    if keyword_set(full) then outblock = atan(inblock,/phase) else outblock = scale2dpha(atan(inblock,/phase),xprev,yprev)
           else: if keyword_set(full) then outblock = float(abs(inblock)) else outblock = scale2d(float(abs(inblock)),xprev,yprev)
        endcase
     end		
;  
;  ;----------------------
;  ; 3D image
;  ;----------------------
;  
     3: begin 
        case trick of
           1: begin             ; complex image				
              outblock = make_array([2,file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then begin
                 for i=0,file.zdim-1 do outblock[0,i,*,*] = abs(inblock[i,*,*])
                 for i=0,file.zdim-1 do outblock[1,i,*,*] = atan(inblock[i,*,*],/phase)
              endif else begin
                 for i=0,file.zdim-1 do outblock[0,i,*,*] = scale2d(abs(inblock[i,*,*]),xprev,yprev)
                 for i=0,file.zdim-1 do outblock[1,i,*,*] = scale2dpha(reform(atan(inblock[i,*,*],/phase)),xprev,yprev)
              endelse
           end
           
           
           2: begin
              outblock = make_array([file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.zdim-1 do outblock[i,*,*] = inblock[i,*,*] $
              else $
                 for i=0,file.zdim-1 do outblock[i,*,*] = scale2dpha(reform(inblock[i,*,*]),xprev,yprev)
           end
           
           3: begin
              outblock = make_array([file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.zdim-1 do outblock[i,*,*] = atan(inblock[i,*,*],/phase) $
              else $
                 for i=0,file.zdim-1 do outblock[i,*,*] = scale2dpha(reform(atan(inblock[i,*,*],/phase)),xprev,yprev)
           end
           
           
           else: begin
              outblock = make_array([file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.zdim-1 do outblock[i,*,*] = float(abs(reform(inblock[i,*,*]))) $ 
              else $
                 for i=0,file.zdim-1 do outblock[i,*,*] = scale2d(float(abs(reform(inblock[i,*,*]))),xprev,yprev)
           end
        endcase
     end		

;----------------------
; 4D image
;----------------------

     4: begin
        case trick of
           
           1: begin
              outblock = make_array([file.vdim, file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = atan(inblock[i,j,*,*],/phase) $
              else $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = scale2dpha(atan(reform(inblock[i,j,*,*]),/phase),xprev,yprev)
           end
           
           2: begin
              outblock = make_array([file.vdim, file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = inblock[i,j,*,*] $
              else $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = scale2dpha(reform(inblock[i,j,*,*]),xprev,yprev)
           end
           
           3: begin
              outblock = make_array([file.vdim, file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = atan(inblock[i,j,*,*],/phase) $
              else $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = scale2dpha(reform(atan(inblock[i,j,*,*],/phase)),xprev,yprev)
           end
           
           else: begin
              outblock = make_array([file.vdim,file.zdim,xprev,yprev],type=4l)
              if keyword_set(full) then $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = float(abs(reform(inblock[i,j,*,*]))) $ 
              else $
                 for i=0,file.vdim-1 do for j=0,file.zdim-1 do outblock[i,j,*,*] = scale2d(float(abs(reform(inblock[i,j,*,*]))),xprev,yprev)
           end
        endcase
     end
  endcase
  
  return,reform(outblock)
end
