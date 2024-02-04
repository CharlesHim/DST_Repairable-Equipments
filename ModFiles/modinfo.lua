--维护指南
--@瑶光 @2023.12.09
--上传前务必修改版本号、更新日期
version = "3.2.0"                   --版本号，每次更新必须改
local update_date = "2024.2.4"


local cn_name = "装备可修复" 
local en_name = "Repairable Equipments"

local cn_desc = [[
	- 用噩梦燃料、纯粹辉煌、纯净恐惧为特定装备填充耐久至99% 
	- 包括但不限于法杖、护符、玻璃刀，暗影、铥、亮茄、虚空、绝望石装备……
	- 懒得挨个写了，自己试吧，有啥建议可以评论区留言
	- 设置里可以修改是否允许填充绿宝石装备的耐久 
	- 可以修改特定道具、护甲、武器的最大耐久 
	- 
	- 最近更新：
]]
local en_desc = [[
	- Fill the durability of specific equipment to 99% with Nightmare Fuel, Pure Horror, Pure Brilliance.
	- Works on staffs, amulets, glasscuttrt, shadow, ancitent, brightshade, void, nightmare, dreadstone equipments...
	- I'm lazy to write it all, have a try or check the source code.
	- Any suggestions can be left in the comment section.
	- You can modify whether to allow filling the durability of green gem equipment.
	- You can also modify the maximum durability of specific items, armor, weapons.
	- 
	- Recent update:
]]

local cn_version = "版本号: " .. version
local en_version = "Version: " .. version

-- 简介翻译


if locale == "zh" then
	name = cn_name
	description = cn_version .. "\n" .. cn_desc .. update_date .. "\n"
else
	name = en_name
	description = en_version .. "\n" .. en_desc .. update_date .. "\n"
end


author = "瑶光"                     --作者
forumthread = ""                    --科雷论坛的thread网址
api_version = 10                    --api兼容性检查用的，当前为10，不写10会报“mod过期”

dst_compatible = true               --与联机版兼容
client_only_mod = false             --不是客户端模组
all_clients_require_mod = true      --所有客户端都需要该模组

icon_atlas = "modicon.xml"          --图标
icon = "modicon.tex"

configuration_options =             --配置选项
{
	{
		name = "maximum",
        label = "道具耐久倍率 / Durability Multiplier for Items",
		hover = "不建议改得太离谱",
        options =
        {
			{description = "20%", 				data = 0.2,		hover = "默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "默认值的50%"},
			{description = "默认/Default",		data = 1,		hover = "默认值"},
			{description = "150%", 				data = 1.5,		hover = "默认值的150%"},
			{description = "200%", 				data = 2,		hover = "默认值的200%"},
			{description = "250%", 				data = 2.5,		hover = "默认值的250%"},
			{description = "300%", 				data = 3,		hover = "默认值的300%"},
            {description = "400%", 				data = 4,		hover = "默认值的400%"},
            {description = "500%", 				data = 5,		hover = "默认值的500%"},
			{description = "1000%", 			data = 10,		hover = "默认值的1000%"},
        },
        default = 2,
	},
	{
		name = "max_armor",
        label = "护甲耐久倍率 / Multiplier for Armors",
		hover = "不建议修改得太离谱",
        options =
        {
			{description = "20%", 				data = 0.2,		hover = "默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "默认值的50%"},
			{description = "默认/Default",		data = 1,		hover = "默认值"},
			{description = "150%", 				data = 1.5,		hover = "默认值的150%"},
			{description = "200%", 				data = 2,		hover = "默认值的200%"},
			{description = "250%", 				data = 2.5,		hover = "默认值的250%"},
			{description = "300%", 				data = 3,		hover = "默认值的300%"},
            {description = "400%", 				data = 4,		hover = "默认值的400%"},
            {description = "500%", 				data = 5,		hover = "默认值的500%"},
			{description = "1000%", 			data = 10,		hover = "默认值的1000%"},
        },
        default = 1,
	},
	{
		name = "max_weapon",
		label = "武器耐久倍率 / Multiplier for Weapons",
		hover = "不建议修改得太离谱",
		options =
		{
			{description = "20%", 				data = 0.2,		hover = "默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "默认值的50%"},
			{description = "默认/Default",		data = 1,		hover = "默认值"},
			{description = "150%", 				data = 1.5,		hover = "默认值的150%"},
			{description = "200%", 				data = 2,		hover = "默认值的200%"},
			{description = "250%", 				data = 2.5,		hover = "默认值的250%"},
			{description = "300%", 				data = 3,		hover = "默认值的300%"},
			{description = "400%", 				data = 4,		hover = "默认值的400%"},
			{description = "500%", 				data = 5,		hover = "默认值的500%"},
			{description = "1000%", 			data = 10,		hover = "默认值的1000%"},
		},
		default = 1,
	},
    {
        name = "work_on_green_gem_equipments",
        label = "对绿宝石装备生效 / Work on Greengem Equipments ",
		hover = "是否对绿宝石装备生效",
        options =
        {
            {description = "否/NO", 	data = false, 	hover = "模组对绿宝石装备不生效"},
			{description = "是/YES", 	data = true, 	hover = "模组对绿宝石装备生效，不建议开启，影响平衡"},
        },
        default = false,
    },
	{
		name = "dont_drop_box_on_open",
		label = "开箱不掉落 / Don't Drop Containers on Open in Inventory",
		hover = "打开物品栏里的容器时，容器不掉落到地上",
        options =
        {
            {description = "是/YES", 	data = true, 	hover = "打开容器时容器不掉落"},
			{description = "否/NO", 	data = false, 	hover = "打开容器时容器掉落"},
        },
        default = true,
	}
}
