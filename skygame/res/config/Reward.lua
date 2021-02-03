local types = {id="number", types="table", weights="table", values="table"}
local table = {
[1]={values={100,5,100},id=1,types={1,100,2},weights={50,50,50}},
[2]={values={500},id=2,types={1},weights={1}},
[3]={values={3000},id=3,types={1},weights={1}},
[4]={values={20},id=4,types={3},weights={1}},
[5]={values={50},id=5,types={3},weights={1}},
[6]={values={2},id=6,types={100},weights={1}},
[7]={values={10},id=7,types={100},weights={1}}
}
return {table, types}