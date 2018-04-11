# MinimalNetworking

[![CI Status](http://img.shields.io/travis/Firanus/MinimalNetworking.svg?style=flat)](https://travis-ci.org/Firanus/MinimalNetworking)
[![Version](https://img.shields.io/cocoapods/v/MinimalNetworking.svg?style=flat)](http://cocoapods.org/pods/MinimalNetworking)
[![License](https://img.shields.io/cocoapods/l/MinimalNetworking.svg?style=flat)](http://cocoapods.org/pods/MinimalNetworking)
[![Platform](https://img.shields.io/cocoapods/p/MinimalNetworking.svg?style=flat)](http://cocoapods.org/pods/MinimalNetworking)

Minimal networking is exactly what's written on the tin; a simple, dependence free networking library that aims to streamline simple networking requests without any unnecessary bells and whistles.

## Installation

MinimalNetworking is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MinimalNetworking'
```

## Usage

Using Minimal Networking is as simple as installing the pod (see Installation) and initialising an HttpClient. From there, you can access the `get` and `post` methods.

The get method is 
```Swift
let httpService = HttpService()
_ = httpService.get(url: "url_to_hit", 
                    responseContentType: ResponseContentType.json, 
                    additionalHeaders: ["Accept": "application/json"]) 
{ (networkResponse: NetworkResponse<ParsedServerData?>) in
    switch networkResponse {
    case .success(let parsedData, let response):
        //use your data
    case .failure(let error):
        //handle the error
    }
}
```

Minimal Networking allows you to specify the expected response type of your data using the `ResponseContentType` enumeration. It then automatically parses the server response if it is a supported type (at the moment, only JSON is supported).

The post method is almost identical. The only difference is that it takes a body parameter of type `POSTBodyEncodable`, which must provide a String detailing how the class will be decoded into a bodyParam:

```Swift
struct PostQuery: POSTBodyEncodable {
  //struct implementation details...

  var asFormUrlEncoded: String = "minimalNetworking=Awesome!"
}
```
```Swift
_ = httpService.post(url: "https://httpbin.org/post", 
                    body: PostQuery(), 
                    responseContentType: ResponseContentType.json, 
                    additionalHeaders: ["Accept": "application/json"]) 
{     (networkResponse: NetworkResponse<PostResponse?>) in 
  //completion handler functionality
}
```
The parsed response is returned to the user into a simple enum, with structure:

```Swift
public enum NetworkResponse<T> {
    case success(T, HTTPURLResponse)
    case failure(Error)
}
```

In the case of a success, you will return your parsed class, and the HTTPUrlResponse class. Otherwise, you will receive a failure message method with details on the error you have received.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

MinimalNetworking requires iOS 9.3 or above. Update dem projects yo.

## Future

The Minimal Networking Pod is still in a pre-release state, and there are a number of features still planned for before full launch. These include:

* Support for more request types
* Providing functionality to automatically encode a class into a POST body
* Better support for requests that do not expect data to be returned
* and more!

Please check out the Github project tab for more information.

## Author

Firanus, ivan.useful@gmail.com

## License

MinimalNetworking is available under the MIT license. See the LICENSE file for more info.
