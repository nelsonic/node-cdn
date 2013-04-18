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
