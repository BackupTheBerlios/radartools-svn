;------------------------------------------------------------------------
; RAT Module: palette_write
;
; written by    : Maxim Neumann
; last revision : 07.Oct.2005
;------------------------------------------------------------------------
; writes the palette to a file
;------------------------------------------------------------------------
; filename == "abc.rat" or "abc.pal" or "abc.rit"
;------------------------------------------------------------------------

pro palette_write, pal, filename=filename
  common rat, types, file, wid, config

  if n_elements(filename) eq 0 then filename = file.name 
  f = strmid(filename,0,strlen(filename)-4)

  ritfile = f+'.rit'
  rit_write,ritfile,'palette',pal,stat=ritstat

  palfile = f+'.pal'
  file_delete,palfile,/QUIET
end
