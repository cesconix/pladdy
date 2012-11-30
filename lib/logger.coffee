winston = require 'winston'

Logger = new winston.Logger
	transports : [
		new winston.transports.Console
			handleExceptions : on
			colorize         : on
			timestamp        : on
	]
	exitOnError : false

module.exports = Logger
