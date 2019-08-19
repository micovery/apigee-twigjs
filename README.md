## Twig.js for Apigee

This repo exposes the [Twig.js](https://github.com/twigjs/twig.js) library re-packaged to make it work within an 
ES5 [Rhino JavaScript run-time](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Rhino) environment.

If your runtime environment is anything else other than Rhino, please use the official Twig.js minified
distribution over at https://github.com/twigjs/twig.js.

The main purpose of this repo is to offer a distribution that can be used within an 
[Apigee JavaScript policy](https://docs.apigee.com/api-platform/reference/policies/javascript-policy).


### Pre-built distribution

You can find pre-built distribution files over in the dist/ directory. You can grab these as-is, and use 
them in Apigee.


### Using in Apigee

In order to use the library in an Apigee JavaScript policy, you must refer to the library using
the `<IncludeURL>` element.

Here is an example JavaScript policy:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Javascript async="false" continueOnError="false" enabled="true" timeLimit="200" name="JC-TwigJS">
    <DisplayName>JC-TwigJS</DisplayName>
    <Properties/>
    <IncludeURL>jsc://twigjs.1.13.3.rhino.js</IncludeURL>
    <ResourceURL>jsc://my-business-logic.js</ResourceURL>
</Javascript>
```


Following from the example above, within the `my-business-logic.js`file you would be able to refer to the
global object `twigjs`, and write your own custom transformation logic.

For example:

```javascript
var template = '                                                     \n\
{% for topic, messages in topics %}                                  \n\
    * {{ loop.index }}: {{ topic }}                                  \n\
  {% for message in messages %}                                      \n\
      - {{ loop.parent.loop.index }}.{{ loop.index }}: {{ message }} \n\
  {% endfor %}                                                       \n\
{% endfor %}                                                         \n\
';

var data = {
    'topics': {
        'topic1': ['Message 1 of topic 1', 'Message 2 of topic 1'],
        'topic2': ['Message 1 of topic 2', 'Message 2 of topic 2'],
    },
};

var template = twigjs.twig({data: template});
var output = template.render(data);

context.setVariable('response.content', output);
```


(I am using a multiline Twig.js template by using the 
newline escape sequence, followed by the line-continuation character. i.e. `\n\`)


### Sample Apigee Proxy

I've also included a [Sample Apigee proxy](https://github.com/micovery/apigee-twigjs/raw/master/downloads/twigjs-proxy-bundle.zip) (in the downloads directory) you can use to quickly try out the library. 
If you are going to be using this library from multiple Apigee proxies, consider creating an [Apigee Shared-Flow](https://docs.apigee.com/api-platform/fundamentals/shared-flows) instead.


### Build Prerequisites

  * Bash shell (your OS must have bash)
  * [Install Docker](https://docs.docker.com/install/)
  

The build process itself runs inside docker, so it should work well across different operating
systems a long as you have both bash, and docker installed in your system.

### Building it

If you want to build the library yourself (as opposed to using the pre-built files in the `dist` directory), use the 
following command:

```bash
 MODE=production BRANCH=master ./build.sh
```

In the example above, I am showing how to build the library in production mode, from the Twig.js master branch.

The `MODE` environment variable maps directly to the `mode` property in webpack. Supported modes are: `production` and `development`. When you build in `production` mode, the resulting build output is
minified. When you build in `development` mode, the resulting build output is not minified.

The `BRANCH` environment variable specifies which Git branch is checked-out after the Twig.js repo is cloned during
the build process. You can specify actual branch names, or even tag names from the Twig.js repo. See the full list of
tags over at https://github.com/twigjs/twig.js/tags.



### Not Google Product Clause

This is not an officially supported Google product.