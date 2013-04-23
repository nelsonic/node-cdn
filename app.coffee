### jslint nomen: true, plusplus: true, vars: true, indent: 2, node: true ###
"use strict" # need this for JSLint Pass
express = require 'express'
$ = require 'jquery'
ECT = require 'ect'
fs = require 'fs'
Faker = require 'Faker'
async = require 'async'
# jsdom = require 'jsdom'

### REDIS ###
redis = require 'redis'
redis_client = redis.createClient()
redis_client.on "error", (err) ->
  console.log("REDIS Error " + err);

# S3
require 'js-yaml'              # see: https://github.com/nodeca/js-yaml
S3Config = require './config/S3.yml' 
knox = require 'knox' 
S3client = knox.createClient(S3Config)

appdir = '/apps/'
apps_filename = 'apps.json'
apps_file_url = 'https://'+S3Config['bucket']+'.s3.amazonaws.com' +appdir+apps_filename
console.log "apps.json is: #{apps_file_url}"
port = process.env.PORT || 5000
console.log " - - - - - - - - - process - - - - - - - - - "
console.log process.argv
console.log " - - - - - - - - - - - - - - - - - - - - - - - - "

# {NodeCDN} = require('./src') # see: http://stackoverflow.com/a/10772136/1148249
# S3 = new NodeCDN

### - - - - - MUST Move these Methods to Lib in Next sprint - - - - - ###

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

S3upload = (filename, jsonstr) ->
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

# upsert newapp in apps.json where newapp = json object of an app
S3UpdateAppsJSON = (newapp) ->
  # console.log(newapp['Id'])
  existing_apps = []
  $.getJSON apps_file_url, (apps) ->
    console.log "There are #{apps.length} Apps"
    if apps.length > 0
      for app in apps
        existing_apps.push app['Id']
        # if the app is already in apps.json update it
        if app['Id'] is newapp['Id']
          app = newapp # over-write / upsert it
          # console.log "Updating App : #{app['Id']}"

    else # there are no apps!
      S3CreateNewAppsJSONFile(newapp)

    if newapp['Id'] in existing_apps
      # console.log "#{newapp['Id']} already existed"
      S3upload(apps_filename, JSON.stringify(apps))
    else
      console.log "*NEW* App: #{newapp['Id']}"
      # console.dir existing_apps
      apps.push newapp 
      console.log "Number of apps with *New* App: #{apps.length}"
      appsnew = apps
      S3upload(apps_filename, JSON.stringify(appsnew))
      # create new apps.json
  .error () ->
    console.log 'error fetching apps.json ... CREATE it!'
    S3CreateNewAppsJSONFile(newapp)

S3CreateNewAppsJSONFile = (newapp) ->
  apps = []
  apps.push(newapp)
  S3upload(apps_filename, JSON.stringify(apps))

# If there is No apps.json FILE on S3
# or the file contains ZERO Apps
# we need to create it with this "example" App:
# exampleapp = require('./public/app-example.json')    
# apps = S3UpdateAppsJSON(exampleapp)


### - - - - - - - - The Mini Express App - - - - - - - - ###

app = module.exports = express()
app.configure () ->
  app.use(express.bodyParser()) #used to parse form submissions
  app.use(express.static(__dirname + '/public')) # local static files >> S3
  app.use(express.static(__dirname + '/spec'))   # tests public for Jasmine 
  app.use(express.static(__dirname + '/lib'))    # lib public for Jasmine access
  app.use(express.static(__dirname + '/apps'))   # apps.json local    >> S3
  # app.use(express.session({ secret: 'keyboard cat' }))
  app.use(express.cookieParser())

app.post '/upload', (req, res, next) ->
  console.log('..................................>> req.body :')
  console.log req.body
  console.log('..................................<< req.body')

  try # cleaning dirt
    if req.body.json is undefined
      json = req.body # dirty
    else 
      json = req.body.json # maybe clean
    json = cleanbodyjson(json)
    len = json.length
    if json.charAt len is '"'
      json = json.slice(0,len)
    newapp = JSON.parse(json)
  catch error
    console.log "InVALID JSON"
    throw error

  filename = newapp['Id']+'.json'
  S3upload(filename, JSON.stringify(newapp))
  S3UpdateAppsJSON(newapp)
  res.send(newapp)

### GEt the logged in user's email address from Session Cookie ###
app.get '/email', (req, res) ->
  get_email(req, (email) ->
      res.send {'email':email}
  )

### Cleans the $H!T JSON We get from Salesforce ###
cleanbodyjson = (dirty) ->
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
  console.log "CLEAN: #{dirty}"
  return dirty

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

get_personalised_ribbon = (req, callback) ->
  get_email req, (email) ->
    if(email.search /@/)
      console.log email

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
S3ReadSingleAppJSON = (app_url, callback) ->
  console.log "S3ReadSingleAppJSON for #{app_url}"
  $.getJSON app_url, (app) ->
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

### Fetch FULL List of APPS from Redis ###
app.get '/appsjson', (req, res) ->
  redis_client.get('apps:apps.json', (err,reply) ->
    res.send JSON.parse(reply)
  )

### Fetch PERSONALISED List of APPS from Redis ###
app.get '/myappsjson', (req, res) ->
  get_app_list(req, (reply) ->
    res.send JSON.parse(reply)
  )  

### List the apps/#{id}.json files in S3 Bucket ###
app.get '/listapps', (req,res) ->
  S3GetListOfApps( (keys) ->
    # console.log keys
    res.send keys
  )

app.get '/rebuildappjson', (req,res) -> 
  S3GetListOfApps (keys) ->
    appcount = keys.length
    console.log "Number of Apps to Fetch: #{appcount}"
    i = 0
    all_apps = []
    for url in keys
      app_url = 'https://'+S3Config['bucket']+'.s3.amazonaws.com/' +url
      S3ReadSingleAppJSON(app_url, (json) ->
        console.log "ID: #{json['Id']}"
        if json['Active__c'] == true
          all_apps.push json
        if i++ is  appcount-1
          S3upload(apps_filename, JSON.stringify(all_apps))
          res.send all_apps
      )

app.get '/ribbon', (req,res) ->
  get_personalised_ribbon req, (email) ->
    console.log email
    res.send email

### - - - - - - - - TDD Specific Routes - - - - - - - - ###

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

app.listen(port)
console.log("Express started on port #{port}")