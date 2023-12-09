--写给想维护这个mod的小可爱的维护指南
--@瑶光 @2023.12.09
--上传前务必修改两处版本号、一处更新日期
--有空写写readme也挺不错哦

name = "Refill+"
description = 
[[
- 本模组仍在接手开发中……
- 版本号：v3.0.0
- 最近更新：2023.12.09
]]
author = "瑶光"                     --作者
version = "3.0.0"                   --版本号，每次更新必须改

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
        label = "道具耐久倍率",
		hover = "。。。",
        options =
        {
			{description = "20%", 				data = 0.2,		hover = "默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "默认值的50%"},
			{description = "默认", 		        data = 1,		hover = "默认值"},
			{description = "150%", 				data = 1.5,		hover = "默认值的150%"},
			{description = "200%", 				data = 2,		hover = "默认值的200%"},
			{description = "250%", 				data = 2.5,		hover = "默认值的250%"},
			{description = "300%", 				data = 3,		hover = "默认值的300%"},
            {description = "400%", 				data = 4,		hover = "默认值的400%"},
            {description = "500%", 				data = 5,		hover = "默认值的500%"},
			{description = "1000%", 			data = 10,		hover = "默认值的1000%"},
        },
        default = 2.5,
	},
	{
		name = "max_armor",
        label = "护甲耐久倍率",
		hover = "。。。",
        options =
        {
			{description = "20%", 				data = 0.2,		hover = "默认值的20%"},
			{description = "50%", 				data = 0.5,		hover = "默认值的50%"},
			{description = "默认", 	        	data = 1,		hover = "默认值"},
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
	label = "武器耐久倍率",
	hover = "。。。",
	options =
	{
		{description = "20%", 				data = 0.2,		hover = "默认值的20%"},
		{description = "50%", 				data = 0.5,		hover = "默认值的50%"},
		{description = "默认", 	           	data = 1,		hover = "默认值"},
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
        name = "green",
        label = "绿宝石装备",
		hover = "模组是否对绿宝石装备生效",
        options =
        {
            {description = "否", 	data = false, 	hover = "模组对绿宝石装备不生效"},
			{description = "是", 	data = true, 	hover = "模组对绿宝石装备生效"},
        },
        default = false,
    },
}
