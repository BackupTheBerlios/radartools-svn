;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; generates (MB) PolInSAR coherency matrix T from given
;;; polarimetric scattering vectors.
;;;
;;; Maxim Neumann, 12/2007
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; stand-alone, needs Rat pre-compiled
;;; 
;;; usage:
;;;   rat_gen_polinsar,['k3_1.rat','k3_2.rat',...],'T_MB_outputfile.rat', $
;;;                    {further options, see code}
;;;
;;; optional:
;;;   presumming with smmx and smmy
;;;   flat earth removal with fe_file
;;;   dem removal with dem_file and kz_file
;;;   RefLee or IDAN Speckle filtering
;;;   C or T output (default: T)
;;;   
;;; for reflee optional parameters:
;;;   speckle_smm, speckle_looks, speckle_threshold, speckle_method_flag
;;; for IDAN optional parameters:
;;;   speckle_looks
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;.compile rat
pro rat_gen_polinsar,polsar_files,outputfile,T=T, COV_MATRIX=C, smmx=smmx,smmy=smmy, $
                     fe_file=fe_file, conj_fe=conj_fe, $
                     dem_file=dem_file, kz_file=kz_file, $
                     bandwidth=bandwidth, sampling_range=sampling_range, $
                     use_reflee=use_reflee, use_idan=use_idan, $
                     speckle_smm=smm, speckle_looks=looks, $
                     speckle_threshold=threshold, $
                     speckle_method_flag=method_flag, $
                     calibrate=calibrate, remove_topo=remove_topo
  compile_opt idl2

  if n_elements(C) eq 0 &&  n_elements(T) eq 0 then T = 1
  if (n_elements(T) ne 0 &&  n_elements(C) ne 0) then $
     message, 'ERROR: Please specify the output data type: T=coherency matrix, C=covariance matrix'

  rat,/nw
  if keyword_set(calibrate) then begin
     for i=0, n_elements(polsar_files)-1 do begin
        open_rat, inputfile=polsar_files[i], /called
        calib_xtalkoap, smmx=16, smmy=16, excludepix=1
        calib_xsym, /called, method=0
        save_rat, outputfile=polsar_files[i]
     endfor 
  endif
  construct_polinsar, /CALLED, FILES=polsar_files
  if n_elements(fe_file) ne 0 then begin
     rrat, fe_file, fe
     polin_rgflt_adaptive, /CALLED, fe=fe, conj_fe=conj_fe, bandwidth=bandwidth, sampling=sampling_range
  endif
  if n_elements(dem_file) ne 0 && n_elements(kz_file) ne 0 then begin
     rrat, dem_file, dem
     rrat, kz_file,  kz
     polin_remove_topo_dem, /CALLED, dem=dem, kz=kz
  endif else if keyword_set(remove_topo) then $
     polin_remove_topo, /CALLED, box=20
  polin_k2m, /CALLED, SMMX=smmx,SMMY=smmy
  if keyword_set(T) then $
     polin_c2t, /CALLED
  if keyword_set(use_reflee) then $
     speck_polreflee, /called, smm=smm, looks=looks, threshold= $
                      threshold, method_flag=method_flag
  if keyword_set(use_idan) then $
     speck_polidan, /called, looks=looks
  save_rat,outputfile=outputfile
  exit_rat
end
