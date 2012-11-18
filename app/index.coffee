{readdirSync}      = require 'fs'
{extname, resolve} = require 'path'

http     = require 'http'
express  = require 'express'
mongoose = require 'mongoose'
socketio = require 'socket.io'

app      = express()
server   = http.createServer app
io       = socketio.listen server

# Paths
APP_DIR      = resolve './app'
LIB_DIR      = resolve './lib'
global.PATHS =
	CONFIG     : "#{APP_DIR}/config"
	MODEL      : "#{APP_DIR}/model"
	VIEW       : "#{APP_DIR}/view"
	CONTROLLER : "#{APP_DIR}/controller"
	ROUTE      : "#{APP_DIR}/route"
	LOCALE     : "#{APP_DIR}/locale"
	LOG        : "#{APP_DIR}/log"
	LIB        : "#{LIB_DIR}"

# Config
require("#{PATHS.CONFIG}/#{file}") app, express for file in [
	  'system'
	, 'middleware'
	, 'database'
	, 'app'
]

# Routes
require("#{PATHS.ROUTE}/#{file}") app for file in (readdirSync "#{PATHS.ROUTE}").reverse() when (extname file) is '.js'

server.listen app.get 'system port'
