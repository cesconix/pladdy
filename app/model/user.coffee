{Schema, model} = require 'mongoose'

name = 'User'

schema = new Schema
	email :
		type : String

module.exports = model name, schema
