local ffi = require("ffi")
local cu32 = ffi.typeof('const uint32_t*')
local cvptr = ffi.typeof('const void*')
local ccptr = ffi.typeof('const char*')

local meta = assert(SMODS.load_file("./func/bomb_prompts/meta.lua"))() --- @type AKYRS.bomb_prompt_meta
local data = SMODS.NFS.newFileData(AKYRS.path..'/func/bomb_prompts/list.bin')
local dataptr = ccptr(data:getFFIPointer())

--- @private
AKYRS.__data_bomb_prompts = data -- required to prevent gc

for len, lendata in pairs(meta.lendata) do
	local foff = lendata[1] + len * lendata[2]
	lendata.wordlen = len
	lendata.offset = lendata[1]
	lendata.count = lendata[2]
	lendata.freqs = cu32(cvptr(dataptr + foff))
end

sendDebugMessage(string.format("Bomb prompt dictionary size (bytes): %d", data:getSize()), "Aikoyori's Shenanigans")

--- @type AKYRS.bomb_prompt_meta.state[]
local states = {}
for k,v in pairs(meta.lendata) do
	states[#states+1] = { lendata = v, weight = 0, left = 0, right = 0, baseWeight = 0 }
end
table.sort(states, function (a, b) return a.lendata.wordlen < b.lendata.wordlen end)

--- @param index number 0-based
local function bsearch_freq(index, buf, search)
	local cursum = AKYRS.endianness.leu32toh(buf[index])
	local prevsum = index > 0 and AKYRS.endianness.leu32toh(buf[index-1]) or 0
	return (cursum - prevsum) - search
end

--- @param state AKYRS.bomb_prompt_meta.state
local function initstate(state, min_freq, max_freq)
	local freqs = state.lendata.freqs
	local ri = state.lendata.count-1
	state.left = AKYRS.binary_search(0, ri, bsearch_freq, 'lL', freqs, min_freq) or 0
	state.right = AKYRS.binary_search(0, ri, bsearch_freq, 'rL', freqs, max_freq) or ri
	state.baseWeight = state.left > 0 and AKYRS.endianness.leu32toh(freqs[state.left-1]) or 0
	state.weight = AKYRS.endianness.leu32toh(freqs[state.right]) - state.baseWeight
end

--- @param index number 0-based
local function bsearch_weight(index, buf, search)
	return AKYRS.endianness.leu32toh(buf[index]) - search
end

--- @param state AKYRS.bomb_prompt_meta.state
local function selectstate(state, weight)
	local ld = state.lendata
	local freqs = ld.freqs
	local index = AKYRS.binary_search(state.left, state.right, bsearch_weight, 'lL', freqs, weight + state.baseWeight)
	local freq = AKYRS.endianness.leu32toh(freqs[index]) - (index > 0 and AKYRS.endianness.leu32toh(freqs[index-1]) or 0)
	local str = ffi.string(dataptr + ld.offset + index * ld.wordlen, ld.wordlen)
	return str, freq
end

function AKYRS.get_bomb_prompt(config)
	config = config or {}
    local seed = config.seed or "bullshit"
    local max_freq = math.min(config.max_freq or 2147483647, 2147483647)
    local min_freq = math.max(config.min_freq or 1000, 1)
    local max_length = math.min(config.max_length or 5, 5)
    local min_length = math.max(config.min_length or 2, 2)

	local totalweight = 0
	for i, state in ipairs(states) do
		state.weight = 0

		if min_length <= state.lendata.wordlen and state.lendata.wordlen <= max_length then
			initstate(state, min_freq, max_freq)
			totalweight = totalweight + state.weight
		end
	end
	if totalweight == 0 then return end

	local select = pseudorandom(seed, 1, totalweight)
	for i, state in ipairs(states) do
		if select > state.weight then
			select = select - state.weight
		else
			return selectstate(state, select)
		end
	end
	sendWarnMessage("Bomb prompt dictionary not found, weighting failure?", "Aikoyori's Shenanigans")
end

--- @class AKYRS.bomb_prompt_meta
--- @field lendata AKYRS.bomb_prompt_meta.lendata[]

--- @class AKYRS.bomb_prompt_meta.lendata
--- @field wordlen number
--- byte offset
--- @field offset number
--- word count
--- @field count number
--- u32 pointer to list of sorted frequency. Length is 4 * count
--- @field freqs ffi.cdata*

--- @class AKYRS.bomb_prompt_meta.state
--- @field lendata AKYRS.bomb_prompt_meta.lendata
--- @field left number
--- @field right number
--- @field weight number
--- @field baseWeight number