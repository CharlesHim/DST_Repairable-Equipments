--写给想修改这个mod的小可爱的修改指南
--@瑶光 @2023.12.09
--改耐久：约第20行
--添加填充物：约第60行、250行
--添加被填充的道具：约第80行


--todo：
--把12.9新添加的道具耐久项目写进填耐久里面

local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS
local SpawnPrefab = GLOBAL.SpawnPrefab
local Vector3 = GLOBAL.Vector3
local DEGREES = GLOBAL.DEGREES

local maximum_use = GetModConfigData("maximum") or 1
local work_on_green = GetModConfigData("green")
local max_armor = GetModConfigData("max_armor")
local max_weapon = GetModConfigData("max_weapon")



--道具耐久  --在此处添加项目

TUNING.ICESTAFF_USES 				= TUNING.ICESTAFF_USES 				* maximum_use	--冰杖
TUNING.FIRESTAFF_USES 				= TUNING.FIRESTAFF_USES 			* maximum_use	--火杖
TUNING.TELESTAFF_USES 				= TUNING.TELESTAFF_USES 			* maximum_use	--传送
TUNING.ORANGESTAFF_USES 			= TUNING.ORANGESTAFF_USES 			* maximum_use	--闪现
TUNING.YELLOWSTAFF_USES 			= TUNING.YELLOWSTAFF_USES 			* maximum_use	--星杖
TUNING.OPALSTAFF_USES 				= TUNING.OPALSTAFF_USES 			* maximum_use	--月杖
TUNING.REDAMULET_USES 				= TUNING.REDAMULET_USES 			* maximum_use	--重生护符
TUNING.BLUEAMULET_FUEL 				= TUNING.BLUEAMULET_FUEL 			* maximum_use	--寒冰~
TUNING.PURPLEAMULET_FUEL 			= TUNING.PURPLEAMULET_FUEL 			* maximum_use	--梦魇~
TUNING.YELLOWAMULET_FUEL 			= TUNING.YELLOWAMULET_FUEL 			* maximum_use	--魔光~
TUNING.ORANGEAMULET_USES 			= TUNING.ORANGEAMULET_USES 			* maximum_use	--懒人~
TUNING.MULTITOOL_AXE_PICKAXE_USES 	= TUNING.MULTITOOL_AXE_PICKAXE_USES	* maximum_use	--斧镐
TUNING.TORNADOSTAFF_USES 			= TUNING.TORNADOSTAFF_USES 			* maximum_use	--风杖
TUNING.VOIDCLOTH_UMBRELLA_PERISHTIME= 30 * 16 *15						* maximum_use	--虚空伞

if work_on_green then
	TUNING.GREENSTAFF_USES 			= TUNING.GREENSTAFF_USES 			* maximum_use	--拆迁法杖
	TUNING.GREENAMULET_USES 		= TUNING.GREENAMULET_USES 			* maximum_use	--偷工减料许可证
end	

--护甲耐久	--在此处添加项目

TUNING.ARMOR_SKELETONHAT 			= TUNING.ARMOR_SKELETONHAT 			* max_armor		--骨头
TUNING.ARMOR_RUINSHAT 				= TUNING.ARMOR_RUINSHAT 			* max_armor		--铥人头
TUNING.ARMORRUINS 					= TUNING.ARMORRUINS 				* max_armor		--铥人甲
TUNING.ARMOR_DREADSTONEHAT			= TUNING.ARMOR_DREADSTONEHAT		* max_armor		--绝望头
TUNING.ARMORDREADSTONE				= TUNING.ARMORDREADSTONE			* max_armor		--绝望甲
TUNING.ARMOR_LUNARPLANT_HAT			= TUNING.ARMOR_LUNARPLANT_HAT		* max_armor		--亮茄头
TUNING.ARMOR_LUNARPLANT				= TUNING.ARMOR_LUNARPLANT			* max_armor		--亮茄甲
TUNING.ARMOR_VOIDCLOTH_HAT			= TUNING.ARMOR_VOIDCLOTH_HAT		* max_armor		--虚空头
TUNING.ARMOR_VOIDCLOTH				= TUNING.ARMOR_VOIDCLOTH			* max_armor		--虚空甲
TUNING.ARMOR_WAGPUNK_HAT			= TUNING.ARMOR_WAGPUNK_HAT			* max_armor		--瓦格头
TUNING.ARMORPUNK					= TUNING.ARMORPUNK					* max_armor		--瓦格甲

--武器耐久  --在此处添加项目

TUNING.RUINS_BAT_USES 				= TUNING.RUINS_BAT_USES 			* max_weapon	--铥人棒
TUNING.BATBAT_USES 					= TUNING.BATBAT_USES 				* max_weapon	--蝙蝠棒
--TUNING.NIGHTSTICK_FUEL 			= TUNING.NIGHTSTICK_FUEL 			* max_weapon
--晨星锤的耐久改为total day time乘以倍率，要不然还是太小
TUNING.NIGHTSTICK_FUEL 				= 30 * 16 							* max_weapon	--晨星锤
TUNING.NIGHTSWORD_USES				= TUNING.NIGHTSWORD_USES			* max_weapon	--影刀
--TUNING.GLASSCUTTER.USES			= TUNING.GLASSCUTTER.USES			* max_weapon	--玻璃刀，这么写似乎有问题
TUNING.STAFF_LUNARPLANT_USES		= TUNING.STAFF_LUNARPLANT_USES		* max_weapon	--亮茄杖
TUNING.SWORD_LUNARPLANT_USES		= TUNING.SWORD_LUNARPLANT_USES		* max_weapon	--亮茄剑
TUNING.VOIDCLOTH_SCYTHE_USES		= TUNING.VOIDCLOTH_SCYTHE_USES		* max_weapon	--暗影镰刀



--充能
	
local function accept_test(inst, item)
	return item ~= nil and (item.prefab == ("nightmarefuel" or "horrorfuel" or "purebrilliance"))	--改这里
end

local function on_accept(inst, giver, item)
	if item ~= nil and (item.prefab == "nightmarefuel" or "horrorfuel" or "purebrilliance") then
		if inst.components.finiteuses ~= nil or inst.components.fueled ~= nil then
			giver.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
			if inst.components.finiteuses ~= nil then
				inst.components.finiteuses:SetPercent(1)
			elseif inst.components.fueled ~= nil then
				inst.components.fueled:SetPercent(1)
			end
		end
	end
end



--修改预制件

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--在此处添加项目

--冰魔杖
AddPrefabPostInit("icestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--火魔杖
AddPrefabPostInit("firestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--传送杖
AddPrefabPostInit("telestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--懒人杖
AddPrefabPostInit("orangestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--星杖
AddPrefabPostInit("yellowstaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--月杖
AddPrefabPostInit("opalstaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--拆迁杖ex
if work_on_green then
	AddPrefabPostInit("greenstaff", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test)
				inst.components.trader.onaccept = on_accept
			end
		end
	end)
end


--重生护符
AddPrefabPostInit("amulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--寒冰护符
AddPrefabPostInit("blueamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--梦魇护符
AddPrefabPostInit("purpleamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--懒人护符
AddPrefabPostInit("orangeamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--魔光护符ex
AddPrefabPostInit("yellowamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.fueled ~= nil then
			inst.components.fueled.accepting = false
		end
		if inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test)
			inst.components.trader.onaccept = on_accept
		end
	end
end)

--偷工减料许可证ex
if work_on_green then
	AddPrefabPostInit("greenamulet", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test)
				inst.components.trader.onaccept = on_accept
			end
		end
	end)
end





-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--在此处添加项目

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

--纯粹辉煌可交易

AddPrefabPostInit("purebrilliance", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.tradable == nil then
			inst:AddComponent("tradable")
		end
	end
end)