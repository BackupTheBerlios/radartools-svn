pro plotClassTables, logTables, coherHist

coherChannels = (size(logTables))[2]
classNum = (size(logTables))[4]

!p.multi = [-1,2*coherChannels,classNum+1]

window, 0, xsize=500, ysize=400

for i=0,coherChannels-1 do begin
    plot, coherHist[*,i,0]
    plot, coherHist[*,i,1]
end

tables = exp(logTables)
infInd = where(finite(tables) eq 0, nr)
if (nr gt 0) then tables[infInd] = 0.0 

for i=0,classNum-1 do begin
    for j=0,coherChannels-1 do begin
        plot, reform(tables[*,j,0,i])

        print, 'tabTotal', total(tables[*,j,0,i])

        plot, reform(tables[*,j,1,i])
    end
end

!p.multi=[-1,0,0]

end

