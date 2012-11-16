{param_error} = require "#{PATHS.LIB}/response"

module.exports.dispatch = (params) ->

	(req, res) ->

		if params.auth is yes
			access_token = req.query.access_token or '';
			res.send param_error 'Missing access_token credential' if access_token is ''

		version    = req.params.ver;
		controller = require "#{PATHS.CONTROLLER}/v#{version}/#{params.controller}"

		controller[ params.action ] req, res
