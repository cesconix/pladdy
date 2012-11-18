{dispatch} = require "#{PATHS.LIB}/routing"

module.exports = (app) ->

	app.post '/v:ver/users/signup', dispatch controller : 'users', action : 'signup', auth : no
