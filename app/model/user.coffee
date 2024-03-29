#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Schema}   = require 'mongoose'
{validate} = require 'mongoose-validator'
crypto     = require 'crypto'

name = 'User'

schema = new Schema({

	username:
		type     : String
		required : yes
		unique   : yes
		validate : [
			validate message : __('string not in range 4-15'), 'len', 4, 25
			validate message : __('invalid characters (must be alphanumeric)'), 'isAlphanumeric'
		]

	email:
		type      : String
		required  : yes
		unique    : yes
		lowercase : yes
		validate  : [
			validate message : __('format not valid'), 'isEmail'
		]

	password:
		type     : String
		required : yes
		validate : [
			validate message : __('must be at least 6 characters'), 'len', 6
		]

	hash:
		type     : String

	email_confirmed:
		type    : Boolean
		default : off

	email_detached: [ String ]

	created:
		type    : Date
		default : Date.now

	modified:
		type : Date

	profile:

		name:
			type    : String
			default : ''

		surname:
			type    : String
			default : ''

	ranking:
		type    : Number
		default : 0

	checkins: [{
		type    : Schema.Types.ObjectId
		ref     : 'Checkin'
	}]

	comments: [{
		type    : Schema.Types.ObjectId
		ref     : 'Comment'
	}]

	tips: [{
		type    : Schema.Types.ObjectId
		ref     : 'Tip'
	}]

},{
	versionKey : no
})

schema.pre 'save', (next) ->
	if @password isnt ''
		@password =	crypto
					.createHmac('sha1', app.get 'security salt')
					.update(@password)
					.digest('hex')
	next()

module.exports.name   = name
module.exports.schema = schema
