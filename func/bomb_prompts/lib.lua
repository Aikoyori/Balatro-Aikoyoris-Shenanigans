local ffi = require("ffi")
local cu32 = ffi.typeof('const uint32_t*')
local cvptr = ffi.typeof('const void*')
local ccptr = ffi.typeof('const char*')

local meta = assert(SMODS.load_file("./func/bomb_prompts/meta.lua"))() --- @type { lendata: any[] }
local data = SMODS.NFS.newFileData(AKYRS.path..'/func/bomb_prompts/list.bin')
local dataptr = ccptr(data:getFFIPointer())

--- @private
AKYRS.__data_bomb_prompts = data -- required to prevent gc

for len, lendata in pairs(meta.lendata) do
	lendata[3] = cu32(cvptr(dataptr + (lendata[1] + len * lendata[2])))
	if lendata[1] + len * (lendata[2] + 4) > data:getSize() then error("buffer overflow") end
end

sendDebugMessage(string.format("Bomb prompt dictionary size (bytes): %d", data:getSize()), "Aikoyori's Shenanigans")

--- temporary data entry for each length
--- - [1]: length
--- - [2]: 0-based start index for word
--- - [3]: 0-based end index for word
--- - [4]: weight
--- - [5]: base
local slots = {}
for k,v in pairs(meta.lendata) do table.insert(slots, { k, 0, 0, 0 }) end

--- @param index number 0-based
local function bsearch_freq(index, buf, search)
	local cursum = AKYRS.endianness.leu32toh(buf[index])
	local prevsum = index > 0 and AKYRS.endianness.leu32toh(buf[index-1]) or 0
	return (cursum - prevsum) - search
end

--- @param index number 0-based
local function bsearch_weight(index, buf, search)
	return AKYRS.endianness.leu32toh(buf[index]) - search
end

local function sortslot(a, b) return a[1] < b[1] end

function AKYRS.get_bomb_prompt(config)
	config = config or {}
    local seed = config.seed or "bullshit"
    local max_freq = math.min(config.max_freq or 2147483647, 2147483647)
    local min_freq = math.max(config.min_freq or 1000, 1)
    local max_length = math.min(config.max_length or 5, 5)
    local min_length = math.max(config.min_length or 2, 2)

	local slotindex = 1
	local totalweight = 0
	for len, lendata in pairs(meta.lendata) do
		if min_length <= len and len <= max_length then
			local buf = lendata[3]
			-- lua AKYRS.get_bomb_prompt()
			local left = AKYRS.binary_search(0, lendata[2]-1, bsearch_freq, 'lL', lendata[3], min_freq)
			local right = AKYRS.binary_search(0, lendata[2]-1, bsearch_freq, 'rL', lendata[3], max_freq)
			local base = left > 0 and AKYRS.endianness.leu32toh(buf[left-1]) or 0
			local weight = AKYRS.endianness.leu32toh(buf[right]) - base

			local slot = slots[slotindex]
			slotindex = slotindex + 1
			slot[1], slot[2], slot[3], slot[4], slot[5] = len, left, right, weight, base
			totalweight = totalweight + weight
		end
	end
	table.sort(slots, sortslot)
	if totalweight == 0 then return end

	local select = pseudorandom(seed, 1, totalweight)
	for i, slot in ipairs(slots) do
		if select > slot[4] then
			select = select - slot[4]
		else
			local lendata = meta.lendata[slot[1]]
			local buf = lendata[3]
			local index = AKYRS.binary_search(slot[2], slot[3], bsearch_weight, 'lL', lendata[3], select + slot[5])
			local freq = AKYRS.endianness.leu32toh(buf[index]) - (index > 0 and AKYRS.endianness.leu32toh(buf[index-1]) or 0)
			local str = ffi.string(dataptr + lendata[1] + index * slot[1], slot[1])

			return str, freq
		end
	end
	sendWarnMessage("Bomb prompt dictionary not found, weighting failure?", "Aikoyori's Shenanigans")
end