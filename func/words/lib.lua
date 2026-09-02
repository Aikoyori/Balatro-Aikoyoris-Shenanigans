local ffi = require("ffi")
local gcinit = collectgarbage("count")
local meta = assert(SMODS.load_file("./func/words/meta.lua"))() --- @type AKYRS.words_meta
local data = SMODS.NFS.newFileData(AKYRS.path..'/func/words/list.bin')
local dataptr = ffi.cast("const uint8_t*", data:getFFIPointer())
local wildchar = string.byte'#'

local mapsize = 0
local mapeff = 0
for len, lendata in pairs(meta.lendata) do
	mapsize = mapsize + len * 2 * 256
	local nextbuf = ffi.new('uint8_t[?]', 256*len, 0)
	local charbuf = ffi.new('uint8_t[?]', 256*len, 0)
	for i,chars in ipairs(lendata[3]) do
		mapeff = mapeff + #chars
		local prevbyte, byte = 0, 0
		for j=1, #chars do
			byte = chars:byte(j, j)
			nextbuf[(i-1)*256+prevbyte] = byte
			nextbuf[(i-1)*256+byte] = 1
			prevbyte = byte
		end
	end
	lendata.offset = lendata[1]
	lendata.count = lendata[2]
	lendata.wildNextMap = nextbuf
	lendata.charMap = charbuf
end

sendDebugMessage(string.format("Word dictionary size (bytes): %d + %d mapping (%d effective) + %dK gc", data:getSize(), mapsize, mapeff, collectgarbage("count") - gcinit), "Aikoyori's Shenanigans")

--- @type AKYRS.words_meta.state
local state = {
	mem = {},
	len = 0,
	lendata = {}, --- @type any
	checklen = 0,
	wildpos = {},
	wildrange = {},
	wildcount = 0,
}

--- @private
AKYRS.__data_words = data -- required to prevent gc

--- binary search function
--- @param index number 0-based
local function bsearch_entry(index, checklen)
	local offset = state.lendata.offset + index * state.len
	for i=1, checklen do
		local b = state.mem[i]
		b = dataptr[offset+i-1] - b
		if b ~= 0 then
			return b
		end
	end
	return 0
end

--- Search word using binary search, non-wild
local function bsearch()
	return AKYRS.binary_search(0, state.lendata.count-1, bsearch_entry, nil, state.checklen)
end

--- increment next possible characters for wild search
local function bsearch_nextchar(ix)
	local pos = state.wildpos[ix]
	local nextpos = (state.wildpos[ix-1] or state.checklen+1)-1
	local range = state.wildrange[ix]
	local prevrange = state.wildrange[ix+1]

	while true do
		state.mem[pos] = state.lendata.wildNextMap[(pos-1)*256+state.mem[pos]]
		if state.mem[pos] == 0 then
			state.mem[pos] = state.lendata.wildNextMap[(pos-1)*256]
			if ix == state.wildcount or not bsearch_nextchar(ix+1) then
				return false
			end
		end

		range[1] = AKYRS.binary_search(prevrange[1], prevrange[2], bsearch_entry, 'l', nextpos)
		range[2] = AKYRS.binary_search(prevrange[1], prevrange[2], bsearch_entry, 'r', nextpos)
		if range[1] and range[2] then
			return true
		end
	end
end

--- @param word string
local function initstate(word)
	if not meta.lendata[#word] then return end
	local isconswild = true -- consecutive wild from right dont count as wild, but reduce the check size
	state.len = #word
	state.lendata = meta.lendata[#word]
	state.checklen = #word
	state.wildcount = 0

	for i=#word, 1, -1 do
		local c = word:byte(i,i)
		if c == wildchar then
			c = 0
			if isconswild then
				state.checklen = state.checklen - 1
			else
				state.wildcount = state.wildcount + 1
				state.wildpos[state.wildcount] = i
			end
		else
			isconswild = false
			if state.lendata.wildNextMap[(i-1)*256+c] == 0 then return false end
		end
		state.mem[i] = c
	end

	if state.wildcount > 0 then
		local range = state.wildrange[state.wildcount+1]
		if not range then range = {} state.wildrange[state.wildcount+1] = range end

		range[1] = 0
		range[2] = state.lendata.count-1

		local firstpos = state.wildpos[state.wildcount]-1
		if firstpos > 0 then
			range[1] = AKYRS.binary_search(range[1], range[2], bsearch_entry, 'l', firstpos)
			if not range[1] then return false end
			range[2] = AKYRS.binary_search(range[1], range[2], bsearch_entry, 'r', firstpos)
			if not range[2] then return false end
		end

		for i=state.wildcount, 1, -1 do
			if not state.wildrange[i] then state.wildrange[i] = {} end
			if not bsearch_nextchar(i) then return false end
		end
	end

	return true
end

--- @param word string | string[]
--- @return table
function AKYRS.check_word(word)
	if type(word) == "table" then word = table.concat(word) end
	local len = #word
	if (not initstate(word)) then return { valid = false } end

	local i
	if state.wildcount > 0 then
		while true do
			i = bsearch()
			if i or not bsearch_nextchar(1) then break end
		end
	else
		i = bsearch()
	end
	if not i then return { valid = false } end

	local offset = state.lendata.offset + i * len
	return {
		valid = true,
		word = ffi.string(dataptr+offset, len)
	}
end

--- @class AKYRS.words_meta
--- @field charset string
--- @field maxlen number
--- @field lendata AKYRS.words_meta.lendata[]

--- @class AKYRS.words_meta.lendata
--- byte offset
--- @field offset number
--- word count
--- @field count number
--- next wildcard character mapping, byte -> byte, length is 256 * string length.
--- value may be 0 if there's no next wildcard character.
--- first byte in segment always points to first character
--- @field wildNextMap ffi.cdata*
--- valid character mapping, length is 256 * string length.
--- 1 if character exists in the nth index, 0 if not
--- @field charMap ffi.cdata*

--- @class AKYRS.words_meta.state
--- List of character bytes.
--- Extra values may contain junk
--- @field mem number[]
--- String length
--- @field len number
---
--- Related check data
--- @field lendata AKYRS.words_meta.lendata
--- Number of bytes to check
--- @field checklen number
---
--- Wild positions, 1-indexed, rghtmost to leftmost
--- @field wildpos number[]
--- Wild ranges for narrowing binary search, rightmost to leftmost
--- @field wildrange [number, number][]
--- Number of wild characters
--- @field wildcount number