;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: edge_canny
; last revision : 11 Jan. 2005
; written by    : Maxim Neumann
; Canny operator edge detection
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


function gauss_cernel,kx,ky,CORR_FACTOR=corr_factor
  if n_elements(ky) eq 0 then ky=kx
  if n_elements(corr_factor) eq 0 then corr_factor = 2.5
  xmask = 2*kx+1                ; mask-size -- (box-size)
  xdev = kx / corr_factor       ; deviation -- sigma
  x = findgen(xmask) - kx
  gaussx = 1/(sqrt(2*!pi)*xdev)*exp(-(x^2)/(2*xdev^2))

  ymask = 2*ky+1                ; mask-size -- (box-size)
  ydev = ky / corr_factor       ; deviation -- sigma
  y = findgen(ymask) - ky
  gaussy = 1/(sqrt(2*!pi)*ydev)*exp(-(y^2)/(2*ydev^2))

  cernel = gaussx # gaussy
  cernel /= total(cernel)  ; normalization of the sum to 1 !!!!
  return,cernel
end

pro edge_canny,CALLED = called, SMMX = smmx, SMMY = smmy
  common rat, types, file, wid, config

  if n_elements(smmx) eq 0 then smmx=11
  if n_elements(smmy) eq 0 then smmy=11
  kx = (smmx-1)/2 & ky = (smmy-1)/2
  corr_factor = 2.5
  keep_phase  = 0

  if not keyword_set(called) then begin ; Graphical interface
     main = WIDGET_BASE(GROUP_LEADER=wid.base,row=6,TITLE='Canny Operator Edge Detection',/floating,/tlb_kill_request_events,/tlb_frame_attr)
     field1 = CW_FIELD(main,VALUE=kx,/integer,TITLE='Gauss size X   : ',XSIZE=3,/all_events)
     text1  = WIDGET_LABEL(main,VALUE='X mask size= '+strcompress(kx*2+1)+' X sigma= '+strcompress(kx/corr_factor))
     field2 = CW_FIELD(main,VALUE=ky,/integer,TITLE='Gauss size Y   : ',XSIZE=3,/all_events)
     text2  = WIDGET_LABEL(main,VALUE='Y mask size= '+strcompress(ky*2+1)+' Y sigma= '+strcompress(ky/corr_factor))
     if file.var eq 6 || file.var eq 9 then $
        but_pha= CW_BGROUP(main,['deleted','attached without changes'],/exclusive,/row, $
                           set_value=0,LABEL_LEFT='Phase should be: ')
     buttons = WIDGET_BASE(main,column=3,/frame)
     but_ok   = WIDGET_BUTTON(buttons,VALUE=' OK ',xsize=80,/frame)
     but_canc = WIDGET_BUTTON(buttons,VALUE=' Cancel ',xsize=60)
     but_info = WIDGET_BUTTON(buttons,VALUE=' Info ',xsize=60)
     WIDGET_CONTROL, main, /REALIZE, default_button = but_canc,tlb_get_size=toto
     pos = center_box(toto[0],drawysize=toto[1])
     widget_control, main, xoffset=pos[0], yoffset=pos[1]

     repeat begin               ; Event loop
        event = widget_event(main)
        if event.id eq but_info then begin ; Info Button clicked
           infotext = ['CANNY EDGE DETECTION',$
                       ' ',$
                       'RAT module written 2004 by Maxim Neumann']
           info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
        endif
        case event.id of
           field1: begin
              widget_control,field1,GET_VALUE=kx
              smmx = kx*2+1
              widget_control,text1,SET_VALUE='X mask-size= '+strcompress(smmx*2+1)+' sigma= '+strcompress(smmx/corr_factor)
           end
           field2: begin
              widget_control,field2,GET_VALUE=ky
              smmy = ky*2+1
              widget_control,text2,SET_VALUE='Y mask-size= '+strcompress(smmy*2+1)+' sigma= '+strcompress(smmy/corr_factor)
           end
           else:
        endcase
     endrep until (event.id eq but_ok) or (event.id eq but_canc) or tag_names(event,/structure_name) eq 'WIDGET_KILL_REQUEST'
     if file.var eq 6 || file.var eq 9 then $
        widget_control,but_pha,GET_VALUE=keep_phase
     widget_control,main,/destroy ; remove main widget
     if event.id ne but_ok then return ; OK button _not_ clicked
  endif

; Error Handling
  if smmx le 0 or smmy le 0 then begin ; Wrong box sizes ?
     error = DIALOG_MESSAGE("Boxsizes has to be >= 1", DIALOG_PARENT = wid.base, TITLE='Error',/error)
     return
  endif

; Gauss Cernel
  gauss = gauss_cernel(kx,ky,CORR_FACTOR=corr_factor)
  
; change mousepointer
  WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED

; handling of complex and amplitude input data

	if file.var eq 6 or file.var eq 9 then begin             ; Wrong variable type?
		error = DIALOG_MESSAGE(["Image is complex and has to","be converted to float first"], /cancel, DIALOG_PARENT = wid.base, TITLE='Warning')
		if error eq "Cancel" then return else complex2abs,/called
	endif


; read / write header
  head = 1l
  rrat,file.name,ddd,header=head,info=info,type=type
  if file.var eq 6 && ~keep_phase then newvar = 4L $
  else if file.var eq 9 && ~keep_phase then newvar = 5L $
  else newvar = file.var
  newtype = 110L
  head[head[0]+1] = newvar
  srat,outputfile,eee,header=head,info=info,type=newtype
  
; calculating preview size and number of blocks
  bs = config.blocksize
  overlap = (smmy + 1) / 2
  calc_blocks_overlap,file.ydim,bs,overlap,anz_blocks,bs_last 
  blocksizes = intarr(anz_blocks)+bs
  blocksizes[anz_blocks-1] = bs_last

  ypos1 = 0                     ; block start
  ypos2 = bs - overlap          ; block end
  byt=[0,1,4,8,4,8,8,0,0,16,0,0,4,4,8,8] ; bytelength of the different variable typos

; pop up progress window
  progress,Message='Canny edge detection...',/cancel_button

;start block processing
  for i=0,anz_blocks-1 do begin   
     progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
     if wid.cancel eq 1 then return

     block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
     oblock= make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=newvar)
     readu,ddd,block
; -------- THE FILTER ----------
     for v=0,file.vdim-1 do for z=0,file.zdim-1 do begin
        amp = convol(abs(reform(block[v,z,*,*])),gauss,/CENTER,/EDGE_TRUNCATE,/NAN,MISSING=0)
;stop
        if keep_phase then begin
           pha = atan(reform(block[v,z,*,*]),/PHASE)
           oblock[v,z,*,*] = sobel(amp) * complex(cos(pha),sin(pha))
        endif else $
           oblock[v,z,*,*] = sobel(amp)
     endfor
; -------- THE FILTER ----------
     if i eq anz_blocks-1 then ypos2 = bs_last
     writeu,eee,oblock[*,*,*,ypos1:ypos2-1]
     ypos1 = overlap
     point_lun,-ddd,file_pos
     point_lun,ddd,file_pos - 2 * overlap * file.vdim * file.zdim * file.xdim * byt[file.var]
  endfor
  free_lun,ddd,eee

; update file information
  file.var  = newvar
  file.type = newtype
  file.name = finalfile
  file_move,outputfile,finalfile,/overwrite

; generate preview
  if not keyword_set(called) then begin
     generate_preview
     update_info_box
  endif
end
