function makeClassLogTables, classCoher, lookNum, logTabLen, hypGeomEPS, useFlags

coherChannels = (size(classCoher))[1]
classNum = (size(classCoher))[2]

coherPhase = atan(classCoher,/phase)
coherAbs = abs(classCoher)

logTables = fltarr(logTablen,coherChannels,2,classNum)

lnPi = alog(2*!pi)
lookConst = alog(2)+alog(lookNum[0]-1)

absRange = (findgen(logTabLen)+1)/(logTabLen+2)

for i=0,classNum-1 do begin
    for j=0,coherChannels-1 do begin
        D = coherAbs[j,i]
        D2 = coherAbs[(j+1) mod coherChannels,i]

        if (useFlags[2] eq 1) then begin
            logTables[*,j,0,i] = lookConst+lookNum[0]*alog(1-D^2)+alog(absRange)+(lookNum[0]-2)*alog(1-absRange^2) + lnHypGeom([lookNum[0],lookNum[0]],1,(D*absRange)^2,epsilon=hypGeomEPS)
        end

        if (useFlags[3] eq 1) then begin
            phaseCenters = [0.0, coherPhase[j,i]]
            logTables[*,j,1,i] = approxAngDiffDistrib([D,D2], phaseCenters, lookNum[1], logTabLen, hypGeomEPS)
        end

        infInd = where(finite(logTables[*,j,*,i]) eq 0, nr)
        if (nr gt 0) then stop
    end
end

logTables = reform(logTables,[logTabLen,coherChannels,2,classNum])

return, logTables
end
