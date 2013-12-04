$.ajax
	dataType: "json"
	type: "GET"
	url: "../mixables"
	success: (data) ->

	error: ->
		console.error arguments
		alert "An error occurred loading mixable elements.\nDM JJJollyjim on reddit for help"