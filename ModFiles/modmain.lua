local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS
local SpawnPrefab = GLOBAL.SpawnPrefab
local Vector3 = GLOBAL.Vector3
local DEGREES = GLOBAL.DEGREES

local maximum_use = GetModConfigData("maximum") or 1

local work_on_green = GetModConfigData("green")

local max_armor = GetModConfigData("max_armor")
local max_weapon = GetModConfigData("max_weapon")



--改最大容量

if maximum_use < 999 then
	TUNING.ICESTAFF_USES 				= TUNING.ICESTAFF_USES 				* maximum_use	
	TUNING.FIRESTAFF_USES 				= TUNING.FIRESTAFF_USES 			* maximum_use
	TUNING.TELESTAFF_USES 				= TUNING.TELESTAFF_USES 			* maximum_use
	TUNING.ORANGESTAFF_USES 			= TUNING.ORANGESTAFF_USES 			* maximum_use
	TUNING.YELLOWSTAFF_USES 			= TUNING.YELLOWSTAFF_USES 			* maximum_use
	TUNING.OPALSTAFF_USES 				= TUNING.OPALSTAFF_USES 			* maximum_use
	TUNING.REDAMULET_USES 				= TUNING.REDAMULET_USES 			* maximum_use
	TUNING.BLUEAMULET_FUEL 				= TUNING.BLUEAMULET_FUEL 			* maximum_use
	TUNING.PURPLEAMULET_FUEL 			= TUNING.PURPLEAMULET_FUEL 			* maximum_use
	TUNING.YELLOWAMULET_FUEL 			= TUNING.YELLOWAMULET_FUEL 			* maximum_use
	TUNING.ORANGEAMULET_USES 			= TUNING.ORANGEAMULET_USES 			* maximum_use
	TUNING.MULTITOOL_AXE_PICKAXE_USES 	= TUNING.MULTITOOL_AXE_PICKAXE_USES	* maximum_use	--多用斧镐
	TUNING.TORNADOSTAFF_USES 			= TUNING.TORNADOSTAFF_USES 			* maximum_use	--天气棒

	if work_on_green then
		TUNING.GREENSTAFF_USES 			= TUNING.GREENSTAFF_USES 			* maximum_use
		TUNING.GREENAMULET_USES 		= TUNING.GREENAMULET_USES 			* maximum_use
	end	
end

--护甲武器容量
	
if max_armor < 999 then
	TUNING.ARMOR_SKELETONHAT 			= TUNING.ARMOR_SKELETONHAT 			* max_armor
	TUNING.ARMOR_RUINSHAT 				= TUNING.ARMOR_RUINSHAT 			* max_armor
	TUNING.ARMORRUINS 					= TUNING.ARMORRUINS 				* max_armor
end

if max_weapon < 999 then
	TUNING.RUINS_BAT_USES = TUNING.RUINS_BAT_USES * max_weapon
	TUNING.BATBAT_USES = TUNING.BATBAT_USES * max_weapon
	--TUNING.NIGHTSTICK_FUEL = TUNING.NIGHTSTICK_FUEL * max_weapon
	TUNING.NIGHTSTICK_FUEL = 30 * 16 * max_weapon	--晨星锤的耐久改为total day time乘以倍率，要不然还是太小
end



--法杖充能
	
local function accept_test_staff(inst, item)
	return item ~= nil and (item.prefab == ("nightmarefuel" or "horrorfuel"))
end

local function on_accept_staff(inst, giver, item)
	if item ~= nil and (item.prefab == ("nightmarefuel" or "horrorfuel")) then
		if inst.components.finiteuses ~= nil then
			giver.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
			inst.components.finiteuses:SetPercent(1)
		end
	end
end



--修改法杖预制件
	
--冰魔杖
AddPrefabPostInit("icestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
	end
end)

--火魔杖
AddPrefabPostInit("firestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
	end
end)

--传送杖
AddPrefabPostInit("telestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
	end
end)

--懒人杖
AddPrefabPostInit("orangestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
	end
end)

--星杖
AddPrefabPostInit("yellowstaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
	end
end)

--月杖
AddPrefabPostInit("opalstaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
	end
end)

--拆迁
if work_on_green then
	AddPrefabPostInit("greenstaff", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
				inst.components.trader.onaccept = on_accept_staff
			end
		end
	end)
end


modimport("scripts/amulet_import")



--噩梦燃料可交易

AddPrefabPostInit("nightmarefuel", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.tradable == nil then
			inst:AddComponent("tradable")
		end
	end
end)

--纯净恐惧可交易

AddPrefabPostInit("horrorfuel", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.tradable == nil then
			inst:AddComponent("tradable")
		end
	end
end)
