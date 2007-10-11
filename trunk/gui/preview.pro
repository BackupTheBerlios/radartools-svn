;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: preview
; last revision : 7. August 2003
; written by    : Andreas Reigber
; Calculate optimized bytscaled versions of data for previewing / saving
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



pro preview,infile,outfile,FULL=full,TRICK=trick,TYPE=type
	common rat, types, file, wid, config

	head = 1l
	rrat,infile,in,header=head,info=info,type=type		

;---------------------------------
; Scaling tricks
; 0 = float
; 1 = complex (amplitude / phase scaling independently)
; 2 = phase
; 3 = complex -> phase
;---------------------------------
	case type of
		 52:  trick=2  ; phase
		 55:  trick=4  ; complex phase
		 102: trick=2  ; phase
;		 301: if file.dim eq 2 then trick=1 else trick=0  ; complex interferogram
		 302: trick=2  ; phase
;		 303: trick=2  ; phase
		 320: trick=2  ; phase
		 524: trick=2  ; phase
		 525: trick=2  ; phase
		else: trick=0  ; normal
	endcase

	if file.dim eq 4 and trick eq 1 then trick = 0

	if not keyword_set(full) then begin		; Caluculate small preview image?
		xprev = wid.base_xsize   		; x-size preview window
		scale = float(xprev) / file.xdim	; scaling factor for preview
		wid.draw_scale = scale
	endif else begin				; or full resolution ?
		xprev = file.xdim
		scale = 1.0
	endelse

; calculating preview size and number of blocks

	bs = config.blocksize
	calc_blocks_normal,file.ydim,bs,anz_blocks,bs_last 

	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last

	yprev = round(file.ydim * scale)
	scalesizes = intarr(anz_blocks)
	for i=0,anz_blocks-1 do begin
		scalesizes[i] = blocksizes[i] * scale
		if total(scalesizes[0:i]) lt total(blocksizes[0:i]) * scale then scalesizes[i] = scalesizes[i]+1
	endfor
	if scalesizes[anz_blocks-1] eq 0 then anz_blocks -= 1

	if file.zdim gt 3 then dim = 3 else dim = file.zdim

; reading and transforming data blockwise

	if file.dim eq 2 and trick eq 1 then srat,outfile,out,header=[3l,2l,xprev,yprev,4l],info='preview' 	
	if file.dim eq 2 and trick ne 1 then srat,outfile,out,header=[2l,xprev,yprev,4l],info='preview'
	if file.dim eq 3 then srat,outfile,out,header=[3l,file.zdim,xprev,yprev,4l],info='preview' 		
	if file.dim eq 4 then srat,outfile,out,header=[4l,file.vdim,file.zdim,xprev,yprev,4l],info='preview' 		

	progress,Message='Calculating preview...'
	for i=0,anz_blocks-1 do begin
		progress,percent=(i+1)*100.0/anz_blocks
		inblock = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,in,inblock

		if keyword_set(full) then outblock = scale_block(inblock,xprev,scalesizes[i],trick,/full) $
		else outblock = scale_block(inblock,xprev,scalesizes[i],trick)

		writeu,out,outblock
	endfor

	free_lun,in,out

end
