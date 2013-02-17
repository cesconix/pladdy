{errorHandler} = require "#{paths.CONTROLLER}/common/middleware"

module.exports = (express) ->

	app.use (req, res, next) ->
		res.header "Access-Control-Allow-Origin", "http://pladdy.com"
		res.header "X-Powered-By", "Pladdy v1"
		next()

	app.use Core.L10n.init()

	app.use express.json()
	app.use express.urlencoded()

	app.use express.static "#{paths.WEBROOT}"

	app.use express.logger(':remote-addr - :status - ":method :url" (:referrer) - :response-time ms - :user-agent')

	app.use app.router

	app.use errorHandler
