local types = {id="string", data="string", intData="number", floatData="number", vector3AllowDate="table"}
local table = {
[FaceBookRewardedAdId]={data="420383218959673_420384762292852",id="FaceBookRewardedAdId"},
[AdsTimeOut]={intData=5000,id="AdsTimeOut"},
[ReviveTime]={intData=5000,id="ReviveTime"},
[ReviveCost]={intData=300,id="ReviveCost"},
[AdsBackButtonTime]={intData=2000,id="AdsBackButtonTime"},
[AdsGold]={intData=500,id="AdsGold"},
[AdsGoldCD]={intData=600,id="AdsGoldCD"},
[MatchTime]={intData=5000,id="MatchTime"},
[MaxStamina]={intData=100,id="MaxStamina"},
[StaminaRecoveryTime]={intData=180,id="StaminaRecoveryTime"},
[StaminaRecoveryVal]={intData=1,id="StaminaRecoveryVal"},
[FastBattleStaminaCost]={intData=5,id="FastBattleStaminaCost"},
[SettlementExtraReward]={intData=100,id="SettlementExtraReward"},
[BagCapacity]={intData=12,id="BagCapacity"},
[MaxStarLv]={intData=8,id="MaxStarLv"},
[MaxChest]={intData=10,id="MaxChest"},
[ADChest]={intData=10,id="ADChest"},
[PreciousStar]={intData=4,id="PreciousStar"},
[ChestTime]={intData=10000,id="ChestTime"},
[MaxMatchIntelval]={intData=500,id="MaxMatchIntelval"},
[MinMatchIntelval]={intData=50,id="MinMatchIntelval"},
[SpinCD]={intData=180000,id="SpinCD"},
[RandomAD]={vector3AllowDate={{1,500,8},{100,5,2}},id="RandomAD"}
}
return {table, types}