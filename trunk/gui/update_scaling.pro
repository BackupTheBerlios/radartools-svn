pro update_scaling
	common rat, types, file, wid, config

; wid.draw_presum = 0  means floating point type presumming
;                 = 1  means phase type presumming (i.e. complex)
;
; wid.draw_bytes  = 0  means unknown scaling       (min -> max)
;                 = 1  means SAR amplitude scaling (0 -> mean)
;                 = 2  means phase scaling         (-pi -> +pi)
;                 = 3  means coherence scaling     (0.0 -> 1.0)
;                 = 4  means alpha angle scaling   (0.0 -> +pi/2)

	wid.draw_presu = 0 
	wid.draw_bytes = 1 
	
	if (file.type eq 302) or (file.type eq 102) then begin  ; phase images
		wid.draw_presu = 1   
		wid.draw_bytes = 2 
	endif
	
end
