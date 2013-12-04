mongoose = require "mongoose"
{Schema} = mongoose
{ObjectId} = Schema.Types
{png64} = require "../utils"

Canvas  = require "canvas"
{Image} = Canvas

mixTypeSchema = new Schema
	slug:
		type: String
		required: true
	name:
		type: String
		required: true
	rect:
		x: Number
		y: Number
		w: Number
		h: Number
	file:
		type: String
		required: true
	mixables: [
		type: ObjectId
		ref: "Mixable"
	]

mixableSchema = new Schema
	name:
		type: String
		required: true
	author:
		type: String
		required: true
	image: Buffer

previewCache = {}

drawSprite = (ctx, img, sprx, spry, desx, desy, fileType="tiles") ->
	switch fileType
		when "tiles"
			ctx.drawImage(img, sprx*40, spry*40, 40, 40, desx, desy, 40, 40)

doneDrawing = (canvas, _id, callback) ->
	canvas.toDataURL (err, url) ->
		previewCache[_id] = url
		callback url

mixableSchema.methods.getPreview = (callback) ->
	if @_id of previewCache then callback previewCache[@_id]
	else
		lightBG = "#d4d4d4"

		canvas = new Canvas 110, 60
		ctx = canvas.getContext("2d")

		ctx.fillStyle = lightBG
		ctx.fillRect(0, 0, canvas.width, canvas.height)

		tiles = new Image
		
		@getType (type) =>
			switch type
				when "flag"
					#  ___________________ 
					# |    /‾r‾‾/ /‾b‾‾/  |
					# |   /____/ /____/   |
					# |  /      /         |
					#  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
					
					tiles.onload = ->
						drawSprite(ctx, tiles, 0, 0, 10, 10)
						drawSprite(ctx, tiles, 1, 0, 60, 10)

						doneDrawing(canvas, @_id, callback)

					tiles.src = @image

mixableSchema.methods.getType = (callback) ->
	mongoose.models.MixType
		.findOne(mixables: {$in: [@_id]})
		.select("slug")
		.exec (err, parent) ->
			console.log parent
			callback(parent.slug)

module.exports =
	MixType: mongoose.model "MixType", mixTypeSchema
	Mixable: mongoose.model "Mixable", mixableSchema