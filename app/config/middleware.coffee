module.exports = (express) ->

	app.use (req, res, next) ->
		res.header "Access-Control-Allow-Origin", "http://pladdy.com"
		res.header "X-Powered-By", "Pladdy v1"
		next()

	app.use express.json()
	app.use express.urlencoded()

	app.use express.static "#{paths.WEBROOT}"

	app.use express.logger(':remote-addr - :status - ":method :url" (:referrer) - :response-time ms - :user-agent')

	app.use app.router

	app.use (err, req, res, next) ->
		res.render 'pages/404', title : '404 Not Found'

	app.use express.errorHandler
		dumpExceptions : true
		showStack      : true
