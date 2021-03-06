// Generated by CoffeeScript 1.6.2
/* jslint nomen: true, plusplus: true, vars: true, indent: 2, node: true
*/


(function() {
  "use strict";
  /* - - - - - - - - The Mini Express App - - - - - - - -
  */

  var CreateFakeApp, ECT, Faker, S3Config, S3GetListOfApps, S3ReadSingleAppJSON, S3client, S3uploadjson, app, appdir, apps_file_url, apps_filename, cleanbodyjson, ectRenderer, express, get_app_list, knox, port, rebuild_apps_json, redis, redisClient, set_my_apps, uniqueId;

  express = require('express');

  app = module.exports = express();

  app.configure(function() {
    app.use(express.bodyParser());
    return app.use(express["static"](__dirname + '/public'));
  });

  /* - - - - - - - - - Copy This to the bottom of SEF-NODEJS/app.js - - - - - - - - -
  */


  /* - - - - - REDIS - - - - -
  */


  redis = require('redis');

  if (!redisClient) {
    console.log("...................................Need to CONNECT to REDIS ...");
    redisClient = redis.createClient();
    redisClient.on("error", function(err) {
      return console.log("REDIS FAIL : " + err);
    });
  }

  /* - - - - - S3 Config and Knox Client - - - - -
  */


  knox = require('knox');

  require('js-yaml');

  S3Config = require('./config/S3.yml');

  S3client = knox.createClient(S3Config);

  /* - - - - - S3 Related Config - - - - -
  */


  appdir = '/apps/';

  apps_filename = 'apps.json';

  apps_file_url = 'https://' + S3Config['bucket'] + '.s3.amazonaws.com' + appdir + apps_filename;

  console.log("apps.json is: " + apps_file_url);

  /* - - - - - MUST Move these Methods to Lib in Next sprint - - - - -
  */


  S3uploadjson = function(filename, jsonstr) {
    var req;

    req = S3client.put(appdir + filename, {
      'Content-Length': jsonstr.length,
      'Content-Type': 'application/json',
      'x-amz-acl': 'public-read'
    });
    req.on('response', function(res) {
      if (200 === res.statusCode) {
        return console.log('saved to %s', req.url);
      }
    });
    return req.end(jsonstr);
  };

  /* Cleans the $H!T JSON We get from Salesforce
  */


  cleanbodyjson = function(req, callback) {
    var dirty, json, len, pos1, pos2, pos3, pos4, pos5;

    dirty = json;
    console.log("     TYPE : " + (typeof dirty));
    if (typeof dirty === 'object') {
      dirty = JSON.stringify(dirty);
      dirty = dirty.replace(/\\"/g, '"');
    }
    len = dirty.length;
    console.log("Length: " + len);
    pos1 = dirty.search(/{"attributes":/);
    console.log("{\"attributes\" : " + pos1);
    if (pos1 > 0) {
      dirty = dirty.slice(pos1, len);
    }
    pos2 = dirty.search(/"Featured__c":false}/);
    console.log(" :false} : " + pos2);
    if (pos2 > 0) {
      dirty = dirty.slice(0, pos2 + 20);
    }
    pos3 = dirty.search(/"Featured__c":true/);
    console.log(" :true} : " + pos3);
    if (pos3 > 0) {
      dirty = dirty.slice(0, pos3 + 19);
    }
    pos4 = dirty.search(/' }]/);
    console.log("' }] : " + pos4);
    if (pos4 > 0) {
      dirty = dirty.slice(0, pos4);
    }
    pos5 = dirty.search(/\"}]/);
    console.log(" \"}] : " + pos5);
    if (pos5 > 0) {
      dirty = dirty.slice(0, pos5);
    }
    dirty.replace(/id":"/g, 'id=');
    len = json.length;
    if (json.charAt(len === '"')) {
      json = json.slice(0, len);
    }
    console.log("CLEAN: " + dirty);
    return callback(dirty);
  };

  get_app_list = function(req, callback) {
    var email, myapps;

    if (req.user === void 0) {
      req.user = {};
      req.user['profiles'] = {};
      req.user.profiles['google'] = [
        {
          "displayName": "Florian Höhn",
          "emails": [
            {
              "value": "florian.hoehn@test.newsint.co.uk"
            }
          ],
          "name": {
            "familyName": "Höhn",
            "givenName": "Florian"
          },
          "identifier": "https://www.google.com/accounts/o8/id?id=AItOawljE9AYuKXDVqwjDOTLjZ88YiM44adgZNc"
        }
      ];
    }
    email = req.user.profiles.google[0]['emails'][0]['value'];
    myapps = 'apps:' + email + '.json';
    console.log("MYAPPS: " + myapps);
    return redisClient.get(myapps, function(err, reply) {
      if (err || reply === null) {
        console.log("REDIS ERROR: " + err + " (user has not personalised ribbon)");
        return redisClient.get('apps:mandatory-default.json', function(err, reply) {
          console.log("Send the Mandatory & Default apps to browser");
          return callback(reply);
        });
      } else {
        return callback(reply);
      }
    });
  };

  set_my_apps = function(req, callback) {
    var email, error, json;

    console.log('..................................>> /upload req.body :');
    console.log(req.body);
    console.log('..................................<< /upload req.body');
    if (req.user === void 0) {
      req.user = {};
      req.user['profiles'] = {};
      req.user.profiles['google'] = [
        {
          "displayName": "Florian Höhn",
          "emails": [
            {
              "value": "florian.hoehn@test.newsint.co.uk"
            }
          ],
          "name": {
            "familyName": "Höhn",
            "givenName": "Florian"
          },
          "identifier": "https://www.google.com/accounts/o8/id?id=AItOawljE9AYuKXDVqwjDOTLjZ88YiM44adgZNc"
        }
      ];
    }
    try {
      if (req.body.json === void 0) {
        json = req.body;
      } else {
        json = req.body.json;
      }
      json = JSON.parse(json);
    } catch (_error) {
      error = _error;
      console.log("InVALID JSON");
      throw error;
    }
    email = req.user.profiles.google[0]['emails'][0]['value'];
    redisClient.set('apps:' + email + '.json', JSON.stringify(json));
    return callback(json);
  };

  /* List all the json files in the S3 Bucket
  */


  S3GetListOfApps = function(callback) {
    return S3client.list({
      prefix: 'apps'
    }, function(err, data) {
      var allapps, app_keys, appcount, testapp, _i, _len, _ref;

      appcount = data['Contents'].length;
      if (appcount > 0) {
        app_keys = [];
        _ref = data['Contents'];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          app = _ref[_i];
          testapp = app['Key'].search(/_TEST/);
          allapps = app['Key'].search(/apps\/apps/);
          if (allapps === -1 && testapp === -1) {
            app_keys.push(app['Key']);
          }
        }
        return callback(app_keys);
      }
    });
  };

  /* Fetch JSON of a Single app from S3 Bucket using JQuery $.getJSON
  */


  S3ReadSingleAppJSON = function(url, callback) {
    var app_url;

    app_url = 'https://' + S3Config['bucket'] + '.s3.amazonaws.com/' + url;
    return S3client.getFile('/' + url, function(err, res) {
      return res.on('data', function(data) {
        var a;

        if (res.statusCode !== 200) {
          console.log("Content Type: " + res.headers['content-type']);
          console.log('..................................>> BAD S3 Res :');
          console.log(data.toString());
          return console.log('..................................<< BAD S3 Res');
        } else {
          app = JSON.parse(data.toString());
          a = {};
          a['Id'] = app['Id'];
          a['Name'] = app['Name'];
          a['Mandatory__c'] = app['Mandatory__c'];
          a['Default__c'] = app['Default__c'];
          a['Application_Icon_URL__c'] = app['Application_Icon_URL__c'];
          a['Application_URL__c'] = app['Application_URL__c'];
          a['Description__c'] = app['Description__c'];
          a['Active__c'] = app['Active__c'];
          redisClient.set('apps:' + a['Id'] + '.json', JSON.stringify(a));
          return callback(a);
        }
      });
    });
  };

  rebuild_apps_json = function(callback) {
    return S3GetListOfApps(function(keys) {
      var all_apps, appcount, defaultapps, i, mandatoryapps, url, _i, _len, _results;

      appcount = keys.length;
      i = 0;
      all_apps = [];
      mandatoryapps = [];
      defaultapps = [];
      _results = [];
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        url = keys[_i];
        _results.push(S3ReadSingleAppJSON(url, function(json) {
          var mandefault;

          if (json['Active__c'] === true) {
            all_apps.push(json);
            if (json['Mandatory__c'] === true) {
              mandatoryapps.push(json);
            }
            if (json['Default__c'] === true) {
              defaultapps.push(json);
            }
          }
          mandefault = mandatoryapps.push(defaultapps);
          if (i++ === appcount - 1) {
            redisClient.set('apps:apps.json', JSON.stringify(all_apps));
            redisClient.set('apps:mandatory-default.json', JSON.stringify(mandefault));
            S3uploadjson(apps_filename, JSON.stringify(all_apps));
            return callback(all_apps);
          }
        }));
      }
      return _results;
    });
  };

  /* - - - - - - Ribbon / Apps Related Routes - - - - - -
  */


  /* Upload a JSON String and push that as a file to S3
  */


  app.post('/upload', function(req, res, next) {
    var appcount, error, filename, i, json, _i, _len, _results;

    try {
      if (req.body.json === void 0) {
        console.log("req.body.json is " + req.body.json + " :-(");
        json = req.body;
      } else {
        json = req.body.json;
      }
      if (typeof json === "string") {
        json = JSON.parse(json);
      }
    } catch (_error) {
      error = _error;
      console.log("InVALID JSON (BODY) json typeof : " + (typeof json));
      throw error;
    }
    appcount = json.length;
    console.log("/UPLOAD is processing " + appcount + " apps - json type : " + (typeof json));
    i = 1;
    _results = [];
    for (_i = 0, _len = json.length; _i < _len; _i++) {
      app = json[_i];
      filename = app['Id'] + '.json';
      S3uploadjson(filename, JSON.stringify(app));
      console.log("i:" + i + " - appcount:" + appcount);
      if (i === appcount) {
        res.send(json);
        rebuild_apps_json(function(all_apps) {
          console.log("New App Count " + all_apps.length);
          return console.log("\n - - - finished uploading - - - \n\n");
        });
      }
      _results.push(i++);
    }
    return _results;
  });

  /* Fetch FULL List of APPS from Redis
  */


  app.get('/appsjson', function(req, res) {
    return redisClient.get('apps:apps.json', function(err, reply) {
      return res.send(JSON.parse(reply));
    });
  });

  /* Get PERSONALISED List of APPS from Redis
  */


  app.get('/getmyappsjson', function(req, res) {
    return get_app_list(req, function(reply) {
      return res.send(JSON.parse(reply));
    });
  });

  /* Set PERSONALISED List of APPS to Redis
  */


  app.post('/setmyappsjson', function(req, res) {
    return set_my_apps(req, function(json) {
      return res.send(json);
    });
  });

  /* List the apps/#{id}.json files in S3 Bucket
  */


  app.get('/listapps', function(req, res) {
    return S3GetListOfApps(function(keys) {
      return res.send(keys);
    });
  });

  app.get('/rebuildappjson', function(req, res) {
    return rebuild_apps_json(function(all_apps) {
      return res.send(all_apps);
    });
  });

  /* GEt the logged in user's email address from Session Cookie
  */


  app.get('/email', function(req, res) {
    var email;

    if (req.user === void 0) {
      req.user = {};
      req.user['profiles'] = {};
      req.user.profiles['google'] = [
        {
          "displayName": "Florian Höhn",
          "emails": [
            {
              "value": "florian.hoehn@test.newsint.co.uk"
            }
          ],
          "name": {
            "familyName": "Höhn",
            "givenName": "Florian"
          },
          "identifier": "https://www.google.com/accounts/o8/id?id=AItOawljE9AYuKXDVqwjDOTLjZ88YiM44adgZNc"
        }
      ];
    }
    email = req.user.profiles.google[0]['emails'][0]['value'];
    return res.send({
      'email': email
    });
  });

  /* - - - - - - - - - Don't Copy below this point - - - - - - - - -
  */


  /* - - - - - - - - TDD Specific Functions & Routes - - - - - - - -
  */


  ECT = require('ect');

  Faker = require('Faker');

  uniqueId = function(length) {
    var id;

    if (length == null) {
      length = 18;
    }
    id = '_TEST';
    while (id.length < length) {
      id += Math.random().toString(36).substr(2);
    }
    return id.substr(0, length);
  };

  CreateFakeApp = function() {
    var exampleapp, _ref;

    exampleapp = require('./public/app-example.json');
    exampleapp['Active__c'] = false;
    exampleapp['Id'] = uniqueId(18);
    exampleapp['Mandatory__c'] = (_ref = Math.random() < 0.5) != null ? _ref : {
      "true": false
    };
    exampleapp['Name'] = Faker.random.bs_buzz();
    exampleapp['Description__c'] = Faker.Lorem.sentence();
    return exampleapp;
  };

  ectRenderer = ECT({
    watch: true,
    root: __dirname + '/views'
  });

  app.engine('.html', ectRenderer.render);

  app.get('/', function(req, res) {
    return res.render('ribbon.html', {
      title: 'App Ribbon Test'
    });
  });

  app.get('/upload', function(req, res) {
    return res.render('uploadform.html', {
      title: 'Basic Uploader Form'
    });
  });

  app.get('/fakeapp', function(req, res) {
    var exampleapp, exampleappOBJECT;

    exampleapp = CreateFakeApp();
    exampleappOBJECT = [];
    exampleappOBJECT[0] = exampleapp;
    return res.send(exampleappOBJECT);
  });

  app.get('/tdd', function(req, res) {
    return res.render('SpecRunner.html', {
      title: 'Test Runner'
    });
  });

  app.get('/s3url', function(req, res) {
    return res.send({
      url: 'http://' + S3Config.bucket + '.s3.amazonaws.com/'
    });
  });

  port = process.env.PORT || 5000;

  app.listen(port);

  console.log("Express started on port " + port);

}).call(this);

/*
//@ sourceMappingURL=app.map
*/
