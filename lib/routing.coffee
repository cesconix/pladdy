{param_error} = require "#{PATHS.LIB}/response"

module.exports.dispatch = (params) ->

	(req, res) ->

		# Check API Version
		ver = (Number req.params.ver) or ''
		if ver isnt ''
			ver = "v#{req.params.ver}/"
			res.send 404 if not require('fs').existsSync "#{PATHS.CONTROLLER}/#{ver}"

		# Check Auth
		if params.auth is yes
			access_token = req.query.access_token or '';
			res.send param_error 'Missing access_token param' if access_token is ''

		# Dispatch to Controller
		controller = require "#{PATHS.CONTROLLER}/#{ver}#{params.controller}"
		controller[ params.action ] req, res
