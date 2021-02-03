local types = {id="number", heroId="table", maxNum="number", interval="number", num="number", times="number", refushRange="number", killCoefficient="number", heroLvCoefficient="number"}
local table = {
[1]={id=1,heroId={60000,60001,60002,60003},maxNum=15,interval=5000,num=10,times=-1,refushRange=250,killCoefficient=5,heroLvCoefficient=1.3},
[2]={id=2,heroId={6002,6003,6004,6005,6050,6060,6070,6080,6090,6100,7002,7003,7004,7005,7050,7060,7070,7080,7090,7100,8002,8003,8004,8005,8050,8060,8070,8080,8090,8100},maxNum=10,interval=10000,num=12,times=-1,refushRange=400,killCoefficient=5,heroLvCoefficient=1.5},
[3]={id=3,heroId={16002,16003,16004,16005,16050,16060,16070,16080,16090,16100,17002,17003,17004,17005,17050,17060,17070,17080,17090,17100,18002,18003,18004,18005,18050,18060,18070,18080,18090,18100},maxNum=8,interval=10000,num=4,times=2,refushRange=400,killCoefficient=5,heroLvCoefficient=1.5}
}
return {table, types}