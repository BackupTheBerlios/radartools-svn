function calcEffectiveNumLooks, covarBlock, winSize

covarSize = (size(covarBlock))[1]
blockRes = (size(covarBlock))[3:4]

lookBuf = fltarr(blockRes)

for i=0,covarSize-1 do begin
    looks = float(reform(covarBlock[i,i,*,*]))
    looks = smooth(looks^2,winSize,/edge_truncate)/(smooth(looks,winSize,/edge_truncate)^2)
    lookBuf += 1.0 / (looks - 1.0)
end

return, (lookBuf / covarSize)
end
