--[[
Copyright 2011 João Cardoso
LibItemCache-1.0 is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of LibItemSearch.

LibItemCache-1.0 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LibItemCache-1.0 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LibItemSearch. If not, see <http://www.gnu.org/licenses/>.
--]]

local Lib = LibStub('LibItemCache-1.0')
if not ArmoryDB or Lib:HasCache() then
  return
end

local Cache, Realm = Lib:NewCache()
local Profile

local function SelectPlayer (player)
    Profile = {realm = Realm, character = player, current = Armory:CurrentProfile()}

    if Armory:ProfileExists(Profile) then
        Armory:SelectProfile(Profile)
    end
end

local function RestorePlayer ()
    if Profile and Profile.current then
        Armory:SelectProfile(Profile.current)
    end
end


--[[ Items ]]--

function Cache:GetBag (player, bag, slot)
  SelectPlayer(player)
  local _, slots = Armory:GetInventoryContainerInfo(bag)
  local link = Armory:GetInventoryItemLink('player', slot)

  RestorePlayer()
  return link, slots
end

function Cache:GetItem (player, bag, slot, isBank)
  SelectPlayer(player)
	
  local _, size = Armory:GetInventoryContainerInfo(bag)
  for i = 1, size or 0 do
	local _, count, _, _, _, index = Armory:GetContainerItemInfo(bag, i)
    if index == slot then
	  local link = Armory:GetContainerItemLink(bag, i)
	
	  RestorePlayer()
      return link, count
    end
  end
end

--[[function Cache:GetItemCount (player, id)
  local i = 0
  for bag, contents in pairs(Realm[player].Inventory) do
    for name, data in pairs(contents) do
      if name:sub(0,4) == 'Link' and data['1']:sub(17, -1):match('^(%d+)') == id then
        i = i + 1
      end
    end
  end

  return i
end]]--

function Cache:GetMoney (player)
  SelectPlayer(player)
  local money = Armory:GetMoney()
  RestorePlayer()
  return money
end


--[[ Players ]]--

function Cache:GetPlayer (player)
	SelectPlayer(player)
    local _, race = Armory:UnitRace()
	local class, sex = Armory:UnitClass(), Armory:UnitSex()
	RestorePlayer()
	return class, race, sex
end

function Cache:IteratePlayers ()
  return ArmoryDB[Realm]
end

function Cache:DeletePlayer (player)
  ArmoryDB[Realm][player] = nil
end