# External module dependencies
mongoose = require "mongoose"
express  = require "express"
http     = require "http"
path     = require "path"
_        = require "lodash"

# Internal module dependencies
utils  = require "./utils" # Utils must come first, as some module loaders need it

models = require "./models"
routes = require "./routes"

#### SCRATCHPAD ####
#                  #

#                  #
####################

# Get express object
app = express()

# Basic setup
app.set "port", process.env.PORT or 3000
app.set "views", "#{__dirname}/views"

# Middleware
app.use express.favicon()
app.use express.logger "dev"
app.use express.json()
app.use app.router
app.use express.static "#{__dirname}/public"

# if app.get("env") is "development"
app.use express.errorHandler()

# Set up routes
for name, route of routes
	if route.get?
		app.get "/#{name}", route.get

	if route.post?
		app.post "/#{name}", route.post

# Check that a mongo connection string is in the ENV
unless process.env.tagpro_mongodb_connection_string?
	console.log "You must specify the environment variable 'tagpro_mongodb_connection_string'"
	process.exit 1

# Connect to mongo server
mongoose.connect process.env.tagpro_mongodb_connection_string

mongoose.connection.on "connected", ->
	# Mongo connection succeeded
	console.log "Successfully connected to mongodb server"

	# Start the HTTP server
	http.createServer(app).listen app.get("port"), ->
		console.log "Running Express HTTP server on port #{app.get "port"}"

mongoose.connection.on "disconnected", ->
	# Mongo connection failed
	console.log "Error connecting to mongodb server"
	process.exit 2
