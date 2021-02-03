--[[
功能:苹果支付
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

function ApplePayVerify(paydata) --苹果支付验证,[request失败 status~=200]需要做自动重试。
    local head = {
        ["content-type"] = "application/json",
    }
    local data = "{\"receipt-data\":\""..paydata.."\"}"
    local function verifyReceipt(url)
        local status, body = xTool.httpc.request("POST", url, "/verifyReceipt", {}, head, data) --HTTP有可能连接失败
        body = luaJson.json2table(body)
        if status ~= 200 or not table.exist(body) then
            ERROR("ApplePay status or body error...")
            return nil
        end
        if body.status == 0 then --购买成功，发钱
            if body.receipt and table.exist(body.receipt.in_app) then
                return body.receipt.in_app
            else 
                return nil
            end
        elseif body.status == 21007 then --如果是测试
            ERROR("ApplePay is sandbox paydata...")
            return verifyReceipt("https://sandbox.itunes.apple.com")
        else
            LOG("ApplePay status error..."..body.status)
            return nil
        end
    end
    return verifyReceipt("https://buy.itunes.apple.com") --验证正式渠道
end
