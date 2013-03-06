#
#   Author : Francesco Pasqua
#   Email  : cesconix87@gmail.com
#
#   Copyright (c) cescolab 2013. All Rights Reserved.
#

{Api} = require "#{paths.CONTROLLER}/common/component"
_js   = require 'underscore'

module.exports =

class TipDelete extends Api

	constructor: ->
		super

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		TipModel      = db.model 'Tip'
		PlaceModel    = db.model 'Place'
		ActivityModel = db.model 'Activity'

		PlaceModel.findOne { _id : @data.place_id, tips : { $in : [@data.tip_id] } }, (err, place) =>

			if not place?
				return Response.endpoint_error res, 'place or tip not found'

			if _js.indexOf(res.locals.user.tips.toString().split(','), @data.tip_id.toString()) is -1
				return Response.other res, 'you cannot delete a tip of another user'

			TipModel.findOneAndRemove { _id : @data.tip_id }, (err) =>
				if err?
					Logger.error "TipDelete: tip not removed. Details: #{err}"
					return Response.server_error res, 'internal server error'

				#
				# Delete this tip from Place
				#

				place.tips.pull @data.tip_id
				place.save (err) ->
					if err?
						Logger.error "TipDelete: place not updated. Details: #{err}"
				#
				# Delete this tip from User
				#

				res.locals.user.tips.pull @data.tip_id
				res.locals.user.save (err) ->
					if err?
						Logger.error "TipDelete: user not updated. Details: #{err}"

				#
				# Delete Activity
				#

				removeConditions =
					'actor.object'  : res.locals.user
					'verb'          : 'tip'
					'object.object' : place

				ActivityModel.findOneAndRemove removeConditions, (err) ->
					if err?
						Logger.error "TipDelete: activity not removed. Details: #{err}"

				return Response.ok res

