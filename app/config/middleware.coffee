module.exports = (express) ->

	app.use express.logger()
	app.use Core.L10n.init()
	app.use express.bodyParser()
	app.use express.static "#{paths.WEBROOT}"
	app.use app.router
	app.use express.errorHandler
		dumpExceptions : true
		showStack      : true
