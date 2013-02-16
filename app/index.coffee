{readdirSync}      = require 'fs'
{extname, resolve} = require 'path'

#----------------
# PATHS
#----------------

APP_DIR  = resolve './app'
LIB_DIR  = resolve './lib'

GLOBAL.paths =
	CONFIG     : "#{APP_DIR}/config"
	MODEL      : "#{APP_DIR}/model"
	VIEW       : "#{APP_DIR}/view"
	CONTROLLER : "#{APP_DIR}/controller"
	ROUTE      : "#{APP_DIR}/route"
	LOCALE     : "#{APP_DIR}/locale"
	LOG        : "#{APP_DIR}/log"
	WEBROOT    : "#{APP_DIR}/webroot"
	LIB        : "#{LIB_DIR}"

#----------------
# MODULES
#----------------

http     = require 'http'
express  = require 'express'
mongoose = require 'mongoose'
socketio = require 'socket.io'

#----------------
# CORE
#----------------

GLOBAL.Core =
	L10n       : require "#{paths.LIB}/L10n"
	Logger     : require "#{paths.LIB}/logger"
	Response   : require "#{paths.LIB}/response"
	Dispatcher : require "#{paths.LIB}/dispatcher"

GLOBAL.__       = Core.L10n.__
GLOBAL.Logger   = Core.Logger
GLOBAL.Response = Core.Response

#----------------
# INIT
#----------------

app    = express()              # App
server = http.createServer app  # HTTP Server
io     = socketio.listen server # Socket.IO

GLOBAL.app = app

#----------------
# BOOTSTRAP
#----------------

# Config
Logger.info("Config: #{file}.coffee") and require("#{paths.CONFIG}/#{file}") express for file in [
	  'system'
	, 'middleware'
	, 'database'
	, 'storage'
	, 'app'
]

# Routes
for file in readdirSync("#{paths.ROUTE}") when extname(file) is '.coffee' and file isnt '_.coffee'
	Logger.info "Route: #{file}"
	require "#{paths.ROUTE}/#{file}"

Logger.info("Route: _.coffee") and require "#{paths.ROUTE}/_.coffee"

#----------------
# STORAGE
#----------------
# GLOBAL.Storage = require('knox').createClient app.get 'storage'

# require('fs').readFile '/Users/cesconix/repos/pladdy/app/webroot/img/pladdy-logo-email.png', (err, buf) ->
# 	req = Storage.put('/test/lolsd2.png')
# 	req.on 'response', (res) ->
# 		if 200 == res.statusCode
# 			console.log 'saved to %s', req.url
# 	req.end buf

#----------------
# START SERVER
#----------------

# Database Models
for file in readdirSync "#{paths.MODEL}" when extname(file) is '.coffee'
	model = require "#{paths.MODEL}/#{file}"
	mongoose.model model.name, model.schema

# Database Connection
db = app.get('databases')[ app.get 'env' ]
db = mongoose.createConnection(
	  db['host']
	, db['name']
	, db['port']
	, 	user : db['user']
	,  	pass : db['pass']
)

# Database connected callback
db.on 'connected', ->
	Logger.info "*** Connection to database completed."
	Logger.info "Pladdy API RESTful Server started."

GLOBAL.db = db

# Go!
server.listen( app.get 'system port' )
Logger.info "*** Connecting to DB [#{app.get('databases')[app.get('env')].name}] (#{app.get('env')})..."
