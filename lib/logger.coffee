#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

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
