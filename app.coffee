# upload to S3
"use strict" # need this for JSLint Pass ;-)
try
	require('coffee-script')        
	require('js-yaml')              # https://github.com/nodeca/js-yaml
	S3 = require('./config/S3.yml')
	knox = require('knox')
	console.log S3
	client = knox.createClient(S3)
	console.log client
	obj = { foo: "bar" }
	str = JSON.stringify(obj)
	console.log(str)
	req = client.put('/test/obj.json',
    'Content-Length': str.length
    'Content-Type': 'application/json'
    'x-amz-acl': 'public-read'
		)
	req.on('response', (res) ->
		console.log(res)
		if res.statusCode is 200
    	console.log('saved to #{req.url}')
		# else 
		# 	console.log('Fail')
		)
	req.end(str)
	# console.log(str)
catch error

