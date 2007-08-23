;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; Main program & event loop
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


@rat_install
@definitions
@gui/compile.pro
@io/compile.pro
@general/compile.pro
@sar/compile.pro
@polar/compile.pro
@insar/compile.pro
@polinsar/compile.pro
@subap/compile.pro

PRO rat_event, event
	common rat, types, file, wid, config

	if not config.debug then begin  ; error / crash handling
		catch, error_status

		if error_status ne 0 then begin
			infotext = ['OOOPS: You have found a bug in RAT !!!',$
			'',$
			'Error message: ' + !error_state.msg ,$
			'',$
			'Please help improving RAT and report this problem to the forum on the RAT website.',$
			'To find a solution, we need the precise error message and a description of what' ,$
			'you did exactly (function, settings, data type, etc.).',$
			'',$
			'RAT will try now to recover from this crash. Good luck!']
			info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='CRASH!!!!',/error)

			if ptr_valid(config.progress) then progress,/destroy            ; destroy progress bar (if there)
			while widget_info(wid.base,/sibling) ne 0 do begin              ; destroy possible sub-routine widgets
				widget_id = widget_info(wid.base,/sibling)
				if widget_info(widget_id,/valid_id) then widget_control,widget_id,/destroy
			endwhile

			goto,out
		endif
	endif


	;delete the progress information to avoid some error in case of crach
	file_delete,config.tempdir+'progressTimer.sav',/quiet

	widget_control,wid.draw,event_pro=''
	if TAG_NAMES(event, /STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST' then exit_rat else begin

   WIDGET_CONTROL, event.id, GET_UVALUE=uval

	if (size(uval))[1] eq 7 then $
   case uval of

; BUTTON DISPLAY
		'button.file.open' : open_rat
		'button.file.save' : save_rat
		'button.file.efh'  : whatisthis
		'button.edit.undo' : undo
		'button.edit.redo' : redo
		'button.edit.zoom' : zoom_region
; 		'button.edit.show_preview_on'  : show_preview,/ON	; to show or not to show the preview
; 		'button.edit.show_preview_off' : show_preview,/OFF	; to show or not to show the preview
		'button.edit.show_preview' : show_preview	; to show or not to show the preview
;  		'button.edit.layer': select_channels
		'button.tool.layer': tool_box ,/select_channel    ;select_channels_new ;data_management
		'button.tool.data' : tool_box ,/data_management   ;select_channels_new ;data_management
		'button.tool.color': tool_box ,/color_table       ;select_channels_new ;data_management

; FILE MENU
		'file': begin
			case event.value of
				'Open RAT file' : open_rat
				'Save RAT file' : save_rat
				'Open internal.E-SAR-RK (Rolf)'				: open_rolf
				'Open internal.rarr / sarr'					: open_rarr
				'Open internal.2*long + complex'				: open_2lcmp
				'Open external.E-SAR        (DLR)'			: open_esar
				'Open external.EMISAR       (DCRS)'			: open_emisar
				'Open external.PI-SAR       (NASDA-CRL)'  : open_pisar
				'Open external.CONVAIR      (CCRS)'       : open_convair
				'Open external.ASF SAR DATA.SLC DATA.RADARSAT-1'		: open_asf_slcs
				'Open external.ASF SAR DATA.SLC DATA.ERS-1/2'			: open_asf_slcs
				'Open external.ASF SAR DATA.SLC DATA.JERS'				: open_asf_slcs
				'Open external.ASF SAR DATA.DETECTED DATA.RADARSAT-1'		: open_asf_slcs
				'Open external.ASF SAR DATA.DETECTED DATA.ERS-1/2'			: open_asf_slcs
				'Open external.ASF SAR DATA.DETECTED DATA.JERS'				: open_asf_slcs
				'Open external.ENVISAT-ASAR (ESA)'			: open_envisat
				'Open external.ALOS-PALSAR  (JAXA)'			: open_palsar
				'Open external.RADARSAT-2   (CSA)'		   : open_radarsat2
				'Open external.RAMSES       (ONERA)'		: open_ramses
				'Open external.POLSARPRO 2.0/3.0'			: open_polsarpro
				'Open external.Generic binary'				: open_generic
				'Open external.ENVI standard'					: open_envi
				'Open pixmap.Open PNG'							: open_image,/png
				'Open pixmap.Open JPEG'							: open_image,/jpg
				'Open pixmap.Open TIFF'							: open_image,/tiff
				'Import system info.E-SAR        (DLR)'				: import_info_esar
				'Import system info.RAMSES       (ONERA)'			: import_info_ramses
				'Import system info.Generic'				: import_info_generic
				'Save external.Generic binary'			: save_generic
				'Save external.ENVI Standard'				: save_generic,/envi
				'Save pixmap.Save PNG'						: save_image,/png
				'Save pixmap.Save JPEG'						: save_image,/jpg
				'Save pixmap.Save TIFF'						: save_image,/tiff
				'Construct.Multitemporal.Create new multitemporal set'		: construct_multi
				'Construct.Multitemporal.Change existing multitemporal set'	: construct_multi, /called
				'Construct.Multitemporal'					: construct_multi
				'Construct.PolSAR vector'					: construct_polsar
				'Construct.InSAR pair'						: construct_insar
				'Construct.MB-PolInSAR vector'					: construct_polinsar
;				'Construct.MB-SAR vector'					: construct_polinsar
				'Construct.Flat earth file'				: construct_flatearth
				'Construct.Baseline lengths file'		: construct_blp
				'Construct.Wavenumber file'				: construct_kz
				'Preferences'									: preferences
		 		'Edit file header'							: whatisthis
		 		'Data management'								: tool_box ,/data_management
		      'Quit'          								: exit_rat
				else: dummy
			endcase
		end

; GENERAL MENU
		'general': begin
			case event.value of
				'Undo'												: undo
				'Redo'												: redo
				'Recalculate preview'							: generate_preview,/recalculate,/nodefault
				'Zoom'												: zoom_region
				'Measure value/location'                  : measure_value
				'Mirror vertical'									: mirror_vert
				'Mirror horizontal'								: mirror_hor
				'Cut out region'									: cut_region
				'Resize image'										: image_resize
				'Presumming'										: image_presumming
				'Channel statistics' 							: multi_statistics
				'Channel spectrum' 								: channel_spectrum
				'Principal Components' 							: principal_components
				'Binary transform.Complex -> Amplitude'	: complex2abs
				'Binary transform.Complex -> Phase'			: complex2pha
				'Binary transform.Integer -> Float'			: int2float
				'Extract channels'	 							: extract_channels
				'Select channels'	 								: tool_box ,/select_channel
				'Colour palettes'	 								: tool_box ,/color_table
				'Parameter Information' 							: parameter_info
				else: dummy
			endcase
		end

; SAR MENU
		'sar': begin
			case event.value of
				'Inspect.Point target'							: inspect_corner
				'Inspect.Distributed target'					: inspect_area
				'Inspect.Calculate # of looks'				: calc_looks
				'RFI filter'                              : rfi_filter
				'Speckle filter.Boxcar'							: speck_mean
				'Speckle filter.Median'							: speck_median
				'Speckle filter.Gauss'							: speck_gauss
				'Speckle filter.Sigma'							: speck_sigma
				'Speckle filter.Lee'								: speck_lee
				'Speckle filter.Refined Lee'					: speck_polreflee
				'Speckle filter.IDAN-LLMMSE'			      : speck_polidan
				'Speckle filter.Frost'							: speck_frost
				'Speckle filter.Kuan'						   : speck_kuan
				'Speckle filter.Gamma-MAP'						: speck_gammamap
				'Edge detection.Lee-RoA'						: edge_maxgrad
				'Edge detection.RoA'					         : edge_roa4
				'Edge detection.MSP-RoA'						: edge_msproa
				'Edge detection.Sobel'							: edge_robsob,/sobel
				'Edge detection.Roberts'						: edge_robsob,/roberts
				'Edge detection.Canny'							: edge_canny
				'Texture.Co-occurence features'           : text_cooc
				'Texture.Texture inhomogenity'            : text_klee
				'Texture.Variation coefficient'           : text_varcoef
				'Geometry.Slant range -> ground range'		: slant2ground
				'Transform.Amplitude <-> Intensity'			: amp2int
				'Transform.SLC -> Amplitude Image'			: complex2abs

				'Multitemporal.Coregistration.Coarse (global offset)'	: mt_coreg_coarse
				'Multitemporal.Coregistration.Warping'		: mt_coreg_warp
				'Multitemporal.Change-detection.Band ratio'	: mt_ratio
				'Multitemporal.Change-detection.Band difference'	: mt_difference
				'Multitemporal.Change-detection.Propability of change'	: mt_prop_of_change
				'Multitemporal.Change-detection.Band entropy'		: mt_entropy
				'Multitemporal.Recombine to single file'					: mt_allinone

				'Spectral tools.watch spectra'				: channel_spectrum
				'Spectral tools.modify spectal weights'	: spectral_weight ;apply_hamming
				'Time-frequency.Generate.Subaperture channels in x'		: subap_generate,/X
				'Time-frequency.Generate.Subaperture channels in y'		: subap_generate,/Y
				'Time-frequency.Generate.Subaperture channels in x and y'		: subap_generate
				'Time-frequency.Generate.Subaperture covariance matrix' 	: subap_cov
                                'Subapertures.Nonstationarity analysis' 			: subap_nonstat
				'Calculate.Span image'							: pol_to_span
				'Calculate.Amplitude ratio'					: calc_ampratio
				'Calculate.Interchannel phase difference'	: calc_iphase
				'Calculate.Interchannel correlation'		: calc_icorr
				'Wizard mode.Speckle filtering'				: wiz_speckle
				else: dummy
			endcase
		end

; POLARIMETRY MENU
		'polsar': begin
			case event.value of
				'Inspect.Point target'							: inspect_polcorner
				'Inspect.Calculate # of looks'				: calc_looks
				'Inspect.Polarimetric scatterer analysis'		: polin_analysis_pol
				'RFI filter'                              : rfi_filter
				'Speckle filter.Boxcar'							: speck_polmean
				'Speckle filter.Lee'								: speck_pollee
				'Speckle filter.Refined Lee'					: speck_polreflee
				'Speckle filter.Simulated Annealing'		: speck_pol_anneal
				'Speckle filter.Refined Lee'					: speck_polreflee
				'Speckle filter.IDAN-LLMMSE'			      : speck_polidan
				'Edge detection.Polarimetric CFAR'				: edge_pol_cfar
				'Basis transforms.-> HV'	: polar_basis,0
				'Basis transforms.-> circular'	: polar_basis,1
				'Basis transforms.-> linar at 45 deg' : polar_basis,2
				'Basis transforms.Others' : polar_basis
				'Parameters.Entropy / Alpha / Anisotropy' : decomp_entalpani
				'Parameters.Alpha / Beta / Gamma / Delta angles' : decomp_alpbetgam
				'Decompositions.Pauli decomposition'		: decomp_pauli
				'Decompositions.Eigenvalue / Eigenvector'	: decomp_eigen
				'Decompositions.Freeman-Durden'				: decomp_fredur
				'Decompositions.Moriyama'				: decomp_moriyama
				'Decompositions.Sphere / Diplane / Helix'	: decomp_sdh
;				'Decomposition.Cameron'    					: classif_cameron
				'Classification.K-means Wishart (general)': classif_wishart
				'Classification.K-means Wishart (H/a/A)'	: classif_wishart_opt
				'Classification.Expectation maximisation EM-PLR' : classif_emplr
				'Classification.Expectation maximisation selfinit' : wishart_em
				'Classification.H/a segmentation'			: classif_ea
				'Classification.H/a/A segmentation' 		: classif_eaa
				'Classification.Lee category preserving' 	: classif_lee
				'Classification.Physical classification'  : classif_physic
				'Classification.Number of sources'        : classif_nrsources
				'Post-classification.Resort clusters'     : pclass_resort
				'Post-classification.Median filter'			: speck_median,smm=3
				'Post-classification.Freeman Durden Palette'     : pclass_fredur
				'Calculate.Span image'							: pol_to_span
				'Calculate.Amplitude ratio'					: calc_ampratio
				'Calculate.Interchannel phase difference'	: calc_iphase
				'Calculate.Interchannel correlation'		: calc_icorr
				'Transform.Vector -> Matrix'					: k_to_m
				'Transform.Matrix -> Vector'					: m_to_k
				'Transform.[C] <--> [T]'						: c_to_t
				'Edge Detector.Maximum Likelihood' : dummy
				'Spectral tools.watch spectra'				: channel_spectrum
				'Time-frequency.Generate.Subaperture channels in x'		: subap_generate,/X
				'Time-frequency.Generate.Subaperture channels in y'		: subap_generate,/Y
				'Time-frequency.Generate.Subaperture channels in x and y'		: subap_generate
				'Time-frequency.Generate.Subaperture covariance matrix' 	: subap_cov
				'Time-frequency.Covarince matrix for every subaperture'  : subap_k2m
				'Time-frequency.Nonstationarity analysis' 			: subap_nonstat
				'Calibration.Cross-talk' 							: calib_xtalk
				'Calibration.Phase and amplitude imbalance' : calib_imbalance
				'Calibration.Cross-polar symmetrisation'    : calib_xsym
				'Wizard mode.Scattering vector -> Entropy/Alpha/Anisotropy'	: wiz_k2eaa
				'Wizard mode.Scattering vector -> Wishart classification'	: wiz_k2wclass
				'Wizard mode.Speckle filtering'				: wiz_speckle
				else: dummy
			endcase
		end

; MB-POLINSAR MENU
                'polinsar': begin
                   case event.value of
                      'Inspect.Classical SB-coherence analysis'			: polin_cohcirc		; done !
                      'Inspect.MB coherence optimization analysis'		: polin_analysis	; done !
                      'Inspect.MB polarimetric scatterer analysis'		: polin_analysis_pol 	; done !
                      'Inspect.Baseline parameter analysis'			:
                      'Inspect.Calculate # of looks'				: calc_looks		; done !
                      'Calibration.Cross-polar symmetrisation'    		: calib_xsym		; done !
                      'Calibration.Reflection symmetrisation'			: ; polin_calib_natural,/REFLECTION_SYM
                      'Calibration.Freeman volume power adjustment'		: ; polin_calib_natural,/VOL_CALIB
                      'RFI filter'                              		: rfi_filter		; done !
;                      'Edge detection.Polarimetric CFAR'			: edge_pol_cfar
                      'Remove topography.From cov/coh matrix'           	: polin_remove_topo	; done !
                      'Spectral filtering.Range (standard)'			: polin_rgflt_standard	; done !
                      'Spectral filtering.Range (adaptive)'			: polin_rgflt_adaptive	; done !
;                       'Spectral filtering.Range (standard)'			: rgflt_standard
;                       'Spectral filtering.Range (adaptive)'			: rgflt_adaptive
                      'Remove flat-earth.Linear'				: polin_flatearth_fft	; done !
;                      'Remove flat-earth.From file'				: polin_flatearth_file
                      'Remove flat-earth.From file'				: polin_flatearth_file	; done !
                      'Speckle filter.Boxcar'					: speck_polmean		; done !
                      'Speckle filter.Lee'					: speck_pollee		; done !
                      'Speckle filter.Refined Lee'				: speck_polreflee	; done !
                      'Speckle filter.IDAN-LLMMSE'				: speck_polidan		; done !
                      'Speckle filter.Simulated Annealing'			: speck_pol_anneal	; done !
                      'Basis transforms.--> HV'					: polin_basis,0		; done !
                      'Basis transforms.--> Circular'				: polin_basis,1		; done !
                      'Basis transforms.--> Linar at 45 deg' 			: polin_basis,2		; done !
                      'Basis transforms.Others'					: polin_basis		; done !
                      'Basis transforms.Individually per pixel'			: polin_basis_indiv	; done !
;                       'Coherence estimation.Boxcar'				: polin_coh_mean
;                       'Coherence estimation.Region Growing'			: polin_coh_rgrow
                      'Coherence estimation.Boxcar'				: polin_coh_mean	; done !
                      'Coherence estimation.Region Growing'			: polin_coh_rgrow	; done !
                      'Coherence optimisation.Multibaseline multiple SMs   (MB-MSM)'	: polin_opt_mcca	; done !
                      'Coherence optimisation.Multibaseline equal SMs      (MB-ESM)'	: polin_opt_nr		; done !
                      'Coherence optimisation.Single-baseline multiple SMs (SB-MSM)'	: polin_opt_sb,method=0	; done !
                      'Coherence optimisation.Single-baseline equal SMs    (SB-ESM)'	: polin_opt_sb,method=1	; done !
                      'Coherence optimisation.Anisotropy parameters'		: polin_params_lff	; done !
;		      'Coherence.Information'					: polin_data_info
                      'Phase optimisation.ESPRIT'				: polin_coh_esprit	; done !
                      'Phase optimisation.Phase diversity'			: polin_coh_div		; done !
                      'Correlation.Total'					: polin_cor,/TOTAL	; done !
                      'Correlation.Over baselines'				: polin_cor		; done !
                      'Parameters.Entropy / Alpha / Anisotropy'			: polin_deco_haa	; done !
                      'Parameters.Mean Alpha / Beta / Gamma / Delta angles'	: polin_deco_abgd,/M	; done !
                      'Parameters.All Alpha / Beta / Gamma / Delta angles'	: polin_deco_abgd	; done !
                      'Decompositions.Pauli decomposition'			: polin_basis,/PAULI	; done !
                      'Decompositions.Lexicographic (default)'			: polin_basis,/LEX	; done !
                      'Decompositions.Freeman-Durden'				: polin_deco_freedur	; done !
                      'Decompositions.Sphere / Diplane / Helix'			: polin_deco_sdh	; done !
;		      'Classification.K-means Wishart' 				: polin_classif_wishart
                      'Classification.Expectation maximisation EM-PLR' 		: classif_emplr		; done !
                      'Classification.Expectation maximisation selfinit' 	: wishart_em		; done !
                      'Classification.K-means Wishart (H/a/A)'			: classif_wishart_opt		; ???
                      'Classification.K-means Wishart (general)' 		: classif_wishart		; ???
                      'Classification.A1/A2 LFF parameters' 			: polin_classif_params_lff	; done
                      'Classification.Expectation maximisation' 		: ;polin_wishart_em 		; ???
                      'Post-classification.Resort clusters'     		: pclass_resort		; done !
                      'Post-classification.Freeman Durden Palette'		: pclass_fredur		; done !
                      'Spectral tools.watch spectra'				: channel_spectrum	; done !
                      'Time-frequency.Generate.Subaperture channels in x'	: subap_generate,/X	; done !
                      'Time-frequency.Generate.Subaperture channels in y'	: subap_generate,/Y	; done !
                      'Time-frequency.Generate.Subaperture channels in x and y'	: subap_generate	; done !
                      'Time-frequency.Generate.Subaperture covariance matrix' 	: subap_cov		; done !
                      'Time-frequency.Covarince matrix for every subaperture'	: subap_k2m		; done !
                      'Time-frequency.Nonstationarity analysis' 		: subap_nonstat         ; done !
                      'PolDInSAR.Differential phases'				: polin_din_phases
                      'PolDInSAR.Differential heights'				: polin_din_phases,/HEIGHTS
                      'Extract.Complex interferograms'				: polin_interf		; done !
                      'Extract.Interferometric phases'				: polin_interf_pha	; done !
                      'Extract.SAR image'					: extract_channels	; done !
                      'Extract.PolSAR image'					: polin_extract_polsar	; done !
                      'Extract.InSAR image'					: polin_extract_insar	; done !
                      'Extract.SB-PolInSAR image'				: polin_extract_polinsar; done !
                      'Transform.Vector -> Matrix'				: polin_k2m		; done !
                      'Transform.Matrix -> Vector'				: m_to_k		; done !
                      'Transform.[C] <--> [T]'					: polin_c2t		; done !
                      'Transform.Matrix normalization'				: polin_normalize	; done !
;                      'For developers.Data info'				: polin_data_info
                      'Wizard mode.POLINSAR data -> HaA-Wishart classification' : polin_wiz_2haawish	; done !
                      'Wizard mode.Speckle filtering'				: wiz_speckle		; done !
                      else: dummy
                   endcase
                end

; INSAR MENU
		'insar': begin
			case event.value of
				'Transform.Image pair -> interferogram'   : pair2interf
				'Transform.Extract amplitude'             : interf2amp
				'Transform.Extract phase'                 : interf2pha
				'Coregistration.Coarse (global)'				: coreg_one
				'Coregistration.Subpixel (global)'			: coreg_sub
				'Coregistration.Array of patches'			: coreg_patch
				'Phase noise filter.Boxcar'					: pnoise_mean
				'Phase noise filter.Goldstein'				: pnoise_goldstein
				'Phase noise filter.GLSME'						: pnoise_qef
				'Coherence.Boxcar'								: coh_mean
				'Coherence.Gauss'									: coh_gauss
				'Coherence.Region growing'						: coh_regrow
				'Remove flat-earth.linear'						: rm_flatearth_fft
				'Remove flat-earth.from geometry'			: rm_flatearth_geometry
				'Remove flat-earth.from file'					: rm_flatearth_file
				'Shaded relief'					            : shaded_relief
				'Airborne case.Parameter information'		: parameter_information,wid.base
				'Airborne case.Remove flat-earth phase'	: rm_flatearth_airborne
				'Phase Unwrapping.Least-Squares'          : unwrap_ls
				'Phase Unwrapping.Branch Cuts.Branch cuts unwrapping' : unwrap_goldstein
				'Phase Unwrapping.Branch Cuts.Identify residues' 		: unwrap_residue
				'Phase Unwrapping.Branch Cuts.Calculate branch cuts' 	: unwrap_bc
				'Phase Unwrapping.Rewrap phase'           : unwrap_rewrap
				'Phase Unwrapping.Calculate difference map': unwrap_diff
				'Spectral filtering.Range (standard)'		: rgflt_standard
				'Spectral filtering.Range (adaptive)'		: rgflt_adaptive
				'Spectral tools.watch spectra'				: channel_spectrum
				else: dummy
			endcase
                     end

; SUBAP MENU
		'subap': begin
			case event.value of
				'Generate.Sub-apertures' : subap_generate
				'Generate.Sub-aperture covariace matrix' : subap_cov
                                'Multi-channel SubAp.Vector -> Covarince matrix for every Sub-aperture' : subap_k2m
                                'Extract.Single Aperture' : subap_extract_single
                                'Nonstationarity.Calculate' : subap_nonstat
                                else: dummy
                             endcase
                     end

;HELP MENU
		'help': begin
			case event.value of
				'RAT User Guide'		: view_ratpdf,/GUIDE
				'About RAT'			: about
				'Contact'			: contact
				'License'			: license
				else: dummy
			endcase
		end
;BASE
		'base': begin
			ysize = event.y
			widget_control,wid.draw,scr_ysize=ysize-80
		end
;ELSE
			else: dummy
   	endcase
		widget_control,wid.draw,draw_button_events=1, draw_motion_events = 1,event_pro='cw_rat_draw_ev',bad_id = dummy
	endelse  ; click on close button
	out:
end



PRO rat,STARTFILE=startfile,BLOCK=block, $
        nw=batch, $ ; nw == no window
        no_preview_image=no_preview_image
	common rat, types, file, wid, config

;---- init ----

	definitions

;;; in the following condition, give not the current version number,
;;; but the last compatible one, where rat_install was not required.
;;; a new rat_install may be necessary in case of addition of new
;;; icons, or color palettes, as well as through changes in
;;; configuration structure variables. (mn, 06.07)
        if config.version lt 0.19 then begin
;; i incremented the number to 0.181 because i made some changes on
;; icons, so that you also have to run the rat_install
;; (mn, 6.6.7)
           info = DIALOG_MESSAGE(["Congratulations!","You obtained a new version of RAT.","This requires the re-installation of some configuration files."], TITLE='RAT Installation Update',/info,/cancel,/center)
           if info eq 'Cancel' then return
           rat_install
           definitions
        endif
        if n_elements(no_preview_image) ne 0 then $
           config.show_preview = ~keyword_set(no_preview_image)
        config.batch = keyword_set(batch)
        if config.batch then config.show_preview = 0
        wid.block = keyword_set(block)

	;delete the progress information to avoid some error in case of crach
	file_delete,config.tempdir+'progressTimer.sav',/quiet

	if config.os eq 'unix'	  then device,true_color=24,decompose=0,retain=2
	if config.os eq 'windows' then begin
		device,decompose=0,retain=2
		widget_control,default_font='Courier New*15'
	endif

;---- menubar ----

;	wid.base      = WIDGET_BASE(TITLE='RAT - Radar Tools',XSIZE=wid.base_xsize, MBAR=bar, UVALUE='base',TLB_frame_attr=1,/column,/TLB_KILL_REQUEST_EVENTS)
        wid.base      = WIDGET_BASE(TITLE='RAT - Radar Tools', $
                                    MBAR=bar, UVALUE='base', $
                                    TLB_frame_attr=1,/column, $
                                    /TLB_KILL_REQUEST_EVENTS, $
                                    MAP=~config.batch)
        file_menu     = WIDGET_BUTTON(bar, VALUE=' File ', /MENU)
        general_menu  = WIDGET_BUTTON(bar, VALUE=' General ', /MENU)
        sar_menu      = WIDGET_BUTTON(bar, VALUE=' SAR ', /MENU)
        polar_menu    = WIDGET_BUTTON(bar, VALUE=' PolSAR ', /MENU)
        insar_menu    = WIDGET_BUTTON(bar, VALUE=' InSAR' , /MENU )
        polin_menu    = WIDGET_BUTTON(bar, VALUE=' PolInSAR ', /MENU)
;	subap_menu    = WIDGET_BUTTON(bar, VALUE=' SubAp' , /MENU )
        help_menu     = WIDGET_BUTTON(bar, VALUE=' Help', /MENU, /HELP)

	m_file = CW_PDMENU(file_menu,[ $
		'0\Open RAT file', $
		'1\Construct', $
		'1\Multitemporal', $
		'0\Create new multitemporal set', $
		'2\Change existing multitemporal set', $
		'0\PolSAR vector', $
		'0\InSAR pair', $
                '0\MB-PolInSAR vector', $
;                '0\MB-SAR vector' , $
                '0\Flat earth file' , $
                '0\Baseline lengths file' , $
                '2\Wavenumber file' , $
		'1\Open external', $
		'0\E-SAR        (DLR)', $
		'0\EMISAR       (DCRS)', $
		'0\PI-SAR       (NASDA-CRL)', $
		'0\RAMSES       (ONERA)', $
		'0\CONVAIR      (CCRS)', $
		'4\ENVISAT-ASAR (ESA)', $
		'0\ALOS-PALSAR  (JAXA)', $
		'0\RADARSAT-2   (CSA)', $
		'1\ASF SAR DATA', $
			'1\SLC DATA', $
				'0\RADARSAT-1', $
				'0\ERS-1/2', $
				'2\JERS', $
			'3\DETECTED DATA', $
				'0\RADARSAT-1', $
				'0\ERS-1/2', $
				'2\JERS', $
 		'4\POLSARPRO 2.0/3.0', $
  		'0\Generic binary', $
		'2\ENVI standard', $
		'1\Open internal', $
		'0\rarr / sarr', $
		'0\2*long + complex', $
		'2\E-SAR-RK (Rolf)', $
		'1\Open pixmap', $
		'0\Open PNG'  , $
		'0\Open JPEG' , $
		'2\Open TIFF' , $
                '1\Import system info', $
                '0\E-SAR        (DLR)', $
                '0\RAMSES       (ONERA)', $
                '2\Generic',$
		'4\Save RAT file', $
		'1\Save external' , $
		'0\ENVI Standard' , $
		'2\Generic binary' , $
		'1\Save pixmap' , $
		'0\Save PNG'  , $
		'0\Save JPEG' , $
		'2\Save TIFF' , $
		'4\Edit file header'  , $
		'0\Data management'  , $
		'4\Preferences'  , $
		'6\Quit'],/MBAR,/RETURN_FULL_NAME,UVALUE = 'file')

	m_general = CW_PDMENU(general_menu,[ $
		'0\Undo' , $
		'0\Redo' , $
		'0\Recalculate preview' , $
		'4\Measure value/location' , $
		'4\Zoom' , $
		'4\Resize image' , $
		'0\Presumming' , $
		'0\Cut out region' , $
		'4\Mirror vertical' , $
		'0\Mirror horizontal', $
		'4\Select channels', $
		'0\Extract channels', $
		'4\Colour palettes',$
		'4\Channel statistics',$
		'0\Channel spectrum', $
		'0\Principal Components',$
		'4\Parameter Information', $
		'5\Binary transform'  , $
		'0\Complex -> Amplitude' , $
		'0\Complex -> Phase', $
		'2\Integer -> Float' $
		],/MBAR,/RETURN_FULL_NAME, UVALUE = 'general')

	m_sar = CW_PDMENU(sar_menu,[ $
		'5\Inspect'   , $
		'0\Point target', $
		'0\Distributed target',$
		'2\Calculate # of looks',$
		'0\RFI filter'   , $
		'5\Speckle filter'   , $
		'0\Boxcar'      , $
		'0\Lee'         , $
		'0\Refined Lee' , $
		'0\IDAN-LLMMSE'      , $
		'0\Gamma-MAP' , $
		'0\Sigma',      $
		'0\Median'      , $
		'0\Gauss'      , $
		'0\Kuan' , $
		'2\Frost' , $
		'1\Edge detection' , $
		'0\RoA'     , $
		'0\Lee-RoA'     , $
		'0\MSP-RoA'     , $
		'0\Canny'     , $
		'4\Sobel'     , $
		'2\Roberts'   , $
		'1\Texture' , $
		'0\Variation coefficient'   , $
		'0\Texture inhomogenity'   , $
		'2\Co-occurence features'   , $
		'1\Geometry'  , $
		'2\Slant range -> ground range', $

		'1\Multitemporal' ,$
		'1\Coregistration' ,$
		'0\Coarse (global offset)' ,$
		'2\Warping' ,$
		'1\Change-detection' ,$
		'0\Band ratio' , $
		'0\Band difference', $
		'0\Propability of change', $
		'2\Band entropy' ,$
		'2\Recombine to single file', $

		'5\Spectral tools'  , $
		'0\watch spectra',$
		'2\modify spectal weights',$
		'1\Time-frequency'  , $
			'1\Generate', $
				'0\Subaperture channels in x', $
				'0\Subaperture channels in y', $
				'0\Subaperture channels in x and y', $
				'2\Subaperture covariance matrix', $
			'2', $
		'5\Calculate', $
		'0\Span image', $
		'0\Amplitude ratio', $
		'0\Interchannel phase difference', $
		'2\Interchannel correlation', $
		'1\Transform'  , $
		'0\Amplitude <-> Intensity',$
		'2\SLC -> Amplitude Image',  $
		'5\Wizard mode', $
			'2\Speckle filtering' $
		],/MBAR,/RETURN_FULL_NAME, UVALUE = 'sar')

	m_polar = CW_PDMENU(polar_menu,[ $
		'5\Inspect'   , $
		'0\Polarimetric scatterer analysis', $
		'0\Point target', $
		'0\Distributed target',$
		'2\Calculate # of looks',$
		'1\Calibration',$
		'0\Phase and amplitude imbalance',$
		'0\Cross-talk',$
		'2\Cross-polar symmetrisation',$
		'0\RFI filter'   , $
		'5\Speckle filter'   , $
			'0\Boxcar'      , $
			'0\Lee'      , $
			'0\Refined Lee'      , $
			'0\IDAN-LLMMSE'      , $
			'2\Simulated Annealing'      , $
		'1\Edge detection', $
			'2\Polarimetric CFAR', $
		'1\Basis transforms', $
			'0\-> HV', $
			'0\-> circular', $
			'0\-> linar at 45 deg', $
			'2\Others', $
		'5\Parameters', $
			'0\Entropy / Alpha / Anisotropy',$
			'2\Alpha / Beta / Gamma / Delta angles',$
		'1\Decompositions', $
			'0\Pauli decomposition', $
			'0\Eigenvalue / Eigenvector', $
			'0\Freeman-Durden', $
;		'0\Cameron', $
			'0\Moriyama', $
			'2\Sphere / Diplane / Helix', $
		'1\Classification', $
			'0\K-means Wishart (general)', $
			'0\K-means Wishart (H/a/A)', $
			'0\Expectation maximisation EM-PLR', $
			'0\Expectation maximisation selfinit', $
			'0\Lee category preserving', $
			'0\H/a segmentation', $
			'0\H/a/A segmentation', $
			'0\Physical classification', $
			'2\Number of sources', $
		'1\Post-classification', $
			'0\Median filter', $
			'0\Freeman Durden Palette', $
			'2\Resort clusters', $
		'5\Spectral tools'  , $
		'2\watch spectra',$
		'1\Time-frequency'  , $
			'1\Generate', $
				'0\Subaperture channels in x', $
				'0\Subaperture channels in y', $
				'0\Subaperture channels in x and y', $
				'2\Subaperture covariance matrix', $
				'0\Covarince matrix for every subaperture', $
			'6\Nonstationarity analysis', $
		'5\Calculate', $
		'0\Span image', $
		'0\Amplitude ratio', $
		'0\Interchannel phase difference', $
		'2\Interchannel correlation', $
		'1\Transform', $
		'0\Vector -> Matrix', $
		'0\Matrix -> Vector', $
		'2\[C] <--> [T]', $
		'5\Wizard mode', $
			'0\Speckle filtering'      , $
			'0\Scattering vector -> Entropy/Alpha/Anisotropy',$
			'2\Scattering vector -> Wishart classification'$
		],/MBAR,/RETURN_FULL_NAME, UVALUE = 'polsar')

	m_polin = CW_PDMENU(polin_menu,[ $
                  '5\Inspect'   , $
                  '0\Classical SB-coherence analysis', $
                  '0\MB coherence optimization analysis', $
                  '0\MB polarimetric scatterer analysis', $
;                  '0\MB parameter inversion analysis', $
                  '2\Calculate # of looks',$
                  '1\Calibration',$
                  '2\Cross-polar symmetrisation', $
;                   '0\Reflection symmetrisation', $
;                   '2\Freeman volume power adjustment', $
                  '0\RFI filter'   , $
                  '5\Remove topography',$
                  '2\From cov/coh matrix',$
                  '1\Spectral filtering', $
                  '0\Range (standard)', $
                  '2\Range (adaptive)', $
                  '1\Remove flat-earth',$
                  '0\Linear',$
                  '2\From file',$
                  '5\Speckle filter'   , $
                  '0\Boxcar'      , $
                  '0\Lee'      , $
                  '0\Refined Lee'      , $
                  '0\IDAN-LLMMSE'      , $
                  '2\Simulated Annealing'      , $
;		'1\Edge detection', $
;		'2\Polarimetric CFAR', $
                  '1\Basis transforms', $
                  '0\--> HV', $
                  '0\--> Circular', $
                  '0\--> Linar at 45 deg', $
                  '0\Others', $
                  '6\Individually per pixel', $
                  '5\Coherence estimation', $
                  '0\Boxcar', $
                  '2\Region Growing', $
                  '1\Coherence optimisation', $
                  '0\Multibaseline multiple SMs   (MB-MSM)', $
                  '0\Multibaseline equal SMs      (MB-ESM)', $
                  '4\Single-baseline multiple SMs (SB-MSM)', $
                  '0\Single-baseline equal SMs    (SB-ESM)', $
                  '6\Anisotropy parameters', $
;		'2\Information', $
                  '1\Phase optimisation', $
                  '0\ESPRIT', $
                  '2\Phase diversity', $
                  '1\Correlation', $
                  '0\Total', $
                  '2\Over baselines', $
                  '5\Parameters', $
                  '0\Entropy / Alpha / Anisotropy',$
                  '0\Mean Alpha / Beta / Gamma / Delta angles',$
                  '2\All Alpha / Beta / Gamma / Delta angles',$
                  '1\Decompositions', $
                  '0\Pauli decomposition', $
                  '0\Lexicographic (default)', $
                  '0\Freeman-Durden', $
                  '2\Sphere / Diplane / Helix', $
; 		'5\Decompositions', $
; 		'2\Pauli decomposition', $
                  '1\Classification',$
                  '0\K-means Wishart (general)', $
                  '0\K-means Wishart (H/a/A)', $
                  '0\Expectation maximisation EM-PLR', $
;                  '0\Expectation maximisation selfinit', $
                  '2\A1/A2 LFF parameters', $
                  '1\Post-classification', $
                  '0\Freeman Durden Palette', $
                  '2\Resort clusters', $
                  '5\Spectral tools'  , $
                  '2\watch spectra',$
                  '1\Time-frequency'  , $
                  '1\Generate', $
                  '0\Subaperture channels in x', $
                  '0\Subaperture channels in y', $
                  '0\Subaperture channels in x and y', $
                  '2\Subaperture covariance matrix', $
                  '0\Covarince matrix for every subaperture', $
                  '6\Nonstationarity analysis', $
                  '5\PolDInSAR', $
                  '0\Differential phases', $
                  '2\Differential heights', $
                  '5\Extract', $
                  '0\Complex interferograms', $
;		'0\Interferometric amplitudes', $
                  '0\Interferometric phases', $
                  '0\SAR image', $
                  '0\PolSAR image', $
                  '0\InSAR image', $
                  '2\SB-PolInSAR image', $
                  '1\Transform', $
                  '0\Vector -> Matrix', $
                  '0\Matrix -> Vector', $
                  '0\[C] <--> [T]', $
                  '2\Matrix normalization', $
                  '5\Wizard mode', $
                  '0\Speckle filtering', $
                  '2\POLINSAR data -> HaA-Wishart classification' $
;                '5\For developers',$
;                '2\Data info' $
	],/MBAR,/RETURN_FULL_NAME, UVALUE = 'polinsar')


	m_insar = CW_PDMENU(insar_menu,[ $
		'1\Coregistration', $
		'0\Coarse (global)'   , $
		'0\Subpixel (global)' , $
		'2\Array of patches'	, $
		'1\Spectral filtering', $
		'0\Range (standard)', $
		'2\Range (adaptive)', $
		'1\Remove flat-earth', $
		'0\linear', $
		'0\from geometry', $
		'2\from file', $
		'1\Coherence',  $
		'0\Boxcar', $
		'0\Gauss', $
		'2\Region growing', $
		'1\Phase noise filter', $
		'0\Boxcar'      , $
		'0\Goldstein'      , $
		'2\GLSME'      , $
		'1\Phase Unwrapping', $
			'0\Least-Squares', $
			'1\Branch Cuts', $
				'0\Branch cuts unwrapping', $
				'0\Identify residues', $
				'2\Calculate branch cuts', $
			'4\Rewrap phase', $
			'2\Calculate difference map', $
		'0\Shaded relief', $
  		'5\Airborne case', $
  		'0\Parameter information',$
  		'2\Remove flat-earth phase',$
;  		'0\Remove topographic phase',$
;  		'0\Range adaptative filter',$
;  		'2\Phase2height conversion',$
		'5\Spectral tools'  , $
		'2\watch spectra',$
		'5\Transform'    , $
		'0\Image pair -> interferogram' , $
		'0\Extract amplitude' , $
		'2\Extract phase'  $
		],/MBAR,/RETURN_FULL_NAME, UVALUE = 'insar')

;  	m_subap = CW_PDMENU(subap_menu,[ $
;  		'1\Generate', $
;                  '0\Sub-apertures', $
;                  '2\Sub-aperture covariace matrix', $
;                  '1\Multi-channel SubAp', $
;                  '2\Vector -> Covarince matrix for every Sub-aperture', $
;                  '1\Nonstationarity', $
;                  '0\Calculate', $
;                  '2\Eliminate', $
;  		'1\Extract'   , $
;                  '0\Single Aperture', $
;                  '2\Full Image' $
;                   ],/MBAR,/RETURN_FULL_NAME, UVALUE = 'subap')
;
	m_help = CW_PDMENU(help_menu,[ $
		'0\RAT User Guide', $
		'4\Contact', $
		'0\License', $
		'6\About RAT' $
		],/MBAR,/RETURN_FULL_NAME,UVALUE = 'help')

; Button bar

	widbuttonx = widget_base(wid.base,/row)
        widbutton = widget_base(widbuttonx,/row,/toolbar)
        widButFile = widget_base(widbutton,/row,/frame,/toolbar)
        button_open = widget_button(widButFile,value=config.imagedir+'open.bmp',/bitmap,tooltip='Open RAT file',uvalue='button.file.open')
        button_save = widget_button(widButFile,value=config.imagedir+'save.bmp',/bitmap,tooltip='Save RAT file',uvalue='button.file.save')
        button_efh = widget_button(widButFile,value=config.imagedir+'prop.bmp',/bitmap,tooltip='Edit file header',uvalue='button.file.efh')
        widButEdit = widget_base(widbutton,/row,/frame,/toolbar)
        wid.button_undo  = widget_button(widButEdit,value=config.imagedir+'undo2.bmp',/bitmap,tooltip='Undo',uvalue='button.edit.undo')
        wid.button_redo  = widget_button(widButEdit,value=config.imagedir+'redo2.bmp',/bitmap,tooltip='Redo',uvalue='button.edit.redo')
        button_zoom  = widget_button(widButEdit,value=config.imagedir+'zoom.bmp',/bitmap,tooltip='Zoom',uvalue='button.edit.zoom')
;         button_show_preview_on = widget_button(widButEdit,value=config.imagedir+'show_preview.bmp',/bitmap,tooltip='Show preview',uvalue='button.edit.show_preview_on')
;         button_show_preview_off = widget_button(widButEdit,value=config.imagedir+'show_preview2.bmp',/bitmap,tooltip='Switch preview off',uvalue='button.edit.show_preview_off')
        wid.button_show_preview = widget_button(widButEdit,value=config.imagedir+'show_preview_'+(config.show_preview?'on':'off')+'.bmp',/bitmap,tooltip='Show preview',uvalue='button.edit.show_preview')
;  			button_layer =
;  			widget_button(widButEdit,value=config.imagedir+'layer.bmp',/bitmap,tooltip='Select channels',uvalue='button.edit.layer')
        widButTool = widget_base(widbutton,/row,/frame,/toolbar)
        button_layer    = widget_button(widButTool,value=config.imagedir+'layer.bmp',/bitmap,tooltip='Select channels',uvalue='button.tool.layer')
        button_data_man = widget_button(widButTool,value=config.imagedir+'mcr.bmp',/bitmap,tooltip='Data management',uvalue='button.tool.data')
        button_color    = widget_button(widButTool,value=config.imagedir+'palette.bmp',/bitmap,tooltip='Color table',uvalue='button.tool.color')
;  		widRatBase = widget_base(widbuttonx,/row)
;  			widSpacebase = widget_base(widRatBase,xsize=wid.base_xsize - 280,ysize=1)
;  ;			widRATDraw = widget_draw(widRatBase,xsize=80,ysize=35)

;---- preview window ----

		widinner = widget_base(wid.base,/column)
;		wid.draw = cw_rat_draw(widinner,wid.base_xsize,wid.base_ysize,/SCROLL,RETAIN=2,color_model=1)
                wid.draw = cw_rat_draw(widinner,wid.base_xsize,wid.base_ysize,XSCROLL=wid.base_xsize+2,YSCROLL=wid.base_ysize,RETAIN=2,color_model=1)
;		wid.draw = cw_rat_draw(widinner,wid.base_xsize-35,wid.draw_ysize,wid.base_xsize-33,wid.base_ysize-100, 	RETAIN=2,color_model=1)
;		wid.draw = WIDGET_DRAW(widinner, XSIZE=wid.base_xsize-35, YSIZE=wid.draw_ysize,X_SCROLL_SIZE=wid.base_xsize-33, Y_SCROLL_SIZE=wid.base_ysize-100, RETAIN=2,color_model=1)

;---- info box ----

		lower    = widget_base(widinner,/row)
		wid.info = WIDGET_TEXT(lower,SCR_XSIZE=wid.base_xsize-135, YSIZE=3)
;	  	image_rat_draw = widget_draw(lower,xsize=130,ysize=57)


;;; set a 'fancy' prompt for rat:

;---- draw everything ----

	WIDGET_CONTROL, /REALIZE, wid.base, MAP=~config.batch ;, XOFFSET=200

;  ;---- display rat logo
;  	widget_control, image_rat_draw, get_value=index
;  	wset,index
;  	rat_logo=read_png(config.imagedir+'rat.png')
;  	tv,rat_logo,true=1

;  ;---- display the eusar logo
;  	widget_control, widRATDraw, get_value=index
;  	wset, index
;  	rat_logo = read_png(config.imagedir+'smallrat.png')
;  	tv,rat_logo,true=1
;
;switch back to main draw widget
	widget_control,wid.draw,get_value=index,draw_button_events=1, draw_motion_events = 1,event_pro='cw_rat_draw_ev'
	wset,index

	device,/cursor_original

	if float(strmid(!version.release,0,3)) lt 6.2 then begin
		error = DIALOG_MESSAGE(["Sorry, IDL / IDL virtual machine version >= 6.2 required"], DIALOG_PARENT = wid.base, TITLE='Error')
		widget_control, wid.base, /destroy
		return
             endif

;       !prompt='RAT: '

;	print,config.workdir+'test.rat'

	if not keyword_set(startfile) then startfile = config.workdir+'/default.rat'

;;; it shouldn't be obligatory, to provide the suffix ".rat" to open a
;;; file automatically - mn, 06.07
        if ~file_test(startfile) then $
           if file_test(startfile+'.rat') then startfile+='.rat' $
           else if file_test(startfile+'.mrat') then startfile+='.mrat' $
           else startfile = config.workdir+'/default.rat'

	if file_test(startfile) then open_rat,inputfile=startfile
	XMANAGER, 'rat', wid.base, no_block = ~wid.block

END
