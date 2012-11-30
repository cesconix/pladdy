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

GLOBAL.__     = Core.L10n.__
GLOBAL.Logger = Core.Logger

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
require("#{paths.CONFIG}/#{file}") express for file in [
	  'system'
	, 'middleware'
	, 'database'
	, 'app'
]

# Routes
require "#{paths.ROUTE}/#{file}" for file in readdirSync("#{paths.ROUTE}").reverse() when extname(file) is '.coffee'

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

GLOBAL.db = db

# Go!
server.listen( app.get 'system port' )
