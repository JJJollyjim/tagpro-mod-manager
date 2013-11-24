# This file will load all coffeescripts in the directory and export them as submodules
# Paste into any directory and it will do the same
# 
# Inspired by Greg Wang's answer on SO:
#  -> http://stackoverflow.com/questions/5364928/node-js-require-all-files-in-a-folder

# require("fs").readdirSync("#{__dirname}/").forEach (file) ->
# 	if file.match(/.+\.coffee/g) isnt null and file isnt "index.coffee"
# 		name = file.replace(".coffee", "")
# 		exports[name] = require("./#{file}")

# Modified version to capatalise the start of each file:
# (depends on String::capFirst, in /utils/capFirst.coffee)

require("fs").readdirSync("#{__dirname}/").forEach (file) ->
	if file.match(/.+\.coffee/g) isnt null and file isnt "index.coffee"
		name = file.replace(".coffee", "").capFirst()
		exports[name] = require("./#{file}")
