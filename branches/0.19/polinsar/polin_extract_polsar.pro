 ;------------------------------------------------------------------------
; RAT Module: polin_extract_polsar
;
; written by       : Maxim Neumann
; last revision    : 08/2006
;------------------------------------------------------------------------
; Extracts a PolSAR image from MB image
;------------------------------------------------------------------------

pro polin_extract_polsar,CALLED = called,channelvector=channelvector
  common rat, types, file, wid, config
  common channel, channel_names, channel_selec, color_flag

; right type? --- calculate new type
  case file.type of
     500 : newtype = 200L
     501 : newtype = 210L
     502 : newtype = 209L
     503 : newtype = 209L
     510 : newtype = 220L
     511 : newtype = 221L
     512 : newtype = 222L
     513 : newtype = 222L
     else: begin
        error_button = DIALOG_MESSAGE(['Data has to be a Multibaseline data'], $
                                      DIALOG_PARENT = wid.base, TITLE='Error',/ERROR)
        return
     endelse
  endcase
  if newtype ge 200 && newtype le 210 then matrix=0 else matrix=1
  pol  = file.vdim mod 3 eq 0 ? 3L : 4L
  n_tr = matrix ? file.vdim/pol : file.zdim

  if not keyword_set(called) then begin ; Graphical interface
     main = WIDGET_BASE(GROUP_LEADER=wid.base,row=4, $
                        TITLE='PolSAR image extraction',/modal, $
                        /tlb_kill_request_events,/tlb_frame_attr)
     text = widget_label(main,value='Select polarimetric vector to extract:')
     if file.type ge 500 && file.type le 503 then $
        ch_groups = 'Vector '+strcompress(indgen(n_tr),/R) $
     else ch_groups = 'T'+strcompress(indgen(n_tr),/R)+strcompress(indgen(n_tr),/R)
     butt = cw_bgroup(main,ch_groups,/exclusive,column=1,SET_VALUE=0)
     buttons  = WIDGET_BASE(main,column=3,/frame)
     but_ok   = WIDGET_BUTTON(buttons,VALUE=' OK ',xsize=80,/frame)
     but_canc = WIDGET_BUTTON(buttons,VALUE=' Cancel ',xsize=60)
     but_info = WIDGET_BUTTON(buttons,VALUE=' Info ',xsize=60)
     WIDGET_CONTROL, main, /REALIZE, default_button = but_ok,tlb_get_size=toto
     pos = center_box(toto[0],drawysize=toto[1])
     widget_control, main, xoffset=pos[0], yoffset=pos[1]
     
     repeat begin
        event = widget_event(main)
        if event.id eq but_info then begin ; Info Button clicked
           infotext = ['POLSAR IMAGE EXTRACTION FROM MB-SAR IMAGE',$
                       ' ',$
                       'RAT module written 08/2006 by Maxim Neumann']
           info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
        end
     endrep until (event.id eq but_ok) or (event.id eq but_canc) $
        or (tag_names(event,/structure_name) eq 'WIDGET_KILL_REQUEST')
     widget_control,butt,GET_VALUE=channelvector
     widget_control,main,/destroy
     if event.id ne but_ok then return ; OK button _not_ clicked
  endif else $
     if n_elements(channelvector) eq 0 then channelvector = 0

; change mousepointer
  WIDGET_CONTROL,/hourglass

; undo function
  undo_prepare,outputfile,finalfile,CALLED=CALLED

; read / write header
  rrat,file.name,ddd,header=head,info=info,type=type
  if matrix then $
     srat,outputfile,eee,header=[4l,pol,pol,file.xdim,file.ydim,file.var], $
          info=info,type=newtype $
  else $
     srat,outputfile,eee,header=[3l,pol,file.xdim,file.ydim,file.var], $
          info=info,type=newtype

; calculating preview size and number of blocks
  bs = config.blocksize
  calc_blocks_normal,file.ydim,bs,anz_blocks,bs_last
  blocksizes = intarr(anz_blocks)+bs
  blocksizes[anz_blocks-1] = bs_last

; pop up progress window
  progress,Message='Extracting polsar image...',/cancel_button

; calculating span
  for i=0,anz_blocks-1 do begin
     progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
     if wid.cancel eq 1 then return
     block  = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
     readu,ddd,block

     if matrix then $
        writeu,eee,block[channelvector*pol:channelvector*pol+pol-1,channelvector*pol:channelvector*pol+pol-1,*,*] $
     else $
        writeu,eee,block[*,channelvector,*,*]
  endfor
  free_lun,ddd,eee

; update file information

  file_move,outputfile,finalfile,/overwrite
  file.name = finalfile
  if matrix then begin
     file.dim  = 4l
     file.vdim = pol
     file.zdim = pol
  endif else begin
     file.dim  = 3l
     file.vdim = 1l
     file.zdim = pol
  endelse
  file.type = newtype
  n_tr_new = 1
  pol_new  = pol
  ignore = set_par('polarizations',pol_new)
  ignore = set_par('nr_tracks',n_tr_new)
  evolute,'Extract POLSAR image'

; generate preview
  if not keyword_set(called) then begin
     generate_preview
     update_info_box
  endif

end
