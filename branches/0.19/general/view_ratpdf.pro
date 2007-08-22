pro view_ratpdf, file=pdffile, path=path, GUIDE=GUIDE
  common rat ;, types, file, wid, config

  if n_elements(path) eq 0 then path=config.docdir
  if keyword_set(GUIDE) then pdffile='user_guide_v1.0.pdf'

  if config.os eq 'unix' then $
     spawn,config.pdfviewer+' '+path+pdffile+' &' $
  else if config.os eq 'windows' then $
     spawn,config.pdfviewer+' '+path+pdffile,/nowait,/noshell

end
