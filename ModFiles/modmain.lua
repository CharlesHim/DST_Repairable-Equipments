--写给想修改这个mod的小可爱的修改指南
--@瑶光 @2023.12.09
--改耐久：约第30行
--添加填充物：约第90行、230行
--添加被填充的道具：约第150行





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

--特殊：按时间计算的
TUNING.VOIDCLOTH_UMBRELLA_PERISHTIME= 30 * 16 *15						* maximum_use	--虚空伞
TUNING.THURIBLE_FUEL_MAX			= 30 * 16							* maximum_use	--香炉

--特殊：绿宝石装备
if work_on_green then
	TUNING.GREENSTAFF_USES 			= TUNING.GREENSTAFF_USES 			* maximum_use	--拆迁法杖
	TUNING.GREENAMULET_USES 		= TUNING.GREENAMULET_USES 			* maximum_use	--偷工减料许可证
end	

--护甲耐久	--在此处添加项目

TUNING.ARMOR_SANITY					= TUNING.ARMOR_SANITY					* max_armor		--影甲
TUNING.ARMOR_SKELETONHAT 			= TUNING.ARMOR_SKELETONHAT 				* max_armor		--骨头
TUNING.ARMOR_RUINSHAT 				= TUNING.ARMOR_RUINSHAT 				* max_armor		--铥人头
TUNING.ARMORRUINS 					= TUNING.ARMORRUINS 					* max_armor		--铥人甲
TUNING.ARMOR_DREADSTONEHAT			= TUNING.ARMOR_DREADSTONEHAT			* max_armor		--绝望头
TUNING.ARMORDREADSTONE				= TUNING.ARMORDREADSTONE				* max_armor		--绝望甲
TUNING.ARMOR_LUNARPLANT_HAT			= TUNING.ARMOR_LUNARPLANT_HAT			* max_armor		--亮茄头
TUNING.ARMOR_LUNARPLANT				= TUNING.ARMOR_LUNARPLANT				* max_armor		--亮茄甲
TUNING.ARMOR_VOIDCLOTH_HAT			= TUNING.ARMOR_VOIDCLOTH_HAT			* max_armor		--虚空头
TUNING.ARMOR_VOIDCLOTH				= TUNING.ARMOR_VOIDCLOTH				* max_armor		--虚空甲
TUNING.ARMOR_WAGPUNK_HAT			= TUNING.ARMOR_WAGPUNK_HAT				* max_armor		--瓦格头
TUNING.ARMORPUNK					= TUNING.ARMORPUNK						* max_armor		--瓦格甲
TUNING.ARMOR_WATHGRITHR_IMPROVEDHAT	= TUNING.ARMOR_WATHGRITHR_IMPROVEDHAT	* max_armor		--统帅头

--武器耐久  --在此处添加项目

TUNING.RUINS_BAT_USES 				= TUNING.RUINS_BAT_USES 			* max_weapon	--铥人棒
TUNING.BATBAT_USES 					= TUNING.BATBAT_USES 				* max_weapon	--蝙蝠棒
TUNING.NIGHTSWORD_USES				= TUNING.NIGHTSWORD_USES			* max_weapon	--影刀
TUNING.STAFF_LUNARPLANT_USES		= TUNING.STAFF_LUNARPLANT_USES		* max_weapon	--亮茄杖
TUNING.SWORD_LUNARPLANT_USES		= TUNING.SWORD_LUNARPLANT_USES		* max_weapon	--亮茄剑
TUNING.VOIDCLOTH_SCYTHE_USES		= TUNING.VOIDCLOTH_SCYTHE_USES		* max_weapon	--暗影镰刀
TUNING.SPEAR_WATHGRITHR_LIGHTNING_USES				= TUNING.SPEAR_WATHGRITHR_LIGHTNING_USES			* max_weapon	--奔雷矛
TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_USES		= TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_USES	* max_weapon	--充能奔雷矛
TUNING.WATHGRITHR_SHIELD_ARMOR		= TUNING.WATHGRITHR_SHIELD_ARMOR	* max_weapon	--武神盾


--特殊情况

--晨星锤的耐久改为total day time乘以倍率，要不然还是太小
TUNING.NIGHTSTICK_FUEL 				= 30 * 16 							* max_weapon	--晨星锤

--玻璃刀修改后写似乎有问题，先删掉，后面有时间再看看吧
--TUNING.GLASSCUTTER.USES			= TUNING.GLASSCUTTER.USES			* max_weapon	--玻璃刀



--充能
	
local function accept_test(inst, item)
	return item ~= nil and (
		(item.prefab == "nightmarefuel") or 
		(item.prefab == "horrorfuel") or 
		(item.prefab == "purebrilliance")		--改这里
	)
end

local function on_accept(inst, giver, item)
	if item ~= nil and (
		(item.prefab == "nightmarefuel") or 	--改这里
		(item.prefab == "horrorfuel") or 
		(item.prefab == "purebrilliance")
		) then
		if (inst.components.finiteuses ~= nil) or (inst.components.fueled ~= nil) or (inst.components.armor ~= nil) then
			giver.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
			if inst.components.finiteuses ~= nil then
				inst.components.finiteuses:SetPercent(0.99)		--道具充能比，建议不要设为1以防这种特殊情况：
				--设定上当亮茄、虚空、瓦格朋克装备耐久归零时，如果不用对应的装备修复，就会导致无法装备；
				--如果设为1，可能导致装备损坏时被错误的道具补满耐久，
				--因而无法再次使用修复套装使其恢复功能，因此装备就变成了满耐久的垃圾。

			elseif inst.components.fueled ~= nil then
				inst.components.fueled:SetPercent(0.99)			--燃料类充能比，同上
			
			elseif inst.components.armor ~= nil then
				inst.components.armor:SetPercent(0.99)			--护甲类充能比，同上
			end
		end
	end
end
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------
				--	这本是测试阶段发现的一个bug，可以想到的修复方法有以下几种：
				--	
				--	1，使这些装备耐久为0时直接损毁，以统一修复的规则：失手用爆装备后果自负；	
				--		（这样符合饥荒设定上的粗犷风格，但修复套装失去了存在的意义）
				--
				--	2，使这些装备耐久修复时自动移除“已经损毁”的状态；
				--		（这样对玩家过于友好，而且修复套装同样失去了存在的意义）
				--
				--	3，使这些装备无法被本mod修复；
				--		（这是只有王者荣耀程序员才会用的暴力bug修复手段）
				--
				--	所以我选择了第四种方案：使得充能只能充到99%。这样装备用爆后，既保留了方案1
				--	对“失手用爆装备”的惩罚，又使得修复套装成为一个可行的弥补措施。
				--
				--	99% ———— 你再也不能把你在永恒领域饱经摧残的心修补完整。有点小浪漫哦~
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------





--修改预制件

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--在此处添加允许接受燃料的东西
local refill_prefab_list = 
{
	"icestaff",			--冰魔杖
	"firestaff",		--火魔杖
	"telestaff",		--传送杖
	"orangestaff",		--懒人杖
	"yellowstaff",		--星杖
	"opalstaff",		--月杖
	"amulet",			--重生护符
	"blueamulet",		--寒冰护符
	"purpleamulet",		--梦魇护符
	"orangeamulet",		--懒人护符
	"multitool_axe_pickaxe",	--多用斧镐
	"staff_tornado",			--风杖
	"voidcloth_umbrella",		--暗影伞
	"skeletonhat",				--骨头
	"ruinshat", "armorruins", "ruins_bat",		--铥人三件套
	"dreadstonehat", "armordreadstone",			--绝望护甲
	"lunarplanthat", "armor_lunarplant", "sword_lunarplant", "staff_lunarplant",	--亮茄四件套
	"voidclothhat", "armor_voidcloth", "voidcloth_scythe",							--虚空三件套
	"wagpunkhat", "armorwagpunk",	--瓦格朋克套
	"batbat",		--蝙蝠棒
	"glasscutter",	--玻璃刀
	"nightstick",	--晨星锤
	"nightsword", "armor_sanity",	--影刀影甲
	"bernie_inactive", "bernie_active", "bernie_big", --伯尼
	"lighter",	 	--打火机
	"spear_wathgrithr_lightning", "spear_wathgrithr_lightning_charged",	--奔雷矛
	"wathgrithr_shield",		--武神盾
	"wathgrithr_improvedhat",	--统帅头
}

for _, refill_prefab in pairs(refill_prefab_list) do
	AddPrefabPostInit(refill_prefab, function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test)
				inst.components.trader.onaccept = on_accept
			end
		end
	end)
end

--以下为例外

--绿宝石装备们
if work_on_green then	
	--拆迁杖
	AddPrefabPostInit("greenstaff", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test)
				inst.components.trader.onaccept = on_accept
			end
		end
	end)
	--偷工减料许可证
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

--魔光护符，原版自带加燃料功能
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



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--在此处添加用于填充的燃料
local trade_prefab_list = 
{
	"nightmarefuel",	--噩梦燃料
	"horrorfuel",		--纯净恐惧
	"purebrilliance",	--纯粹辉煌
}

for _, trade_prefab in pairs(trade_prefab_list) do
	AddPrefabPostInit(trade_prefab, function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.tradable == nil then
				inst:AddComponent("tradable")
			end
		end
	end)
end
