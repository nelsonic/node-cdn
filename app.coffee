express = require 'express'
ECT = require 'ect'
fs = require 'fs'
Faker = require 'Faker'
appdir = './apps/'
port = 3000

# not uploading to S3 till we get the JSONP Right (aprox 2h more work+testing)
# {NodeCDN} = require('./src') # see: http://stackoverflow.com/a/10772136/1148249
# S3 = new NodeCDN

### @Todo: Move these Methods to Lib in Next sprint ###

uniqueId = (length=18) -> # generates a random Id with _TEST prefix for Fake Apps
  id = '_TEST'
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

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


app.get '/upload', (req, res) ->
  res.render('uploadform.html', { title: 'Basic Uploader Form' })

app.post '/upload', (req, res, next) ->
  filename = savejson(req.body.json)
  res.send {"filename":JSON.parse(req.body.json)['Id']+'.json'}

app.get '/fakeapp', (req, res) ->
  exampleapp = require('./app-example.json')
  exampleapp['Id'] = uniqueId(18)
  exampleapp['Mandatory__c'] = Math.random() < 0.5 ? true : false
  exampleapp['Name'] = Faker.random.bs_buzz()
  exampleapp['Description__c'] = Faker.Lorem.sentence()
  res.send exampleapp

app.get '/tdd', (req, res) ->
  res.render('SpecRunner.html', { title: 'Test Runner' })

app.get '/s3url', (req, res) ->
  res.send { url: 'http://'+S3.S3Config.bucket+'.s3.amazonaws.com/' }

app.get '/buildappsjson', (req, res) ->
  buildappsjson() # recreate & save the apps.json file
  apps = require('./apps/apps.json')
  # console.dir apps
  res.send JSON.stringify(apps)

app.listen(port)
console.log("Express started on port #{port}")