describe 'iNI Phase 2 - App Ribbon (NodeJS) Tests', ->

  it 'GET /appsjson should return a list of apps', ->
  	$.getJSON '/appsjson', (json) ->
  		window.appcount = json.length
  		console.log "Number of apps: #{window.appcount} (before re-building apps.json)"
  		i = 1
  		for app in json 
  			# console.log "#{i++} : #{app['Id']} : #{app['Name']} -- Active__c = #{app['Active__c']}"
  			expect(window.appcount).toBeGreaterThan(0) #  >> re-work this!


  it "GET /fakeapp returns a 'Fake' App (JSON) for testing purposes", ->
		# this creates an apps.json file if one doesn't exist
		# $.get '/buildappsjson', (data) ->

    $.getJSON 'fakeapp', (obj) ->
      for json in obj
      	console.log("Id #{json['Id']} length #{json['Id'].length} == 18")
      	expect(json["Active__c"]).toEqual(false)
      	expect(json["Id"].length).toEqual(18)

    	# feel free to write other expectations here just keeping it simple

  it 'POST /upload should upload/update apps.json on S3', ->
  	# When submitting a POST Request 	to /upload with JSon
  	$.getJSON '/fakeapp', (json) ->
  		window.Id = json['Id']
  		window.jsonstr = JSON.stringify(json)
  		$.post '/upload', "json": window.jsonstr, (data) ->
				# uploadedfile = 'https://mpyc.s3.amazonaws.com/apps/'+window.Id + '.json'
				# console.log "Fetching: #{uploadedfile}"

  it 'GET /several-apps.json expects a JSON String/OBJECT with 3 Apps', ->
    $.getJSON '/several-apps.json', (json) -> 
      console.log "Expect Number of apps: #{json.length} == 3"
      expect(json.length).toEqual(3)


  it 'POST /upload (MULTIPLE) should upload a JSON String with 3 Apps', ->
  # When submitting a POST Request  to /upload with JSon
    $.getJSON '/several-apps.json', (json) -> 
      for app in json
        console.log "App ID: #{app['Id']}"
      multiapp = json
      $.post '/upload', "json": multiapp, (data) ->
        # uploadedfile = 'https://mpyc.s3.amazonaws.com/apps/'+window.Id + '.json'
        # console.log "Fetching: #{uploadedfile}"

  it 'GET /s3url returns the full S3 url', ->
    $.getJSON '/s3url', (json) ->
      window.s3url = json['url']
      console.log "S3 URL: #{window.s3url}"

  it 'GET /email Returns the Email Address for the Logged In User', ->
    $.getJSON '/email', (json) ->
      console.log("Email Address: #{json['email']}")

  it 'POST /setmyappsjson updates redis with string of apps', ->
    myjson = {"apps":"1,2,3"}
    window.myjson = myjson
    console.log "MYJSON : #{myjson} [BEFORE]"
    $.post '/setmyappsjson', "json": JSON.stringify(myjson), (data) ->
      console.log(data)

  it 'GET /getmyappsjson updates redis with string of apps', ->
    $.getJSON '/getmyappsjson', (json) ->
      console.log(json)

  xit 'GET /listapps returns a list of all apps', ->
    $.getJSON '/listapps', (app_list) ->
      i = 0
      for url in app_list when i < 1
        jsonp = window.s3url + url + '?callback=mycallback'
        console.log(jsonp)
        mycallback = (data) ->
          console.log json
        $.getJSON jsonp, (data) ->
        i++

	xit 'Confirm uploaded to CDN', ->
		delay = (ms, func) -> setTimeout func, ms
		delay 500, -> 
			$.getJSON '/appsjson', (json) ->
  	  	newappcount = json.length
  	  	console.log "Old App Count #{window.appcount} >> new count #{newappcount}"
  	  	expect(newappcount).toBeGreaterThan(window.appcount)

  xit '/uploadraw', ->
  	#"json":'{"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T04:15:12.000+0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T04:15:12.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}'
  	raw = '{"json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T02:24:04.000 0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id":"015b00000001EScAAM","oid":["00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM","00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T02:24:04.000 0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000 0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}"]}'
  	$.post '/uploadraw', raw, (data) ->
				delay = (ms, func) -> setTimeout func, ms
				delay 500, -> 
				$.getJSON '/appsjson', (json) ->
  	  		newappcount = json.length
  	  		console.log "Old App Count #{window.appcount} >> new count #{newappcount}"
  	  		expect(newappcount).toBeGreaterThan(window.appcount)

  xit '/uploadraw NEW', ->
  	# raw = "json":{"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T03:59:21.000+0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T03:59:21.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}
  	raw = "json:"+'{"Fattributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T04:20:46.000+0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T04:20:46.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}'
  	$.post '/upload', raw, (data) ->
  		console.log data
### I will be re-writing these tests in Sprint 2 to use /lib to keep them clean ###