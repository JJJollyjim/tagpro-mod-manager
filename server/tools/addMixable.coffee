mongoose = require "mongoose"
fs = require "fs"

require "../utils"
require "../models"
{Mixable, MixType} = mongoose.models
consolog = -> console.log arguments

buf = fs.readFileSync process.argv[4]

mongoose.connect process.env.tagpro_mongodb_connection_string

mongoose.connection.on "connected", ->

	mxbl = new Mixable
		name: process.argv[2]
		author: process.argv[3]
		image: buf

	mxbl.save ->
		MixType.findOne {slug: process.argv[5]}, "", (type) ->
			type.mixables.push mxbl._id
			type.save()