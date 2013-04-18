json = '''
{ json: 'json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYxYAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-17T21:26:11.000+0000","Default__c":false,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001ERoAAM&oid=00Db0000000I3q2EAC","Active__c":false,"Application_URL__c":"http://edse-web/editorial_services/archives/records_management.html","Name":"Archiving","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001ERoAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-17T21:26:11.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:32:36.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYxYAAU","Description__c":"Archive and record office information","Featured__c":false}' }]
'''

match = /{ 'json : /.test(json)
match2 = /'json/.test(json)
match3 = json.search /'json/
console.log "Match 1: #{match} -- Match 2: #{match2} -- Match 3: #{match3}"


 match = /{ 'json : /.test(dirty)
 if match
   console.log "              BODY IS DIRTY!! :-( "
   pos = dirty.search /{"attributes":/
   console.log "Pos: #{pos}"
   len = dirty.length
   console.log "Length: #{len}"
   stilldirty = dirty.slice(pos, len);
   #console.log "Still Dirty: #{stilldirty}"
   len = stilldirty.length
   pos = stilldirty.search /"Featured__c":false}/
   console.log "Pos2: #{pos}"
   clean = stilldirty.slice(0, -5);
   console.log "CLEAN: #{clean}"
   newapp = $.parseJSON( clean )
   
   
json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bcAHAAY"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-17T23:37:59.000+0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001F5EAAU&oid=00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://gmail.com/","Name":"Gmail","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001F5EAAU&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-17T23:37:59.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-16T10:04:30.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bcAHAAY","Description__c":"Your email","Featured__c":false}


{ 'json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYxOAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T00:54:12.000 0000","Default__c":false,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id': '015b00000001EReAAM', oid:['00Db0000000I3q2EAC","Active__c":false,"Application_URL__c":"http://edse-web/corporate/top_bday.html","Name":"Birthday Database","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EReAAM','00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T00:54:13.000 0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:30:33.000 0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYxOAAU","Description__c":"Find birthdays for Celebs, Politicians and Sports stars","Featured__c":false}' ] }

{"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYxOAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T01:18:50.000+0000","Default__c":false,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EReAAM&oid=00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://edse-web/corporate/top_bday.html","Name":"Birthday Database","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EReAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T01:18:50.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:30:33.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYxOAAU","Description__c":"Find birthdays for Celebs, Politicians and Sports stars","Featured__c":false}

{"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T02:03:07.000 0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id":"015b00000001EScAAM","oid":["00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM","00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T02:03:07.000 0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000 0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}"]}



dirty = '{"json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T02:24:04.000 0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id":"015b00000001EScAAM","oid":["00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM","00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T02:24:04.000 0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000 0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}"]}'

cleanbodyjson = (dirty) ->
  console.log "........................         BODY IS DIRTY!! :-( "
  console.dir dirty
  console.log "........................   "
  # dirty = String(dirty)
  console.log("     TYPE : #{typeof dirty}")
  if typeof dirty is 'object'
    dirty = JSON.stringify(dirty)
    dirty.replace(/\\"/g, '"')
  len = dirty.length
  console.log "Length: #{len}"
  pos1 = dirty.search /{"attributes":/
  console.log("Pos1:#{pos1}")
  if pos1 > 0
   console.log "found {\"attributes\": at #{pos1}"
   dirty = dirty.slice(pos1, len);
  pos2 = dirty.search /,"Featured__c":false}'/
  console.log("Pos2:#{pos2}")
  if pos2 > 0
   console.log "found :false} at #{pos2}"
   dirty = dirty.slice(0, pos2+21);
  pos3 = dirty.search /,"Featured__c":true}/
  console.log("Pos3:#{pos3}")
  if pos3 > 0
   console.log "found :true} at #{pos3}"
   dirty = dirty.slice(0, pos3+20);
  pos4 = dirty.search /' }]/
  console.log("Pos4:#{pos4}")
  if pos4 > 0 
   console.log "found ' }] at #{pos4}"
   dirty = dirty.slice(0, pos4);
  pos5 = dirty.search /\"}]/
  console.log("Pos5:#{pos5}")
  if pos5 > 0 
   console.log "found ' }] at #{pos5}"
   dirty = dirty.slice(0, pos5);

  console.log "CLEAN: #{dirty}"
  return dirty


dirty
'''
{"{\"json : {\"attributes\":{\"type\":\"Application__c\",\"url\":\"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU\"},\"Mandatory__c\":false,\"LastModifiedById\":\"005b0000000MGa7AAG\",\"OwnerId\":\"005b0000000MGa7AAG\",\"LastModifiedDate\":\"2013-04-18T02:24:04.000 0000\",\"Default__c\":true,\"Application_Icon_Url__c\":\"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id\":\"015b00000001EScAAM\",\"oid\":[\"00Db0000000I3q2EAC\",\"Active__c\":true,\"Application_URL__c\":\"http://timesintranet/intranet_2002/default_2002.htm\",\"Name\":\"TT Intranet\",\"Application_Icon_Preview__c\":\"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id":"015b00000001EScAAM\",\"00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_\",\"SystemModstamp\":\"2013-04-18T02:24:04.000 0000\",\"CreatedById\":\"005b0000000MGa7AAG\",\"CreatedDate\":\"2013-04-12T08:54:13.000 0000\",\"Featured_Banner_Preview__c\":\"No Image Uploaded\",\"IsDeleted\":false,\"Id\":\"a07b0000004bYyRAAU\",\"Description__c\":\"The Times intranet access\",\"Featured__c\":false}\"]}"}
'''
console.log dirty.replace(/\\"/g, '"')


"json":{"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYyRAAU"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-18T03:59:21.000+0000","Default__c":true,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://timesintranet/intranet_2002/default_2002.htm","Name":"TT Intranet","Application_Icon_Preview__c":"_IM1_https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b00000001EScAAM&oid=00Db0000000I3q2EAC_IM2_ _IM3__30_IM4_30_IM5_","SystemModstamp":"2013-04-18T03:59:21.000+0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:54:13.000+0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYyRAAU","Description__c":"The Times intranet access","Featured__c":false}


"Featured__c":false}