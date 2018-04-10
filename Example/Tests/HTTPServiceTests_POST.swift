//
//  HTTPServiceTests_POST.swift
//  MinimalNetworking_Tests
//
//  Created by Ivan Tchernev on 10/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import MinimalNetworking

class HTTPServiceTests_POST: XCTestCase {
    
    var subject: HttpService!
    var session: URLSessionMock!
    var body: POSTBodyEncodableMock!
    
    var urlString = "https://and.digital"
    var jsonHeaders = ["Accept":"application/json, image/*"]
    
    override func setUp() {
        super.setUp()
        session = URLSessionMock()
        subject = HttpService(session: session)
        body = POSTBodyEncodableMock()
        body.nextBody = "myParam=myValue"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_POST_RequestsTheUrl() {
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.empty) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(session.lastRequest?.url?.absoluteString == urlString)
    }
    
    func test_POST_RequestsWithHeaders() {
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, additionalHeaders: jsonHeaders) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(session.lastRequest?.allHTTPHeaderFields ?? [:] == jsonHeaders)
    }
    
    func test_POST_EmptyURL_ReturnsAnError() {
        var error: NetworkingServiceError?
        
        _ = subject.post(url: "", body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.invalidURL) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_InvalidURL_ReturnsAnError() {
        var error: NetworkingServiceError?
        
        _ = subject.post(url: "https://😂.lol", body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.invalidURL) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_ResumeWasCalled() {
        let dataTask = URLSessionDataTaskMock()
        session.nextDataTask = dataTask
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.empty) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(dataTask.resumeCalled)
    }
    
    func test_POST_receivesBodyEncodedAsUtf8() {
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.empty) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(session.lastRequest?.httpBody == Data(body.nextBody.utf8))
    }
    
    //Sam, should I inject the parser dependency to isolate what this test is testing?
    func test_POST_WithResponseData_ReturnsDecodedData() {
        let encoder = JSONEncoder()
        let expectedData = ["string": "Hello World"]
        
        session.nextData = try! encoder.encode(expectedData)
        
        var actualData: [String:String]? = [:]
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            switch responseObject {
            case .success(let decodedData, _):
                actualData = decodedData
            default:
                break
            }
        })
        
        XCTAssert(expectedData == actualData)
    }
    
    func test_POST_WithResponseData_CannotDecodeData_ReturnsError() {
        
        struct MyStringType: Codable {
            let myString: String
        }
        
        struct MyIntType: Codable {
            let myInt: Int
        }
        
        let encoder = JSONEncoder()
        let expectedData = MyStringType(myString: "Hello world")
        session.nextData = try! encoder.encode(expectedData)
        
        var error: DecodingError?
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<MyIntType?>) in
            error = TestUtilities.extractError(from: responseObject) as? DecodingError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_WithANetworkError_ReturnsANetworkError() {
        session.nextError = NetworkingServiceError.testNetworkError
        
        var error: Error? = nil
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            switch responseObject {
            case .failure(let networkError):
                error = networkError
            default:
                break
            }
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_InvalidResponse_ReturnsInvalidResponseError() {
        session.nextResponse = nil
        
        var error: NetworkingServiceError?
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.responseInvalid) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_InvalidStatusCode_ReturnsStatusCodeError() {
        let expectedCode = 500
        session.nextResponse = HTTPURLResponse(url: URL(string: urlString)!, statusCode: expectedCode, httpVersion: nil, headerFields: nil)
        
        var error: NetworkingServiceError?
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.statusCode(expectedCode)) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_EmptyDataReturnedWhenExpectingJSON_ReturnsEmptyDataError() {
        var error: NetworkingServiceError?
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.dataEmpty) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_POST_ExpectEmptyData_ReturnsNilInNetworkSuccess() {
        let expectedData: [String:String]? = nil
        
        var actualData: [String:String]? = [:]
        
        _ = subject.post(url: urlString, body: body, responseContentType: ResponseContentType.empty, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            switch responseObject {
            case .success(let decodedData, _):
                actualData = decodedData
            default:
                break
            }
        })
        
        XCTAssert(expectedData == actualData)
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
