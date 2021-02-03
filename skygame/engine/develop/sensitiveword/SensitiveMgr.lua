--[[
功能: 屏蔽字过滤
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
local SensitiveMgr = class('SensitiveMgr')

function SensitiveMgr:ctor()
	self.warnlist = {}
	self:LoadData()
end

--初始化结构
function SensitiveMgr:LoadData()
	--敏感词库
	local file = assert(io.open("res/keywords.txt",'r'))--[[r表示读取的权限(read)，a表示追加(append),w表示写的权限(write),b表示打开二进制(binary)]]
	for line in file:lines() do
		self.warnlist[string.lower(line)] = true
	end
	file:close()
end

function SensitiveMgr:Check(str)
	str = string.lower(str)
	for i=1, #str do
		for j=i, #str do
			if self.warnlist[string.sub(str, i, j)] then
				return false
			end
		end
	end
	return true
end

return SensitiveMgr