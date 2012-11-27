{dispatch} = require "#{paths.LIB}/routing"

module.exports = () ->

	app.get '/v:ver/users/signup', dispatch controller : 'users', action : 'signup', auth : no
