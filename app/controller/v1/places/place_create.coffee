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

class PlaceCreate extends Api

	constructor: ->
		super
		@params = params

	#
	# API Params
	#
	params =
		body:
			lat  : { required : yes }
			lng  : { required : yes }
			type : { required : yes, values : ['love', 'vendor'] }

	#
	# Execute
	#
	exec: (req, res) ->
		return if super is false

		# Models
		PlaceModel    = db.model 'Place'
		ActivityModel = db.model 'Activity'

		where =
			type : @data.type
			loc  :
				$near        : [ @data.lat, @data.lng ]
				$maxDistance : app.get('app settings').maxDistance

		PlaceModel.find where, (err, results) =>

			# clone results
			places = results.slice()

			# create new place
			place      = new PlaceModel
			place.type = @data.type
			place.loc  = [@data.lat, @data.lng]

 			# insert this new place in clone results
			places.push place

			merged = no
			places_removed = []

			# calculation of the average distance between the points
			while (places.length > 1)

				merged = yes

				# create new place place from the merge data of the first 2 places
				new_place = @merge places[0], places[1]

				places_removed.push places[0], places[1]

				# delete first 2 places found
				places.splice 0, 2

				# save new place in head of the clone results
				places.unshift new_place

			# delete all places from db
			for result in results
				result.remove()

			# add new place
			if places.length is 1
				place          = new PlaceModel
				place.type     = @data.type
				place.loc      = [ places[0].loc[0], places[0].loc[1] ]
				place.ranking  = places[0].ranking
				place.likes    = places[0].likes
				place.tips     = places[0].tips
				place.checkins = places[0].checkins
				place.save (err) ->
					if err?
						Logger.error err
						return Response.server_error res, 'internal server error'

					if merged
						ActivityModel.update({ 'actor.type'  : 'place',  'actor.object' : { $in : places_removed } }, {  'actor.object' : place }).exec()
						ActivityModel.update({ 'object.type' : 'place', 'object.object' : { $in : places_removed } }, { 'object.object' : place }).exec()
						ActivityModel.update({ 'target.type' : 'place', 'target.object' : { $in : places_removed } }, { 'target.object' : place }).exec()
					else
						activity        = new ActivityModel
						activity.verb   = "place.#{place.type}"
						activity.actor  = { type : 'user' , object : res.locals.user }
						activity.object = { type : 'place', object : place }
						activity.target = { type : 'place', object : place }
						activity.save()

					return Response.created res, compactObject('place', place).object

	merge: (p1, p2) ->
		PlaceModel    = db.model 'Place'

		lat = ( (p1.ranking * p1.loc[0]) + (p2.ranking * p2.loc[0]) ) / (p1.ranking + p2.ranking)
		lng = ( (p1.ranking * p1.loc[1]) + (p2.ranking * p2.loc[1]) ) / (p1.ranking + p2.ranking)
		rnk = p1.ranking + p2.ranking

		place          = new PlaceModel
		place.type     = p1.type
		place.loc      = [ lat, lng ]
		place.ranking  = rnk
		place.likes    = _js.union p1.likes   , p2.likes
		place.tips     = _js.union p1.tips    , p2.tips
		place.checkins = _js.union p1.checkins, p2.checkins

		return place
