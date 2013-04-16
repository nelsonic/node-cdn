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