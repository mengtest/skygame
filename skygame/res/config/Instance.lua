local types = {id="number", dueTime="number", type="number", sceneId="number", difficult="number", limitLevel="number", times="number", life="number", randomNameRefreshId="number", refreshId="table", bornPoint="table", bornDir="number", battleLVMax="number", goldCoefficient="number", dmgScoreCoefficient="number"}
local table = {
[1001]={id=1001,dueTime=180,type=1,sceneId=100,difficult=1,limitLevel=20,times=1,refreshId={1,2},bornPoint={0,0,0},battleLVMax=10,goldCoefficient=0.325,dmgScoreCoefficient=0.5},
[2001]={id=2001,dueTime=180,type=2,sceneId=100,difficult=1,life=5,randomNameRefreshId=3,refreshId={1},bornPoint={0,0,100},battleLVMax=10,goldCoefficient=0.5,dmgScoreCoefficient=1}
}
return {table, types}