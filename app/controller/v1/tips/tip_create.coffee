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

class TipCreate extends Api

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

		PlaceModel.findOne { _id : @data.place_id }, (err, place) =>

			if not place?
				return Response.endpoint_error res, 'place not found'

			tip      = new TipModel
			tip.text = @data.text
			tip.save (err) ->
				if err?
					Logger.error "TipCreate: tip not saved. Details: #{err}"
					return Response.validation_error err, res

				place.tips.push tip
				place.save (err) ->
					if err?
						Logger.error "TipCreate: place not updated. Details: #{err}"

				res.locals.user.tips.push tip
				res.locals.user.save (err) ->
					if err?
						Logger.error "TipCreate: user not updated. Details: #{err}"

				#
				# Create Activity
				#

				activity        = new ActivityModel
				activity.verb   = 'tip'
				activity.actor  = { type : 'user' , object : res.locals.user }
				activity.object = { type : 'place', object : place }
				activity.target = { type : 'place', object : place }
				activity.save (err) ->
					if err?
						Logger.error "TipCreate: activity not created. Details: #{err}"

				return Response.created res, compactObject('tip', tip).object
