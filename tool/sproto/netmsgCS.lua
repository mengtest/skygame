.package
{
  type  0 :  integer      #消息号
  session  1 :  integer   #回调函数
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

