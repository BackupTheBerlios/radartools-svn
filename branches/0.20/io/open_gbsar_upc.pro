;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: open_gbsar_upc
; written by    : Maxim Neumann
; last revision : Dec.2007
; Imports data from the ground-based sensor frop UPC (Barcelona)
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

function open_gbsar_upc_info, inputfile, x=x,y=y, CHANNEL_TYPE=channel_type, info=info
  common rat

  channel_type = 0              ; single channel
  info         = file_basename(inputfile,'.bin')

;;; check for other POL-,IN-,POLIN- files
  ref_pol = ['HH','VV','HV','VH']
  for i=0,3 do begin
     pos = strpos(inputfile,ref_pol[i])
     if pos gt 0 then begin
        inputfiles = strmid(inputfile,0,pos)+ref_pol+strmid(inputfile,pos+2,strlen(inputfile))
        ind = file_test(inputfiles,/READ)
        if ind[0] && ind[1] && ind[2] then begin
           q = DIALOG_MESSAGE(['In this directory exist files for a polarimetric data set:',inputfiles[where(ind)],'','Should the polarimetric vector be built?'], $
                              DIALOG_PARENT = main,/QUESTION)
           if q eq 'Yes' then begin
              channel_type = 2
              inputfile=inputfiles[where(ind)]
           endif
           return,0
        endif
     endif
  endfor
  return, 0
end

pro open_gbsar_upc,INPUTFILE = inputfile
  common rat
  common channel, channel_names, channel_selec, color_flag, palettes, pnames

  if ~keyword_set(inputfile) then begin ; GUI for file selection
     path = config.workdir
     inputfile = cw_rat_dialog_pickfile(TITLE='Open GB-SAR (UPC) file', $
                                        DIALOG_PARENT=wid.base, FILTER = '*.bin', /MUST_EXIST, PATH=path, GET_PATH=path)
     if strlen(inputfile) gt 0 then config.workdir = path
  endif
  if strlen(inputfile) le 0 then return

; change mousepointer
  WIDGET_CONTROL,/hourglass     ; switch mouse cursor

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED
   open_rit,/EMPTY              ; no parameters are set: delete the odl ones!

; converting format to RAT
  
   nrx  = 0l
   nry  = 0l
   openr,ddd,inputfile,/get_lun  ; open input file
   readu,ddd,nrx                ; reading range size
   readu,ddd,nry                ; reading azimuth size
   close,ddd

  err=open_gbsar_upc_info(inputfile,x=nrx,y=nry,channel_type=channel_type,info=info)

  q = DIALOG_MESSAGE(['Please not that, contrary to default RAT representation of SAR data,', $
                      'for convenience, the ground based data will be represented transposed,', $
                      'i.e. the x-axis will represent the cross-range direction', $
                      'while the y-axis will represent the range.'], $
                     DIALOG_PARENT = main,/INFO)

  if err then return
;  header = bytarr(4+nrx*4*2,/nozero)
  header = [0L,0L]
;  data   = complexarr(nrx,nry,,/nozero)
  nrch   = n_elements(inputfile) ; nr of channels
  newtype= (channel_type eq 0?101L:(channel_type eq 1?300L:200L))
  newdims= [(channel_type eq 0?2L:[3L,nrch]),nrx,nry,6L]
  ddd    = lonarr(nrch)

  for ch=0,nrch-1 do begin
     get_lun,tmp
     ddd[ch] = tmp
     openr,ddd[ch],inputfile[ch]  ; open input file
     readu,ddd[ch],header
  endfor

  srat,outputfile,eee,header=newdims,type=newtype,info=info ; write RAT file header

  bs_y  = config.blocksize/nrch ; get standard RAT blocksize
  block    = complexarr(     nrx,bs_y,/nozero)  ; define block
  blockALL = complexarr(nrch,nrx,bs_y,/nozero)
  nr_y  = nry  /  bs_y          ; calc nr. of blocks
  re_y  = nry mod bs_y          ; calc size of last block
  
  progress,message='Reading GBSAR (UPC) file...'
  
  for i=0,nr_y-1 do begin       ; read and write blocks
     progress,percent=((i+1)*100)/nr_y ; display progress bar
     for ch=0,nrch-1 do begin
        readu,ddd[ch],block
        blockALL[ch,*,*]=block
     endfor
     writeu,eee,blockALL
  endfor
  if re_y gt 0 then begin       ; read and write last block
     block   = complexarr(     nrx,re_y,/nozero)
     blockALL= complexarr(nrch,nrx,re_y,/nozero)
     for ch=0,nrch-1 do begin
        readu,ddd[ch],block
        blockALL[ch,*,*] = block
     endfor
     writeu,eee,blockALL
  endif
  for ch=0,nrch-1 do $
     free_lun,ddd[ch]
  free_lun,eee                  ; close all files

; set internal variables of RAT

  file_move,outputfile,finalfile,/overwrite
  file.name = finalfile
  file.info = info              ; Put here a string describing your data
  file.type = newtype           ; data type (101 = single channel complex)
  file.dim  = newdims[0]        ; single channel data (two-dimensional array)
  file.xdim = nrx               ; range image size
  file.ydim = nry               ; azimuth image size
  file.zdim = nrch              ; nr. of layers (set to 1 if not needed)
  file.vdim = 1l                ; nr. of layers of layers (set to 1 if not needed)
  file.var  = 6l                ; IDL variable type (6 = complex, 4 = floating point)

; update file generation history (evolution)

  evolute,'Import GB-SAR (UPC) data from: '+strjoin(file_basename(inputfile),', ')

; reset palette information

	palettes[0,*,*] = palettes[2,*,*] ; set variable palette to b/w linear
	palettes[1,*,*] = palettes[2,*,*] ; set variable palette to b/w linear

; generate preview

  file.window_name = 'Untitled.rat'
  generate_preview
  update_info_box

end
