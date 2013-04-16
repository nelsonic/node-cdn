describe 'iNI Apps Create New App (NodeJS) Tests', ->

  it "GET /fakeapp returns a 'Fake' App (JSON) for testing purposes", ->
  	# app = new App()
  	# app.test
  	
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
				uploadedfile = '/'+window.Id + '.json'
				console.log "Fetching: #{uploadedfile}"
				$.getJSON uploadedfile, (json2) ->
					console.log("Fake app id #{window.Id} == #{json2.Id}")
					expect(JSON.stringify(json2)).toEqual(window.jsonstr)

  it '/apps.json should be a list of apps', ->


  it 'Should add a new app to list of apps', ->

