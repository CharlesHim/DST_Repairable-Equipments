

local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS

local is_english = GetModConfigData("lang")
local refill_rate = GetModConfigData("rate") or 0.20
local refill_rate_reduction = GetModConfigData("rate_reduction") or 1
local can_be_used = GetModConfigData("usage")
local maximum_use = GetModConfigData("maximum") or 1
local wont_break = GetModConfigData("break")
local work_on_green = GetModConfigData("green")

-- 瑶光：获取新增的配置参数
local max_armor = GetModConfigData("max_armor")
local max_weapon = GetModConfigData("max_weapon")



	--Maximum Capacity/最大容量

if maximum_use < 999 then
	TUNING.ICESTAFF_USES = TUNING.ICESTAFF_USES * maximum_use	
	TUNING.FIRESTAFF_USES = TUNING.FIRESTAFF_USES * maximum_use
	TUNING.TELESTAFF_USES = TUNING.TELESTAFF_USES * maximum_use
	TUNING.ORANGESTAFF_USES = TUNING.ORANGESTAFF_USES * maximum_use
	TUNING.YELLOWSTAFF_USES = TUNING.YELLOWSTAFF_USES * maximum_use
	TUNING.OPALSTAFF_USES = TUNING.OPALSTAFF_USES * maximum_use
	
	if work_on_green then
		TUNING.GREENSTAFF_USES = TUNING.GREENSTAFF_USES * maximum_use
	end
	
	TUNING.REDAMULET_USES = TUNING.REDAMULET_USES * maximum_use
	TUNING.BLUEAMULET_FUEL = TUNING.BLUEAMULET_FUEL * maximum_use
	TUNING.PURPLEAMULET_FUEL = TUNING.PURPLEAMULET_FUEL * maximum_use
	TUNING.YELLOWAMULET_FUEL = TUNING.YELLOWAMULET_FUEL * maximum_use
	TUNING.ORANGEAMULET_USES = TUNING.ORANGEAMULET_USES * maximum_use
	TUNING.MULTITOOL_AXE_PICKAXE_USES = TUNING.MULTITOOL_AXE_PICKAXE_USES * maximum_use	--瑶光：多用斧镐
	TUNING.TORNADOSTAFF_USES = TUNING.TORNADOSTAFF_USES * maximum_use	--瑶光：天气棒
	
	if work_on_green then
		TUNING.GREENAMULET_USES = TUNING.GREENAMULET_USES * maximum_use
	end	
end



	-- 瑶光：护甲武器容量
	
if max_armor < 999 then
	TUNING.ARMOR_SKELETONHAT = TUNING.ARMOR_SKELETONHAT * max_armor
	TUNING.ARMOR_RUINSHAT = TUNING.ARMOR_RUINSHAT * max_armor
	TUNING.ARMORRUINS = TUNING.ARMORRUINS * max_armor
end
if max_weapon < 999 then
	TUNING.RUINS_BAT_USES = TUNING.RUINS_BAT_USES * max_weapon
	TUNING.BATBAT_USES = TUNING.BATBAT_USES * max_weapon
	--TUNING.NIGHTSTICK_FUEL = TUNING.NIGHTSTICK_FUEL * max_weapon
	TUNING.NIGHTSTICK_FUEL = 30 * 16 * max_weapon	--瑶光：晨星锤的耐久改为total day time乘以倍率，要不然还是太小
end



modimport("scripts/staff_import")
modimport("scripts/amulet_import")


	--No Consumption/装备无消耗

if maximum_use == 999 then
	AddComponentPostInit("finiteuses", function(Finiteuses, inst)
		Finiteuses.oldUseFn_consumption_on = Finiteuses.Use
		function Finiteuses:Use(num)
			if self.inst:HasTag("no_equipment_consumption") then
				return
			else
				return Finiteuses:oldUseFn_consumption_on(num)
			end
		end
	end)	
	AddComponentPostInit("fueled", function(Fueled, inst)
		Fueled.oldStartConsumingFn_consumption_on = Fueled.StartConsuming
		function Fueled:StartConsuming()
			if self.inst:HasTag("no_equipment_consumption") then
				return
			else
				return Fueled:oldStartConsumingFn_consumption_on()
			end
		end
	end)
end

	--Zero Durability Related/零耐久相关

if wont_break then
	AddComponentPostInit("finiteuses", function(FiniteUses, inst)
		FiniteUses.oldSetUsesFn_durability_fix = FiniteUses.SetUses
		function FiniteUses:SetUses(val)
			if self.inst:HasTag("durability_fix") then
				local was_positive = self.current > 0
				self.current = val
				if self.current <= 0 then
					self.current = 0
					if was_positive then
						self.inst:AddTag("usesdepleted")
						if self.onfinished ~= nil then
							self.onfinished(self.inst)
						end
					end
				elseif not was_positive then
					self.inst:RemoveTag("usesdepleted")
				end
				self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
			else
				return FiniteUses:oldSetUsesFn_durability_fix(val)
			end
		end
	end)
	AddComponentPostInit("hauntable", function(Hauntable, inst)
		Hauntable.oldDoHauntFn_no_durability = Hauntable.DoHaunt
		function Hauntable:DoHaunt(doer)
			if self.inst:HasTag("durability_exhausted") then
				self.haunted = true
				self.cooldowntimer = self.cooldown or TUNING.HAUNT_COOLDOWN_SMALL
				self:StartFX(true)
				self:StartShaderFx()
				self.inst:StartUpdatingComponent(self)
				return
			else
				return Hauntable:oldDoHauntFn_no_durability(doer)
			end
		end
	end)
end

	--Nightmare Fuel Tradable/噩梦燃料可交易

if refill_rate > 0 then
	AddPrefabPostInit("nightmarefuel", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.tradable == nil then
				inst:AddComponent("tradable")
			end
		end
	end)
end

