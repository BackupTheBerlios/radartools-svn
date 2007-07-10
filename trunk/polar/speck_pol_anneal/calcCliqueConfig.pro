function calcCliqueConfig

cliqueConf = intarr(3,3,12)
rot = [1,2,5,0,4,8,3,6,7]
ind = indgen(9)

for i=0,3 do begin
    for j=0,2 do begin
        conf = intarr(3,3)
        conf[ind[1]] = 1
        conf[ind[j+6]] = 1
        cliqueConf[*,*,i*3+j] = conf
    end
    ind = rot[ind]
end

return, cliqueConf
end
