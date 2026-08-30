local wordsdat = assert(io.open("words.txt"))
assert(load(assert(wordsdat:read("*a")), "@words.lua"))()
wordsdat:close()

local map = {}
local h = 0

for k,v in pairs(AKYRS_WORDS) do
	for kk, vv in pairs(v) do
		if not kk then break end
		local mv = map[#kk]
		if not mv then mv = {} map[#kk] = mv end
		table.insert(mv, kk)
		if #kk > h then h = #kk end
	end
end

local outfile = assert(io.open("list.bin", "wb"))
local outoffs = assert(io.open("offsets.lua", "wb"))

outoffs:write('return {\n')

for i=1, h do
	local l = map[i]
	if l then
		outoffs:write(string.format('    [%d] = {%d, %d},\n', i, outfile:seek(), #l))
		table.sort(l)
		outfile:write(table.concat(l, ''))
	end
end

outoffs:write('\n}')

outfile:close()
outoffs:close()