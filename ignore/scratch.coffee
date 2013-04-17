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



---------------------- *WORKING* Simple HTML Form --------------------------

express = require('express')
format = require('util').format;

app = module.exports = express()
app.use(express.bodyParser())

app.get '/', (req, res) ->
  res.send '''<form method="post" action="/upload" enctype="multipart/form-data">
  <p>Title: <input type="text" name="title" /></p>
  <p>Image: <input type="file" name="image" /></p>
  <p><input type="submit" value="Upload" /></p>
  </form>'''

app.post '/upload', (req, res, next) ->
  # the uploaded file can be found as `req.files.image` and the
  # title field as `req.body.title`
  res.send format('\nuploaded %s (%d Kb) to %s as %s'
    , req.files.image.name
    , req.files.image.size / 1024 | 0 
    , req.files.image.path
    , req.body.title)

if (!module.parent)
  app.listen(3000)
  console.log('Express started on port 3000')


--- not working ---

uploadtos3 = (filename) ->
  S3.client.putFile filename, filename, {'Content-Type': 'text/json','x-amz-acl': 'public-read'}, (err, res) ->
    if err 
      console.log err
    return res.client['_httpMessage']['url']
  