#CDN Uploader
---

### What This Module Does

- Creates a REST API Wrapper Method which allows any app to upload a static file (image/css/js/json) to Amazon WebServices (AWS) Simple Storage Service (S3) and **returns** a **URL** for the uploaded file.

---

### Intro

If you have no *idea* what a Content Delivery Network 
[CDN](http://en.wikipedia.org/wiki/Content_delivery_network) is, *in a nutshell* it means the **people** visiting have to **wait less** time (for pages to load).

![CDN Diagram shows one server vs several servers distributed near the client](http://upload.wikimedia.org/wikipedia/commons/f/f9/NCDN_-_CDN.png "CDN means content is served from the web server that is closest to the visitor")


If you are not *using* a CDN for your NodeJS projects, 
this module will help you get started. ;-)

Take some time to watch this **Video** on 
How CDNs Work: http://youtu.be/WTlweLma3Vc

Using a CDN is the *single* greatest *performance boost* you can give your Web Application. 

See: 

* [**Yahoo** Web Developer **Rules**](http://developer.yahoo.com/performance/rules.html) : http://developer.yahoo.com/performance/rules.html
* [**Google** Web Page Speed **Best Practices**](https://developers.google.com/speed/docs/best-practices/rules_intro) : https://developers.google.com/speed/docs/best-practices/rules_intro


The cost of using a CDN has decreased greatly in the past few years due to increased competition.

There are several great CDN Providers out there; the main ones are:

- [Akamai](http://www.akamai.com) (the industry leader) 
- [NetDna](http://www.netdna.com/pricing/) - almost as fast as Akamai but with 
transparent pay-as-you-go pricing. But there's a **minimum** fee of 
**$800** *per* **month**!!  Not exactly BootStrap sort of Money...!
- [RackSpace Cloud Files](http://www.rackspace.co.uk/cloud-files/) - Uses Akamai's 
technology but offers pay-as-you-go pricing (more expensive than Amazon's Cloudfront)
- [MaxCDN](http://www.maxcdn.com/pricing) - decent but *annoying* 
**annual pricing** and "overage" charges!
- [Amazon Web Services (AWS) **CloudFront**](http://aws.amazon.com/cloudfront/pricing/) Offers **95%** of the **speed** of **Akamai** for a *fraction* (half?) *the price* and **no contract** or minimum spend!
- [Amazon S3](http://aws.amazon.com/s3/) is not considered to be a "*Real* CDN" 
by *purists* because its not designed to *minimise latency* (by distributing copies of files to several nodes) It does offer many of 
the benefits of a CDN (different server for static content speeds up page load) for *minimal* costs! And *most importantly* the ["*Free Tier*"](http://aws.amazon.com/free/) means you can use S3 for **FREE** for the first *year* (*below 5GB* - which *trust me* is **plenty** of space!)

For a **Report** on **CDN Performance and Availability** 
visit: http://www.cedexis.com/country-reports/ 
(click on the "CDNs" tab on the main menu) shows clearly that 
you **get more** when you **pay more**. 
At the time of writing Akamai has an average latency of 102ms '
whereas AWS's **CloudFront** is 106ms; a negligeable difference.
For our purposes using **Amazon's S3** + **CloudFront** 
will provide a *massive* boost to any NodeJS (or *any* other Web App!) and is a great way to **get started**!


---

### Implementation

We are using:

#### [Lingua Franca](http://en.wikipedia.org/wiki/Lingua_franca) : [CoffeeScript](http://coffeescript.org/)

If you are toally *new* to CoffeeScript, *welcome* to the **Future**!! 

There has been much **debate** in the JavaScript / NodeJS Community as to wether you should learn CoffeeScript or just continue writing (*mediocre*) JavaScript ... It boils down to Five Things:

- Code Clarity - CoffeeScript forces indentation and is "whitespace significant" (like Python)
- Consistent Quality - CoffeeScript is designed to *Pass* [JS Lint](http://www.javascriptlint.com) meaning it follows all the JavaScript Best Practices described in [Douglas Crockford](http://javascript.crockford.com/)'s ["JavaScript: The Good Parts"](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742). 

Essentially people *new* to JS development *hack* at the problem or copy-paste the "solution" by googling, by contrast, people that do the [Homework](https://twitter.com/nelsonic/status/321950687619584001/photo/1) and have experience of **debugging** *terrible* (rushed/unstructured/untested/undocumented) JS code learn to appreciate the value of enforced standards.

CoffeeScript forces you to respect WhiteSpace. While initially annoying for those of you who don't have a background in Python, you will soon see the benefit when working in a *Team* of having everbody's code look *consistent*.

Here are a couple of simple tutorials to get you started:

- GitHub: https://github.com/jashkenas/coffee-script
- [NodeTuts](http://nodetuts.com/) Video intro by Pedro Teixeira [pgte](https://github.com/pgte) http://vimeo.com/18429839 ... Pedro works for [NodeJitsu](https://www.nodejitsu.com/) ... Follow him! [@pgte](https://twitter.com/pgte)
- Intro tutorial http://net.tutsplus.com/tutorials/javascript-ajax/rocking-out-with-coffeescript/
- CoffeeScript with BackBone and Jasmine http://net.tutsplus.com/tutorials/javascript-ajax/building-and-testing-a-backbone-app/
- http://glennstovall.com/blog/2012/05/07/rapid-development-with-node-dot-js-and-coffeescript/

>> Must move this block to CoffeeScript Blog Post / Rant ... ;-)


#### Testing with [Jasmine](http://pivotal.github.io/jasmine) 

For our *Unit Testing* http://pivotal.github.io/jasmine/ 
If you are *new* to using Jasmine I recommend you take the time to *learn it well* by working through these tutorials:

- Basic intro to Jasmine: http://net.tutsplus.com/tutorials/javascript-ajax/testing-your-javascript-with-jasmine/
- [CoffeeScript **Koans**](https://github.com/sleepyfox/coffeescript-koans) TTD/BDD Tutorials (time: 60 mins) 
- CoffeeScript Cookbook section on [Testing with Jasmine](http://coffeescriptcookbook.com/chapters/testing/testing_with_jasmine) (time: 30 mins)
- Little Book on CoffeeScript (50 pages = 60 mins) http://arcturo.github.io/library/coffeescript/index.html
- https://github.com/mhevery/jasmine-node

#### Templating with [ECT](http://ectjs.com/)

Note: Templating is **ONLY** used in *testing*. This module does not *dictate* any templating engine. You can still use what ever you are using. ;-)

On previous projects I've used [Jade](http://jade-lang.com/), [EJS](http://embeddedjs.com/) and [CoffeeKup](https://github.com/mauricemach/coffeekup)
but decided to try [ECT](https://github.com/baryshev/ect) because it *claims* to be **Faster** than the more *established* alternatives. see: [Templating Engine Benchmark](https://github.com/baryshev/template-benchmark) https://github.com/baryshev/template-benchmark

Long story short, my 3 reasons for chosing ECT for this project:

- Its (a **LOT**) **faster** than [Jade](https://github.com/visionmedia/jade) / [EJS](https://github.com/visionmedia/ejs) etc!
- The Templates **Look like HTML** (closely matches output so easier to debug)
- **Minimal Learning Curve** for people who are familiar with HTML.
- (Bonus) A change from Jade ... ;-)

#### Primary Dependency: [Knox](https://github.com/LearnBoost/knox) 

The Knox module by [LearnBoost](https://www.learnboost.com/): https://github.com/LearnBoost/knox it is the most popular Amazon WebServices (AWS) Simple Storage System (S3) Module for NodeJS - read the examples on the module's GitHub page and then subtract all the superfluous "punctuation" (curly braces, semi-colons and "vars"...)

#### JSDom (Client Side Testing) -- https://github.com/tmpvar/jsdom


## Stuck? 

If you get stuck or have any questions tweet me! [@nelsonic](https://twitter.com/nelsonic)

---
#### Notes to Future-Self:
If you need to *update* the version of **Jasmine** go to: https://github.com/pivotal/jasmine/downloads

I'm using [**CDNJS**](http://cdnjs.com/) http://cdnjs.com/ to source all Backbone JS dependencies in **SpecRunner.html** (but you do not *need* to know Backbone to use this module!)

- http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js
- http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js
- http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min.js
- http://cdnjs.cloudflare.com/ajax/libs/coffee-script/1.6.2/coffee-script.min.js

If you need to update any of these version numbers, go for it and submit a patch to me!

In production you may want to host these Static JS files on your own CDN to have *full control* over what code you are running (#Security), but I trust [CloudFlare](https://www.cloudflare.com/) (for now...) so just using their bandwidth. ;-)

>> I need to investigate using SourceMaps to help debug CoffeeScript (the Missing Piece in the CoffeeScript Puzzle!)
- http://stackoverflow.com/questions/11068023/debugging-coffeescript-line-by-line
- http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/
- http://www.adaltas.com/blog/2012/02/15/coffeescript-print-debug-line/
<<

Look into speeding up CSS:

* More Efficient CSS: http://vimeo.com/54990931

## License 

(The MIT License)

Copyright (c) 2013 [@nelsonic](https://twitter.com/nelsonic)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.