dirty = '''
{ 'json : {"attributes":{"type":"Application__c","url":"/services/data/v27.0/sobjects/Application__c/a07b0000004bYOFAA2"},"Mandatory__c":false,"LastModifiedById":"005b0000000MGa7AAG","OwnerId":"005b0000000MGa7AAG","LastModifiedDate":"2013-04-17T17:11:21.000 0000","Default__c":false,"Application_Icon_Url__c":"https://c.eu2.content.force.com/servlet/servlet.ImageServer?id': '015b00000001ERZAA2', oid: [ '00Db0000000I3q2EAC","Active__c":true,"Application_URL__c":"http://edse-web/corporate/fsg/FSG_portal.html","Name":"CIS Portal","SystemModstamp":"2013-04-17T17:11:21.000 0000","CreatedById":"005b0000000MGa7AAG","CreatedDate":"2013-04-12T08:26:48.000 0000","Featured_Banner_Preview__c":"No Image Uploaded","IsDeleted":false,"Id":"a07b0000004bYOFAA2","Description__c":"CIS portal","Featured__c":false}' ] }
'''

match = /{ 'json : /.test(dirty)
if match
          console.log "              BODY IS DIRTY!! :-( "
      console.log dirty
      console.log '- - - - - - - - - - - - - '
      dirty.replace /{ 'json : /, " "
      dirty.replace /' ] }/, " "
      console.log dirty

pos = dirty.search /{"attributes":/
console.log "Pos: #{pos}"
len = dirty.length
console.log "Length: #{len}"
stilldirty = dirty.slice(pos, len);
#console.log "Still Dirty: #{stilldirty}"
len = stilldirty.length
clean = stilldirty.slice(0, -5);
console.log "CLEAN: #{clean}"