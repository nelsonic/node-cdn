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


app.get '/uploadraw', (req, res) ->
  res.render('uploadraw.html', { title: 'Basic Uploader Form' })

app.post '/uploadraw', (req, res) ->
  newapp = JSON.parse req.body
  console.log newapp
  S3UpdateAppsJSON(newapp)
  res.send "200"


###  - - - - Matcher Logic : Superceded - - - - - ###

  # check for dirt:
  match = /{ 'json : /.test(json)
  match2 = /'json/.test(json)
  match3 = json.search /'json/
  console.log "Match 1: #{match} -- Match 2: #{match2} -- Match 3: #{match3}"
  if match or match2 or match3 != -1
    try
      json = cleanbodyjson(json)
      newapp = JSON.parse(json)
    catch error
      console.log "InVALID JSON"
      throw error
  else
    try
      newapp = JSON.parse(json)
    catch error
      console.log "InVALID JSON"
      throw error



#LOOK AWAY NOW or read: http://stackoverflow.com/a/4043513/1148249

# createWindow = (fn) ->
#   window  = jsdom.jsdom().createWindow()
#   script = window.document.createElement('script')
#   jsdom.jsonp(window, -> 
#     script.src = 'file://' + __dirname + '/jquery.jsonp.js'
#     script.onload = () ->
#       if (this.readyState === 'complete')
#         fn(window)

dirty = '''
{ json: 'json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYxYAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-17T21:26:11.000+0000","Default__c":false,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001ERoAAM&oid=00Db0000000I3q2EAC","Active__c":false,"Application_URL__c":"http://edse-web/editorial_services/archives/records_management.html","Name":"Archiving","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001ERoAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-17T21:26:11.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:32:36.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYxYAAU","Description__c":"Archive and record office information","Featured__c":false}' }]
'''

dirty = String(dirty)
console.log "........................         BODY IS DIRTY!! :-( "
len = dirty.length
console.log "Length: #{len}"
pos1 = dirty.search /{"attributes":/
if pos1 != -1
 console.log "found {\"attributes\": at #{pos}"
 dirty = dirty.slice(pos1, len);
pos2 = dirty.search /,"Featured__c":false}'/
if pos2 != -1
 console.log "found :false} at #{pos2}"
 clean = dirty.slice(0, pos2+20);
pos3 = dirty.search /,"Featured__c":true}/
if pos3 != 1
 console.log "found :true} at #{pos}"
 clean = dirty.slice(0, pos3+19);
pos4 = dirty.search /' }]/
if pos4 != -1
 console.log "found ' }] at #{pos}"
 clean = dirty.slice(0, pos4);

console.log "CLEAN: #{clean}"




  try
    console.log('..................................??? req.body.json')
    console.dir req.body.json
    console.log('..................................??? req.body.json')
  catch error
    console.log "InVALID JSON"


  if req.body.json is undefined
    json = req.body # dirty
  else 
    json = req.body.json # maybe clean


### Trial and improvment ###


app.get '/uploadraw', (req, res) ->
  res.render('uploadraw.html', { title: 'Basic Uploader Form' })

app.post '/uploadraw', (req, res) ->
  console.log('                                               <RAW>')
  console.log("\n    req.body: #{typeof req.body}")
  console.dir req.body
  json = JSON.stringify(req.body)
  console.log("\n    json #{typeof json}")
  console.log json
  json_no_quotes = json.replace(/\\"/g, '"')
  console.log("\n    json backslash-quotes removed - parsed: #{typeof json}") 
  console.log json_no_quotes
  # jsonobj = JSON.parse(json)
  # console.log("\n    json should parse: #{typeof jsonobj}") 
  json = cleanbodyjson(json)
  console.log("\n    json - After SECOND Clean: #{typeof json}")
  json = json.replace(/\\"/g, '"')
  len = json.length
  posbackslash = json.search /\\/
  console.log "Backslash : #{posbackslash} =? #{len}"
  if posbackslash == len-1
    json = json.slice(0, posbackslash)
  console.log("\n    json - After removing backslash: #{typeof json}")
  console.log json
  newapp = JSON.parse(json)
  console.log("\n    newapp - from raw: #{typeof newapp}")
  console.dir newapp
  filename = newapp['Id']+'.json'
  console.log('    filename - from raw: ')
  console.log filename
  console.log('                                               </RAW>')

  S3upload(filename, JSON.stringify(newapp))
  S3UpdateAppsJSON(json)
  res.end()



  <!-- CoffeeScript -->
<script type="text/coffeescript">
  $ ->
    # override .bx-viewport by giving it an id
    $('.bx-viewport').attr('id','ribbon_viewport')
    $('.bx-viewport').css('height', '60px');
    $('#ribbon-container').html('<p>TEST</p>')

    $.ajax
      url: 'http://mpyc.s3.amazonaws.com/apps/apps.json',
      dataType: 'jsonp',
      success: (data) ->
        text = ''
        len = data.length
        for app in data
          console.log app
          entry = app['Name'];
          text += "<p> Example: #{entry}</p>"
        $('#ribbon-container').html(text)


  app_create = (data) ->
    console.log(data)

 //  script = document.createElement("script");
  // script.type = "text/javascript";
  // script.src = 'http://mpyc.s3.amazonaws.com/apps/apps.json'+'?callback=app_create'

</script>
  


