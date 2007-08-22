;------------------------------------------------------------------------
; RAT Module: import_info_generic
;
; written by    : Maxim Neumann
; last revision : 08/2006
;------------------------------------------------------------------------

pro import_info_generic, TRACKS_NR=n_tr
  common rat
  common channel

  infotext = ['GENERIC IMPORT SYSTEM INFO DATA',$
              'RAT module written 2006 by Maxim Neumann',' ', $
              'Select one system informatin file.',"At the moment only ESAR-.sav and RAMSES-.ent files are supported."]
  info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')

  path = config.workdir
  files = cw_rat_dialog_pickfile(TITLE='Open system info file (".sav" or ".ent")', DIALOG_PARENT=wid.base, FILTER = '*.sav;*.ent', $
                                    /MUST_EXIST, PATH=path, GET_PATH=path)
  if files eq '' then return

  if stregex(files,'.sav$',/fold,/bool) then $
     import_info_esar, TRACKS_NR=n_tr, INPUTFILE=files

  if stregex(files,'.ent$',/fold,/bool) then $
     import_info_ramses, TRACKS_NR=n_tr, INPUTFILE=files

end
