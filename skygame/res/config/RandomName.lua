local types = {id="number", desc_cn="string", desc_en="string"}
local table = {
[1]={id=1,desc_cn="poison",desc_en="poison"},
[2]={id=2,desc_cn="Minx",desc_en="Minx"},
[3]={id=3,desc_cn="flowers",desc_en="flowers"},
[4]={id=4,desc_cn="missish",desc_en="missish"},
[5]={id=5,desc_cn="cuisines",desc_en="cuisines"},
[6]={id=6,desc_cn="1nd1ra",desc_en="1nd1ra"},
[7]={id=7,desc_cn="1zef1a",desc_en="1zef1a"},
[8]={id=8,desc_cn="3nd",desc_en="3nd"},
[9]={id=9,desc_cn="9UN",desc_en="9UN"},
[10]={id=10,desc_cn="ADr3am",desc_en="ADr3am"},
[11]={id=11,desc_cn="Aletta",desc_en="Aletta"},
[12]={id=12,desc_cn="Almond",desc_en="Almond"},
[13]={id=13,desc_cn="Amaris",desc_en="Amaris"},
[14]={id=14,desc_cn="Amaryllis",desc_en="Amaryllis"},
[15]={id=15,desc_cn="Amaya",desc_en="Amaya"},
[16]={id=16,desc_cn="Anemone",desc_en="Anemone"},
[17]={id=17,desc_cn="Angelina",desc_en="Angelina"},
[18]={id=18,desc_cn="Ani",desc_en="Ani"},
[19]={id=19,desc_cn="anima",desc_en="anima"},
[20]={id=20,desc_cn="annihilation",desc_en="annihilation"},
[21]={id=21,desc_cn="Apple",desc_en="Apple"},
[22]={id=22,desc_cn="Apricot",desc_en="Apricot"},
[23]={id=23,desc_cn="Arbutus",desc_en="Arbutus"},
[24]={id=24,desc_cn="Avocado",desc_en="Avocado"},
[25]={id=25,desc_cn="Bagasse",desc_en="Bagasse"},
[26]={id=26,desc_cn="Banana",desc_en="Banana"},
[27]={id=27,desc_cn="Beauty",desc_en="Beauty"},
[28]={id=28,desc_cn="Bennet",desc_en="Bennet"},
[29]={id=29,desc_cn="Bergamot",desc_en="Bergamot"},
[30]={id=30,desc_cn="Berry",desc_en="Berry"},
[31]={id=31,desc_cn="Betelnut",desc_en="Betelnut"},
[32]={id=32,desc_cn="Bilberry",desc_en="Bilberry"},
[33]={id=33,desc_cn="Blanche",desc_en="Blanche"},
[34]={id=34,desc_cn="blossoms",desc_en="blossoms"},
[35]={id=35,desc_cn="blue",desc_en="blue"},
[36]={id=36,desc_cn="Blueberry",desc_en="Blueberry"},
[37]={id=37,desc_cn="breed",desc_en="breed"},
[38]={id=38,desc_cn="Bryony",desc_en="Bryony"},
[39]={id=39,desc_cn="Bullace",desc_en="Bullace"},
[40]={id=40,desc_cn="bus",desc_en="bus"},
[41]={id=41,desc_cn="Cantaloupe",desc_en="Cantaloupe"},
[42]={id=42,desc_cn="capital",desc_en="capital"},
[43]={id=43,desc_cn="Carambola",desc_en="Carambola"},
[44]={id=44,desc_cn="Cec1l1a",desc_en="Cec1l1a"},
[45]={id=45,desc_cn="Cecile",desc_en="Cecile"},
[46]={id=46,desc_cn="Celina",desc_en="Celina"},
[47]={id=47,desc_cn="ch1ld",desc_en="ch1ld"},
[48]={id=48,desc_cn="cherry",desc_en="cherry"},
[49]={id=49,desc_cn="Cherry",desc_en="Cherry"},
[50]={id=50,desc_cn="Chestnut",desc_en="Chestnut"},
[51]={id=51,desc_cn="CHINATSU",desc_en="CHINATSU"},
[52]={id=52,desc_cn="Chloe",desc_en="Chloe"},
[53]={id=53,desc_cn="chome",desc_en="chome"},
[54]={id=54,desc_cn="citycl3ar",desc_en="citycl3ar"},
[55]={id=55,desc_cn="Classic",desc_en="Classic"},
[56]={id=56,desc_cn="Claud1a",desc_en="Claud1a"},
[57]={id=57,desc_cn="Claudia",desc_en="Claudia"},
[58]={id=58,desc_cn="clockwork",desc_en="clockwork"},
[59]={id=59,desc_cn="Coconut",desc_en="Coconut"},
[60]={id=60,desc_cn="Codlin",desc_en="Codlin"},
[61]={id=61,desc_cn="complacent",desc_en="complacent"},
[62]={id=62,desc_cn="Core",desc_en="Core"},
[63]={id=63,desc_cn="Cranberry",desc_en="Cranberry"},
[64]={id=64,desc_cn="Cumquat",desc_en="Cumquat"},
[65]={id=65,desc_cn="Cytheria",desc_en="Cytheria"},
[66]={id=66,desc_cn="d3m3anor",desc_en="d3m3anor"},
[67]={id=67,desc_cn="D3MON",desc_en="D3MON"},
[68]={id=68,desc_cn="Damson",desc_en="Damson"},
[69]={id=69,desc_cn="Danae",desc_en="Danae"},
[70]={id=70,desc_cn="Date",desc_en="Date"},
[71]={id=71,desc_cn="death",desc_en="death"},
[72]={id=72,desc_cn="Deirdre",desc_en="Deirdre"},
[73]={id=73,desc_cn="Delilah",desc_en="Delilah"},
[74]={id=74,desc_cn="Des1gn",desc_en="Des1gn"},
[75]={id=75,desc_cn="Desdemona",desc_en="Desdemona"},
[76]={id=76,desc_cn="Destiny",desc_en="Destiny"},
[77]={id=77,desc_cn="Detour",desc_en="Detour"},
[78]={id=78,desc_cn="Dew",desc_en="Dew"},
[79]={id=79,desc_cn="dialogue",desc_en="dialogue"},
[80]={id=80,desc_cn="Dione",desc_en="Dione"},
[81]={id=81,desc_cn="disappointed",desc_en="disappointed"},
[82]={id=82,desc_cn="Dolores",desc_en="Dolores"},
[83]={id=83,desc_cn="Donk3ybaby",desc_en="Donk3ybaby"},
[84]={id=84,desc_cn="dream",desc_en="dream"},
[85]={id=85,desc_cn="Durian",desc_en="Durian"},
[86]={id=86,desc_cn="Easter",desc_en="Easter"},
[87]={id=87,desc_cn="Elina",desc_en="Elina"},
[88]={id=88,desc_cn="Elodie",desc_en="Elodie"},
[89]={id=89,desc_cn="entered",desc_en="entered"},
[90]={id=90,desc_cn="Episode",desc_en="Episode"},
[91]={id=91,desc_cn="feast",desc_en="feast"},
[92]={id=92,desc_cn="feat",desc_en="feat"},
[93]={id=93,desc_cn="Feel1n9",desc_en="Feel1n9"},
[94]={id=94,desc_cn="feelin9",desc_en="feelin9"},
[95]={id=95,desc_cn="Fel1c1a",desc_en="Fel1c1a"},
[96]={id=96,desc_cn="Female",desc_en="Female"},
[97]={id=97,desc_cn="Filbert",desc_en="Filbert"},
[98]={id=98,desc_cn="Files",desc_en="Files"},
[99]={id=99,desc_cn="fin9er",desc_en="fin9er"},
[100]={id=100,desc_cn="Fiona",desc_en="Fiona"},
[101]={id=101,desc_cn="FL3SH",desc_en="FL3SH"},
[102]={id=102,desc_cn="flash",desc_en="flash"},
[103]={id=103,desc_cn="flower",desc_en="flower"},
[104]={id=104,desc_cn="Force",desc_en="Force"},
[105]={id=105,desc_cn="fr33dom",desc_en="fr33dom"},
[106]={id=106,desc_cn="Gina",desc_en="Gina"},
[107]={id=107,desc_cn="Ginkgo",desc_en="Ginkgo"},
[108]={id=108,desc_cn="goodby3",desc_en="goodby3"},
[109]={id=109,desc_cn="grac3s",desc_en="grac3s"},
[110]={id=110,desc_cn="fruit",desc_en="fruit"},
[111]={id=111,desc_cn="Guava",desc_en="Guava"},
[112]={id=112,desc_cn="H3ART",desc_en="H3ART"},
[113]={id=113,desc_cn="happin3ss",desc_en="happin3ss"},
[114]={id=114,desc_cn="Harbor",desc_en="Harbor"},
[115]={id=115,desc_cn="Haw",desc_en="Haw"},
[116]={id=116,desc_cn="heart",desc_en="heart"},
[117]={id=117,desc_cn="heartache",desc_en="heartache"},
[118]={id=118,desc_cn="Heartbeat",desc_en="Heartbeat"},
[119]={id=119,desc_cn="Herbaceous",desc_en="Herbaceous"},
[120]={id=120,desc_cn="Hickory",desc_en="Hickory"},
[121]={id=121,desc_cn="high",desc_en="high"},
[122]={id=122,desc_cn="HOST",desc_en="HOST"},
[123]={id=123,desc_cn="hypocrites",desc_en="hypocrites"},
[124]={id=124,desc_cn="Ice",desc_en="Ice"},
[125]={id=125,desc_cn="ink",desc_en="ink"},
[126]={id=126,desc_cn="intensions",desc_en="intensions"},
[127]={id=127,desc_cn="Ishtar",desc_en="Ishtar"},
[128]={id=128,desc_cn="Jin",desc_en="Jin"},
[129]={id=129,desc_cn="Karida",desc_en="Karida"},
[130]={id=130,desc_cn="Kiwifruit",desc_en="Kiwifruit"},
[131]={id=131,desc_cn="Laraine",desc_en="Laraine"},
[132]={id=132,desc_cn="Lemon",desc_en="Lemon"},
[133]={id=133,desc_cn="li9ht",desc_en="li9ht"},
[134]={id=134,desc_cn="Lichee",desc_en="Lichee"},
[135]={id=135,desc_cn="Lik3masks",desc_en="Lik3masks"},
[136]={id=136,desc_cn="Lilith",desc_en="Lilith"},
[137]={id=137,desc_cn="linger",desc_en="linger"},
[138]={id=138,desc_cn="lonely2c",desc_en="lonely2c"},
[139]={id=139,desc_cn="Longan",desc_en="Longan"},
[140]={id=140,desc_cn="Lorelei",desc_en="Lorelei"},
[141]={id=141,desc_cn="Lou1se",desc_en="Lou1se"},
[142]={id=142,desc_cn="lover",desc_en="lover"},
[143]={id=143,desc_cn="Lu3xtravagant",desc_en="Lu3xtravagant"},
[144]={id=144,desc_cn="man",desc_en="man"},
[145]={id=145,desc_cn="Mandarin",desc_en="Mandarin"},
[146]={id=146,desc_cn="Mango",desc_en="Mango"},
[147]={id=147,desc_cn="mar9in",desc_en="mar9in"},
[148]={id=148,desc_cn="MATAHARI",desc_en="MATAHARI"},
[149]={id=149,desc_cn="me",desc_en="me"},
[150]={id=150,desc_cn="Melantha",desc_en="Melantha"},
[151]={id=151,desc_cn="mellow",desc_en="mellow"},
[152]={id=152,desc_cn="Memory",desc_en="Memory"},
[153]={id=153,desc_cn="messy",desc_en="messy"},
[154]={id=154,desc_cn="Michaela",desc_en="Michaela"},
[155]={id=155,desc_cn="Michelle",desc_en="Michelle"},
[156]={id=156,desc_cn="Miss",desc_en="Miss"},
[157]={id=157,desc_cn="MONSTER",desc_en="MONSTER"},
[158]={id=158,desc_cn="more",desc_en="more"},
[159]={id=159,desc_cn="move",desc_en="move"},
[160]={id=160,desc_cn="Mr",desc_en="Mr"},
[161]={id=161,desc_cn="Muriel",desc_en="Muriel"},
[162]={id=162,desc_cn="ni9ht",desc_en="ni9ht"},
[163]={id=163,desc_cn="oath",desc_en="oath"},
[164]={id=164,desc_cn="orange",desc_en="orange"},
[165]={id=165,desc_cn="oratorio",desc_en="oratorio"},
[166]={id=166,desc_cn="P1tfath3r",desc_en="P1tfath3r"},
[167]={id=167,desc_cn="pain",desc_en="pain"},
[168]={id=168,desc_cn="Peach",desc_en="Peach"},
[169]={id=169,desc_cn="perfect",desc_en="perfect"},
[170]={id=170,desc_cn="Persimmon",desc_en="Persimmon"},
[171]={id=171,desc_cn="Pick",desc_en="Pick"},
[172]={id=172,desc_cn="Pineapple",desc_en="Pineapple"},
[173]={id=173,desc_cn="play",desc_en="play"},
[174]={id=174,desc_cn="Princess",desc_en="Princess"},
[175]={id=175,desc_cn="Quella",desc_en="Quella"},
[176]={id=176,desc_cn="rain",desc_en="rain"},
[177]={id=177,desc_cn="remini",desc_en="remini"},
[178]={id=178,desc_cn="reverse",desc_en="reverse"},
[179]={id=179,desc_cn="ROLL",desc_en="ROLL"},
[180]={id=180,desc_cn="rose",desc_en="rose"},
[181]={id=181,desc_cn="s1st3r",desc_en="s1st3r"},
[182]={id=182,desc_cn="Sade",desc_en="Sade"},
[183]={id=183,desc_cn="Sadness",desc_en="Sadness"},
[184]={id=184,desc_cn="Sakura",desc_en="Sakura"},
[185]={id=185,desc_cn="Sera",desc_en="Sera"},
[186]={id=186,desc_cn="Serafina",desc_en="Serafina"},
[187]={id=187,desc_cn="Sicily",desc_en="Sicily"},
[188]={id=188,desc_cn="skarn",desc_en="skarn"},
[189]={id=189,desc_cn="sky",desc_en="sky"},
[190]={id=190,desc_cn="sleep",desc_en="sleep"},
[191]={id=191,desc_cn="Snow",desc_en="Snow"},
[192]={id=192,desc_cn="Speaker",desc_en="Speaker"},
[193]={id=193,desc_cn="style",desc_en="style"},
[194]={id=194,desc_cn="sunshine",desc_en="sunshine"},
[195]={id=195,desc_cn="tears",desc_en="tears"},
[196]={id=196,desc_cn="THUNDER",desc_en="THUNDER"},
[197]={id=197,desc_cn="Triste",desc_en="Triste"},
[198]={id=198,desc_cn="Ulr1ca",desc_en="Ulr1ca"},
[199]={id=199,desc_cn="Unable",desc_en="Unable"},
[200]={id=200,desc_cn="Vague",desc_en="Vague"},
[201]={id=201,desc_cn="Vanity",desc_en="Vanity"},
[202]={id=202,desc_cn="Venice",desc_en="Venice"},
[203]={id=203,desc_cn="vows",desc_en="vows"},
[204]={id=204,desc_cn="W1zard",desc_en="W1zard"},
[205]={id=205,desc_cn="Waitin9",desc_en="Waitin9"},
[206]={id=206,desc_cn="Wast3",desc_en="Wast3"},
[207]={id=207,desc_cn="Waylung",desc_en="Waylung"},
[208]={id=208,desc_cn="wh1t3",desc_en="wh1t3"},
[209]={id=209,desc_cn="WhiteInte",desc_en="WhiteInte"},
[210]={id=210,desc_cn="world",desc_en="world"},
[211]={id=211,desc_cn="Zahara",desc_en="Zahara"},
[212]={id=212,desc_cn="Wizard",desc_en="Wizard"}
}
return {table, types}