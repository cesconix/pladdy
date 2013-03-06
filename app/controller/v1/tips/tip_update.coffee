#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api}           = require "#{paths.CONTROLLER}/common/component"
{compactObject} = require "#{paths.CONTROLLER}/common/helpers"

_js   = require 'underscore'

module.exports =

class TipUpdate extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		body:
			text : { required : yes }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		PlaceModel    = db.model 'Place'
		TipModel      = db.model 'Tip'
		ActivityModel = db.model 'Activity'

		PlaceModel.findOne { _id : @data.place_id, tips : { $in : [@data.tip_id] } }, (err, place) =>

			if not place?
				return Response.endpoint_error res, 'place or tip not found'

			if _js.indexOf(res.locals.user.tips.toString().split(','), @data.tip_id.toString()) is -1
				return Response.other res, 'you cannot modify a tip of another user'

			TipModel.findOneAndUpdate { _id : @data.tip_id }, { text : @data.text, modified : new Date() }, (err, tip) ->
				if err?
					Logger.error "TipUpdate: tip not updated. Details: #{err}"
					return Response.validation_error err, res

				return Response.ok res, compactObject('tip', tip).object
