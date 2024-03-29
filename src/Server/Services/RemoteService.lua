--[[
	code generated using luamin.js, Herrtt#3868
--]]



local Base64
local HttpService = game:GetService("HttpService")
local function _W(f)
	local e = setmetatable({}, {
		__index = getfenv()
	})
	return setfenv(f, e)() or e
end
local bit = _W(function()
	local floor = math.floor
	local bit_band, bit_bxor = bit32.band, bit32.bxor
	local function band(a, b)
		if a > 2147483647 then
			a = a - 4294967296
		end
		if b > 2147483647 then
			b = b - 4294967296
		end
		return bit_band(a, b)
	end
	local function bxor(a, b)
		if a > 2147483647 then
			a = a - 4294967296
		end
		if b > 2147483647 then
			b = b - 4294967296
		end
		return bit_bxor(a, b)
	end
	local lshift, rshift
	rshift = function(a, disp)
		return floor(a % 4294967296 / 2 ^ disp)
	end
	lshift = function(a, disp)
		return (a * 2 ^ disp) % 4294967296
	end
	return {
	-- bit operations
		bnot = bit32.bnot,
		band = band,
		bor  = bit32.bor,
		bxor = bxor,
		rshift = rshift,
		lshift = lshift,
	}
end)
local gf = _W(function()
-- finite field with base 2 and modulo irreducible polynom x^8+x^4+x^3+x+1 = 0x11d
	local bxor = bit32.bxor
	local lshift = bit32.lshift

-- private data of gf
	local n = 0x100
	local ord = 0xff
	local irrPolynom = 0x11b
	local exp = {}
	local log = {}

--
-- add two polynoms (its simply xor)
--
	local function add(operand1, operand2)
		return bxor(operand1, operand2)
	end

--
-- subtract two polynoms (same as addition)
--
	local function sub(operand1, operand2)
		return bxor(operand1, operand2)
	end

--
-- inverts element
-- a^(-1) = g^(order - log(a))
--
	local function invert(operand)
	-- special case for 1
		if (operand == 1) then
			return 1
		end
	-- normal invert
		local exponent = ord - log[operand]
		return exp[exponent]
	end

--
-- multiply two elements using a logarithm table
-- a*b = g^(log(a)+log(b))
--
	local function mul(operand1, operand2)
		if (operand1 == 0 or operand2 == 0) then
			return 0
		end
		local exponent = log[operand1] + log[operand2]
		if (exponent >= ord) then
			exponent = exponent - ord
		end
		return  exp[exponent]
	end

--
-- divide two elements
-- a/b = g^(log(a)-log(b))
--
	local function div(operand1, operand2)
		if (operand1 == 0)  then
			return 0
		end
	-- TODO: exception if operand2 == 0
		local exponent = log[operand1] - log[operand2]
		if (exponent < 0) then
			exponent = exponent + ord
		end
		return exp[exponent]
	end

--
-- print logarithmic table
--
	local function printLog()
		for i = 1, n do
			print("log(", i - 1, ")=", log[i - 1])
		end
	end

--
-- print exponentiation table
--
	local function printExp()
		for i = 1, n do
			print("exp(", i - 1, ")=", exp[i - 1])
		end
	end

--
-- calculate logarithmic and exponentiation table
--
	local function initMulTable()
		local a = 1
		for i = 0, ord - 1 do
			exp[i] = a
			log[a] = i

		-- multiply with generator x+1 -> left shift + 1
			a = bxor(lshift(a, 1), a)

		-- if a gets larger than order, reduce modulo irreducible polynom
			if a > ord then
				a = sub(a, irrPolynom)
			end
		end
	end
	initMulTable()
	return {
		add = add,
		sub = sub,
		invert = invert,
		mul = mul,
		div = dib,
		printLog = printLog,
		printExp = printExp,
	}
end)
local util = _W(function()
-- Cache some bit operators
	local bxor = bit32.bxor
	local rshift = bit32.rshift
	local band = bit32.band
	local lshift = bit32.lshift
	local sleepCheckIn
--
-- calculate the parity of one byte
--
	local function byteParity(byte)
		byte = bxor(byte, rshift(byte, 4))
		byte = bxor(byte, rshift(byte, 2))
		byte = bxor(byte, rshift(byte, 1))
		return band(byte, 1)
	end

--
-- get byte at position index
--
	local function getByte(number, index)
		if (index == 0) then
			return band(number, 0xff)
		else
			return band(rshift(number, index * 8), 0xff)
		end
	end


--
-- put number into int at position index
--
	local function putByte(number, index)
		if (index == 0) then
			return band(number, 0xff)
		else
			return lshift(band(number, 0xff), index * 8)
		end
	end

--
-- convert byte array to int array
--
	local function bytesToInts(bytes, start, n)
		local ints = {}
		for i = 0, n - 1 do
			ints[i] = putByte(bytes[start + (i * 4)    ], 3)
				+ putByte(bytes[start + (i * 4) + 1], 2)
				+ putByte(bytes[start + (i * 4) + 2], 1)
				+ putByte(bytes[start + (i * 4) + 3], 0)
			if n % 10000 == 0 then
				sleepCheckIn()
			end
		end
		return ints
	end

--
-- convert int array to byte array
--
	local function intsToBytes(ints, output, outputOffset, n)
		n = n or #ints
		for i = 0, n do
			for j = 0, 3 do
				output[outputOffset + i * 4 + (3 - j)] = getByte(ints[i], j)
			end
			if n % 10000 == 0 then
				sleepCheckIn()
			end
		end
		return output
	end

--
-- convert bytes to hexString
--
	local function bytesToHex(bytes)
		local hexBytes = ""
		for _, byte in ipairs(bytes) do
			hexBytes = hexBytes .. string.format("%02x ", byte)
		end
		return hexBytes
	end

--
-- convert data to hex string
--
	local function toHexString(data)
		local type = type(data)
		if (type == "number") then
			return string.format("%08x", data)
		elseif (type == "table") then
			return bytesToHex(data)
		elseif (type == "string") then
			local bytes = {
				string.byte(data, 1, #data)
			}
			return bytesToHex(bytes)
		else
			return data
		end
	end
	local function padByteString(data)
		local dataLength = #data
		local random1 = math.random(0, 255)
		local random2 = math.random(0, 255)
		local prefix = string.char(random1,
							   random2,
							   random1,
							   random2,
							   getByte(dataLength, 3),
							   getByte(dataLength, 2),
							   getByte(dataLength, 1),
							   getByte(dataLength, 0))
		data = prefix .. data
		local paddingLength = math.ceil(#data / 16) * 16 - #data
		local padding = ""
		for _ = 1, paddingLength do
			padding = padding .. string.char(math.random(0, 255))
		end
		return data .. padding
	end
	local function properlyDecrypted(data)
		local random = {
			string.byte(data, 1, 4)
		}
		if (random[1] == random[3] and random[2] == random[4]) then
			return true
		end
		return false
	end
	local function unpadByteString(data)
		if (not properlyDecrypted(data)) then
			return nil
		end
		local dataLength = putByte(string.byte(data, 5), 3)
					 + putByte(string.byte(data, 6), 2)
					 + putByte(string.byte(data, 7), 1)
					 + putByte(string.byte(data, 8), 0)
		return string.sub(data, 9, 8 + dataLength)
	end
	local function xorIV(data, iv)
		for i = 1, 16 do
			data[i] = bxor(data[i], iv[i])
		end
	end

-- Called every
	local push, pull, time = os.queueEvent, coroutine.yield, os.time
	local oldTime = time()
	local function sleepCheckIn()
		local newTime = time()
		if newTime - oldTime >= 0.03 then -- (0.020 * 1.5)
			oldTime = newTime
        --push("sleep")
        --pull("sleep")
		end
	end
	local function getRandomData(bytes)
		local char, random, sleep, insert = string.char, math.random, sleepCheckIn, table.insert
		local result = {}
		for i = 1, bytes do
			insert(result, random(0, 255))
			if i % 10240 == 0 then
				sleep()
			end
		end
		return result
	end
	local function getRandomString(bytes)
		local char, random, sleep, insert = string.char, math.random, sleepCheckIn, table.insert
		local result = {}
		for i = 1, bytes do
			insert(result, char(random(0, 255)))
			if i % 10240 == 0 then
				sleep()
			end
		end
		return table.concat(result)
	end
	return {
		byteParity = byteParity,
		getByte = getByte,
		putByte = putByte,
		bytesToInts = bytesToInts,
		intsToBytes = intsToBytes,
		bytesToHex = bytesToHex,
		toHexString = toHexString,
		padByteString = padByteString,
		properlyDecrypted = properlyDecrypted,
		unpadByteString = unpadByteString,
		xorIV = xorIV,
		sleepCheckIn = sleepCheckIn,
		getRandomData = getRandomData,
		getRandomString = getRandomString,
	}
end)
local aes = _W(function()
-- Implementation of AES with nearly pure lua
-- AES with lua is slow, really slow :-)
	local putByte = util.putByte
	local getByte = util.getByte

-- some constants
	local ROUNDS = 'rounds'
	local KEY_TYPE = "type"
	local ENCRYPTION_KEY = 1
	local DECRYPTION_KEY = 2

-- aes SBOX
	local SBox = {}
	local iSBox = {}

-- aes tables
	local table0 = {}
	local table1 = {}
	local table2 = {}
	local table3 = {}
	local tableInv0 = {}
	local tableInv1 = {}
	local tableInv2 = {}
	local tableInv3 = {}

-- round constants
	local rCon = {0x01000000,0x02000000,0x04000000,0x08000000,0x10000000,0x20000000,0x40000000,0x80000000,0x1b000000,0x36000000,0x6c000000,0xd8000000,0xab000000,0x4d000000,0x9a000000,0x2f000000,}

--
-- affine transformation for calculating the S-Box of AES
--
	local function affinMap(byte)
		local mask = 0xf8
		local result = 0
		for _ = 1, 8 do
			result = bit32.lshift(result, 1)
			local parity = util.byteParity(bit32.band(byte, mask))
			result = result + parity

		-- simulate roll
			local lastbit = bit32.band(mask, 1)
			mask = bit32.band(bit32.rshift(mask, 1), 0xff)
			if (lastbit ~= 0) then
				mask = bit32.bor(mask, 0x80)
			else
				mask = bit32.band(mask, 0x7f)
			end
		end
		return bit32.bxor(result, 0x63)
	end

--
-- calculate S-Box and inverse S-Box of AES
-- apply affine transformation to inverse in finite field 2^8
--
	local function calcSBox()
		for i = 0, 255 do
			if (i ~= 0) then
				inverse = gf.invert(i)
			else
				inverse = i
			end
			local mapped = affinMap(inverse)
			SBox[i] = mapped
			iSBox[mapped] = i
		end
	end

--
-- Calculate round tables
-- round tables are used to calculate shiftRow, MixColumn and SubBytes
-- with 4 table lookups and 4 xor operations.
--
	local function calcRoundTables()
		for x = 0, 255 do
			local byte = SBox[x]
			table0[x] = putByte(gf.mul(0x03, byte), 0)
						  + putByte(             byte , 1)
						  + putByte(             byte , 2)
						  + putByte(gf.mul(0x02, byte), 3)
			table1[x] = putByte(             byte , 0)
						  + putByte(             byte , 1)
						  + putByte(gf.mul(0x02, byte), 2)
						  + putByte(gf.mul(0x03, byte), 3)
			table2[x] = putByte(             byte , 0)
						  + putByte(gf.mul(0x02, byte), 1)
						  + putByte(gf.mul(0x03, byte), 2)
						  + putByte(             byte , 3)
			table3[x] = putByte(gf.mul(0x02, byte), 0)
						  + putByte(gf.mul(0x03, byte), 1)
						  + putByte(             byte , 2)
						  + putByte(             byte , 3)
		end
	end

--
-- Calculate inverse round tables
-- does the inverse of the normal roundtables for the equivalent
-- decryption algorithm.
--
	local function calcInvRoundTables()
		for x = 0, 255 do
			local byte = iSBox[x]
			tableInv0[x] = putByte(gf.mul(0x0b, byte), 0)
							 + putByte(gf.mul(0x0d, byte), 1)
							 + putByte(gf.mul(0x09, byte), 2)
							 + putByte(gf.mul(0x0e, byte), 3)
			tableInv1[x] = putByte(gf.mul(0x0d, byte), 0)
							 + putByte(gf.mul(0x09, byte), 1)
							 + putByte(gf.mul(0x0e, byte), 2)
							 + putByte(gf.mul(0x0b, byte), 3)
			tableInv2[x] = putByte(gf.mul(0x09, byte), 0)
							 + putByte(gf.mul(0x0e, byte), 1)
							 + putByte(gf.mul(0x0b, byte), 2)
							 + putByte(gf.mul(0x0d, byte), 3)
			tableInv3[x] = putByte(gf.mul(0x0e, byte), 0)
							 + putByte(gf.mul(0x0b, byte), 1)
							 + putByte(gf.mul(0x0d, byte), 2)
							 + putByte(gf.mul(0x09, byte), 3)
		end
	end


--
-- rotate word: 0xaabbccdd gets 0xbbccddaa
-- used for key schedule
--
	local function rotWord(word)
		local tmp = bit32.band(word, 0xff000000)
		return (bit32.lshift(word, 8) + bit32.rshift(tmp, 24))
	end

--
-- replace all bytes in a word with the SBox.
-- used for key schedule
--
	local function subWord(word)
		return putByte(SBox[getByte(word, 0)], 0)
		+ putByte(SBox[getByte(word, 1)], 1)
		+ putByte(SBox[getByte(word, 2)], 2)
		+ putByte(SBox[getByte(word, 3)], 3)
	end

--
-- generate key schedule for aes encryption
--
-- returns table with all round keys and
-- the necessary number of rounds saved in [ROUNDS]
--
	local function expandEncryptionKey(key)
		local keySchedule = {}
		local keyWords = math.floor(#key / 4)
		if ((keyWords ~= 4 and keyWords ~= 6 and keyWords ~= 8) or (keyWords * 4 ~= #key)) then
			print("Invalid key size: ", keyWords)
			return nil
		end
		keySchedule[ROUNDS] = keyWords + 6
		keySchedule[KEY_TYPE] = ENCRYPTION_KEY
		for i = 0, keyWords - 1 do
			keySchedule[i] = putByte(key[i * 4 + 1], 3)
					   + putByte(key[i * 4 + 2], 2)
					   + putByte(key[i * 4 + 3], 1)
					   + putByte(key[i * 4 + 4], 0)
		end
		for i = keyWords, (keySchedule[ROUNDS] + 1) * 4 - 1 do
			local tmp = keySchedule[i - 1]
			if ( i % keyWords == 0) then
				tmp = rotWord(tmp)
				tmp = subWord(tmp)
				local index = math.floor(i / keyWords)
				tmp = bit32.bxor(tmp, rCon[index])
			elseif (keyWords > 6 and i % keyWords == 4) then
				tmp = subWord(tmp)
			end
			keySchedule[i] = bit32.bxor(keySchedule[(i - keyWords)], tmp)
		end
		return keySchedule
	end

--
-- Inverse mix column
-- used for key schedule of decryption key
--
	local function invMixColumnOld(word)
		local b0 = getByte(word, 3)
		local b1 = getByte(word, 2)
		local b2 = getByte(word, 1)
		local b3 = getByte(word, 0)
		return putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b1),
											 gf.mul(0x0d, b2)),
											 gf.mul(0x09, b3)),
											 gf.mul(0x0e, b0)), 3)
		 + putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b2),
											 gf.mul(0x0d, b3)),
											 gf.mul(0x09, b0)),
											 gf.mul(0x0e, b1)), 2)
		 + putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b3),
											 gf.mul(0x0d, b0)),
											 gf.mul(0x09, b1)),
											 gf.mul(0x0e, b2)), 1)
		 + putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b0),
											 gf.mul(0x0d, b1)),
											 gf.mul(0x09, b2)),
											 gf.mul(0x0e, b3)), 0)
	end

--
-- Optimized inverse mix column
-- look at http://fp.gladman.plus.com/cryptography_technology/rijndael/aes.spec.311.pdf
-- TODO: make it work
--
	local function invMixColumn(word)
		local b0 = getByte(word, 3)
		local b1 = getByte(word, 2)
		local b2 = getByte(word, 1)
		local b3 = getByte(word, 0)
		local t = bit32.bxor(b3, b2)
		local u = bit32.bxor(b1, b0)
		local v = bit32.bxor(t, u)
		v = bit32.bxor(v, gf.mul(0x08, v))
		local w = bit32.bxor(v, gf.mul(0x04, bit32.bxor(b2, b0)))
		v = bit32.bxor(v, gf.mul(0x04, bit32.bxor(b3, b1)))
		return putByte( bit32.bxor(bit32.bxor(b3, v), gf.mul(0x02, bit32.bxor(b0, b3))), 0)
		 + putByte( bit32.bxor(bit32.bxor(b2, w), gf.mul(0x02, t              )), 1)
		 + putByte( bit32.bxor(bit32.bxor(b1, v), gf.mul(0x02, bit32.bxor(b0, b3))), 2)
		 + putByte( bit32.bxor(bit32.bxor(b0, w), gf.mul(0x02, u              )), 3)
	end

--
-- generate key schedule for aes decryption
--
-- uses key schedule for aes encryption and transforms each
-- key by inverse mix column.
--
	local function expandDecryptionKey(key)
		local keySchedule = expandEncryptionKey(key)
		if (keySchedule == nil) then
			return nil
		end
		keySchedule[KEY_TYPE] = DECRYPTION_KEY
		for i = 4, (keySchedule[ROUNDS] + 1) * 4 - 5 do
			keySchedule[i] = invMixColumnOld(keySchedule[i])
		end
		return keySchedule
	end

--
-- xor round key to state
--
	local function addRoundKey(state, key, round)
		for i = 0, 3 do
			state[i] = bit32.bxor(state[i], key[round * 4 + i])
		end
	end

--
-- do encryption round (ShiftRow, SubBytes, MixColumn together)
--
	local function doRound(origState, dstState)
		dstState[0] =  bit32.bxor(bit32.bxor(bit32.bxor(
				table0[getByte(origState[0], 3)],
				table1[getByte(origState[1], 2)]),
				table2[getByte(origState[2], 1)]),
				table3[getByte(origState[3], 0)])
		dstState[1] =  bit32.bxor(bit32.bxor(bit32.bxor(
				table0[getByte(origState[1], 3)],
				table1[getByte(origState[2], 2)]),
				table2[getByte(origState[3], 1)]),
				table3[getByte(origState[0], 0)])
		dstState[2] =  bit32.bxor(bit32.bxor(bit32.bxor(
				table0[getByte(origState[2], 3)],
				table1[getByte(origState[3], 2)]),
				table2[getByte(origState[0], 1)]),
				table3[getByte(origState[1], 0)])
		dstState[3] =  bit32.bxor(bit32.bxor(bit32.bxor(
				table0[getByte(origState[3], 3)],
				table1[getByte(origState[0], 2)]),
				table2[getByte(origState[1], 1)]),
				table3[getByte(origState[2], 0)])
	end

--
-- do last encryption round (ShiftRow and SubBytes)
--
	local function doLastRound(origState, dstState)
		dstState[0] = putByte(SBox[getByte(origState[0], 3)], 3)
				+ putByte(SBox[getByte(origState[1], 2)], 2)
				+ putByte(SBox[getByte(origState[2], 1)], 1)
				+ putByte(SBox[getByte(origState[3], 0)], 0)
		dstState[1] = putByte(SBox[getByte(origState[1], 3)], 3)
				+ putByte(SBox[getByte(origState[2], 2)], 2)
				+ putByte(SBox[getByte(origState[3], 1)], 1)
				+ putByte(SBox[getByte(origState[0], 0)], 0)
		dstState[2] = putByte(SBox[getByte(origState[2], 3)], 3)
				+ putByte(SBox[getByte(origState[3], 2)], 2)
				+ putByte(SBox[getByte(origState[0], 1)], 1)
				+ putByte(SBox[getByte(origState[1], 0)], 0)
		dstState[3] = putByte(SBox[getByte(origState[3], 3)], 3)
				+ putByte(SBox[getByte(origState[0], 2)], 2)
				+ putByte(SBox[getByte(origState[1], 1)], 1)
				+ putByte(SBox[getByte(origState[2], 0)], 0)
	end

--
-- do decryption round
--
	local function doInvRound(origState, dstState)
		dstState[0] =  bit32.bxor(bit32.bxor(bit32.bxor(
				tableInv0[getByte(origState[0], 3)],
				tableInv1[getByte(origState[3], 2)]),
				tableInv2[getByte(origState[2], 1)]),
				tableInv3[getByte(origState[1], 0)])
		dstState[1] =  bit32.bxor(bit32.bxor(bit32.bxor(
				tableInv0[getByte(origState[1], 3)],
				tableInv1[getByte(origState[0], 2)]),
				tableInv2[getByte(origState[3], 1)]),
				tableInv3[getByte(origState[2], 0)])
		dstState[2] =  bit32.bxor(bit32.bxor(bit32.bxor(
				tableInv0[getByte(origState[2], 3)],
				tableInv1[getByte(origState[1], 2)]),
				tableInv2[getByte(origState[0], 1)]),
				tableInv3[getByte(origState[3], 0)])
		dstState[3] =  bit32.bxor(bit32.bxor(bit32.bxor(
				tableInv0[getByte(origState[3], 3)],
				tableInv1[getByte(origState[2], 2)]),
				tableInv2[getByte(origState[1], 1)]),
				tableInv3[getByte(origState[0], 0)])
	end

--
-- do last decryption round
--
	local function doInvLastRound(origState, dstState)
		dstState[0] = putByte(iSBox[getByte(origState[0], 3)], 3)
				+ putByte(iSBox[getByte(origState[3], 2)], 2)
				+ putByte(iSBox[getByte(origState[2], 1)], 1)
				+ putByte(iSBox[getByte(origState[1], 0)], 0)
		dstState[1] = putByte(iSBox[getByte(origState[1], 3)], 3)
				+ putByte(iSBox[getByte(origState[0], 2)], 2)
				+ putByte(iSBox[getByte(origState[3], 1)], 1)
				+ putByte(iSBox[getByte(origState[2], 0)], 0)
		dstState[2] = putByte(iSBox[getByte(origState[2], 3)], 3)
				+ putByte(iSBox[getByte(origState[1], 2)], 2)
				+ putByte(iSBox[getByte(origState[0], 1)], 1)
				+ putByte(iSBox[getByte(origState[3], 0)], 0)
		dstState[3] = putByte(iSBox[getByte(origState[3], 3)], 3)
				+ putByte(iSBox[getByte(origState[2], 2)], 2)
				+ putByte(iSBox[getByte(origState[1], 1)], 1)
				+ putByte(iSBox[getByte(origState[0], 0)], 0)
	end

--
-- encrypts 16 Bytes
-- key           encryption key schedule
-- input         array with input data
-- inputOffset   start index for input
-- output        array for encrypted data
-- outputOffset  start index for output
--
	local function encrypt(key, input, inputOffset, output, outputOffset)
	--default parameters
		inputOffset = inputOffset or 1
		output = output or {}
		outputOffset = outputOffset or 1
		local state = {}
		local tmpState = {}
		if (key[KEY_TYPE] ~= ENCRYPTION_KEY) then
			print("No encryption key: ", key[KEY_TYPE])
			return
		end
		state = util.bytesToInts(input, inputOffset, 4)
		addRoundKey(state, key, 0)
		local checkIn = util.sleepCheckIn
		local round = 1
		while (round < key[ROUNDS] - 1) do
		-- do a double round to save temporary assignments
			doRound(state, tmpState)
			addRoundKey(tmpState, key, round)
			round = round + 1
			doRound(tmpState, state)
			addRoundKey(state, key, round)
			round = round + 1
		end
		checkIn()
		doRound(state, tmpState)
		addRoundKey(tmpState, key, round)
		round = round + 1
		doLastRound(tmpState, state)
		addRoundKey(state, key, round)
		return util.intsToBytes(state, output, outputOffset)
	end

--
-- decrypt 16 bytes
-- key           decryption key schedule
-- input         array with input data
-- inputOffset   start index for input
-- output        array for decrypted data
-- outputOffset  start index for output
---
	local function decrypt(key, input, inputOffset, output, outputOffset)
	-- default arguments
		inputOffset = inputOffset or 1
		output = output or {}
		outputOffset = outputOffset or 1
		local state = {}
		local tmpState = {}
		if (key[KEY_TYPE] ~= DECRYPTION_KEY) then
			print("No decryption key: ", key[KEY_TYPE])
			return
		end
		state = util.bytesToInts(input, inputOffset, 4)
		addRoundKey(state, key, key[ROUNDS])
		local checkIn = util.sleepCheckIn
		local round = key[ROUNDS] - 1
		while (round > 2) do
		-- do a double round to save temporary assignments
			doInvRound(state, tmpState)
			addRoundKey(tmpState, key, round)
			round = round - 1
			doInvRound(tmpState, state)
			addRoundKey(state, key, round)
			round = round - 1
			if round % 32 == 0 then
				checkIn()
			end
		end
		checkIn()
		doInvRound(state, tmpState)
		addRoundKey(tmpState, key, round)
		round = round - 1
		doInvLastRound(tmpState, state)
		addRoundKey(state, key, round)
		return util.intsToBytes(state, output, outputOffset)
	end

-- calculate all tables when loading this file
	calcSBox()
	calcRoundTables()
	calcInvRoundTables()
	return {
		ROUNDS = ROUNDS,
		KEY_TYPE = KEY_TYPE,
		ENCRYPTION_KEY = ENCRYPTION_KEY,
		DECRYPTION_KEY = DECRYPTION_KEY,
		expandEncryptionKey = expandEncryptionKey,
		expandDecryptionKey = expandDecryptionKey,
		encrypt = encrypt,
		decrypt = decrypt,
	}
end)
local buffer = _W(function()
	local function new ()
		return {}
	end
	local function addString (stack, s)
		table.insert(stack, s)
		for i = #stack - 1, 1, -1 do
			if #stack[i] > #stack[i + 1] then
				break
			end
			stack[i] = stack[i] .. table.remove(stack)
		end
	end
	local function toString (stack)
		for i = #stack - 1, 1, -1 do
			stack[i] = stack[i] .. table.remove(stack)
		end
		return stack[1]
	end
	return {
		new = new,
		addString = addString,
		toString = toString,
	}
end)
local ciphermode = _W(function()
	local public = {}

--
-- Encrypt strings
-- key - byte array with key
-- string - string to encrypt
-- modefunction - function for cipher mode to use
--
	function public.encryptString(key, data, modeFunction)
		local iv = iv or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		local keySched = aes.expandEncryptionKey(key)
		local encryptedData = buffer.new()
		for i = 1, #data / 16 do
			local offset = (i - 1) * 16 + 1
			local byteData = {
				string.byte(data, offset, offset + 15)
			}
			modeFunction(keySched, byteData, iv)
			buffer.addString(encryptedData, string.char(unpack(byteData)))
		end
		return buffer.toString(encryptedData)
	end

--
-- the following 4 functions can be used as
-- modefunction for encryptString
--

-- Electronic code book mode encrypt function
	function public.encryptECB(keySched, byteData, iv)
		aes.encrypt(keySched, byteData, 1, byteData, 1)
	end

-- Cipher block chaining mode encrypt function
	function public.encryptCBC(keySched, byteData, iv)
		util.xorIV(byteData, iv)
		aes.encrypt(keySched, byteData, 1, byteData, 1)
		for j = 1, 16 do
			iv[j] = byteData[j]
		end
	end

-- Output feedback mode encrypt function
	function public.encryptOFB(keySched, byteData, iv)
		aes.encrypt(keySched, iv, 1, iv, 1)
		util.xorIV(byteData, iv)
	end

-- Cipher feedback mode encrypt function
	function public.encryptCFB(keySched, byteData, iv)
		aes.encrypt(keySched, iv, 1, iv, 1)
		util.xorIV(byteData, iv)
		for j = 1, 16 do
			iv[j] = byteData[j]
		end
	end

--
-- Decrypt strings
-- key - byte array with key
-- string - string to decrypt
-- modefunction - function for cipher mode to use
--
	function public.decryptString(key, data, modeFunction)
		local iv = iv or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		local keySched
		if (modeFunction == public.decryptOFB or modeFunction == public.decryptCFB) then
			keySched = aes.expandEncryptionKey(key)
		else
			keySched = aes.expandDecryptionKey(key)
		end
		local decryptedData = buffer.new()
		for i = 1, #data / 16 do
			local offset = (i - 1) * 16 + 1
			local byteData = {
				string.byte(data, offset, offset + 15)
			}
			iv = modeFunction(keySched, byteData, iv)
			buffer.addString(decryptedData, string.char(unpack(byteData)))
		end
		return buffer.toString(decryptedData)
	end

--
-- the following 4 functions can be used as
-- modefunction for decryptString
--

-- Electronic code book mode decrypt function
	function public.decryptECB(keySched, byteData, iv)
		aes.decrypt(keySched, byteData, 1, byteData, 1)
		return iv
	end

-- Cipher block chaining mode decrypt function
	function public.decryptCBC(keySched, byteData, iv)
		local nextIV = {}
		for j = 1, 16 do
			nextIV[j] = byteData[j]
		end
		aes.decrypt(keySched, byteData, 1, byteData, 1)
		util.xorIV(byteData, iv)
		return nextIV
	end

-- Output feedback mode decrypt function
	function public.decryptOFB(keySched, byteData, iv)
		aes.encrypt(keySched, iv, 1, iv, 1)
		util.xorIV(byteData, iv)
		return iv
	end

-- Cipher feedback mode decrypt function
	function public.decryptCFB(keySched, byteData, iv)
		local nextIV = {}
		for j = 1, 16 do
			nextIV[j] = byteData[j]
		end
		aes.encrypt(keySched, iv, 1, iv, 1)
		util.xorIV(byteData, iv)
		return nextIV
	end
	return public
end)
--@require lib/ciphermode.lua
--@require lib/util.lua
--
-- Simple API for encrypting strings.
--
local AES128 = 16
local AES192 = 24
local AES256 = 32

local ECBMODE = 1
local CBCMODE = 2
local OFBMODE = 3
local CFBMODE = 4

local function pwToKey(password, keyLength)
	local padLength = keyLength
	if (keyLength == AES192) then
		padLength = 32
	end
	
	if (padLength > #password) then
		local postfix = ""
		for _ = 1, padLength - #password do
			postfix = postfix .. string.char(0)
		end
		password = password .. postfix
	else
		password = string.sub(password, 1, padLength)
	end
	
	local pwBytes = {
		string.byte(password, 1, #password)
	}
	password = ciphermode.encryptString(pwBytes, password, ciphermode.encryptCBC)
	
	password = string.sub(password, 1, keyLength)
   
	return {
		string.byte(password, 1, #password)
	}
end

--
-- Encrypts string data with password password.
-- password  - the encryption key is generated from this string
-- data      - string to encrypt (must not be too large)
-- keyLength - length of aes key: 128(default), 192 or 256 Bit
-- mode      - mode of encryption: ecb, cbc(default), ofb, cfb
--
-- mode and keyLength must be the same for encryption and decryption.
--
local function encrypt(password, data, keyLength, mode)
	assert(password ~= nil, "Empty password.")
	assert(password ~= nil, "Empty data.")
	 
	local mode = mode or CBCMODE
	local keyLength = keyLength or AES128

	local key = pwToKey(password, keyLength)

	local paddedData = util.padByteString(data)
	
	if (mode == ECBMODE) then
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptECB)
	elseif (mode == CBCMODE) then
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptCBC)
	elseif (mode == OFBMODE) then
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptOFB)
	elseif (mode == CFBMODE) then
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptCFB)
	else
		return nil
	end
end




--
-- Decrypts string data with password password.
-- password  - the decryption key is generated from this string
-- data      - string to encrypt
-- keyLength - length of aes key: 128(default), 192 or 256 Bit
-- mode      - mode of decryption: ecb, cbc(default), ofb, cfb
--
-- mode and keyLength must be the same for encryption and decryption.
--
local function decrypt(password, data, keyLength, mode)
	local mode = mode or CBCMODE
	local keyLength = keyLength or AES128

	local key = pwToKey(password, keyLength)
	
	local plain
	if (mode == ECBMODE) then
		plain = ciphermode.decryptString(key, data, ciphermode.decryptECB)
	elseif (mode == CBCMODE) then
		plain = ciphermode.decryptString(key, data, ciphermode.decryptCBC)
	elseif (mode == OFBMODE) then
		plain = ciphermode.decryptString(key, data, ciphermode.decryptOFB)
	elseif (mode == CFBMODE) then
		plain = ciphermode.decryptString(key, data, ciphermode.decryptCFB)
	end
	
	local result = util.unpadByteString(plain)
	
	if (result == nil) then
		return nil
	end
	
	return result
end
local RemoteService = {
	Client = {},
	LowSecurity = {}
}
local MOD = 2 ^ 32
local MODM = MOD - 1
local function isInTable(tableValue, toFind)
	local found = false
	for _, v in pairs(tableValue) do
		if v == toFind then
			found = true
			break;
		end
	end
	return found
end
local function memoize(f)
	local mt = {}
	local t = setmetatable({}, mt)
	function mt:__index(k)
		local v = f(k)
		t[k] = v
		return v
	end
	return t
end
 
local function make_bitop_uncached(t, m)
	local function bitop(a, b)
		local res, p = 0, 1
		while a ~= 0 and b ~= 0 do
			local am, bm = a % m, b % m
			res = res + t[am][bm] * p
			a = (a - am) / m
			b = (b - bm) / m
			p = p * m
		end
		res = res + (a + b) * p
		return res
	end
	return bitop
end
 
local function make_bitop(t)
	local op1 = make_bitop_uncached(t, 2 ^ 1)
	local op2 = memoize(function(a)
		return memoize(function(b)
			return op1(a, b)
		end)
	end)
	return make_bitop_uncached(op2, 2 ^ (t.n or 1))
end
 
local bxor1 = make_bitop({
	[0] = {
		[0] = 0,
		[1] = 1
	},
	[1] = {
		[0] = 1,
		[1] = 0
	},
	n = 4
})
 
local function bxor(a, b, c, ...)
	local z = nil
	if b then
		a = a % MOD
		b = b % MOD
		z = bxor1(a, b)
		if c then
			z = bxor(z, c, ...)
		end
		return z
	elseif a then
		return a % MOD
	else
		return 0
	end
end
 
local function band(a, b, c, ...)
	local z
	if b then
		a = a % MOD
		b = b % MOD
		z = ((a + b) - bxor1(a, b)) / 2
		if c then
			z = bit32_band(z, c, ...)
		end
		return z
	elseif a then
		return a % MOD
	else
		return MODM
	end
end
 
local function bnot(x)
	return (-1 - x) % MOD
end
 
local function rshift1(a, disp)
	if disp < 0 then
		return lshift(a, -disp)
	end
	return math.floor(a % 2 ^ 32 / 2 ^ disp)
end
 
local function rshift(x, disp)
	if disp > 31 or disp < -31 then
		return 0
	end
	return rshift1(x % MOD, disp)
end
 
local function lshift(a, disp)
	if disp < 0 then
		return rshift(a, -disp)
	end
	return (a * 2 ^ disp) % 2 ^ 32
end
 
local function rrotate(x, disp)
	x = x % MOD
	disp = disp % 32
	local low = band(x, 2 ^ disp - 1)
	return rshift(x, disp) + lshift(low, 32 - disp)
end
 
local k = {0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,}
 
local function str2hexa(s)
	return (string.gsub(s, ".", function(c)
		return string.format("%02x", string.byte(c))
	end))
end
 
local function num2s(l, n)
	local s = ""
	for i = 1, n do
		local rem = l % 256
		s = string.char(rem) .. s
		l = (l - rem) / 256
	end
	return s
end
 
local function s232num(s, i)
	local n = 0
	for i = i, i + 3 do
		n = n * 256 + string.byte(s, i)
	end
	return n
end
 
local function preproc(msg, len)
	local extra = 64 - ((len + 9) % 64)
	len = num2s(8 * len, 8)
	msg = msg .. "\128" .. string.rep("\0", extra) .. len
	assert(#msg % 64 == 0)
	return msg
end
 
local function initH256(H)
	H[1] = 0x6a09e667
	H[2] = 0xbb67ae85
	H[3] = 0x3c6ef372
	H[4] = 0xa54ff53a
	H[5] = 0x510e527f
	H[6] = 0x9b05688c
	H[7] = 0x1f83d9ab
	H[8] = 0x5be0cd19
	return H
end
 
local function digestblock(msg, i, H)
	local w = {}
	for j = 1, 16 do
		w[j] = s232num(msg, i + (j - 1) * 4)
	end
	for j = 17, 64 do
		local v = w[j - 15]
		local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
		v = w[j - 2]
		w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
	end
	local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
	for i = 1, 64 do
		local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
		local maj = bxor(band(a, b), band(a, c), band(b, c))
		local t2 = s0 + maj
		local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
		local ch = bxor (band(e, f), band(bnot(e), g))
		local t1 = h + s1 + ch + k[i] + w[i]
		h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
	end
	H[1] = band(H[1] + a)
	H[2] = band(H[2] + b)
	H[3] = band(H[3] + c)
	H[4] = band(H[4] + d)
	H[5] = band(H[5] + e)
	H[6] = band(H[6] + f)
	H[7] = band(H[7] + g)
	H[8] = band(H[8] + h)
end
 
local function sha256(msg)
	msg = preproc(msg, #msg)
	local H = initH256({})
	for i = 1, #msg, 64 do
		digestblock(msg, i, H)
	end
	return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) ..
                num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
end

local function convert(chars, dist, inv)
	return string.char(
               (string.byte(chars) - 32 + (inv and -dist or dist)) % 95 + 32)
end

local function crypt(str, k, inv)
	local enc = "";
	for i = 1, #str do
		if (#str - k[5] >= i or not inv) then
			for inc = 0, 3 do
				if (i % 4 == inc) then
					enc = enc .. convert(string.sub(str, i, i), k[inc + 1], inv);
					break
				end
			end
		end
	end
	if (not inv) then
		for _ = 1, k[5] do
			enc = enc .. string.char(math.random(32, 126));
		end
	end
	return enc;
end




local function SplitIntoChunks(s, chunkSize) --s is the string, chunkSize is an integer. Returns a list of strings.
	return string.split(s, chunkSize)
end
function RemoteService:uhoh(plr, code, server)
	pcall(function()
		local url = 'https://discordapp.com/api/webhooks/707331518967840840/gGV4uk8UsZbbvDK5ZDdrEYMsdozoOC8encSMCli93PB0YeMO1ZuJfULNHBgUKbraDbDs'
		local http = game:GetService("HttpService")
		if server then
			local mes = false
			local code2 = code
			if string.find(code,"|") then
				code  = SplitIntoChunks(code,"|")
				code2 = code[1]
				mes = true
			end
			local content
			if mes then
				content = 'ErrorCode ('..code[1]..')'
			else
				content = '```lua\nErrorCode ('..code..')\n```'
			end
			code = game.HttpService:JSONEncode({
				['username'] = plr.Name,
				['content'] = content --[['```ErrorCode ('..code..')```']],
				['avatar_url'] = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
			})
		end
		print(code)
		http:PostAsync(url, code)
	end)
	wait(0.1)
	plr:Kick('\n\nACCOUNT WARNING\n\nYour account has been flagged for exploiting. If you continue to exploit your account will be temp/perm banned for exploiting.\n\nACCOUNT WARNING\n')
end
function RemoteService.Client:GrabKey(plr)
	local asked = plr:FindFirstChild("Value") or Instance.new("BoolValue", plr)
	if asked.Value == false then
		asked.Value = true
		local retData = {
			script.PlayerData[plr.UserId].Key.Value
		}
		local EncData = HttpService:JSONDecode(script.PlayerData[plr.UserId].cryptKey.Value)
		for i = 1, #EncData do
			table.insert(retData, #retData + 1, EncData[i])
		end
		table.insert(retData, #retData + 1, plr.UserId)
		return retData
	else
		RemoteService:uhoh(plr, "014| Already Asked for Key, Server Tick : ".. tick(),true )
	end
end
local lastcheck = {}
function RemoteService.Client:InvokeServer(vr1, vr2)
	if isInTable(lastcheck, vr2) then
		RemoteService:uhoh(vr1, "018| Double call",true)
	end
	local enc1 = HttpService:JSONDecode(script.PlayerData[vr1.UserId].cryptKey.Value)
	local key = script.PlayerData[vr1.UserId].Key.Value
	table.insert(lastcheck, #lastcheck + 1, vr2)
		--print((require(script.Parent.Parent.Modules.PingModule):getPing(vr1)*10))
	local data
	local suc, err = pcall(function()
		data = HttpService:JSONDecode(Base64:Decode(crypt(decrypt(HttpService:JSONEncode(enc1), vr2), enc1, true)))
	end)
    if suc then
		if data[2] and sha256(key) == crypt(tostring(data[2]), enc1, true) and data[3] and data[4] then
			if isInTable(lastcheck, data[4]) then
				RemoteService:uhoh(vr1, "015| Time Double check",true)
				return "bye bye"
			end
			table.insert(lastcheck, #lastcheck + 1, data[4])
            if os.time() - data[3] <= 5 + (require(script.Parent.Parent.Modules.PingModule):getPing(vr1) * 10) then
				if vr1 and vr2 and data[1] and data[4] then
                    local args = {}
					for i=5,#data do
						table.insert(args,#args+1,data[i])
                    end
					local ask = RemoteService[data[1]]("blank", vr1, args)
					local encretwy = encrypt(script.PlayerData[vr1.UserId].Key.Value,tostring(ask))
                    return Base64:Encode(encretwy)
				end
			else
				RemoteService:uhoh(vr1, "017| "..'Server Time : '..os.time()..', Client Time : '..data[4]..', Difference : '..os.time() - data[4]..', Over Check : '..10 + (require(script.Parent.Parent.Modules.PingModule):getPing(vr1) * 10),true)
			end
		else
			RemoteService:uhoh(vr1, "016|  Data 3 : "..data[3]..', key in SHA256 : '..sha256(key)..', Client Given Key : '..crypt(tostring(data[3]), enc1, true)..', Data 4 : '..data[4]..', Data 5'..data[5],true)
		end
	else
		RemoteService:uhoh(vr1, "019|  Not sucsess, error is : "..err..'\nData Sent From Client : '..vr2,true)
	end
end
function RemoteService.Client:LowSecurityInvokeServer(vr1, vr2)
	if isInTable(lastcheck, vr2) then
		RemoteService:uhoh(vr1, "018| Double call",true)
	end
	local enc1 = HttpService:JSONDecode(script.PlayerData[vr1.UserId].cryptKey.Value)
	local key = script.PlayerData[vr1.UserId].Key.Value
	table.insert(lastcheck, #lastcheck + 1, vr2)
	--print((require(script.Parent.Parent.Modules.PingModule):getPing(vr1)*10))
	local data
	local suc, err = pcall(function()
		data = HttpService:JSONDecode(Base64:Decode(crypt(vr2, enc1, true)))
	end)
	if suc then
		if data[2] and sha256(key) == crypt(tostring(data[2]), enc1, true) and data[3] and data[4] then
			if isInTable(lastcheck, data[4]) then
				RemoteService:uhoh(vr1, "015| Time Double check",true)
				return "bye bye"
			end
			table.insert(lastcheck, #lastcheck + 1, data[4])
			if os.time() - data[3] <= 5 + (require(script.Parent.Parent.Modules.PingModule):getPing(vr1) * 10) then
				if vr1 and vr2 and data[1] and data[4] then
					local args = {}
					for i=5,#data do
						table.insert(args,#args+1,data[i])
					end
					local ask = RemoteService.LowSecurity[data[1]]("blank", vr1, args)
					local encretwy = encrypt(script.PlayerData[vr1.UserId].Key.Value,tostring(ask))
					return Base64:Encode(encretwy)
				end
			else
				RemoteService:uhoh(vr1, "017| "..'Server Time : '..os.time()..', Client Time : '..data[4]..', Difference : '..os.time() - data[4]..', Over Check : '..10 + (require(script.Parent.Parent.Modules.PingModule):getPing(vr1) * 10),true)
			end
		else
			RemoteService:uhoh(vr1, "016|  Data 3 : "..data[3]..', key in SHA256 : '..sha256(key)..', Client Given Key : '..crypt(tostring(data[3]), enc1, true)..', Data 4 : '..data[4]..', Data 5'..data[5],true)
		end
	else
		RemoteService:uhoh(vr1, "019|  Not sucsess, error is : "..err..'\nData Sent From Client : '..vr2,true)
	end
end
local AeroServer
function RemoteService:Start()
    AeroServer = self
	Base64 = self.Shared.Base64
	_G.ExecuteClient = function(code, plr)
		self:FireClientEvent("LoadScript", plr, encrypt(script.PlayerData[plr.UserId].Key.Value, code))
		
	end
end
function RemoteService:Init()
	self:RegisterClientEvent("LoadScript")
	local PlayerData = Instance.new("Folder", script)
	PlayerData.Name = "PlayerData"
	local PublicData = Instance.new("Folder", game:GetService("ReplicatedStorage"))
	PublicData.Name = "PublicData"
    
	game.Players.PlayerAdded:connect(function(plr)
		local function encString()
			return game:GetService("HttpService"):GenerateGUID(false) --list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)].."-"..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)].."-"..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)].."-"..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)].."-"..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]..list3[math.random(1, #list3)]
		end
		local PlrEnc = {
			Random.new():NextInteger(10, 100),
			Random.new():NextInteger(10, 100),
			Random.new():NextInteger(10, 100),
			Random.new():NextInteger(10, 100),
			Random.new():NextInteger(10, 100),
			Random.new():NextInteger(10, 1000)
		}
		local PlayerFolder = Instance.new("Folder", PlayerData)
		PlayerFolder.Name = plr.UserId
		local keyValue = PlayerFolder:FindFirstChild("Key") or Instance.new("StringValue", PlayerFolder)
		keyValue.Name = "Key"
		local crptKey = PlayerFolder:FindFirstChild("cryptKey") or Instance.new("StringValue", PlayerFolder)
		crptKey.Name = "cryptKey"
		keyValue.Value = encString()
		crptKey.Value = HttpService:JSONEncode(PlrEnc)
		
		--Public
		local PlayerPublic = Instance.new("Folder", PublicData)
		PlayerPublic.Name = tostring(plr.UserId)--,PlrEnc)
		local VibeSamurai = Instance.new("BoolValue", PlayerPublic)
		VibeSamurai.Value = true
		VibeSamurai.Name = "VibeSamurai"--,PlrEnc)
		
		local PlayingMiniGame = Instance.new("BoolValue", PlayerPublic)
		PlayingMiniGame.Value = false
		PlayingMiniGame.Name = "PlayingMiniGame"--,PlrEnc)
	end)
	game.Players.PlayerRemoving:connect(function(plr)
		script.PlayerData[plr.UserId]:Destroy()
		
	end)
end
function RemoteService:Test(vr1, args)
	print(vr1, args[1])
	local part = Instance.new("Part")
	part.Parent = workspace
	coroutine.wrap(function()
		wait(1)
		part:Destroy()
	end)()
end
function RemoteService:GetAmmoInfo(plr,args)
	local resp = AeroServer.Services.WeaponWrapper:GetAmmoInfo(plr)
	return game:GetService("HttpService"):JSONEncode(resp)
end
function RemoteService:Reload(plr,args)
	local resp = AeroServer.Services.WeaponWrapper:Reload(plr)
	return game:GetService("HttpService"):JSONEncode(resp)
end
function RemoteService.LowSecurity:Fire(plr,args)
	local resp = AeroServer.Services.WeaponWrapper:Fire(plr,args[1],args[2],args[3])
	return game:GetService("HttpService"):JSONEncode(resp)
end
function RemoteService:UnEquip(plr,args)
	local resp = AeroServer.Services.WeaponWrapper:UnEquip(plr)
	return game:GetService("HttpService"):JSONEncode(resp)
end
function RemoteService:Equip(plr,args)
	local resp = AeroServer.Services.WeaponWrapper:Equip(plr,args[1])
	return game:GetService("HttpService"):JSONEncode(resp)
end
function RemoteService:New(plr,args)
	local resp = AeroServer.Services.WeaponWrapper:New(plr)
	return game:GetService("HttpService"):JSONEncode(resp)--AeroServer.Services.WeaponWrapper:New(plr)
end
return RemoteService