
name = "Refill"
description = 
[[
- 2023-03-06：尝试加入骨盔、铥头、铥甲、铥棒、天气棒、晨星锤、斧镐、蝙蝠棒的耐久更改。

- 2023-03-05：原模组似乎于2023年3月15日变得不可见或已下架，因此重新上传一份，供好友使用。

- 原模组介绍：法杖和护身符可以被充能、变得更加耐用或易坏、可以在耐久度耗尽时被保留。
]]
author = "瑶光"
version = "2.1.0"

forumthread = ""
api_version = 10

dst_compatible = true
client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
    {
        name = "lang",
        label = "Language/语言",
		hover = "The language you prefer for character speech".."\n你希望角色使用的语言",
        options =
        {
            {description = "English", 	data = true, 	hover = "The character will declare the refill in English"},
            {description = "中文", 		data = false, 	hover = "角色将使用中文对充能进行宣告"},
        },
        default = true,
    },
	{
		name = "rate",
        label = "Refill Rate/充能值",
		hover = "The percentage of durability that can be increased by each nightmare fuel".."\n每一份噩梦燃料可以增加的耐久度百分比",
        options =
        {
			{description = "No Refill/不充能", 		data = 0,		hover = "Equipment can not be refilled/装备不可被充能"},
            {description = "5%", 					data = 0.05,	hover = "Increase by 5%/增加5%"},
            {description = "10%", 					data = 0.10,	hover = "Increase by 10%/增加10%"},
            {description = "20%", 					data = 0.20,	hover = "Increase by 20%/增加20%"},
	        {description = "34%", 					data = 0.34,	hover = "Increase by 34%/增加34%"},
            {description = "50%", 					data = 0.50,	hover = "Increase by 50%/增加50%"},
            {description = "100%", 					data = 1.00,	hover = "Increase by 100%/增加100%"},
        },
        default = 1.00,
	},
	{
		name = "rate_reduction",
        label = "Refill Rate Reduction/充能值削减",
		hover = "Refill rate reduction for rare equipment".."\n削减稀有装备获得的充能值",
        options =
        {
			{description = "No Cut/不削减", 		data = 1,		hover = "No refill rate reduction for rare equipment/不削减稀有装备获得的充能值"},
			{description = "50%", 					data = 0.50,	hover = "Reduce the refill rate of rare equipment by 50%/稀有装备获得的充能值减少50%"},
            {description = "75%", 					data = 0.25,	hover = "Reduce the refill rate of rare equipment by 75%/稀有装备获得的充能值减少75%"},
            {description = "80%", 					data = 0.20,	hover = "Reduce the refill rate of rare equipment by 80%/稀有装备获得的充能值减少80%"},
            {description = "90%", 					data = 0.10,	hover = "Reduce the refill rate of rare equipment by 90%/稀有装备获得的充能值减少90%"},
            {description = "95%", 					data = 0.05,	hover = "Reduce the refill rate of rare equipment by 95%/稀有装备获得的充能值减少95%"},
			{description = "No Refill/不充能", 		data = 0,		hover = "Rare equipment can not be refilled/稀有装备不可被充能"},
        },
        default = 1,
	},
    {
        name = "yellow_rate",
        label = "Magil Refill Rate/魔光充能值",
		hover = "Whether to set the refill of the Magiluminescence to the original standard".."\n是否将魔光护符的充能设为原版标准",
        options =
        {
            {description = "Yes/是", 		data = true, 	hover = "Use the original refill rate (37.5%)/使用系统默认的充能值（37.5%）"},
            {description = "No/否", 		data = false, 	hover = "Do not use the original refill rate/不使用系统默认的充能值"},
        },
        default = false,
    },
    {
        name = "usage",
        label = "Minimum Consumption/最低消耗",
		hover = "Functionality that the remaining usage of the equipment is less than one".."\n装备剩余使用次数小于一时的功能性",
        options =
        {
            {description = "Yes/是", 	data = false, 	hover = "Unusable/不可被使用"},
			{description = "No/否", 	data = true, 	hover = "Can be used/可以被使用"},
        },
        default = true,
    },
	{
		name = "maximum",
        label = "Maximum Capacity/最大容量",
		hover = "The maximum durability of the equipment".."\n装备的耐久度上限",
        options =
        {
			{description = "20%", 				data = 0.2,		hover = "20% of default value/默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "50% of default value/默认值的50%"},
			{description = "Default/默认", 		data = 1,		hover = "Default value/默认值"},
			{description = "150%", 				data = 1.5,		hover = "150% of default value/默认值的150%"},
			{description = "200%", 				data = 2,		hover = "200% of default value/默认值的200%"},
			{description = "250%", 				data = 2.5,		hover = "250% of default value/默认值的250%"},
			{description = "300%", 				data = 3,		hover = "300% of default value/默认值的300%"},
            {description = "400%", 				data = 4,		hover = "400% of default value/默认值的400%"},
            {description = "500%", 				data = 5,		hover = "500% of default value/默认值的500%"},
			{description = "1000%", 			data = 10,		hover = "1000% of default value/默认值的1000%"},
			{description = "Infinity/无限", 	data = 999,		hover = "Equipment won't lose durability/装备不会损失耐久度"},
        },
        default = 2.5,
	},
	-- 瑶光@23-03-16：护甲武器耐久的选项
	{
		name = "max_armor",
        label = "Armor Maximum Capacity/护甲最大容量",
		hover = "The maximum durability of the armor".."\n护甲的耐久度上限",
        options =
        {
			{description = "20%", 				data = 0.2,		hover = "20% of default value/默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "50% of default value/默认值的50%"},
			{description = "Default/默认", 		data = 1,		hover = "Default value/默认值"},
			{description = "150%", 				data = 1.5,		hover = "150% of default value/默认值的150%"},
			{description = "200%", 				data = 2,		hover = "200% of default value/默认值的200%"},
			{description = "250%", 				data = 2.5,		hover = "250% of default value/默认值的250%"},
			{description = "300%", 				data = 3,		hover = "300% of default value/默认值的300%"},
            {description = "400%", 				data = 4,		hover = "400% of default value/默认值的400%"},
            {description = "500%", 				data = 5,		hover = "500% of default value/默认值的500%"},
			{description = "1000%", 			data = 10,		hover = "1000% of default value/默认值的1000%"},
			{description = "Infinity/无限", 	data = 999,		hover = "Equipment won't lose durability/装备不会损失耐久度"},
        },
        default = 1,
	},
	{
	name = "max_weapon",
	label = "Weapon Maximum Capacity/武器最大容量",
	hover = "The maximum durability of the weapon".."\n武器的耐久度上限",
	options =
	{
		{description = "20%", 				data = 0.2,		hover = "20% of default value/默认值的20%"},
		{description = "50%", 				data = 0.5,		hover = "50% of default value/默认值的50%"},
		{description = "Default/默认", 		data = 1,		hover = "Default value/默认值"},
		{description = "150%", 				data = 1.5,		hover = "150% of default value/默认值的150%"},
		{description = "200%", 				data = 2,		hover = "200% of default value/默认值的200%"},
		{description = "250%", 				data = 2.5,		hover = "250% of default value/默认值的250%"},
		{description = "300%", 				data = 3,		hover = "300% of default value/默认值的300%"},
		{description = "400%", 				data = 4,		hover = "400% of default value/默认值的400%"},
		{description = "500%", 				data = 5,		hover = "500% of default value/默认值的500%"},
		{description = "1000%", 			data = 10,		hover = "1000% of default value/默认值的1000%"},
		{description = "Infinity/无限", 	data = 999,		hover = "Equipment won't lose durability/装备不会损失耐久度"},
	},
	default = 1,
},
    {
        name = "break",
        label = "Equipment Retention/装备保留",
		hover = "Whether to keep the equipment when its durability is exhausted".."\n是否在装备耐久度耗尽时保留装备",
        options =
        {
			{description = "Yes/是", 	data = true, 	hover = "Keep the equipment/保留装备"},
            {description = "No/否", 	data = false, 	hover = "Remove the equipment/移除装备"},
        },
        default = true,
    },
    {
        name = "green",
        label = "Green Gem Items/绿宝石装备",
		hover = "Whether the mod work on green gem items".."\n模组是否对绿宝石装备生效",
        options =
        {
            {description = "No/否", 	data = false, 	hover = "Mod does not work on green gem items/模组对绿宝石装备不生效"},
			{description = "Yes/是", 	data = true, 	hover = "Mod works on green gem items/模组对绿宝石装备生效"},
        },
        default = false,
    },
}

