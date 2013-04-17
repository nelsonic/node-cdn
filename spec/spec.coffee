describe 'iNI Phase 2 - App Ribbon (NodeJS) Tests', ->

  it 'GET /appsjson should return a list of apps', ->
  	$.getJSON '/appsjson', (json) ->
  		window.appcount = json.length
  		console.log "Number of apps: #{window.appcount} (before re-building apps.json)"
  		i = 1
  		for app in json 
  			console.log "#{i++} : #{app['Id']} : #{app['Name']}"
  			expect(window.appcount).toBeGreaterThan(0) #  >> re-work this!


  it "GET /fakeapp returns a 'Fake' App (JSON) for testing purposes", ->
		# this creates an apps.json file if one doesn't exist
		# $.get '/buildappsjson', (data) ->

    $.getJSON 'fakeapp', (json) ->
    	console.log("Id #{json['Id']} length #{json['Id'].length} == 18")
    	expect(json["Active__c"]).toEqual(true)
    	expect(json["Id"].length).toEqual(18)

    	# feel free to write other expectations here just keeping it simple

  it 'POST /upload should upload a JSON string/file to Node', ->
  	# When submitting a POST Request to /upload with JSon
  	$.getJSON '/fakeapp', (json) ->
  		window.Id = json['Id']
  		window.jsonstr = JSON.stringify(json)
  		$.post '/upload', "json": window.jsonstr, (data) ->
				# uploadedfile = 'https://mpyc.s3.amazonaws.com/apps/'+window.Id + '.json'
				# console.log "Fetching: #{uploadedfile}"
				delay = (ms, func) -> setTimeout func, ms
				delay 500, -> 
					$.getJSON '/appsjson', (json) ->
  	  			newappcount = json.length
  	  			console.log "Old App Count #{window.appcount} >> new count #{newappcount}"
  	  			expect(newappcount).toBeGreaterThan(window.appcount)


  xit 'Should add a new app to list of apps (rebuild apps.json file)', ->



### I will be re-writing these tests in Sprint 2 to use /lib to keep them clean ###