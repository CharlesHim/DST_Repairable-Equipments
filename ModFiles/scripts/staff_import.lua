

local TUNING = GLOBAL.TUNING
local SpawnPrefab = GLOBAL.SpawnPrefab
local Vector3 = GLOBAL.Vector3
local DEGREES = GLOBAL.DEGREES

local is_english = GetModConfigData("lang")
local refill_rate = GetModConfigData("rate") or 0.20
local refill_rate_reduction = GetModConfigData("rate_reduction") or 1
local can_be_used = GetModConfigData("usage")
local maximum_use = GetModConfigData("maximum") or 1
local wont_break = GetModConfigData("break")
local work_on_green = GetModConfigData("green")

-- @CharlesHim 获取新增的配置参数
local max_armor = GetModConfigData("max_armor")
local max_weapon = GetModConfigData("max_weapon")


	--Only Remove the Function/只有功能被移除
	
local function staff_break(inst)
	local owner = inst.components.inventoryitem.owner
	if owner ~= nil and inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
		if owner.components.talker ~= nil then
			if is_english then
				owner.components.talker:Say("Durability exhausted.")
			else
				owner.components.talker:Say("耐久度耗尽。")
			end
		end
		if not owner:HasTag("busy") then
			owner:PushEvent("toolbroke", {tool = inst})
		end
	end
	if inst.components.weapon ~= nil then
		inst:RemoveComponent("weapon")
	end
	if inst.components.spellcaster ~= nil then
		inst.components.spellcaster.canuseontargets = false
		inst.components.spellcaster.canusefrominventory = false
		inst.components.spellcaster.canonlyuseonlocomotorspvp = false
		inst.components.spellcaster.canuseonpoint = false
		inst.components.spellcaster.canuseonpoint_water = false
		inst.components.spellcaster.canonlyuseonrecipes = false
	end
	if inst.prefab == "orangestaff" then
		if not can_be_used then
			inst.shouldwork = false
		end
		inst:UnregisterComponentActions("blinkstaff")
		if inst.components.equippable ~= nil then
			inst.components.equippable.walkspeedmult = 1
		end
	end
	inst:AddTag("durability_exhausted")
end

	--Refill/充能
	
local function onattack_blue_new(inst, attacker, target, skipsanity)
	return inst.onattack_blue_old(inst, attacker, target, skipsanity)
end

local function onattack_red_new(inst, attacker, target, skipsanity)
	return inst.onattack_red_old(inst, attacker, target, skipsanity)
end
	
local function accept_test_staff(inst, item)
	return item ~= nil 
	and (item.prefab == "nightmarefuel"
	or (inst.prefab == "icestaff" and item.prefab == "bluegem") 
	or (inst.prefab == "firestaff" and item.prefab == "redgem") 
	or (inst.prefab == "telestaff" and item.prefab == "purplegem") 
	or (inst.prefab == "yellowstaff" and item.prefab == "yellowgem") 
	or (inst.prefab == "orangestaff" and item.prefab == "orangegem") 
	or (inst.prefab == "greenstaff" and item.prefab == "greengem")
	or (inst.prefab == "opalstaff" and item.prefab == "opalpreciousgem"))
end

local function on_accept_staff(inst, giver, item)
	if item ~= nil and (item.prefab == "nightmarefuel" or item:HasTag("gem")) then
		if inst.components.finiteuses ~= nil then
			local current_percent = inst.components.finiteuses:GetPercent()
			if current_percent >= 1 then
				if giver.components.talker ~= nil then
					if is_english then
						giver.components.talker:Say("Durability is full already.")
					else
						giver.components.talker:Say("耐久度已满。")
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
						if inst.prefab == "icestaff" or inst.prefab == "firestaff" or inst.prefab == "telestaff" then
							current_percent = current_percent + refill_rate
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
					inst.components.finiteuses:SetPercent(current_percent)
					if giver.components.talker ~= nil then
						if is_english then
							if item.prefab == "nightmarefuel" then
								if inst.prefab == "icestaff" or inst.prefab == "firestaff" or inst.prefab == "telestaff" then
									giver.components.talker:Say("Durability restored: "..(refill_rate * 100).."%.")
								else
									if refill_rate_reduction < 1 then
										giver.components.talker:Say("Durability restored: "..(refill_rate * refill_rate_reduction * 100).."%.")
									else
										giver.components.talker:Say("Durability restored: "..(refill_rate * 100).."%.")
									end
								end
							else
								giver.components.talker:Say("The power of gem!")
							end
						else
							if item.prefab == "nightmarefuel" then
								if inst.prefab == "icestaff" or inst.prefab == "firestaff" or inst.prefab == "telestaff" then
									giver.components.talker:Say("耐久度恢复："..(refill_rate * 100).."%。")
								else
									if refill_rate_reduction < 1 then
										giver.components.talker:Say("耐久度恢复："..(refill_rate * refill_rate_reduction * 100).."%。")
									else
										giver.components.talker:Say("耐久度恢复："..(refill_rate * 100).."%。")
									end
								end
							else
								giver.components.talker:Say("宝石之力！")
							end
						end
					end
					if can_be_used then
						if inst.prefab == "icestaff" then
							if inst.components.weapon == nil then
								inst:AddComponent("weapon")
								inst.components.weapon:SetDamage(0)
								inst.components.weapon:SetRange(8, 10)
								inst.components.weapon:SetOnAttack(onattack_blue_new)
								inst.components.weapon:SetProjectile("ice_projectile")							
							end
						elseif inst.prefab == "firestaff" then
							if inst.components.weapon == nil then
								inst:AddComponent("weapon")
								inst.components.weapon:SetDamage(0)
								inst.components.weapon:SetRange(8, 10)
								inst.components.weapon:SetOnAttack(onattack_red_new)
								inst.components.weapon:SetProjectile("fire_projectile")
							end
						elseif inst.prefab == "telestaff" then
							if inst.components.spellcaster ~= nil then
								inst.components.spellcaster.canuseontargets = true
								inst.components.spellcaster.canusefrominventory = true
								inst.components.spellcaster.canonlyuseonlocomotorspvp = true
							end
						elseif inst.prefab == "yellowstaff" or inst.prefab == "opalstaff" then
							if inst.components.spellcaster ~= nil then
								inst.components.spellcaster.canuseonpoint = true
								inst.components.spellcaster.canuseonpoint_water = true
							end
						elseif inst.prefab == "orangestaff" then
							inst:RegisterComponentActions("blinkstaff")
						elseif inst.prefab == "greenstaff" then
							if inst.components.spellcaster ~= nil then
								inst.components.spellcaster.canuseontargets = true
								inst.components.spellcaster.canonlyuseonrecipes = true
							end
						end
					end
					if inst.prefab == "orangestaff" then
						if inst.components.equippable ~= nil then
							inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
						end
					end
					inst:RemoveTag("durability_exhausted")
				else
					if item.prefab == "nightmarefuel" then
						if inst.prefab == "icestaff" or inst.prefab == "firestaff" or inst.prefab == "telestaff" then
							current_percent = current_percent + refill_rate
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
						inst.components.finiteuses:SetPercent(1)
						if giver.components.talker ~= nil then
							if is_english then
								if item.prefab == "nightmarefuel" then
									giver.components.talker:Say("Fully repaired.")
								else
									giver.components.talker:Say("The power of gem!")
								end
							else
								if item.prefab == "nightmarefuel" then
									giver.components.talker:Say("完全修复。")
								else
									giver.components.talker:Say("宝石之力！")
								end
							end
						end
					else
						inst.components.finiteuses:SetPercent(current_percent)
						if giver.components.talker ~= nil then
							if is_english then
								if item.prefab == "nightmarefuel" then
									if inst.prefab == "icestaff" or inst.prefab == "firestaff" or inst.prefab == "telestaff" then
										giver.components.talker:Say("Durability restored: "..(refill_rate * 100).."%.")
									else
										if refill_rate_reduction < 1 then
											giver.components.talker:Say("Durability restored: "..(refill_rate * refill_rate_reduction * 100).."%.")
										else
											giver.components.talker:Say("Durability restored: "..(refill_rate * 100).."%.")
										end
									end
								else
									giver.components.talker:Say("The power of gem!")
								end
							else
								if item.prefab == "nightmarefuel" then
									if inst.prefab == "icestaff" or inst.prefab == "firestaff" or inst.prefab == "telestaff" then
										giver.components.talker:Say("耐久度恢复："..(refill_rate * 100).."%。")
									else
										if refill_rate_reduction < 1 then
											giver.components.talker:Say("耐久度恢复："..(refill_rate * refill_rate_reduction * 100).."%。")
										else
											giver.components.talker:Say("耐久度恢复："..(refill_rate * 100).."%。")
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

	--Add or Lose Function/添加或移除功能

local function lose_function_staff(inst)
	if inst.components.finiteuses ~= nil and inst.components.finiteuses:GetPercent() > 0 then
		if inst.components.finiteuses:GetUses() < 0.999 then
			if inst.components.weapon ~= nil then
				inst:RemoveComponent("weapon")
			end
			if inst.components.spellcaster ~= nil then
				inst.components.spellcaster.canuseontargets = false
				inst.components.spellcaster.canusefrominventory = false
				inst.components.spellcaster.canonlyuseonlocomotorspvp = false
				inst.components.spellcaster.canuseonpoint = false
				inst.components.spellcaster.canuseonpoint_water = false
				inst.components.spellcaster.canonlyuseonrecipes = false
			end
			if inst.prefab == "orangestaff" and inst.shouldwork == true then
				inst.shouldwork = false
				inst:UnregisterComponentActions("blinkstaff")
			end
			if inst.components.finiteuses:GetUses() < 0.001 then
				inst.components.finiteuses:SetPercent(0)
			end
		else
			if inst.prefab == "icestaff" then
				if inst.components.weapon == nil then
					inst:AddComponent("weapon")
					inst.components.weapon:SetDamage(0)
					inst.components.weapon:SetRange(8, 10)
					inst.components.weapon:SetOnAttack(onattack_blue_new)
					inst.components.weapon:SetProjectile("ice_projectile")							
				end
			elseif inst.prefab == "firestaff" then
				if inst.components.weapon == nil then
					inst:AddComponent("weapon")
					inst.components.weapon:SetDamage(0)
					inst.components.weapon:SetRange(8, 10)
					inst.components.weapon:SetOnAttack(onattack_red_new)
					inst.components.weapon:SetProjectile("fire_projectile")
				end
			elseif inst.prefab == "telestaff" then
				if inst.components.spellcaster ~= nil then
					inst.components.spellcaster.canuseontargets = true
					inst.components.spellcaster.canusefrominventory = true
					inst.components.spellcaster.canonlyuseonlocomotorspvp = true
				end
			elseif inst.prefab == "yellowstaff" or inst.prefab == "opalstaff" then
				if inst.components.spellcaster ~= nil then
					inst.components.spellcaster.canuseonpoint = true
					inst.components.spellcaster.canuseonpoint_water = true
				end
			elseif inst.prefab == "orangestaff" and inst.shouldwork == false then
				inst.shouldwork = true
				inst:RegisterComponentActions("blinkstaff")
			elseif inst.prefab == "greenstaff" then
				if inst.components.spellcaster ~= nil then
					inst.components.spellcaster.canuseontargets = true
					inst.components.spellcaster.canonlyuseonrecipes = true
				end
			end
		end
	end
end

	--Modify Prefab File/修改预制件
	
		--Blue/蓝

AddPrefabPostInit("icestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("nopunch")
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(staff_break)
				if inst.components.weapon ~= nil then
					inst.onattack_blue_old = inst.components.weapon.onattack
				end
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_staff)
				inst:DoTaskInTime(0, lose_function_staff)
			end
		end
	end
end)

		--Red/红
	
AddPrefabPostInit("firestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("nopunch")
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(staff_break)
				if inst.components.weapon ~= nil then
					inst.onattack_red_old = inst.components.weapon.onattack
				end
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_staff)
				inst:DoTaskInTime(0, lose_function_staff)
			end
		end
	end
end)

		--Purple/紫
	
AddPrefabPostInit("telestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(staff_break)
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_staff)
				inst:DoTaskInTime(0, lose_function_staff)
			end
		end
	end
end)

		--Orange/橙

AddPrefabPostInit("orangestaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
		if inst.components.finiteuses ~= nil then
			if not can_be_used then
				inst.shouldwork = true
				inst:ListenForEvent("percentusedchange", lose_function_staff)
				inst:DoTaskInTime(0, lose_function_staff)
			end
			if wont_break then
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(staff_break)
			end
		end
	end
end)

		--Yellow/黄

AddPrefabPostInit("yellowstaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(staff_break)
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_staff)
				inst:DoTaskInTime(0, lose_function_staff)
			end
		end
	end
end)

		--Opalprecious/彩虹

AddPrefabPostInit("opalstaff", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if maximum_use == 999 then
			inst:AddTag("no_equipment_consumption")
		end
		if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
			inst:AddComponent("trader")
			inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
			inst.components.trader.onaccept = on_accept_staff
		end
		if inst.components.finiteuses ~= nil then
			if wont_break then
				inst:AddTag("durability_fix")
				inst.components.finiteuses:SetOnFinished(staff_break)
			end
			if not can_be_used then
				inst:ListenForEvent("percentusedchange", lose_function_staff)
				inst:DoTaskInTime(0, lose_function_staff)
			end
		end
	end
end)

		--Green/绿

if work_on_green then
	AddPrefabPostInit("greenstaff", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if maximum_use == 999 then
				inst:AddTag("no_equipment_consumption")
			end
			if refill_rate > 0 and refill_rate_reduction > 0 and inst.components.trader == nil then
				inst:AddComponent("trader")
				inst.components.trader:SetAbleToAcceptTest(accept_test_staff)
				inst.components.trader.onaccept = on_accept_staff
			end
			if inst.components.finiteuses ~= nil then
				if wont_break then
					inst:AddTag("durability_fix")
					inst.components.finiteuses:SetOnFinished(staff_break)
				end
				if not can_be_used then
					inst:ListenForEvent("percentusedchange", lose_function_staff)
					inst:DoTaskInTime(0, lose_function_staff)
				end
			end
		end
	end)
end

