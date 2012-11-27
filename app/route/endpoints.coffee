{dispatch} = require "#{paths.LIB}/routing"

module.exports = () ->

	app.all '/endpoints', dispatch controller : 'common', action : 'endpoints', auth : no
