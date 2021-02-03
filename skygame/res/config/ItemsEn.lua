local types = {itemId="number", itemType="number", itemName="string", useLevel="number", itemList="table", itemsDict="table", itemBool="bool", itemFloat="number", itemVector2="table", itemVector3="table", desc_en="string"}
local table = {
[101101]={itemId=101101,itemType=3,itemName="屠龙刀",useLevel=30,itemList={1,2,3,4,5},itemsDict={["屠龙刀"]="test",["倚天剑"]="\"1234567\""},itemBool=true,itemFloat=1.111,itemVector2={{1,1},{2,2}},itemVector3={["pos2"]={6,7,8},["pos"]={2,3,4}},desc_en="hello"},
[101102]={itemFloat=1.111,itemId=101102,itemType=1,itemName="倚天剑",useLevel=90,itemList={1,2,3,4,5},itemsDict={["屠龙刀"]="test",["倚天剑"]="\"1234567\""},itemBool=true}
}
return {table, types}