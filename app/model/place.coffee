#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Schema}   = require 'mongoose'
{validate} = require 'mongoose-validator'

name = 'Place'

schema = new Schema({

	type:
		type     : String
		required : yes

	loc:
		type     : [ Number ]
		index    : '2d'
		required : yes

	ranking:
		type     : Number
		default  : 1

	likes: [{
		type    : Schema.Types.ObjectId
		ref     : 'User'
	}]

	tips: [{
		type    : Schema.Types.ObjectId
		ref     : 'Tip'
	}]

	checkins: [{
		type    : Schema.Types.ObjectId
		ref     : 'Checkin'
	}]

},{
	versionKey : no
})

module.exports.name   = name
module.exports.schema = schema
