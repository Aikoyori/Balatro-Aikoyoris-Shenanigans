local ffi = require("ffi")
local gcinit = collectgarbage("count")
local meta = assert(SMODS.load_file("./func/words/meta.lua"))() --- @type { lendata: any[], maxlen: number, charset: string }
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
	lendata[3] = nextbuf
	lendata[4] = charbuf
end

sendDebugMessage(string.format("Word dictionary size (bytes): %d + %d mapping (%d effective) + %dK gc", data:getSize(), mapsize, mapeff, collectgarbage("count") - gcinit), "Aikoyori's Shenanigans")

local state = {
	mem = {},
	len = 0,
	lendata = {},

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
	local offset = state.lendata[1] + index * state.len
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
	return AKYRS.binary_search(0, state.lendata[2]-1, bsearch_entry, nil, state.checklen)
end

--- increment next possible characters for wild search
local function bsearch_nextchar(ix)
	local pos = state.wildpos[ix]
	local nextpos = (state.wildpos[ix-1] or state.checklen+1)-1
	local range = state.wildrange[ix]
	local prevrange = state.wildrange[ix+1]

	while true do
		state.mem[pos] = state.lendata[3][(pos-1)*256+state.mem[pos]]
		if state.mem[pos] == 0 then
			state.mem[pos] = state.lendata[3][(pos-1)*256]
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
			if state.lendata[3][(i-1)*256+c] == 0 then return false end
		end
		state.mem[i] = c
	end

	if state.wildcount > 0 then
		local range = state.wildrange[state.wildcount+1]
		if not range then range = {} state.wildrange[state.wildcount+1] = range end

		range[1] = 0
		range[2] = state.lendata[2]-1

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

--- @param word string
--- @return string? matching
function AKYRS.check_word(word)
	local len = #word
	if (!initstate(word)) then return end

	local i
	if state.wildcount > 0 then
		while true do
			i = bsearch()
			if i or not bsearch_nextchar(1) then break end
		end
	else
		i = bsearch()
	end
	if not i then return end

	local offset = state.lendata[1] + i * len
	return ffi.string(dataptr+offset, len)
end