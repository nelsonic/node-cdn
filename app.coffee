"use strict"                 # need this for JSLint Pass ;-)
express = require 'express'
app = express()
port = 3000
ECT = require 'ect'
ectRenderer = ECT({ watch: true, root: __dirname + '/views' })
app.engine('.html', ectRenderer.render)

app.configure( -> 
  # app.set('views', __dirname + '/views')
  # app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.cookieParser())
  app.use(express.session({ secret: 'iHoardOldComputers' }))
  # app.use(require('stylus').middleware({ src: __dirname + '/public' }));
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
)

{NodeCDN} = require('./src') # see: http://stackoverflow.com/a/10772136/1148249
S3 = new NodeCDN
S3.upload()

app.get '/test', (req,res) ->
	res.render('layout.html', { title: 'Basic Uploader Form' })
	# console.log(req)

app.post '/upload', (req,res) ->
	console.log(req)
	console.log('upload it!')

app.get 'examplejson', (req,res) ->
  res.render('layout.html', { title: 'Basic Uploader Form' })


filename = 'package.json'
S3.client.putFile('./'+filename, filename, {'x-amz-acl': 'public-read'}, (err, res) ->
  # console.log res
)


app.listen(port);
console.log("Express server listening on port #{port}")