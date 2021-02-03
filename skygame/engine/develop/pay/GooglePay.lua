--[[
功能: 谷歌支付
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

function chunk_split(paramString, paramLength, paramEnd) 
    paramEnd = paramEnd or '\n'
    local p = {}
    local s = paramString;
    while string.len(s) > paramLength do
        local s1 = string.sub(s, 1, paramLength)
        local s2 = string.sub(s, paramLength+1)
        s = s2;
        table.insert(p, s1)
    end
    if string.len(s) > 0 then
        table.insert(p, s)
    end
    table.insert(p, "")
    return table.concat(p, paramEnd)
end

--[[
	@desc: 验证订单
	--@OriginalJson: 来自前端订单信息
	--@Signature: 来自前端订单信息
    --@google_public_key: 谷歌账号控制台查询
    
]]
function GoolePayVerify(OriginalJson, Signature, google_public_key)
    -- 测试订单数据
    -- local google_public_key  = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArPaRMljLB9NI/IWm4QPoNKGf8Cei/Erj+/DYYAD48IGtJOHPSSpxpmc+CaPULW5pvQAIe2kUpvGBhD8TAfDk9IYV6fue7cXd1QjPpCk8GwHaz3IbdyiSBTEjEEZiB1NtoFMtrPq3kiZj0YfSlbDfB0MjDIt+aaJ4mMVyxn4OxxVEbBXiac9uiVdelhxAggWdbct1aqqIEvK2x2U2UOR7zh75QYmntf+PhTkuq2Ev8Pm6wOc1fcwICwZt1UO5G2kZIYUCoHjdjLpTlPCCu2CNbygWmZQTsNcHpOqBXEvDX5qlJpTIFs/3rbzB1hufNXN8wQRaAmbj+P1RPXdZBfP+0QIDAQAB';
    -- local OriginalJson =  "{\"orderId\":\"GPA.3339-0641-8627-81141\",\"packageName\":\"com.eodgames.sbca\",\"productId\":\"com.eodgames.sbca.diamond_4.99\",\"purchaseTime\":1563441970889,\"purchaseState\":0,\"purchaseToken\":\"agkllbpokifgpkipmbgldnda.AO-J1Ow9hfOFZp6NZzatxaSWRh11t6m7w2lKVP3EwQDy-EtxewBqMi_68t1XQmZe_2HexuvH4FW07a9bPN2iji3EXovzRqOmfPDPzLZYbBvtUfqbdVLi-Kntx8bjriEPLLaFgEUyTmKv-JipYdi7H3nET03xrYhJIw\"}"
    -- local Signature  = 'goOIiPOtJXfpNu14XcbE/LntfXpoF0c36ON0+nGq9fBFnZsWitAGhXxzbpYEpvQgZSA6Tv7ybmaGvbNYPCprrIE6aeifyParWINZKfuonj7Vkcdp28fuKmvR7dUiZI/4UIDNP/7Zw/4xgg06hTcze285baYNBLH+VhR7QfJJ4ukAP0jtocIh1i38AgNwmun6FOOIUi5hV9zb9g+cUe4VfjsUDX0FGwcLA0avR+1yWx+EXrqDSN6jyx5U0Fa1nYW9vvfI54xtJtM1OcJ26Jy7qua3RxEIK1CDv0hycxa/jlQWnGNlqCycehGIZlj9IyuZMvWwrAzYCVqD6uDBhphsHA==';

    local PHP_EOL = '\n'

    local codec = require('codec')
    if not codec then
        ERROR("codec is nil")
        return false
    end
    local publicKey = "-----BEGIN PUBLIC KEY-----"..PHP_EOL..chunk_split(google_public_key, 64, PHP_EOL).."-----END PUBLIC KEY-----";
    return codec.rsa_public_verify(OriginalJson, codec.base64_decode(Signature), publicKey, 0)
end

--验证API， 需要google api权限， 可以检查订单是否退款等信息，但是发行一般不会给权限
function GoolePayVerifyByApi(packageName, productId, token)
    local access_token = GetGoogleAccessToken()
    if not access_token then
        LOG("GetGoogleAccessToken error, please check...")
        self:SendNotice(NOTICE.UnKnow)
        return
    end

    local head = {
        ["content-type"] = "application/x-www-form-urlencoded",
    }
    local data = "/androidpublisher/v3/applications/"..packageName.."/purchases/products/"..productId.."/tokens/"..token.."?access_token="..access_token
    local status, body = xTool.httpc.request("GET", "https://www.googleapis.com", data, {}, head)
    LOG("https://www.googleapis.com"..data)
    LOG(status)
    LOG(body)
end


function GetGoogleAccessToken()
    local now = os.time()
    if not self.GoogleAccessToken or not self.GoogleAccessTokenTime or now - self.GoogleAccessTokenTime > 3000 then
        self.GoogleAccessTokenTime = now
        local form = {}
        form["grant_type"] = "refresh_token"
        form["client_id"] = "541381625259-0l801hr5b1qakmkuuqt9bgjufdjnhoam.apps.googleusercontent.com"
        form["client_secret"] = "Igc-C9Ws9OGbTxu0K_-gI2F-"
        form["refresh_token"] = "1/Wusgwz34lpcK8eR9Ydr2Kkwa1xDwMDSkt1PFCxd5E4JwpjbzxeLcPKxHfPLb_CLP"
        local status, body = xTool.httpc.post("https://accounts.google.com", "/o/oauth2/token", form, {})
        if status == 200 then --成功
            self.GoogleAccessToken = body.access_token
        else
            self.GoogleAccessToken = nil
        end
    end

    return self.GoogleAccessToken
end