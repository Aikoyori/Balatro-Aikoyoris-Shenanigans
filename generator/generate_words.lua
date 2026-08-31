local wordsdat = assert(io.open("words.txt"))
assert(load(assert(wordsdat:read("*a")), "@words.lua"))()
wordsdat:close()

--- @type table<number, { [number]: string, freqs: { [string]: number, [number]: string }[] }>
local map = {}
local charmap = {}
local h = 0

for k,v in pairs(AKYRS_WORDS) do
	for kk, vv in pairs(v) do
		local lenmap = map[#kk]
		if not lenmap then
			lenmap = { freqs = {} }
			for i=1, #kk do lenmap.freqs[i] = {} end
			map[#kk] = lenmap
		end
		table.insert(lenmap, kk)

		if #kk > h then h = #kk end
		for i=1, #kk do
			local c = kk:sub(i,i)

			local charfreq = lenmap.freqs[i]
			if not charfreq[c] then table.insert(charfreq, c) end
			charfreq[c] = (charfreq[c] or 0) + 1

			if not charmap[c] then table.insert(charmap, c) end
			charmap[c] = true
		end
	end
end

table.sort(charmap)

local outfile = assert(io.open("../func/words/list.bin", "wb"))
local outmeta = assert(io.open("../func/words/meta.lua", "wb"))

outmeta:write('return {\n')
outmeta:write('\tlendata = {\n')

for i=1, h do
	local lenmap = map[i]
	if lenmap then
		local charfreq = {}
		for j,v in ipairs(lenmap.freqs) do
			table.sort(v, function (a, b) return v[a] > v[b] end)
			charfreq[j] = '[['..table.concat(v)..']]'
		end

		outmeta:write(string.format('\t\t[%d] = {%d, %d, {%s}},\n', i, outfile:seek(), #lenmap, table.concat(charfreq, ', ')))
		table.sort(lenmap)
		outfile:write(table.concat(lenmap, ''))
	end
end

outmeta:write('\t},\n')
outmeta:write(string.format('\tmaxlen = %s,\n', h))
outmeta:write(string.format('\tcharset = [[%s]],\n', table.concat(charmap)))
outmeta:write('}\n')

outfile:close()
outmeta:close()