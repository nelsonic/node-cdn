jasmine = require('jasmine-node')
{NodeCDN} = require('../src/node-cdn') # see: http://stackoverflow.com/a/10772136/1148249

describe 'Upload a File to S3', ->

  beforeEach ->
  	S3 = new NodeCDN

  it 'Should connect to S3 Service', ->
    expect(1+2).toEqual(3)

  it 'should fail', ->
    expect(1+2).toEqual(3)