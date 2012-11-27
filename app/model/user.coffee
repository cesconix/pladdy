{Schema} = require 'mongoose'

name = 'User'

schema = new Schema
	email :
		type : String

module.exports.name   = name
module.exports.schema = schema
