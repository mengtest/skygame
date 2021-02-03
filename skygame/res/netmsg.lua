return [[
#TAG 1 ~ 5000 for C# NetMsg
#TAG 5001 ~ MAX for LUA NetMsg
#integer boolean string binary

.package
{
  type  0 :  integer      #消息号
  session  1 :  integer   #回调函数
}

.Property #通用属性结构
{
  Key  0 :  string    #属性的key
  Type  1 :  string   #s，b，i
  Int  2 :  integer   #整形
  Str  3 :  string    #字符串
}


GAME_CS_PLAYER_BEGIN 5001 			#开始获取游戏数据
{
  request
  {
  }
}
GAME_SC_PLAYER_PUSHDATA 5002 			#推送玩家数据
{
  request
  {
  }
}
GAME_SC_PLAYER_PROPERTY 5003 			#属性修改
{
  request
  {
    PropertyList  0 :  *Property  #变化的属性列表
  }
}
GAME_SC_PLAYER_OVER 5004 			#全部数据发送完成， 可以开始游戏了
{
  request
  {
  }
}

#---登录---#LOGIN
LOGIN_CS_EODGUEST 5005 			#游客登录
{
  request
  {
    token  0 :  string  #唯一标识
  }
  response
  {
    IsShowAgreement  0 :  boolean   #是否显示用户协议
    UID  1 :  integer
  }
}
LOGIN_CS_AGREEMENT 5006 			#同意用户协议
{
  request
  {
    UID  0 :  integer
  }
}

.HandShake
{
  Tag  0 :  string
  ServerID  1 :  integer
}

#---------------C TO S---------------#
SYSTEM_CS_HANDSHAKE 5007 			#握手消息
{
  request
  {
    Token  0 :  string
    BindList  1 :  *HandShake
  }
}
SYSTEM_CS_HEARTBEAT 5008 			#心跳同步请求
{
  request
  {
  }
  response
  {
    ServerTimeTick  0 :  integer     #服务器的时间戳(秒)，客户端的逻辑依据。
  }
}
SYSTEM_CS_RECONNECT 5009 			#重连
{
  request
  {
    UID  0 :  integer           #用户ID
    GameTokenMD5  1 :  string   #验证游戏服token
  }
  response
  {
    state  0 :  boolean   #验证状态，如果失败返回登录服
  }
}

#---------------S TO C---------------#
SYSTEM_SC_NOTICE 5010 			#服务器通知
{
  request
  {
    NoticeID  0 :  integer   #通知ID
  }
}

SYSTEM_CS_TESTMSG 1 			#测试消息
{
  request
  {
    servertime  0 :  integer
    teststr  1 :  string
  }
}

SYSTEM_SC_TESTMSG 2 			#测试消息
{
  request
  {
    servertime  0 :  integer
    teststr  1 :  string
  }
}


]]