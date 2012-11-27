{param_error} = require "./response"

L10n          = require "./L10n"
global.__     = L10n.__

module.exports.dispatch = (params) ->

	(req, res) ->

		# API Version
		ver = (Number req.params.ver) or ''
		if ver isnt ''
			ver = "v#{req.params.ver}/"
			res.send 404 if not require('fs').existsSync "#{paths.CONTROLLER}/#{ver}"

		# Check Auth
		if params.auth is yes
			access_token = req.query.access_token or '';
			res.send param_error 'Missing access_token param' if access_token is ''

		# Localization request
		L10n.setLocale req.acceptedLanguages[0]

		# Dispatch to Controller
		(require "#{paths.CONTROLLER}/#{ver}#{params.controller}")[ params.action ] req, res
