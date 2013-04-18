### jslint nomen: true, plusplus: true, vars: true, indent: 2, node: true ###
"use strict" # need this for JSLint Pass
express = require 'express'
$ = require 'jquery'
ECT = require 'ect'
fs = require 'fs'
Faker = require 'Faker'
# jsdom = require 'jsdom'

# S3
require 'js-yaml'              # see: https://github.com/nodeca/js-yaml
S3Config = require './config/S3.yml' 
knox = require 'knox' 
client = knox.createClient(S3Config)

appdir = '/apps/'
apps_filename = 'apps.json'
apps_file_url = 'https://'+S3Config['bucket']+'.s3.amazonaws.com' +appdir+apps_filename
console.log "apps.json is: #{apps_file_url}"
port = process.env.PORT || 5000

# {NodeCDN} = require('./src') # see: http://stackoverflow.com/a/10772136/1148249
# S3 = new NodeCDN

### MUST Move these Methods to Lib in Next sprint ###

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
  req = client.put(appdir+filename, 
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
  console.log(newapp['Id'])
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
exampleapp = require('./public/app-example.json')    
apps = S3UpdateAppsJSON(exampleapp)


### The Mini Express App ###

app = module.exports = express()
app.configure () ->
  app.use(express.bodyParser()) #used to parse form submissions
  app.use(express.static(__dirname + '/public')) # local static files >> S3
  app.use(express.static(__dirname + '/spec'))   # tests public for Jasmine 
  app.use(express.static(__dirname + '/lib'))    # lib public for Jasmine access
  app.use(express.static(__dirname + '/apps'))   # apps.json local    >> S3


# Define ECT as Templating Language >> http://ectjs.com/#benchmark
ectRenderer = ECT({ watch: true, root: __dirname + '/views' })
app.engine('.html', ectRenderer.render)

app.get '/', (req, res) ->
  res.render('layout.html', { title: 'Hello!' })

app.get '/upload', (req, res) ->
  res.render('uploadform.html', { title: 'Basic Uploader Form' })

# cleans the $H!T JSON We get from Salesforce
cleanbodyjson = (dirty) ->
  # console.log "........................         BODY IS DIRTY!! :-( "
  # console.dir dirty
  # console.log "........................   "
  # dirty = String(dirty)
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

  pos2 = dirty.search /,"Featured__c":false}'/
  console.log " :false} : #{pos2}"
  if pos2 > 0
    dirty = dirty.slice(0, pos2+21)
  pos3 = dirty.search /,"Featured__c":true}/
  console.log " :true} : #{pos3}"
  if pos3 > 0
    dirty = dirty.slice(0, pos3+20);
  pos4 = dirty.search /' }]/
  console.log "' }] : #{pos4}"
  if pos4 > 0 
    dirty = dirty.slice(0, pos4);
  pos5 = dirty.search /\"}]/
  console.log " \"}] : #{pos5}"
  if pos5 > 0 
    dirty = dirty.slice(0, pos5);
  # console.log "CLEAN: #{dirty}"
  return dirty

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
    newapp = JSON.parse(json)
  catch error
    console.log "InVALID JSON"
    throw error

  filename = newapp['Id']+'.json'
  S3upload(filename, JSON.stringify(newapp))
  S3UpdateAppsJSON(newapp)
  res.send(newapp)


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
  # console.log '\n # # # # # # # # # RAW START \n'
  # console.dir newapp
  # console.log '\n # # # # # # # # # RAW END \n'

  # console.log json
  S3UpdateAppsJSON(json)
  # console.log('\n ------------------- NEXT CALL --------------------- \n')
  res.end()

app.get '/fakeapp', (req, res) ->
  exampleapp = CreateFakeApp()
  res.send exampleapp

app.get '/tdd', (req, res) ->
  res.render('SpecRunner.html', { title: 'Test Runner' })

app.get '/s3url', (req, res) ->
  res.send { url: 'http://'+S3.S3Config.bucket+'.s3.amazonaws.com/' }

app.get '/appsjson', (req, res) ->
  $.getJSON apps_file_url, (json) ->
    res.send json

app.listen(port)
console.log("Express started on port #{port}")