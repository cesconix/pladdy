{existsSync} = require 'fs'

Dispatcher = (params) ->

	(req, res, next) ->

		# API Version
		ver = (Number req.params.ver) or ''
		if ver isnt ''
			ver = "v#{req.params.ver}/"
			if not existsSync "#{paths.CONTROLLER}/#{ver}"
				next

		# Dispatch to Controller
		controller = "#{paths.CONTROLLER}/#{ver}#{params.controller}"

		if not existsSync controller
			next

		controller = require controller

		if params.action not in controller
			next

		controller[ params.action ] req, res

module.exports = Dispatcher

# # Check Auth
# if params.auth is yes
# 	access_token = req.query.access_token or '';
# 	res.send param_error 'Missing access_token param' if access_token is ''
