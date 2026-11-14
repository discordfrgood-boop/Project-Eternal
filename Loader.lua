-- Project Eternal | Script Loader
-- Detects the game you are in. Supported game: its script starts on its own.
-- Any other game: a menu opens so you can pick a script and run it anyway.
 
local ETERNAL_LOGO = "rbxassetid://119192451708380"
local ETERNAL_LOGO_B64 = "" -- embedded copy removed; logo loads from the asset id above
 
--------------------------------------------------------------------------
-- CATALOG: add one block per game.
-- Loader = the raw link that hosts that game's script
--          (for example a raw.githubusercontent.com link).
--------------------------------------------------------------------------
local CATALOG = {
	{
		Key = "bloxfruits",
		Name = "Blox Fruits",
		Places = { 2753915549, 4442272183, 7449423635 },
		Universe = 994732206,
		Loader = "https://raw.githubusercontent.com/discordfrgood-boop/Project-Eternal/refs/heads/main/Bloxfruit%20(2).lua",
		Listed = true,
		Tone = Color3.fromRGB(90, 169, 255),
	},
	{
		Key = "tsb",
		Name = "The Strongest Battlegrounds",
		Places = { 10449761463 },
		Universe = 3808081382,
		Loader = "https://raw.githubusercontent.com/discordfrgood-boop/Project-Eternal/refs/heads/main/GenosFarm.lua",
		Listed = true,
		Tone = Color3.fromRGB(226, 96, 96),
	},
	{
		Key = "rivals",
		Name = "Rivals",
		Places = { 17625359962 },
		Universe = 6035872082,
		Loader = "https://raw.githubusercontent.com/discordfrgood-boop/Project-Eternal/refs/heads/main/rivals.luau",
		Listed = true,
		Tone = Color3.fromRGB(167, 120, 255),
	},
	{
		Key = "mm2",
		Name = "Murder Mystery 2",
		Places = { 142823291 },
		Universe = 66654135,
		Loader = "https://raw.githubusercontent.com/discordfrgood-boop/Project-Eternal/refs/heads/main/MM2.lua",
		Listed = true,
		Tone = Color3.fromRGB(255, 190, 80),
	},
}
 
local TOGGLE_KEY = Enum.KeyCode.LeftControl
 
--------------------------------------------------------------------------
-- services / helpers
--------------------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
 
local genv = (getgenv and getgenv()) or _G
 
local function launch(entry)
	if type(entry.Loader) ~= "string" or entry.Loader == "" then
		return false, "no loader link set for " .. entry.Name
	end
	return pcall(function()
		return loadstring(game:HttpGet(entry.Loader), "@" .. entry.Key)()
	end)
end
 
local function matchPlace(placeId, universeId)
	for _, entry in ipairs(CATALOG) do
		if entry.Universe and entry.Universe == universeId then
			return entry
		end
	end
	for _, entry in ipairs(CATALOG) do
		for _, id in ipairs(entry.Places) do
			if id == placeId then
				return entry
			end
		end
	end
	return nil
end
 
--------------------------------------------------------------------------
-- supported game: start its script and stop here
--------------------------------------------------------------------------
local supported = matchPlace(game.PlaceId, game.GameId)
if supported then
	local ok, err = launch(supported)
	if not ok then
		warn("Project Eternal: " .. supported.Name .. " failed to start - " .. tostring(err))
