local ffi = require("ffi")

AKYRS = {}
local bpdat = assert(io.open("bomb_prompts.txt"))
assert(load(assert(bpdat:read("*a")), "@bomb_prompts.lua"))()
bpdat:close()

do
local hfreq = 0
local lm = {}
for i,v in ipairs(AKYRS.pickable_bomb_prompts) do
	lm[v] = true
	if not AKYRS.bomb_prompts[v] then
		print(v, "exists in pickable but not in table")
	end
end
for k,v in pairs(AKYRS.bomb_prompts) do
	if hfreq < v then hfreq = v end
	if not lm[k] then
		print(k, "exists in table but not pickable")
	end
end
print(string.format("high freq: %d", hfreq))
end

local isbe
do
	local a = ffi.new('uint16_t[1]')
	local b = ffi.cast('uint8_t*', a)
	a[0] = 0x1234
	isbe = b[0] == 0x12
end
local _su32data = { u32 = ffi.new('uint32_t[1]') } _su32data.u8 = ffi.cast('uint8_t*', _su32data.u32)

local function su32(u32)
	_su32data.u32[0] = u32
	_su32data.u8[0], _su32data.u8[3] = _su32data.u8[3], _su32data.u8[0]
	_su32data.u8[1], _su32data.u8[2] = _su32data.u8[2], _su32data.u8[1]
	return _su32data.u32[0]
end

local hl = 0
local l = {}
for k,v in pairs(AKYRS.bomb_prompts) do
	if hl < #k then hl = #k end
	local ll = l[#k]
	if not ll then ll = {} l[#k] = ll end
	table.insert(ll, {k, v})
end

local outfile = assert(io.open("../func/bomb_prompts/list.bin", "wb"))
local outmeta = assert(io.open("../func/bomb_prompts/meta.lua", "wb"))
local i32 = ffi.new('uint32_t[1]')

outmeta:write('return {\n')
outmeta:write('\tlendata = {\n')

for i=1, hl do
	local ll = l[i]
	if ll then
		outmeta:write(string.format('\t\t[%d] = {%d, %d},\n', i, outfile:seek(), #ll))
		table.sort(ll, function (a, b)
			if b[2] ~= a[2] then return a[2] < b[2] end
			return a[1] < b[1]
		end)
		local sum = 0
		for j, e in ipairs(ll) do
			sum = sum + e[2]
			e[2] = sum
			outfile:write(e[1])
		end
		for j, e in ipairs(ll) do
			i32[0] = isbe and su32(e[2]) or e[2] -- store as le
			outfile:write(ffi.string(i32, 4))
		end
		print(string.format("len %2d: %6d words, %8d total weight", i, #ll, sum))
	end
end

outmeta:write('\t}\n')
outmeta:write('}\n')

outfile:close()
outmeta:close()