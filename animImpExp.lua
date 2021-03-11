self
--[[

	Animation to CFrame
	Credits: sleepcodes#3803
	
	API:
		<void function> export()
			<nil> records the movement of player for <recordTime> seconds and saves to <filename>
			
		<void function> import()
			<array> retrieves the CFrame data from <filename>
			
			Example Returned value:
			
			{
			[1] = {["Head"]=CFRAME_HERE,["Torso"]=CFRAME_HERE},
			[2] = {["Head"]=CFRAME_HERE,["Torso"]=CFRAME_HERE},
			[3] = {["Head"]=CFRAME_HERE,["Torso"]=CFRAME_HERE}
			}
			
			The import function returns an array, the index is the frame number, based off of render frames.
			In the array, each value is a dictionary, the indexes are the string names of bodyparts and the value is a CFrame.
]]--

local recordTime = 10 -- How long in seconds to record you animation
local filename = "default.txt" -- The name of the file to write the data to and retrieve from

-- DONT TOUCH ANYTHING BELOW HERE --	
local function export()
local anims = {}
local a = tick()
local conn
local wai = true
conn = game:GetService("RunService").RenderStepped:Connect(function()
	if tick()-a >= recordTime then conn:Disconnect();wai = false; return end
	anims[#anims+1] = {}
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") then
			anims[#anims][v.Name]= tostring(v.CFrame)
		end
	end
end)
repeat wait() until wai == false
	writefile(filename,game:GetService("HttpService"):JSONEncode(anims))
	print('Import Complete...')
end

local function import()
	local txt = readfile(filename) or "[{}]"
	local parsed = game:GetService("HttpService"):JSONDecode(txt)
	for i1,v1 in pairs(parsed) do
		for i2,v2 in pairs(v1) do
			local split = v2:split(", ")
			for i3,v3 in pairs(split) do
				split[i3] = tonumber(v3)
			end
			parsed[i1][i2] = CFrame.new(table.unpack(split))
		end
	end
	print('Export Complete...')
	return parsed
end
