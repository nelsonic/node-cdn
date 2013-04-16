"use strict" # need this for JSLint Pass ;-)
class NodeCDN
	constructor: ->  
		require('js-yaml')              # https://github.com/nodeca/js-yaml
		@S3Config = require('../config/S3.yml')
		@knox = require('knox')
		@client = @knox.createClient(@S3Config)
	  
	upload: (jsonStr) ->
		id = JSON.parse(jsonStr)['Id']
		req = @client.put('/apps/'+id+'.json', {
			'Content-Length': jsonStr.length
			'Content-Type': 'application/json'
			'x-amz-acl': 'public-read'
			})
		req.on 'response', (res) ->
			console.log(res)
			if res.statusCode is 200
				console.log("saved to #{req.url}")
			else 
				console.log("Fail :-(")
			return req

exports.NodeCDN = NodeCDN