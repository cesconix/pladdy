#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Schema}   = require 'mongoose'
{validate} = require 'mongoose-validator'

name = 'Activity'

schema = new Schema({

	actor:
		type:
			type     : String
			required : yes
		object:
			type     : Schema.Types.ObjectId
			required : yes

	verb:
		type     : String
		required : yes

	object:
		type:
			type     : String
			required : no
		object:
			type     : Schema.Types.ObjectId
			required : no

	target:
		type:
			type     : String
			required : yes
		object:
			type     : Schema.Types.ObjectId
			required : yes

	created:
		type     : Date
		default  : Date.now

},{
	versionKey : no
})

module.exports.name   = name
module.exports.schema = schema
