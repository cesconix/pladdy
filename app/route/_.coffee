{dispatch} = require "#{PATHS.LIB}/routing"

module.exports = (app) ->

	app.all '/v:ver/*', dispatch controller : 'common', action : 'endpoint_error', auth : no
	app.all '/v:ver'  , dispatch controller : 'common', action : 'index'         , auth : no
	app.all '/'       , dispatch controller : 'common', action : 'index'         , auth : no
	app.all '*'       , dispatch controller : 'common', action : 'page_not_found', auth : no
