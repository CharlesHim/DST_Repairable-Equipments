

local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS

local is_english = GetModConfigData("lang")
local refill_rate = GetModConfigData("rate") or 0.20
local refill_rate_reduction = GetModConfigData("rate_reduction") or 1
local can_be_used = GetModConfigData("usage")
local maximum_use = GetModConfigData("maximum") or 1
local wont_break = GetModConfigData("break")
local work_on_green = GetModConfigData("green")

-- 获取新增的配置参数 @CharlesHim
local max_armor = GetModConfigData("max_armor")
local max_weapon = GetModConfigData("max_weapon")



	--Maximum Capacity/最大容量	--完工

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
	TUNING.MULTITOOL_AXE_PICKAXE_USES = TUNING.MULTITOOL_AXE_PICKAXE_USES * maximum_use	--@CharlesHim 多用斧镐
	TUNING.TORNADOSTAFF_USES = TUNING.TORNADOSTAFF_USES * maximum_use	--@CharlesHim 天气棒
	
	if work_on_green then
		TUNING.GREENAMULET_USES = TUNING.GREENAMULET_USES * maximum_use
	end	
end



	-- @CharlesHim 护甲武器容量	--完工
	
if max_armor < 999 then
	TUNING.ARMOR_SKELETONHAT = TUNING.ARMOR_SKELETONHAT * max_armor
	TUNING.ARMOR_RUINSHAT = TUNING.ARMOR_RUINSHAT * max_armor
	TUNING.ARMORRUINS = TUNING.ARMORRUINS * max_armor
end
if max_weapon < 999 then
	TUNING.RUINS_BAT_USES = TUNING.RUINS_BAT_USES * max_weapon
	TUNING.BATBAT_USES = TUNING.BATBAT_USES * max_weapon
	--TUNING.NIGHTSTICK_FUEL = TUNING.NIGHTSTICK_FUEL * max_weapon
	TUNING.NIGHTSTICK_FUEL = 30 * 16 * max_weapon	--@CharlesHim 晨星锤的耐久改为total day time乘以倍率，要不然还是太小
end



modimport("scripts/staff_import")
modimport("scripts/amulet_import")



	--No Consumption/装备无消耗	--待加上max_weapon和max_armor的判定

if maximum_use == 999 then
	AddComponentPostInit("finiteuses", function(Finiteuses, inst)	
		-- 给 "finiteuses" 组件添加一个后初始化函数，给使用按次数计的道具用，如法杖
		Finiteuses.oldUseFn_consumption_on = Finiteuses.Use			-- 保存原来的 Use 函数

		-- 重写 Use 函数 
		function Finiteuses:Use(num)
			if self.inst:HasTag("no_equipment_consumption") then	-- 检查实例是否有 "no_e._c." 标签
				return												-- 如果有，则不执行任何操作
			else
				return Finiteuses:oldUseFn_consumption_on(num)		-- 否则，调用原来的 Use 函数
			end
		end
	end)	
	AddComponentPostInit("fueled", function(Fueled, inst)			
		-- 同上，但是fueled组件，给魔光护符这类消耗燃料或消耗持续时间的prefab用
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

if wont_break then	-- wont_break是空耐久不损毁的选项
	AddComponentPostInit("finiteuses", function(FiniteUses, inst)	-- 给 "finiteuses" 组件添加一个后初始化函数
		FiniteUses.oldSetUsesFn_durability_fix = FiniteUses.SetUses	-- 保存原来的 SetUses 函数
		-- 重写 SetUses 函数
		function FiniteUses:SetUses(val)
			if self.inst:HasTag("durability_fix") then				-- 检查实例是否有 "durability_fix" 标签
				local was_positive = self.current > 0				-- 把“是否曾是正数”定义为“当前值是否曾大于0”以暂存这个值
				self.current = val									-- 更新 self.current 的值
				if self.current <= 0 then
					self.current = 0								-- 如果 self.current 现在小于等于 0，则将其设为 0
					if was_positive then							-- 并再次判断是否曾是正数
						self.inst:AddTag("usesdepleted")			-- 如果是 则加上“usesdepleted”标签 表示已经耗尽耐久
						if self.onfinished ~= nil then				-- 如果该物品有耗尽后会执行的操作，执行之
							self.onfinished(self.inst)
						end
					end
				elseif not was_positive then	-- 如果之前就已经耗尽燃料，那么说明刚刚进行的SetUses操作一定是在给空耐久的道具添加燃料
					self.inst:RemoveTag("usesdepleted")				-- 所以删除“已耗尽”标签
				end
				self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})	-- 发送事件通知使用百分比发生变化
			else
				return FiniteUses:oldSetUsesFn_durability_fix(val)	-- 否则，调用原来的 SetUses 函数即可
			end
		end
	end)

	--[[给 “hauntable” 组件添加一个后初始化函数。这个函数会在组件被创建后执行。
	它首先保存了原来的 DoHaunt 函数，然后重写了 DoHaunt 函数。
	新的 DoHaunt 函数会检查实例是否有 “durability_exhausted” 标签:
	如果有，设置 self.haunted 为 true，并执行相应操作；
	否则，调用原来的 DoHaunt 函数。]]
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

