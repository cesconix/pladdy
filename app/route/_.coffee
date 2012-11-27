{dispatch} = require "#{paths.LIB}/routing"

module.exports = () ->

	app.all '/v:ver/*', dispatch controller : 'common', action : 'endpoint_error', auth : no
	app.all '/v:ver'  , dispatch controller : 'common', action : 'page_not_found', auth : no
	app.all '/'       , dispatch controller : 'common', action : 'home'          , auth : no
	app.all '*'       , dispatch controller : 'common', action : 'page_not_found', auth : no
