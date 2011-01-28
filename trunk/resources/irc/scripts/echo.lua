---------------------------------------------------------------------
-- Project: irc
-- Author: MCvarial
-- Contact: mcvarial@gmail.com
-- Version: 1.0.0
-- Date: 31.10.2010
---------------------------------------------------------------------

------------------------------------
-- Echo
------------------------------------
addEventHandler("onResourceStart",root,
	function (resource)
		if getResourceInfo(resource,"type") ~= "map" then
			outputIRC("07* Resource '"..getResourceName(resource).."' started!")
		end
	end
)

addEventHandler("onResourceStop",root,
	function (resource)
		if getResourceInfo(resource,"type") ~= "map" then
			outputIRC("07* Resource '"..(getResourceName(resource) or "?").."' stopped!")
		end
	end
)

addEventHandler("onPlayerJoin",root,
	function ()
		outputIRC("03*** "..getPlayerName(source).." joined the game.")
	end
)

addEventHandler("onPlayerQuit",root,
	function (quit,reason,element)
		if reason then
			outputIRC("02*** "..getPlayerName(source).." was "..quit.." from the game by "..getPlayerName(element).." ("..reason..")")
		else
			outputIRC("02*** "..getPlayerName(source).." left the game ("..quit..")")
		end
	end
)

addEventHandler("onPlayerChangeNick",root,
	function (oldNick,newNick)
		outputIRC("13* "..oldNick.." is now known as "..newNick)
	end
)

addEvent("onPlayerMute",root,
	function ()
		outputIRC("12* "..getPlayerName(source).." has been muted")
	end
)

addEvent("onPlayerUnmute",root,
	function ()
		outputIRC("12* "..getPlayerName(source).." has been unmuted")
	end
)

addEventHandler("onPlayerChat",root,
	function (message,type)
		if type == 0 then
			outputIRC("07"..getPlayerName(source)..": "..message)
		elseif type == 1 then
			outputIRC("06* "..getPlayerName(source).." "..message)
		elseif type == 2 then
			outputIRC("07(TEAM)"..getPlayerName(source)..": "..message)
		end
	end
)

local bodyparts = {nil,nil,"Torso","Ass","Left Arm","Right Arm","Left Leg","Right Leg","Head"}
local weapons = {}
weapons[19] = "Rockets"
weapons[88] = "Fire"
addEventHandler("onPlayerWasted",root,
	function (ammo,killer,weapon,bodypart)
		if killer then
			if getElementType(killer) == "vehicle" then
				local driver = getVehicleController(killer)
				if driver then
					outputIRC("04* "..getPlayerName(source).." was killed by "..getPlayerName(driver).." in a "..getVehicleName(killer))
				else
					outputIRC("04* "..getPlayerName(source).." was killed by an "..getVehicleName(killer))
				end
			elseif getElementType(killer) == "player" then
				if weapon == 37 then
					if getPedWeapon(killer) ~= 37 then
						weapon = 88
					end
				end
				outputIRC("04* "..getPlayerName(source).." was killed by "..getPlayerName(killer).." ("..(getWeaponNameFromID(weapon) or weapons[weapon] or "?")..")("..bodyparts[bodypart]..")")
			else
				outputIRC("04* "..getPlayerName(source).." died")
			end
		else
			outputIRC("04* "..getPlayerName(source).." died")
		end
	end
)
		
addEvent("onPlayerFinish",true)
addEventHandler("onPlayerFinish",root,
	function (rank,time)
		outputIRC("12* "..getPlayerName(source).." finished (rank: "..rank.." time: "..msToTimeStr(time)..")")
	end
)

addEvent("onGamemodeMapStart",true)
addEventHandler("onGamemodeMapStart",root,
	function (res)
		outputIRC("12* Map started: "..(getResourceInfo(res, "name") or getResourceName(res)))
		local resource = getResourceFromName("mapratings")
		if resource and getResourceState(resource) == "running" then
			outputIRC("07* Rating: "..exports.mapratings:getMapRating(getResourceName(res)).average or "none")
		end
	end
)

addEvent("onPlayerToptimeImprovement",true)
addEventHandler("onPlayerToptimeImprovement",root,
	function (newPos,newTime,oldPos,oldTime)
		if newPos == 1 then
			outputIRC("07* New record: "..msToTimeStr(newTime).." by "..getPlayerName(source).."!")
		end
	end
)

addEventHandler("onBan",root,
	function (ban)
		outputIRC("12* Ban added by "..(getPlayerName(source) or "Console")..": name: "..(getBanNick(ban) or "/")..", ip: "..(getBanIP(ban) or "/")..", serial: "..(getBanSerial(ban) or "/")..", banned by: "..(getBanAdmin(ban) or "/").." banned for: "..(getBanReason(ban) or "/"))
	end
)

addEventHandler("onUnban",root,
	function (ban)
		outputIRC("12* Ban removed by "..(getPlayerName(source) or "Console")..": name: "..(getBanNick(ban) or "/")..", ip: "..(getBanIP(ban) or "/")..", serial: "..(getBanSerial(ban) or "/")..", banned by: "..(getBanAdmin(ban) or "/").." banned for: "..(getBanReason(ban) or "/"))
	end
)

------------------------------------
-- Admin interaction
------------------------------------
addEvent("onPlayerFreeze")
addEventHandler("onPlayerFreeze",root,
	function (state)
		if state then
			outputIRC("12* "..getPlayerName(source).." was frozen!")
		else
			outputIRC("12* "..getPlayerName(source).." was unfrozen!")
		end
	end
)

addEvent("onPlayerMute")
addEventHandler("onPlayerMute",root,
	function (state)
		if state then
			outputIRC("12* "..getPlayerName(source).." was muted!")
		else
			outputIRC("12* "..getPlayerName(source).." was unmuted!")
		end
	end
)

------------------------------------
-- Votemanager interaction
------------------------------------
local pollData

addEvent("onPollStarting")
addEventHandler("onPollStarting",root,
	function (data)
		pollData = data
	end
)

addEvent("onPollModified")
addEventHandler("onPollModified",root,
	function (data)
		pollData = data
	end
)

addEvent("onPollStart")
addEventHandler("onPollStart",root,
	function ()
		outputIRC("14* A vote was started ["..tostring(pollData.title).."]")
	end
)

addEvent("onPollStop")
addEventHandler("onPollStop",root,
	function ()
		outputIRC("14* Vote stopped!")
	end
)

addEvent("onPollEnd")
addEventHandler("onPollEnd",root,
	function ()
		outputIRC("14* Vote ended!")
	end
)

addEvent("onPollDraw")
addEventHandler("onPollDraw",root,
	function ()
		outputIRC("14* A draw was reached!")
	end
)