### jslint nomen: true, plusplus: true, vars: true, indent: 2, node: true ###
"use strict" # need this for JSLint Pass

### - - - - - - - - The Mini Express App - - - - - - - - ###
express = require 'express'
app = module.exports = express()
app.configure () ->
  app.use(express.bodyParser()) #used to parse form submissions
  app.use(express.static(__dirname + '/public')) # local static files >> S3
  # app.use(express.static(__dirname + '/spec'))   # tests public for Jasmine 
  # app.use(express.static(__dirname + '/lib'))    # lib public for Jasmine access
  # app.use(express.static(__dirname + '/apps'))   # apps.json local    >> S3
  # app.use(express.cookieParser())

### - - - - - - - - - Copy This to the bottom of SEF-NODEJS/app.js - - - - - - - - - ###


### - - - - - REDIS - - - - - ###
redis = require 'redis'
redis_client = redis.createClient()
redis_client.on "error", (err) ->
  console.log("REDIS FAIL : " + err);

### - - - - - S3 Config and Knox Client - - - - - ###
knox = require 'knox' # see: https://github.com/LearnBoost/knox
require 'js-yaml'   # see: https://github.com/nodeca/js-yaml
S3Config = require './config/S3.yml' 
S3client = knox.createClient(S3Config)

### - - - - - S3 Related Config - - - - - ###
appdir = '/apps/'
apps_filename = 'apps.json'
apps_file_url = 'https://'+S3Config['bucket']+'.s3.amazonaws.com' +appdir+apps_filename
console.log "apps.json is: #{apps_file_url}"

# {NodeCDN} = require('./src') # see: http://stackoverflow.com/a/10772136/1148249
# S3 = new NodeCDN

### - - - - - MUST Move these Methods to Lib in Next sprint - - - - - ###

S3uploadjson = (filename, jsonstr) ->
  req = S3client.put(appdir+filename, 
      'Content-Length': jsonstr.length
      'Content-Type': 'application/json'
      'x-amz-acl': 'public-read'
  )
  req.on('response', (res) ->
    if (200 == res.statusCode) 
      console.log('saved to %s', req.url);
  )
  req.end(jsonstr)

### Cleans the $H!T JSON We get from Salesforce ###
cleanbodyjson = (req, callback) ->
  console.log('..................................>> /upload req.body :')
  console.log req.body
  console.log('..................................<< /upload req.body')
  try # cleaning dirt
    if req.body.json is undefined
      json = req.body # dirty
    else 
      json = req.body.json # maybe clean
  catch error
    console.log "InVALID JSON"
    throw error
  dirty = json  #ReFactor This! 
  console.log("     TYPE : #{typeof dirty}")
  if typeof dirty is 'object'
    dirty = JSON.stringify(dirty)
    dirty = dirty.replace(/\\"/g, '"')
  len = dirty.length
  console.log "Length: #{len}"
  pos1 = dirty.search /{"attributes":/
  console.log "{\"attributes\" : #{pos1}"
  if pos1 > 0
    dirty = dirty.slice(pos1, len)
  pos2 = dirty.search /"Featured__c":false}/
  console.log " :false} : #{pos2}"
  if pos2 > 0
    dirty = dirty.slice(0, pos2+20)
  pos3 = dirty.search /"Featured__c":true/
  console.log " :true} : #{pos3}"
  if pos3 > 0
    dirty = dirty.slice(0, pos3+19);
  pos4 = dirty.search /' }]/
  console.log "' }] : #{pos4}"
  if pos4 > 0 
    dirty = dirty.slice(0, pos4);
  pos5 = dirty.search /\"}]/
  console.log " \"}] : #{pos5}"
  if pos5 > 0 
    dirty = dirty.slice(0, pos5);
  dirty.replace(/id":"/g, 'id=')
  len = json.length
  if json.charAt len is '"'
    json = json.slice(0,len) # removes trailing double-quote
  console.log "CLEAN: #{dirty}"
  callback(dirty)

# Get the email address by looking up the session id in redis
# and slice out the email address iKOW THIS IS A HACK!! Please fix!
get_email = (req, callback) ->
  console.dir req.headers.cookie
  connect_session_id_cookie = 'connect.sid='
  cookiepos = req.headers.cookie.search /connect_session_id_cookie/
  # console.log cookiepos
  start = cookiepos + connect_session_id_cookie.length+1
  end   = req.headers.cookie.search /;/
  cookie = req.headers.cookie.slice(start, end);
  # console.dir cookie
  redis_sess = 'sess:'+cookie.replace(/\'/g,'')
  redis_sess = redis_sess.replace(/%2F/g,'/')
  redis_sess = redis_sess.slice(0,74)
  # console.log redis_sess
  redis_client.get(redis_sess, (err,reply) ->
    # console.log("REDIS REPLY:")
    # console.dir reply
    json = JSON.parse(reply)
    email = json.passport.user.profiles.google[0]['emails'][0]['value']
    # console.dir json.passport.user.profiles.google[0]['emails'][0]['value']
    callback(email)
  )

get_app_list = (req, callback) ->
  # first check if this *user* has customiszed her ribbon
  get_email(req, (email) ->
    myapps = 'apps:'+email+'.json'
    console.log "MYAPPS: #{myapps}"
    redis_client.get(myapps, (err,reply) ->
      if err or reply is null
        console.log "REDIS ERROR: #{err} (user has not personalised ribbon)"
        # if user has no custom ribbon, return full list of apps
        redis_client.get('apps:apps.json', (err,reply) ->
          console.log "Send ALL apps.json to browser"
          callback(reply) 
        )
      else
        callback(reply)
    )
  )

set_my_apps = (req, callback) ->
  console.log('..................................>> /upload req.body :')
  console.log req.body
  console.log('..................................<< /upload req.body')

  try # cleaning dirt
    if req.body.json is undefined
      json = req.body # dirty
    else 
      json = req.body.json # maybe clean
    json = JSON.parse(json)
  catch error
    console.log "InVALID JSON"
    throw error

  get_email(req, (email) -> 
    redis_client.set('apps:'+email+'.json', JSON.stringify(json))
  )
  callback(json)

### List all the json files in the S3 Bucket ###
S3GetListOfApps = (callback) ->
  S3client.list { prefix: 'apps' }, (err, data) ->
    appcount  = data['Contents'].length
    if appcount > 0
      app_keys = []
      for app in data['Contents']
        # console.log app['Key']
        testapp = app['Key'].search /_TEST/  # we're not interested in _TEST apps
        allapps = app['Key'].search /apps\/apps/
        if allapps is -1 and testapp is -1
          app_keys.push app['Key']
      callback(app_keys)

### Fetch JSON of a Single app from S3 Bucket using JQuery $.getJSON ###
S3ReadSingleAppJSON = (url, callback) ->
  app_url = 'https://'+S3Config['bucket']+'.s3.amazonaws.com/' +url
  # console.log "S3ReadSingleAppJSON for #{app_url}"
  # console.log "url:#{url}"
  S3client.getFile('/'+url, (err,res) ->
    res.on('data', (data) ->
      if res.statusCode isnt 200
        console.log "Content Type: #{res.headers['content-type']}"
        console.log('..................................>> BAD S3 Res :')
        console.log data.toString()
        console.log('..................................<< BAD S3 Res')
      else 
        app = JSON.parse(data.toString())
        a = {} # extract only the essential fields
        a['Id'] = app['Id']
        a['Name'] = app['Name']
        a['Mandatory__c'] = app['Mandatory__c']
        a['Default__c'] = app['Default__c']
        a['Application_Icon_Url__c'] = app['Application_Icon_Url__c']
        a['Application_URL__c'] = app['Application_URL__c']
        a['Description__c'] = app['Description__c']
        a['Active__c'] = app['Active__c']
        # write these essential fields to Redis
        redis_client.set('apps:'+a['Id']+'.json', JSON.stringify(a))
        callback(a)
    ) # END res.on
  ) # END getFile

# url = "apps/a07b0000004bXrFAAU.json"
# S3ReadSingleAppJSON(url, (a) ->
#   console.log a
# )

rebuild_apps_json = (callback) ->
  S3GetListOfApps (keys) ->
    appcount = keys.length
    # console.log "Number of Apps to Fetch: #{appcount}"
    i = 0
    all_apps = []
    for url in keys
      S3ReadSingleAppJSON(url, (json) ->
        # console.log "ID: #{json['Id']}"
        if json['Active__c'] == true
          all_apps.push json
        if i++ is  appcount-1
          S3uploadjson(apps_filename, JSON.stringify(all_apps))
          callback(all_apps)
      )

### - - - - - - Ribbon / Apps Related Routes - - - - - - ### 

### Upload a JSON String and push that as a file to S3 ###
app.post '/upload', (req, res, next) ->
  cleanbodyjson(req, (json) ->
    newapp = JSON.parse(json)
    filename = newapp['Id']+'.json'
    S3uploadjson(filename, JSON.stringify(newapp))
    res.send newapp
    # After we res.send we rebuild apps.json on S3 & Redis
    rebuild_apps_json( (all_apps) ->
      console.log "New App Count #{all_apps.length}"
    )
  )

### Fetch FULL List of APPS from Redis ###
app.get '/appsjson', (req, res) ->
  redis_client.get('apps:apps.json', (err,reply) ->
    res.send JSON.parse(reply)
  )

### Get PERSONALISED List of APPS from Redis ###
app.get '/getmyappsjson', (req, res) ->
  get_app_list(req, (reply) ->
    res.send JSON.parse(reply)
  )  

### Set PERSONALISED List of APPS to Redis ###
app.post '/setmyappsjson', (req, res) ->
  set_my_apps(req, (json) ->
    res.send json
  )  

### List the apps/#{id}.json files in S3 Bucket ###
app.get '/listapps', (req,res) ->
  S3GetListOfApps( (keys) ->
    # console.log keys
    res.send keys
  )

app.get '/rebuildappjson', (req,res) -> 
  rebuild_apps_json( (all_apps) ->
    res.send all_apps
  )

### GEt the logged in user's email address from Session Cookie ###
app.get '/email', (req, res) ->
  get_email(req, (email) ->
      res.send {'email':email}
  )

### - - - - - - - - TDD Specific Functions & Routes - - - - - - - - ###

ECT = require 'ect'
Faker = require 'Faker'

uniqueId = (length=18) -> # generates a random Id with _TEST prefix for Fake Apps
  id = '_TEST'
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

CreateFakeApp = () ->
  exampleapp = require('./public/app-example.json')
  exampleapp['Active__c'] = false
  exampleapp['Id'] = uniqueId(18)
  exampleapp['Mandatory__c'] = Math.random() < 0.5 ? true : false
  exampleapp['Name'] = Faker.random.bs_buzz()
  exampleapp['Description__c'] = Faker.Lorem.sentence()
  return exampleapp

# Define ECT as Templating Language >> http://ectjs.com/#benchmark
ectRenderer = ECT({ watch: true, root: __dirname + '/views' })
app.engine('.html', ectRenderer.render)

app.get '/', (req, res) ->
  res.render('ribbon.html', { title: 'App Ribbon Test' })

app.get '/upload', (req, res) ->
  res.render('uploadform.html', { title: 'Basic Uploader Form' })

app.get '/fakeapp', (req, res) ->
  exampleapp = CreateFakeApp()
  res.send exampleapp

app.get '/tdd', (req, res) ->
  res.render('SpecRunner.html', { title: 'Test Runner' })

app.get '/s3url', (req, res) ->
  res.send { url: 'http://'+S3Config.bucket+'.s3.amazonaws.com/' }

### - - - - - - - - - Don't Copy below this point - - - - - - - - - ###


port = process.env.PORT || 5000
app.listen(port)
console.log("Express started on port #{port}")