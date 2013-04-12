"use strict" # need this for JSLint Pass ;-)
class NodeCDN
  constructor: ->  
	  require('js-yaml')              # https://github.com/nodeca/js-yaml
	  S3Config = require('../config/S3.yml')
	  @knox = require('knox')
	  @client = @knox.createClient(S3Config)
	  

  upload: ->
		obj = { foo: "bar", bat: "baz" }
		str = JSON.stringify(obj)
		console.log("String: #{str} "+ typeof str)
		cum = str.length
		console.log cum
		console.log @client


		# req = @client.put('/test/obj.json', {
		#   # 'Content-Length': cum
	 #    'Content-Type': 'application/json'
	 #    'x-amz-acl': 'public-read'
	 #  })
	 #  req.on 'response', (res) ->
		# 	console.log(res)
		# 	if res.statusCode is 200
		# 		console.log("saved to #{req.url}")
		# 	else 
		# 		console.log("Fail")
		# req.end(str) 

exports.NodeCDN = NodeCDN