require("engine.develop.devdefine")

--通知
NOTICE = { 
	--common
	UnKnow = 0,		    	--未知错误,请联系客服。
    AccountRepeat = 1,    	--注册账号重复
	TokenError = 2,			--账号验证过期，请重新登录。
    Maintained = 3,			--服务器维护中
	LoginError = 4,       	--登录错误
	RepeatLogin = 5,	    --重复登录。
	AnotherPlaceLogin = 6,	--异地登录
	--game
}

--配置表
CFG = {
	ITEM = "Item",
}

--排行榜类型
RANK = {
	GO = 1,
	GRADE = 1,			--段位排行榜
	GRADEHISTORY = 2,	--历史段位排行榜
	END = 2,
}
--排行榜表名
RANKTAB = {}
RANKTAB[RANK.GRADE] = "rankgrade"
RANKTAB[RANK.GRADEHISTORY] = "historyrankgrade"
--排行榜刷新间隔(秒)
RANKREFRESH = 60