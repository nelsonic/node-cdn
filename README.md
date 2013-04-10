#CDN Uploader
---

### What This Module Does

- Creates a REST API Wrapper Method which allows any app to upload a static file (image/css/js/json) to Amazon WebServices (AWS) Simple Storage Service (S3) and **returns** a **URL** for the uploaded file.

---

### Intro

If you are *not* using a Content Delivery Network 
[CDN](http://en.wikipedia.org/wiki/Content_delivery_network) 
for your web projects. Take some time to watch this Video on 
How CDNs Work: http://youtu.be/WTlweLma3Vc

Using a CDN is the single greatest performance boost you can give your Web App. 



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
- [Amazon S3](http://aws.amazon.com/s3/) - not considered to be a "*Real* CDN" 
by *purists* because its not designed to *minimise latency* it offers many of 
the benefits of a CDN for *minimal* costs! And *most importantly* the ["*Free Tier*"](http://aws.amazon.com/free/) means you can use S3 for **FREE** for the first *year* for 
small projects (*below 5GB* - which *trust me* is a **LOT** of space!)

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

Essentially people *new* to JS development *hack* at the problem or copy-paste the "solution" by googling, by contrast, people that do the [Homework](https://twitter.com/nelsonic/status/321950687619584001/photo/1) and have experience of debugging *terrible* (rushed/unstructured/untested/undocumented) JS code


Here are a couple of simple tutorials to get you started:

- GitHub: https://github.com/jashkenas/coffee-script
- [NodeTuts](http://nodetuts.com/) Video intro by Pedro Teixeira [pgte](https://github.com/pgte) http://vimeo.com/18429839 ... Pedro works for [NodeJitsu](https://www.nodejitsu.com/) ... Follow him! [@pgte](https://twitter.com/pgte)
- Intro tutorial http://net.tutsplus.com/tutorials/javascript-ajax/rocking-out-with-coffeescript/
- CoffeeScript with BackBone and Jasmine http://net.tutsplus.com/tutorials/javascript-ajax/building-and-testing-a-backbone-app/


#### Testing with [Jasmine](http://pivotal.github.io/jasmine) 

For our *Unit Testing* http://pivotal.github.io/jasmine/ 
If you are *new* to using Jasmine I recommend you take the time to *learn it well* by working through the following tutorials:

- Basic intro to Jasmine: http://net.tutsplus.com/tutorials/javascript-ajax/testing-your-javascript-with-jasmine/
- [CoffeeScript **Koans**](https://github.com/sleepyfox/coffeescript-koans) TTD/BDD Tutorials (time: 60 mins) 
- CoffeeScript Cookbook section on [Testing with Jasmine](http://coffeescriptcookbook.com/chapters/testing/testing_with_jasmine) (time: 30 mins)

#### Templating

I've used Jade, EJS and [CoffeeKup](https://github.com/mauricemach/coffeekup)
but decided to try ECT because it claims to be **Faster** than the more established alternatives. see: [Templating Engine Benchmark](https://github.com/baryshev/template-benchmark) https://github.com/baryshev/template-benchmark

#### Primary Dependency: [Knox](https://github.com/LearnBoost/knox) 

The Knox module by [LearnBoost](https://www.learnboost.com/): https://github.com/LearnBoost/knox it is the most popular Amazon WebServices (AWS) Simple Storage System (S3) Module for NodeJS - read the examples on the module's GitHub page and then subtract all the superfluous "punctuation".


## Stuck? 

If you get stuck or have any questions I'm here to help! [@nelsonic](https://twitter.com/nelsonic)

---
#### Notes to Future-Self:
If you need to *update* the version of **Jasmine** go to: https://github.com/pivotal/jasmine/downloads

I'm using [**CDNJS**](http://cdnjs.com/) http://cdnjs.com/ to source all BackboneJS dependencies in **SpecRunner.html** 

- http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js
- http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js
- http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min.js
- http://cdnjs.cloudflare.com/ajax/libs/coffee-script/1.6.2/coffee-script.min.js

If you need to update any of these for any reason, go for it! :-)

In production you may want to host these Static JS files on your own CDN to have *full control* over what code you are running (#Security), but I trust [CloudFlare](https://www.cloudflare.com/) (for now...) so just using their bandwidth. ;-)

>> I need to investigate using 


