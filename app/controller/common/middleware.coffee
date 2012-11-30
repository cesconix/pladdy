module.exports.auth = (req, res, next) ->

	# Check Auth
	access_token = req.query.access_token or '';

	if access_token is ''
		Core.Response.param_error res, 'Missing access_token param'
	else
		next()
