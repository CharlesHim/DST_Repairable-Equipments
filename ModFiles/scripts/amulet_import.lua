

local TUNING = GLOBAL.TUNING
local SpawnPrefab = GLOBAL.SpawnPrefab
local Vector3 = GLOBAL.Vector3
local DEGREES = GLOBAL.DEGREES


local refill_rate = GetModConfigData("rate") or 0.20
local refill_rate_reduction = GetModConfigData("rate_reduction") or 1
local yellow_default = GetModConfigData("yellow_rate")
local can_be_used = GetModConfigData("usage")
local maximum_use = GetModConfigData("maximum") or 1
local wont_break = GetModConfigData("break")
local work_on_green = GetModConfigData("green")

-- @CharlesHim 获取新增的配置参数
local max_armor = GetModConfigData("max_armor")
local max_weapon = GetModConfigData("max_weapon")



	--Only Remove the Function/只有功能被移除
	
local function amulet_break(inst)	-- 当护符耐久耗尽损坏时
	local owner = inst.components.inventoryitem.owner	--将owner（物品的主人）定义为该护符所在物品栏槽位的所有者
	-- 如果有主人、该护符可以被穿戴、该护符正被穿戴
	if owner ~= nil and inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
		if owner.components.talker ~= nil then -- 如果主人可以说话（也许是用来排除韦斯这个角色？）
			-- 根据语言环境说不同的提示语
			if is_english then
				owner.components.talker:Say("Amulet durability exhausted.")
			else
				owner.components.talker:Say("护身符耐久度耗尽。")
			end
		end
		if not owner:HasTag("busy") then	-- 如果主人不繁忙
			owner:PushEvent("toolbroke", {tool = inst}) -- 触发“工具损坏”的event（也许是人物用爆一件装备时的那一下抽搐？）
		end
		
		if inst.prefab == "purpleamulet" then	--是梦魇护符：如果爆装备之后还锁着空san，就解锁空san
			if owner.components.sanity ~= nil then
				owner.components.sanity:SetInducedInsanity(inst, false)
			end
			
		elseif inst.prefab == "yellowamulet" then	--是魔光护符：
			if owner.components.bloomer ~= nil then	-- 如果主人自身有泛光效果
				owner.components.bloomer:PopBloom(inst)	-- 继续泛光
			else
				owner.AnimState:ClearBloomEffectHandle()	--否则清除魔光护符的泛光效果
			end
			if inst._light ~= nil then	-- 如果魔光护符在发光
				if inst._light:IsValid() then	--且光有效（？）
					inst._light:Remove()		-- 移除光
				end
				inst._light = nil	-- 并不再发光
			end
			inst.components.equippable.walkspeedmult = 1	-- 设置魔光护符的移速因数为1x以移除加速
			
		elseif inst.prefab == "greenamulet" then	--是建造护符：如果可行，则将材料消耗倍率改回1x
			if owner.components.builder ~= nil then
				owner.components.builder.ingredientmod = 1
			end
			--[[@NewBing：下面这行代码调用了 inst 对象的 RemoveEventCallback 方法，用于移除一个事件回调。
				它传入了三个参数：事件名称 "consumeingredients"，回调函数 inst.onitembuild 和对象 owner。
				这意味着当 owner 对象触发 "consumeingredients" 事件时，不再调用 inst.onitembuild 函数作为回调。
				具体来说，这行代码的目的是移除一个事件回调，以防止在特定条件下触发某些操作。]]
			--消耗合成材料时不再触发“主人”的“在建造物品时”函数 
			inst:RemoveEventCallback("consumeingredients", inst.onitembuild, owner)
		end
	end
	if inst.prefab == "amulet" then	--是重生护符：如果可行，取消正在进行的任务（回血）并删除任务
	    if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
		
    elseif inst.prefab == "blueamulet" then	--是寒冰护符：被攻击时不再触发冰冻反击；如果有，移除护符的“加热器”（制冷）组件
		inst:RemoveEventCallback("attacked", inst.freezefn, owner)
		if inst.components.heater ~= nil then
			inst:RemoveComponent("heater")
		end
		
	elseif inst.prefab == "orangeamulet" then	--是懒人护符：如果可行，取消正在进行的任务（捡东西）并删除任务
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end	
	end
	inst:AddTag("durability_exhausted")		-- 加上耐久耗尽的标签
	if inst.components.equippable ~= nil then	-- 如果可穿戴
		inst.components.equippable.dapperness = 0	-- 取消回san效果
	end
end



	--Refill/充能

local function accept_test_amulet(inst, item)
	return item ~= nil 
	and (item.prefab == "nightmarefuel" 
	or (inst.prefab == "amulet" and item.prefab == "redgem") 
	or (inst.prefab == "blueamulet" and item.prefab == "bluegem") 
	or (inst.prefab == "purpleamulet" and item.prefab == "purplegem") 
	or (inst.prefab == "yellowamulet" and item.prefab == "yellowgem") 
	or (inst.prefab == "orangeamulet" and item.prefab == "orangegem") 
	or (inst.prefab == "greenamulet" and item.prefab == "greengem"))
end
	
local function on_accept_amulet(inst, giver, item)
	if item ~= nil and (item.prefab == "nightmarefuel" or item:HasTag("gem")) then
		if inst.components.finiteuses ~= nil or inst.components.fueled ~= nil then
			local current_percent = 0
			if inst.components.finiteuses ~= nil then
				current_percent = inst.components.finiteuses:GetPercent()
			elseif inst.components.fueled ~= nil then
				current_percent = inst.components.fueled:GetPercent()
			end
			if current_percent >= 1 then
				if giver.components.talker ~= nil then
					if is_english then
						giver.components.talker:Say("Amulet durability is full already.")
					else
						giver.components.talker:Say("护身符耐久度已满。")
					end
				end
				inst:DoTaskInTime(0.1, function()
					local giveBack = SpawnPrefab(item.prefab)
					local pitPos = Vector3(inst.Transform:GetWorldPosition())
					local pt = pitPos + Vector3(0, 1, 0)
					giveBack.Transform:SetPosition(pt:Get())
					local angle = (math.random() * 360) * DEGREES
					local sp = 3 + math.random()
					giveBack.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 4, sp * math.sin(angle))
					giver.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
				end)
			else
				giver.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
				if current_percent <= 0 then
					if item.prefab == "nightmarefuel" then
						if inst.prefab == "amulet" or inst.prefab == "blueamulet" or inst.prefab == "purpleamulet" then
							current_percent = current_percent + refill_rate
						elseif yellow_default and inst.prefab == "yellowamulet" then
							current_percent = current_percent + 0.375
						else
							if refill_rate_reduction < 1 then
								current_percent = current_percent + refill_rate * refill_rate_reduction
							else
								current_percent = current_percent + refill_rate
							end
						end
						if current_percent >= 0.999 then
							current_percent = 1
						end
					else
						current_percent = 1
					end
					if inst.components.finiteuses ~= nil then
						inst.components.finiteuses:SetPercent(current_percent)
					elseif inst.components.fueled ~= nil then
						inst.components.fueled:SetPercent(current_percent)
					end
					if giver.components.talker ~= nil then
						if is_english then
							if item.prefab == "nightmarefuel" then
								if inst.prefab == "amulet" or inst.prefab == "blueamulet" or inst.prefab == "purpleamulet" then
									giver.components.talker:Say("Amulet durability restored: "..(refill_rate * 100).."%.")
								elseif yellow_default and inst.prefab == "yellowamulet" then
									giver.components.talker:Say("Amulet durability restored: "..(0.375 * 100).."%.")
								else
									if refill_rate_reduction < 1 then
										giver.components.talker:Say("Amulet durability restored: "..(refill_rate * refill_rate_reduction * 100).."%.")
									else
										giver.components.talker:Say("Amulet durability restored: "..(refill_rate * 100).."%.")
									end
								end
							else
								giver.components.talker:Say("The power of gem!")
							end
						else
							if item.prefab == "nightmarefuel" then
								if inst.prefab == "amulet" or inst.prefab == "blueamulet" or inst.prefab == "purpleamulet" then
									giver.components.talker:Say("护身符耐久度恢复："..(refill_rate * 100).."%。")
								elseif yellow_default and inst.prefab == "yellowamulet" then
									giver.components.talker:Say("护身符耐久度恢复："..(0.375 * 100).."%。")
								else
									if refill_rate_reduction < 1 then
										giver.components.talker:Say("护身符耐久度恢复："..(refill_rate * refill_rate_reduction * 100).."%。")
									else
										giver.components.talker:Say("护身符耐久度恢复："..(refill_rate * 100).."%。")
									end
								end
							else
								giver.components.talker:Say("宝石之力！")
							end
						end
					end
					local owner = inst.components.inventoryitem.owner
					if owner ~= nil and inst.components.equippable:IsEquipped() then
						if inst.prefab == "amulet" then
							if can_be_used and inst.onequip_red_old ~= nil then
								inst.onequip_red_old(inst, owner)
							end
						elseif inst.prefab == "blueamulet" then
							if inst.onequip_blue_old ~= nil then
								inst.onequip_blue_old(inst, owner)
							end
							if inst.components.heater == nil then
								inst:AddComponent("heater")
								inst.components.heater:SetThermics(false, true)
								inst.components.heater.equippedheat = TUNING.BLUEGEM_COOLER
							end
						elseif inst.prefab == "purpleamulet" then
							if inst.onequip_purple_old ~= nil then
								inst.onequip_purple_old(inst, owner)
							end
						elseif inst.prefab == "orangeamulet" then
							if can_be_used and inst.onequip_orange_old ~= nil then
								inst.onequip_orange_old(inst, owner)
							end
						elseif inst.prefab == "yellowamulet" then
							if inst.onequip_yellow_old ~= nil then
								inst.onequip_yellow_old(inst, owner)
							end
						elseif inst.prefab == "greenamulet" then
							if can_be_used and inst.onequip_green_old ~= nil then
								inst.onequip_green_old(inst, owner)
							end
						end
					end
					inst:RemoveTag("durability_exhausted")
					if inst.prefab == "purpleamulet" then
						inst.components.equippable.dapperness = -TUNING.DAPPERNESS_MED
					else
						inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
					end
					if inst.prefab == "yellowamulet" then
						inst.components.equippable.walkspeedmult = 1.2
					end
					if inst.components.fueled ~= nil and inst.components.equippable:IsEquipped() then
						inst.components.fueled:StartConsuming()
					end
				else
					if item.prefab == "nightmarefuel" then
						if inst.prefab == "amulet" or inst.prefab == "blueamulet" or inst.prefab == "purpleamulet" then
							current_percent = current_percent + refill_rate
						elseif yellow_default and inst.prefab == "yellowamulet" then
							current_percent = current_percent + 0.375
						else
							if refill_rate_reduction < 1 then
								current_percent = current_percent + refill_rate * refill_rate_reduction
							else
								current_percent = current_percent + refill_rate
							end
						end
						if current_percent >= 0.999 then
							current_percent = 1
						end
					else
						current_percent = 1
					end
					if current_percent >= 1 then
						if inst.components.finiteuses ~= nil then
							inst.components.finiteuses:SetPercent(1)
						elseif inst.components.fueled ~= nil then
							inst.components.fueled:SetPercent(1)
						end
						if giver.components.talker ~= nil then
							if is_english then
								if item.prefab == "nightmarefuel" then
									giver.components.talker:Say("Amulet fully repaired.")
								else
									giver.components.talker:Say("The power of gem!")
								end
							else
								if item.prefab == "nightmarefuel" then
									giver.components.talker:Say("护身符完全修复。")
								else
									giver.components.talker:Say("宝石之力！")
								end
							end
						end
					else
						if inst.components.finiteuses ~= nil then
							inst.components.finiteuses:SetPercent(current_percent)
						elseif inst.components.fueled ~= nil then
							inst.components.fueled:SetPercent(current_percent)
						end
						if giver.components.talker ~= nil then
							if is_english then
								if item.prefab == "nightmarefuel" then
									if inst.prefab == "amulet" or inst.prefab == "blueamulet" or inst.prefab == "purpleamulet" then
										giver.components.talker:Say("Amulet durability restored: "..(refill_rate * 100).."%.")
									elseif yellow_default and inst.prefab == "yellowamulet" then
										giver.components.talker:Say("Amulet durability restored: "..(0.375 * 100).."%.")										
									else
										if refill_rate_reduction < 1 then
											giver.components.talker:Say("Amulet durability restored: "..(refill_rate * refill_rate_reduction * 100).."%.")
										else
											giver.components.talker:Say("Amulet durability restored: "..(refill_rate * 100).."%.")
										end
									end
								else
									giver.components.talker:Say("The power of gem!")
								end
							else
								if item.prefab == "nightmarefuel" then
									if inst.prefab == "amulet" or inst.prefab == "blueamulet" or inst.prefab == "purpleamulet" then
										giver.components.talker:Say("护身符耐久度恢复："..(refill_rate * 100).."%。")
									elseif yellow_default and inst.prefab == "yellowamulet" then
										giver.components.talker:Say("护身符耐久度恢复："..(0.375 * 100).."%。")										
									else
										if refill_rate_reduction < 1 then
											giver.components.talker:Say("护身符耐久度恢复："..(refill_rate * refill_rate_reduction * 100).."%。")
										else
											giver.components.talker:Say("护身符耐久度恢复："..(refill_rate * 100).."%。")
										end
									end
								else
									giver.components.talker:Say("宝石之力！")
								end
							end		
						end
					end
				end
			end
		end
	end
end



	--Load Check/载入检查

local function fuel_function_remove(inst)
	if inst.components.fueled ~= nil and inst.components.fueled:IsEmpty() then
		inst:AddTag("durability_exhausted")
		if inst.prefab == "yellowamulet" then
			if inst.components.equippable ~= nil then
				inst.components.equippable.walkspeedmult = 1
				inst.components.equippable.dapperness = 0
			end
		else
			if inst.components.equippable ~= nil then
				inst.components.equippable.dapperness = 0
			end
		end
	end
end

local function fuel_remove(inst)
	if inst.components.fueled ~= nil and inst.components.fueled:IsEmpty() then
		if not wont_break then
			inst:Remove()
		end
	end
end



	--Onequip Check/佩戴检查

local function amulet_onequip(inst, owner)
	if inst.components.finiteuses ~= nil then
		if (can_be_used == true and inst.components.finiteuses:GetPercent() <= 0) 
		or (can_be_used == false and inst.components.finiteuses:GetUses() < 0.999) then
			local skin_build = inst:GetSkinBuild()
			if skin_build ~= nil then
				owner:PushEvent("equipskinneditem", inst:GetSkinName())
				owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_amulets")
			else
				if inst.prefab == "amulet" then
					owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")
				elseif inst.prefab == "orangeamulet" then
					owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "orangeamulet")
				elseif inst.prefab == "greenamulet" then
					owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "greenamulet")
				end
			end
		else
			if inst.prefab == "amulet" then
				return inst.onequip_red_old(inst, owner)
			elseif inst.prefab == "orangeamulet" then
				return inst.onequip_orange_old(inst, owner)
			elseif inst.prefab == "greenamulet" then
				return inst.onequip_green_old(inst, owner)
			end
		end
	elseif inst.components.fueled ~= nil then
		if inst.components.fueled:IsEmpty() then
			local skin_build = inst:GetSkinBuild()
			if skin_build ~= nil then
				owner:PushEvent("equipskinneditem", inst:GetSkinName())
				owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_amulets")
			else
				if inst.prefab == "blueamulet" then
					owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "blueamulet")
				elseif inst.prefab == "purpleamulet" then
					owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "purpleamulet")
				elseif inst.prefab == "yellowamulet" then
					owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "yellowamulet")
				end
			end
		else
			if inst.prefab == "blueamulet" then
				return inst.onequip_blue_old(inst, owner)
			elseif inst.prefab == "purpleamulet" then
				return inst.onequip_purple_old(inst, owner)
			elseif inst.prefab == "yellowamulet" then
				return inst.onequip_yellow_old(inst, owner)
			end
		end
	end
end

local function amulet_onunequip(inst, owner)
	if inst.prefab == "blueamulet" then
		if inst.components.fueled ~= nil then
			if inst.components.fueled:IsEmpty() then
				owner.AnimState:ClearOverrideSymbol("swap_body")
			else
				return inst.onunequip_blue_old(inst, owner)
			end
		end
	elseif inst.prefab == "greenamulet" then
		if inst.components.finiteuses ~= nil then
			if (can_be_used == true and inst.components.finiteuses:GetPercent() <= 0) 
			or (can_be_used == false and inst.components.finiteuses:GetUses() < 0.999) then
				owner.AnimState:ClearOverrideSymbol("swap_body")
			else
				return inst.onunequip_green_old(inst, owner)
			end
		end		
    end
end



	--Add or Lose Function/添加或移除功能
	
local function lose_function_amulet(inst)
	if inst.components.finiteuses ~= nil and inst.components.finiteuses:GetPercent() > 0 then
		if inst.components.finiteuses:GetUses() < 0.999 then
			if inst.prefab == "amulet" then
				if inst.task ~= nil then
					inst.task:Cancel()
					inst.task = nil
				end
			elseif inst.prefab == "orangeamulet" then
				if inst.task ~= nil then
					inst.task:Cancel()
					inst.task = nil
				end	
			elseif inst.prefab == "greenamulet" then
				local owner = inst.components.inventoryitem.owner
				if owner ~= nil and inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
					if inst.onitembuild ~= nil then
						owner.components.builder.ingredientmod = 1
						inst:RemoveEventCallback("consumeingredients", inst.onitembuild, owner)
					end
				end
			end
			if inst.components.finiteuses:GetUses() < 0.001 then
				inst.components.finiteuses:SetPercent(0)
			end
		else
			local owner = inst.components.inventoryitem.owner
			if owner ~= nil and inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
				if inst.prefab == "amulet" then
					if inst.task == nil and inst.onequip_red_old ~= nil then
						inst.onequip_red_old(inst, owner)
					end
				elseif inst.prefab == "orangeamulet" then
					if inst.task == nil and inst.onequip_orange_old ~= nil then
						inst.onequip_orange_old(inst, owner)
					end
				elseif inst.prefab == "greenamulet" then
					if owner.components.builder ~= nil and owner.components.builder.ingredientmod >= 1 and inst.onequip_green_old ~= nil then
						inst.onequip_green_old(inst, owner)
					end
				end
			end
		end
	end
end



	--Modify prefab file/修改预制件
	
		--Red/红

AddPrefabPostInit("amulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_amulet)
			inst.components.trader.onaccept = on_accept_amulet
		end
		if inst.components.equippable ~= nil then
			inst.onequip_red_old = inst.components.equippable.onequipfn
			inst.components.equippable:SetOnEquip(amulet_onequip)
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(amulet_break)
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_amulet)
				inst:DoTaskInTime(0, lose_function_amulet)
			end
		end
	end
end)

		--Blue/蓝

AddPrefabPostInit("blueamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_amulet)
			inst.components.trader.onaccept = on_accept_amulet
		end
		if inst.components.fueled ~= nil then
			if wont_break then
				inst.components.fueled:SetDepletedFn(amulet_break)
				if inst.components.equippable ~= nil then
					inst.onequip_blue_old = inst.components.equippable.onequipfn
					inst.onunequip_blue_old = inst.components.equippable.onunequipfn
					inst.components.equippable:SetOnEquip(amulet_onequip)
					inst.components.equippable:SetOnUnequip(amulet_onunequip)
				end
				inst:DoTaskInTime(0, fuel_function_remove)
			else
				inst:DoTaskInTime(0, fuel_remove)
			end
		end
	end
end)

		--Purple/紫

AddPrefabPostInit("purpleamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_amulet)
			inst.components.trader.onaccept = on_accept_amulet
		end
		if inst.components.fueled ~= nil then
			if wont_break then
				inst.components.fueled:SetDepletedFn(amulet_break)
				if inst.components.equippable ~= nil then
					inst.onequip_purple_old = inst.components.equippable.onequipfn
					inst.components.equippable:SetOnEquip(amulet_onequip)
				end
				inst:DoTaskInTime(0, fuel_function_remove)
			else
				inst:DoTaskInTime(0, fuel_remove)
			end
		end
	end
end)

		--Orange/橙

AddPrefabPostInit("orangeamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_amulet)
			inst.components.trader.onaccept = on_accept_amulet
		end
		if inst.components.equippable ~= nil then
			inst.onequip_orange_old = inst.components.equippable.onequipfn
			inst.components.equippable:SetOnEquip(amulet_onequip)
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(amulet_break)
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_amulet)
				inst:DoTaskInTime(0, lose_function_amulet)
			end
		end
	end
end)

		--Yellow/黄

AddPrefabPostInit("yellowamulet", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if inst.components.fueled ~= nil then
			inst.components.fueled.accepting = false
		end
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_amulet)
			inst.components.trader.onaccept = on_accept_amulet
		end
		if inst.components.fueled ~= nil then
			if wont_break then
				inst.components.fueled:SetDepletedFn(amulet_break)
				if inst.components.equippable ~= nil then
					inst.onequip_yellow_old = inst.components.equippable.onequipfn
					inst.components.equippable:SetOnEquip(amulet_onequip)
				end
				inst:DoTaskInTime(0, fuel_function_remove)
			else
				inst:DoTaskInTime(0, fuel_remove)
			end
		end
	end
end)

		--Green/绿

if work_on_green then

			--Construction Amulet Icon/建造护符图标

	local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
	local require = GLOBAL.require
	local recipe_popup = require "widgets/recipepopup"
	local recipe_popup_refresh = recipe_popup.Refresh

	function recipe_popup:Refresh()
		recipe_popup_refresh(self)
		local owner = self.owner
		if owner == nil then
			return false
		end
		local equipped_body = owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if equipped_body ~= nil and equipped_body.prefab == "greenamulet" then
			if owner.replica.inventory:EquipHasTag("greenamulet_no_durability") then
				self.amulet:Hide()
			else
				self.amulet:Show()
			end
		end
	end
	
	local function update_icon_tag(inst)
		if (can_be_used == true and inst.components.finiteuses:GetPercent() <= 0) 
		or (can_be_used == false and inst.components.finiteuses:GetUses() < 0.999) then
			inst:AddTag("greenamulet_no_durability")
		else
			inst:RemoveTag("greenamulet_no_durability")
		end
	end
	
	AddPrefabPostInit("greenamulet", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if maximum_use == 999 then
				inst:AddTag("no_equipment_consumption")
			end
			if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test_amulet)
				inst.components.trader.onaccept = on_accept_amulet
			end
			if inst.components.equippable ~= nil then
				inst.onequip_green_old = inst.components.equippable.onequipfn
				inst.onunequip_green_old = inst.components.equippable.onunequipfn
				inst.components.equippable:SetOnEquip(amulet_onequip)
				inst.components.equippable:SetOnUnequip(amulet_onunequip)
			end
			if inst.components.finiteuses ~= nil then
				if wont_break then
					inst:AddTag("durability_fix")
					inst.components.finiteuses:SetOnFinished(amulet_break)
				end
				if not can_be_used then
					inst:ListenForEvent("percentusedchange", lose_function_amulet)
					inst:DoTaskInTime(0, lose_function_amulet)
				end
				inst:ListenForEvent("percentusedchange", update_icon_tag)
				inst:DoTaskInTime(0, update_icon_tag)
			end
		end
	end)
end

