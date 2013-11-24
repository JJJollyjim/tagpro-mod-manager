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
	description:
		type: String
		required: true
	reddit:
		type: String
		required: true
	thumbnail:
		type: Buffer
	accepted:
		type: Boolean
		default: false

module.exports = mongoose.model "Mod", modSchema