{dispatch} = require "#{PATHS.LIB}/routing"

module.exports = (app) ->

	app.get  '/v:ver/users'       , dispatch controller : 'users', action : 'list'  , auth : yes
	app.post '/v:ver/users/signup', dispatch controller : 'users', action : 'signup', auth : no
