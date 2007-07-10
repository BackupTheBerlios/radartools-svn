pro definitions,update_pref=update_pref
	common rat, types, file, wid, config
	common channel, channel_names, channel_selec, color_flag, palettes, pnames
        common rit, parstruct, evolution
	
	prefversion = 0.181 ; version .18 beta1
;;; please take note, that prefversion is closely related to version
;;; control at the beginning of the rat procedure. (adjust both
;;; accordingly: prefversion should never be smaller than the checked
;;; version)
	
	types=strarr(901)
	types[0]   = "Unkown type"
	types[1]   = "bytes"
	types[2]   = "integer"
	types[3]   = "long integer"
	types[4]   = "floating point"
	types[5]   = "double"
	types[6]   = "complex"
	types[9]   = "double complex"
	types[12]  = "unsigned integer"
	types[13]  = "unsigned long"
	types[14]  = "integer64"
	types[15]  = "unsigned integer64"

; 50-99 generic formats

	types[50]  = "generic amplitude"
	types[51]  = "generic amplitude (mean scaled)"
	types[52]  = "generic phase"
	types[53]  = "generic complex amplitude"
	types[54]  = "generic complex amplitude (mean scaled)"
	types[55]  = "generic complex phase"
	types[56]  = "generic correlation"         ;; values in range [0:1]
	types[57]  = "generic complex correlation" ;; values in range [0:1]

; 100-199 single channel SAR

	types[100] = "SAR amplitude image"
	types[101] = "SAR complex image"
	types[102] = "SAR phase image"
	types[103] = "SAR intensity image"
	types[110] = "SAR image after edge detection"
	types[120] = "Co-occurance texture features"
	types[121] = "Variation coefficient"
	types[122] = "Band ratio"
	types[123] = "Band difference"
	types[124] = "Propability of change"
	types[125] = "Band entropy"

; 200-299 polarimetric SAR

	types[200] = "scattering vector, lexicographic basis"
;	types[201] = "scattering vector, linear basis at 45 deg "
;	types[202] = "scattering vector, circular basis"
;	types[208] = "scattering vector"
	types[209] = "scattering vector, lexicographic arbitrary basis"
	types[210] = "Pauli decomposition"
	types[211] = "Freeman-Durden decomposition"
	types[212] = "Unknown decomposition"
	types[213] = "Sphere-Diplane-Helix decomposition"
	types[214] = "Eigenvector decomposition"
	types[216] = "Moriyama decomposition"
	types[220] = "covariance matrix [C]"
	types[221] = "coherency matrix [T]"
	types[222] = "covariance matrix [C], arbitrary basis"

	types[230] = "polarimetric entropy"
	types[231] = "polarimetric alpha angle"			
	types[232] = "polarimetric anisotropy"
	types[233] = "Entropy / Alpha / Anisotropy"
	types[234] = "Alpha / Beta / Gamma / Delta angles"

	types[250] = "polarimetric span image"
	types[280] = "ENVISAT partial polarimetry scattering vector"

; 300-399 interferometric SAR

	types[300] = "interferometric image pair"
	types[301] = "complex interferogram"
	types[302] = "interferometric phase"
	types[303] = "unwrapped phase"
	types[310] = "interferometric coherence"
	types[311] = "complex interferometric coherence"
	types[320] = "shaded relief"
	types[390] = "Flat-earth phase" 		  ;; 1d or 2d
	types[391] = "Flat-earth phase (multiple tracks)" ;; 1d or 2d ;; especially for polin
        types[392] = "Wavenumber" 			  ;; 1d or 2d e.g. kz or ky
        types[393] = "Wavenumber (multiple tracks)" 	  ;; 1d or 2d ;; especially for polin
        types[394] = "Baseline" 			  ;; 1d or 2d e.g. perpendicular baseline (in meters)
        types[395] = "Baseline (multiple tracks)" 	  ;; 1d or 2d e.g. perpendicular baseline (in meters)

; 400-499 Classification results

	types[400] = "Entropy / Alpha classification"
	types[401] = "Entropy / Alpha / Anisotropy classification"
	types[402] = "Wishart Entropy / Alpha classification"
	types[403] = "Wishart Entropy / Alpha / Anisotropy classification"
	types[404] = "Physical classification"
	types[405] = "Forest classification"
	types[406] = "Surface classification"
	types[407] = "Double bounce classification"
	types[408] = "Number of scattering mechanisms"
	types[409] = "Lee category preserving classification"
	types[410] = "Cameron classification"
	types[411] = "Wishart EM classification"
        types[444] = "General classification"
	types[450] = "PolInSAR Wishart classification"
	types[451] = "PolInSAR A1/A2 coherence classification"
	types[499] = "Colour palette file"

; 500-599 Polarimetric Interferometric SAR
	types[500] = "PolInSAR scattering vector, lexicographic basis"
	types[501] = "PolInSAR scattering vector, Pauli basis"
	types[502] = "PolInSAR scattering vector, lexicographic arbitrary basis"
	types[503] = "PolInSAR scattering vector, Pauli arbitrary basis"
	types[510] = "PolInSAR covariance matrix"
	types[511] = "PolInSAR coherency matrix"
	types[512] = "PolInSAR covariance matrix, arbitrary basis"
	types[513] = "PolInSAR coherency matrix, arbitrary basis"
        types[514] = "PolInSAR normalized cov/coh matrix" ;; i.e. with identity block matrices along the diagonal
  	types[530] = "PolInSAR coherence"           ;; should be used for real and complex coherences!
;;; 	types[531] = "PolInSAR complex coherence"   ;; should not be used anymore!!! use always 530! obsolete
        types[532] = "POLInSAR optimized coherence" ;; special type for special rgb-channel rearange!
        types[535] = "POLInSAR scattering mechanims vectors" ;; SM's
	types[540] = "PolInSAR LFF coherence parameters (A1,A2,Hint,Aint)"

; 600-699 SAR Sub-Apertures
	types[600] = "Subaperture decomposition"
	types[601] = "Multi-channel subapertures"
	types[610] = "Covariance matrices for every subaperture"
	types[615] = "Subapertures covariance matrix"
	types[630] = "Subapertures stationarity [log(L)]"

; 700-799 Multitemporal & others
	types[700] = "Multitemporal data"

; 800-899 Polarimetric Multibaseline SAR
; 	types[800] = "MB scattering vector, lexicographic basis"
; 	types[801] = "MB scattering vector, Pauli basis"
; 	types[802] = "MB scattering vector, lexicographic arbitrary basis"
; 	types[803] = "MB scattering vector, Pauli arbitrary basis"
; 	types[810] = "MB covariance matrix"
; 	types[811] = "MB coherency matrix"
; 	types[812] = "MB covariance matrix, arbitrary basis"
; 	types[813] = "MB coherency matrix, arbitrary basis"
;       types[814] = "MB normalized cov/coh matrix" ;; i.e. with identity block matrices along the diagonal
;   	types[830] = "MB coherence"
;   	types[832] = "MB optimized coherence" ;; special type for special rgb-channels rearange!


;----------------------------------------------------
	channel_names = strarr(1)
	channel_selec = [0,1,2]
	color_flag    = 1
	palettes      = bytarr(256,256,3)
	pnames        = strarr(256)
;----------------------------------------------------

	file={$
		name : " " ,$
		window_name : " ",$
		info : " " ,$
		type : 0l  ,$
		var  : 0l  ,$
		dim  : 0l  ,$
		xdim : 0l  ,$
		ydim : 0l  ,$
		zdim : 0l  ,$
		vdim : 0l  ,$
		mult : 1l  $
	}


	wid={$
		base  : 0l ,$	      	;Main window widget ID
		draw  : 0l , $		;Draw window widget ID
		cancel : 0l , $		;cancel a routine
		block : 0b, $		;block rat widget or not
		info  : 0l , $        	;Info window widget ID
                button_undo: 0l , $   	;Undo button widget ID 
                button_redo: 0l , $   	;Redo button widget ID 
		button_show_preview: 1L, $ ; Preview Show
		prog1 : 0l , $        	;progress window widget ID
		prog2 : 0l , $        	;progress window widget ID
		prog3 : 0l , $        	;progress window text widget ID
		base_xsize : 700 ,$	;Size main window in x
		base_ysize : 700 ,$	;Size main window in y
		draw_ysize : 1000 ,$    ;Size scroll window in y
		draw_scale : 0.0 $    	;Preview image scaling factor
            }

	config = {$
		tempdir  : "", $
		tempbase : "", $
		workdir  : "", $
		pref     : "", $
		imagedir : "", $
		prefdir  : "", $
		palettes : "", $
		pnames   : "", $
		docdir   : "", $
		pdfviewer: "", $
		progress : ptr_new(), $ ; create a new pointer, will be used to store the progress bar status
		workfile1: "workfile1.rat", $
		workfile2: "workfile2.rat", $
		workfile3: "workfile3.rat", $
		lookfile : "lookfile.rat", $
		undofile : "",$
                redofile : "", $
                blocksize: 128l, $
		sar_scale: 2.5, $
		pha_gamma: 1.5, $
		test     : 0.0, $
		os       : strlowcase(!version.os_family), $
;		file_filters: ['*.rat;*.mrat','*.rat','*.mrat','*.rit'], $
		version  : prefversion, $
		show_preview : 1, $ ; should a preview be shown ?
                batch    : 0, $ ; starting to implement the batch mode
                debug    : 0 $
	}

	if config.os eq 'unix' then begin
		homedir  = getenv("HOME")
		tempbase = getenv("TMP")
		if tempbase eq '' then tempbase = homedir
		config.tempbase = tempbase+'/'
		config.tempdir  = tempbase+'/'
		config.workdir  = homedir+'/'
		config.pref     = homedir+'/.rat/preferences'
		config.imagedir = homedir+'/.rat/icons/'
		config.prefdir  = homedir+'/.rat/'
		config.palettes = homedir+'/.rat/palettes.rat'
		config.pnames   = homedir+'/.rat/palettes.txt'
		config.pdfviewer= 'xpdf'
	endif

	if config.os eq 'windows' then begin
		homedir = getenv("USERPROFILE")
		tempbase = getenv("TMP")
		if tempbase eq '' then tempbase = homedir
		config.tempbase = tempbase+'\'
		config.tempdir  = tempbase+'\'
		config.workdir  = homedir+'\'
		config.pref     = homedir+'\rat\preferences'
		config.imagedir = homedir+'\rat\icons\'
		config.prefdir  = homedir+'\rat\'
		config.palettes = homedir+'\rat\palettes.rat'
		config.pnames   = homedir+'\rat\palettes.txt'
		config.pdfviewer= 'acrord32.exe'
	endif

	if keyword_set(update_pref) then save,filename=config.pref,config,wid

	if FILE_TEST(config.pref) then begin
		wid_struct=wid
                config_struct=config
		restore,config.pref
		struct_assign,wid,wid_struct,/NOZERO ; for backwards compatibility (mn, 09/06)
		wid=wid_struct		; else the new fields in the structure would be deleted by restore!
                struct_assign,config,config_struct,/NOZERO ; for backwards compatibility (mn, 2/7)
                config=config_struct
                wid_struct = -1 & config_struct = -1
	endif
;        config.docdir = file_dirname((routine_info('rat',/source)).path,/mark)+'doc'+path_sep()
        config.docdir = file_dirname((routine_info('definitions',/source)).path,/mark)+'doc'+path_sep()
        
	if keyword_set(update_pref) then config.version = prefversion

	if FILE_TEST(config.palettes) then rrat,config.palettes,palettes

	config.tempdir  = config.tempbase+'TMPRAT_'+strcompress(floor(1e9*randomu(s,1)),/remove)+path_sep()
	file_mkdir,config.tempdir,/noexpand_path

	if FILE_TEST(config.pnames) then begin
		str = ""
		pnames=""
		openr,ddd,config.pnames,/get_lun
		while ~ eof(ddd) do begin
			readf,ddd,str
			pnames = [pnames,str]
		endwhile
		pnames = pnames[1:*]
		free_lun,ddd
	endif

	wid.base  = 0l
	wid.draw  = 0l
	wid.info  = 0l
	wid.prog1 = 0l
	wid.prog2 = 0l
	wid.prog3 = 0l

        parstruct = { $
                    polarizations:	ptr_new(), $ ; number of polarizations for multibaseline datasets
                    nr_tracks:		ptr_new(), $ ; number of tracks for multibaseline datasets
                    polbasis_ellipticity: ptr_new(), $ ; e.g. for POLInSAR
                    polbasis_orientation: ptr_new(), $ ; e.g. for POLInSAR
                    subap_x:		ptr_new(), $
                    subap_y:		ptr_new(), $
                    res_az:		ptr_new(), $ ; resolution of one pixel in azimuth (m)
                    res_gr:		ptr_new(), $ ; resolution of one pixel in ground range (m)
                    res_sr:		ptr_new(), $ ; resolution of one pixel in slant  range (m)
                    wavelength:		ptr_new(), $
                    range_delay:	ptr_new(), $
                    slant_range:	ptr_new(), $
                    plane_height:	ptr_new(), $
                    plane_velocity:	ptr_new(), $
                    flat_earth:		ptr_new(), $
                    fe_file:		ptr_new(), $ ; connection e.g. for polin algorithms
                    kz_file:		ptr_new(), $ ; connection e.g. for polin algorithms
                    bl_file:		ptr_new(), $ ; Baseline lengths
                    inc_file:		ptr_new(), $ ; Incidence angles ; connection e.g. for polin algorithms
                    rsl_file:		ptr_new()  $ ; Slant ranges file
                    }

        evolution = ['']

end
