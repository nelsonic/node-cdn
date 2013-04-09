#CDN Uploader
---

### What This Module Does

- Creates a REST API Wrapper Method which allows any app to upload a static file (image/css/js/json) to Amazon Webservices (AWS) Simple Storage Service (S3) and **returns** a **URL** for uploaded file.

---

### Intro

If you are *not* using a Content Delivery Network 
[CDN](http://en.wikipedia.org/wiki/Content_delivery_network) 
for your web projects. Take some time to watch this Video on 
How CDNs Work: http://youtu.be/WTlweLma3Vc

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


###



