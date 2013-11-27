mongoose = require "mongoose"

Schema = mongoose.Schema

modSchema = new Schema
	name:
		type: String
		unique: true
		dropDups: true
		required: true
	author:
		type: String
		required: true
	reddit:
		type: String
		required: true
	thumbnail: String
	files:
		tiles:
			type: String
			required: true
		speedpad: String
		splats: String
		flair: String
	accepted:
		type: Boolean
		default: false

module.exports = mongoose.model "Mod", modSchema