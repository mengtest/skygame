
var fs = require('fs'),
path = require('path');



function array2arraybuffer(array) {
    var b = new ArrayBuffer(array.length);
    var v = new DataView(b, 0);
    for (var i = 0; i < array.length; i++) {
        v.setUint8(i, array[i]);
    }
    return b;
}


var arguments = process.argv




sourcefile = './../bin/sproto_byte.spb'
if (arguments.length >= 6) {
	sourcefile = arguments[5];
}




	var outfile = './../bin/sproto.spb' 
	if (arguments.length >=4) {
		outfile = arguments[3];
	}


fs.readFile(sourcefile, function (err, buff) {
	if (err) return console.error('error', err);

	var dataview = new DataView(array2arraybuffer(buff));
	var schema = new Array();
	for (var i = 0; i < dataview.byteLength; i++) {
		schema[i] = dataview.getUint8(i);
	}





	var str = JSON.stringify(schema);
	fs.writeFile(outfile, str, function (err) {
		if(err) {
			console.error(err);
		} else {
		   console.log("conver to", outfile);
		}
	
	});
})


