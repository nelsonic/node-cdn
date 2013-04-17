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


--- not working --- :-(

uploadtos3 = (filename) ->
  S3.client.putFile filename, filename, {'Content-Type': 'text/json','x-amz-acl': 'public-read'}, (err, res) ->
    if err 
      console.log err
    return res.client['_httpMessage']['url']

--- OLD app.coffee - before re-write --- 

"use strict"                 # need this for JSLint Pass ;-)
fs = require 'fs'
formidable = require 'formidable'
express = require 'express'
util = require 'util'
app = express()
port = 3000
ECT = require 'ect'
ectRenderer = ECT({ watch: true, root: __dirname + '/views' })
app.engine('.html', ectRenderer.render)

app.configure( -> 
  app.use(express.bodyParser())
  app.use(app.router)
)

app.listen(port);
console.log("Express server listening on port #{port}")

{NodeCDN} = require('./src') # see: http://stackoverflow.com/a/10772136/1148249
S3 = new NodeCDN
S3.upload()

app.post '/upload', (req, res) ->
  form = new formidable.IncomingForm();
  form.parse req, (err, fields, files) -> 
    res.writeHead(200, {'content-type': 'text/plain'});
    res.write('received upload:\n\n');
    # res.end(util.inspect({fields: fields, files: files}));
    console.log fields
  res.end('...')
  # console.log(req)
  # fs.writeFile "./req.txt", util.inspect(req),  (err) -> 

app.get 'examplejson', (req,res) ->
  res.render('layout.html', { title: 'Basic Uploader Form' })


filename = 'package.json'
S3.client.putFile('./'+filename, filename, {'x-amz-acl': 'public-read'}, (err, res) ->
  # console.log res
)

### - - - Works but too slow - - - ###
S3readapps = () ->
  appstring = ''
  client.get('/apps/apps.json').on('response', (res) -> 
    console.log(res.statusCode)
    # console.log(res.headers)
    res.setEncoding('utf8')
    res.on('data', (chunk) ->
      # console.log(chunk)
      appstring += chunk
    )
  ).end()


### - - - Casualties (Were Working!) - - - ###


S3uploadjson = (jsonstr) ->
  id = JSON.parse(jsonstr)['Id']
  filename = appdir+id+".json"
  req = client.put(filename, 
      'Content-Length': jsonstr.length
      'Content-Type': 'application/json'
      'x-amz-acl': 'public-read'
  )
  req.on('response', (res) ->
    if (200 == res.statusCode) 
      console.log('saved to %s', req.url);
  )
  req.end(jsonstr)


savejson = (jsonStr) ->  # saves appId.json to apps dir
  id = JSON.parse(jsonStr)['Id']
  filename = appdir+id+".json"
  fs.writeFile filename, jsonStr, {encoding:'utf8'},  (err) ->
    if (err) 
      throw err
    console.log "Local File Written: #{filename}"
  return filename

buildappsjson = () ->  # rebuilds the /apps/apps.json file
  fs.readdir './apps', (err, list) ->
    # console.log list
    apps = []
    i = 0
    for file in list
      if file != '.DS_Store' and file != 'apps.json'
        # console.log file
        app = require('./apps/'+file)
        if app['Active__c'] is true
          apps.push(app)

    fs.writeFile './apps/apps.json', JSON.stringify(apps), {encoding:'utf8'},  (err) ->
    if (err) 
      throw err
    console.log "Local File Written: ./apps/apps.json"

S3buildappsjson = () ->  # rebuilds the /apps/apps.json file
  fs.readdir './apps', (err, list) ->
    # console.log list
    apps = []
    i = 0
    for file in list
      if file != '.DS_Store' and file != 'apps.json'
        # console.log file
        app = require('./apps/'+file)
        if app['Active__c'] is true
          apps.push(app)

    fs.writeFile './apps/apps.json', JSON.stringify(apps), {encoding:'utf8'},  (err) ->
    if (err) 
      throw err
    console.log "Local File Written: ./apps/apps.json"

app.get '/buildappsjson', (req, res) ->
  buildappsjson() # recreate & save the apps.json file
  apps = require('./apps/apps.json')
  # console.dir apps
  res.send JSON.stringify(apps)
  