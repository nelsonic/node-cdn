uniqueId = (length=18) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

saveapp = (jsonStr) ->
  id = JSON.parse(jsonStr)['Id']
  filename = appdir+id+".json"
  fs.writeFile filename, jsonStr,  (err) ->
    console.log "Wrote: #{filename}"


express = require 'express'
fs = require 'fs'
appdir = './uploads/'

app = module.exports = express()
app.use(express.bodyParser())

app.get '/upload', (req, res) ->
  res.send ''' <html><head></head><body>
  <form method="post" action="/upload" enctype="multipart/form-data">
  Json: <input type="text" name="json" />
  <input type="submit" value="upload" />
  </form></body></html>'''

app.post '/upload', (req, res, next) ->
  saveapp(req.body.json)
  res.send req.body.json

app.get '/fakeapp', (req, res) ->
  exampleapp = require('./app-example.json')
  exampleapp['Id'] = uniqueId(18)
  res.send exampleapp


app.listen(3000)
console.log('Express started on port 3000')



