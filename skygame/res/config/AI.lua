local types = {id="number", activeBehavior="table", activeRate="table", activeInterval="table", behitActive="table", behitRate="table", behitInterval="table", lockActive="table", lockRate="table", lockInterval="table", switchShielRate="table", switchIds="table", followID="number"}
local table = {
[1]={id=1,activeBehavior={1,2,3,0},activeRate={20,30,30,50},activeInterval={4000,5000},behitActive={1,2,3,0},behitRate={10,30,20,50},behitInterval={3000,5000},lockActive={1,2,3,0},lockRate={20,10,10,40},lockInterval={3000,5000},switchShielRate={30},switchIds={2}},
[2]={id=2,activeBehavior={3,0},activeRate={50,50},activeInterval={1000,5000},behitActive={2},behitRate={20},behitInterval={3000,5000},lockActive={2,0},lockRate={20,30},lockInterval={3000,5000}},
[3]={id=3,activeBehavior={1,2,3,4,0},activeRate={20,30,30,20,50},activeInterval={3000,5000},behitActive={1,2,3,4,0},behitRate={20,30,30,20,50},behitInterval={3000,5000},lockActive={1,2,3,4,0},lockRate={20,30,30,20,50},lockInterval={3000,5000},switchShielRate={30},switchIds={4}},
[4]={id=4,activeBehavior={3,0},activeRate={50,50},activeInterval={1000,5000},behitActive={2},behitRate={20},behitInterval={3000,5000},lockActive={2,0},lockRate={20,30},lockInterval={3000,5000}},
[6]={id=6,activeBehavior={1,3},activeRate={2,2},activeInterval={1000,3000},behitActive={2},behitRate={2},behitInterval={1000,3000},lockActive={2},lockRate={2},lockInterval={1000,3000},followID=6},
[7]={id=7,activeBehavior={1,3},activeRate={2,2},activeInterval={1000,3000},behitActive={2},behitRate={2},behitInterval={1000,3000},lockActive={2},lockRate={2},lockInterval={1000,3000},followID=7},
[8]={id=8,activeBehavior={1,3},activeRate={2,2},activeInterval={1000,3000},behitActive={2},behitRate={2},behitInterval={1000,3000},lockActive={2},lockRate={2},lockInterval={1000,3000},followID=8},
[9]={id=9,activeBehavior={1,3},activeRate={2,2},activeInterval={1000,3000},behitActive={2},behitRate={2},behitInterval={1000,3000},lockActive={2},lockRate={2},lockInterval={1000,3000},followID=9},
[998]={id=998,activeBehavior={1},activeRate={1},activeInterval={1000,3000},behitActive={2},behitRate={1},behitInterval={1000,3000},lockActive={0},lockRate={1},lockInterval={1000,3000},followID=1},
[999]={id=999,activeBehavior={1},activeRate={1},activeInterval={1000,3000},behitActive={2},behitRate={1},behitInterval={1000,3000},lockActive={0},lockRate={1},lockInterval={1000,3000},followID=2},
[60000]={id=60000,activeBehavior={2},activeRate={50},activeInterval={3000,5000},behitActive={2},behitRate={1},behitInterval={3000,5000},lockActive={2},lockRate={1},lockInterval={3000,5000}}
}
return {table, types}