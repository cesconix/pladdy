module.exports = (app, express) ->

	app.use express.logger()
	app.use express.bodyParser()
	app.use app.router
	app.use express.errorHandler
		dumpExceptions : true
		showStack      : true
