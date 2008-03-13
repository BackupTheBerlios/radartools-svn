;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Refined Lee filtering
;;;
;;; Maxim Neumann, 2/2008
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; stand-alone, needs Rat pre-compiled
;;;
;;; example usage:
;;;   rat_rlee,'C3.rat','C3_rlee7.rat',smm=7,looks=6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;.compile rat
pro rat_rlee, inputfile, outputfile, smm=smm, looks=looks, $
              threshold=threshold, method_flag=method_flag
  compile_opt idl2

  rat,/nw
  open_rat, inputfile=inputfile, /called
  speck_polreflee, /called, smm=smm, looks=looks, threshold= $
                   threshold, method_flag=method_flag
  save_rat, outputfile=outputfile
  exit_rat
end
