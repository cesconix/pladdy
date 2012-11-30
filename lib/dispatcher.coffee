Dispatcher = (params) ->

	(req, res, next) ->

		# API Version
		ver = (Number req.params.ver) or ''
		if ver isnt ''
			ver = "v#{req.params.ver}/"

		# Dispatch to Controller
		controller = "#{paths.CONTROLLER}/#{ver}#{params.controller}"

		if require('fs').existsSync controller
			controller = require controller

			if controller[params.action]?
				return controller[params.action] req, res

		next new Error('Controller not found.')

module.exports = Dispatcher

# # Check Auth
# if params.auth is yes
# 	access_token = req.query.access_token or '';
# 	res.send param_error 'Missing access_token param' if access_token is ''
