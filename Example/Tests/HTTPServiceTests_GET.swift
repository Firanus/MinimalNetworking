import XCTest
import MinimalNetworking

class HTTPServiceTests_GET: XCTestCase {
    
    var subject: HttpService!
    var session: URLSessionMock!
    
    var urlString = "https://and.digital"
    var jsonHeaders = ["Accept":"application/json, image/*"]
    
    override func setUp() {
        super.setUp()
        session = URLSessionMock()
        subject = HttpService(session: session)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_GET_RequestsTheUrl() {
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.empty) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(session.lastRequest?.url?.absoluteString == urlString)
    }
    
    func test_GET_RequestsWithHeaders() {
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, additionalHeaders: jsonHeaders) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(session.lastRequest?.allHTTPHeaderFields ?? [:] == jsonHeaders)
    }
    
    func test_GET_EmptyURL_ReturnsAnError() {
        var error: NetworkingServiceError?
        
        _ = subject.get(url: "", responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.invalidURL) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_GET_InvalidURL_ReturnsAnError() {
        var error: NetworkingServiceError?
        
        _ = subject.get(url: "https://😂.lol", responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.invalidURL) as? NetworkingServiceError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_GET_ResumeWasCalled() {
        let dataTask = URLSessionDataTaskMock()
        session.nextDataTask = dataTask
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.empty) { (response : NetworkResponse<[String: String]?>) -> Void in }
        
        XCTAssert(dataTask.resumeCalled)
    }
    
    func test_GET_WithResponseData_ReturnsDecodedData() {
        let encoder = JSONEncoder()
        let expectedData = ["string": "Hello World"]
        let expectation = XCTestExpectation(description: "Gets and Decodes response data")
        
        session.nextData = try! encoder.encode(expectedData)
        
        var actualData: [String:String]? = [:]
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            switch responseObject {
            case .success(let decodedData, _):
                actualData = decodedData
                
                XCTAssert(expectedData == actualData)
                
                expectation.fulfill()
            default:
                break
            }
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GET_WithResponseData_CannotDecodeData_ReturnsError() {
        
        struct MyStringType: Codable {
            let myString: String
        }
        
        struct MyIntType: Codable {
            let myInt: Int
        }
        
        let encoder = JSONEncoder()
        let expectedData = MyStringType(myString: "Hello world")
        session.nextData = try! encoder.encode(expectedData)
        let expectation = XCTestExpectation(description: "Failed to decode response data and errored")
        
        var error: DecodingError?
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<MyIntType?>) in
            error = TestUtilities.extractError(from: responseObject) as? DecodingError
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GET_WithANetworkError_ReturnsANetworkError() {
        session.nextError = NetworkingServiceError.testNetworkError
        
        var error: Error? = nil
        let expectation = XCTestExpectation(description: "Returned network error")
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            switch responseObject {
            case .failure(let networkError):
                error = networkError
                
                XCTAssertNotNil(error)
                
                expectation.fulfill()
            default:
                break
            }
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GET_InvalidResponse_ReturnsInvalidResponseError() {
        session.nextResponse = nil
        
        var error: NetworkingServiceError?
        let expectation = XCTestExpectation(description: "Returned invalid response error")
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.responseInvalid) as? NetworkingServiceError
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GET_500StatusCode_ReturnsStatusCodeError() {
        let expectedCode = 500
        session.nextResponse = HTTPURLResponse(url: URL(string: urlString)!, statusCode: expectedCode, httpVersion: nil, headerFields: nil)
        
        var error: NetworkingServiceError?
        let expectation = XCTestExpectation(description: "Returned status code error with appropriate status code")
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.statusCode(expectedCode)) as? NetworkingServiceError
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GET_EmptyDataReturnedWhenExpectingJSON_ReturnsEmptyDataError() {
        var error: NetworkingServiceError?
        let expectation = XCTestExpectation(description: "Returned empty data error")
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.json, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            error = TestUtilities.extractError(from: responseObject, ofType: NetworkingServiceError.dataEmpty) as? NetworkingServiceError
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GET_ExpectEmptyData_ReturnsNilInNetworkSuccess() {
        let expectedData: [String:String]? = nil
        let expectation = XCTestExpectation(description: "Returned nil when expected")
        
        var actualData: [String:String]? = [:]
        
        _ = subject.get(url: urlString, responseContentType: ResponseContentType.empty, completion: { (responseObject: NetworkResponse<[String: String]?>) in
            switch responseObject {
            case .success(let decodedData, _):
                actualData = decodedData
                
                XCTAssert(actualData == expectedData)
                
                expectation.fulfill()
            default:
                break
            }
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}

