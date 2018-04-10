//
//  HTTPService.swift
//  skyscanner-viper
//
//  Created by Ivan Tchernev on 16/03/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
class HttpService: HttpServiceProtocol {
    
    enum supportedHTTPMethod {
        case GET
        case POST(POSTBodyEncodable)
    }
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func get<T: Codable>(url urlString: String, responseContentType: ResponseContentType, additionalHeaders: [String:String] = [:], completion: @escaping (NetworkResponse<T?>) -> Void) -> URLSessionDataTaskProtocol? {
        if let url = URL(string: urlString) {
            let request = createRequest(to: url, withHttpMethod: .GET, andHeaders: additionalHeaders)
            let task = createDataTask(with: request, responseContentType: responseContentType, completion: completion)
            task.resume()
            return task
        } else {
            completion(NetworkResponse.failure(NetworkingServiceError.invalidURL))
            return nil
        }
    }
    
    func post<T: Codable>(url urlString: String, body: POSTBodyEncodable, responseContentType: ResponseContentType, additionalHeaders: [String:String] = [:], completion: @escaping (NetworkResponse<T?>) -> Void) -> URLSessionDataTaskProtocol? {
        
        if let url = URL(string: urlString) {
            let request = createRequest(to: url, withHttpMethod: .POST(body), andHeaders: additionalHeaders)
            let task = createDataTask(with: request, responseContentType: responseContentType, completion: completion)
            task.resume()
            return task
        } else {
            completion(NetworkResponse.failure(NetworkingServiceError.invalidURL))
            return nil
        }
    }
    
    private func createRequest(to url: URL, withHttpMethod httpMethod: supportedHTTPMethod, andHeaders headers: [String : String]) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch httpMethod {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let body):
            request.httpMethod = "POST"
            let bodyData = Data(body.asFormUrlEncoded.utf8)
            request.httpBody = bodyData
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    private func createDataTask<T: Codable>(with request: URLRequest, responseContentType: ResponseContentType, completion: @escaping (NetworkResponse<T?>) -> Void) -> URLSessionDataTaskProtocol {
        let task = session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            var networkResponse: NetworkResponse<T?>
            do {
                networkResponse = .success(try self.decodeResponse(withData: data,
                    urlResponse: urlResponse,
                    error: error,
                    responseContentType: responseContentType), urlResponse as! HTTPURLResponse)
            } catch {
                networkResponse = .failure(error)
            }
            completion(networkResponse)
        })
        return task
    }
    
    private func decodeResponse<T: Codable>(withData optionalData: Data?, urlResponse optionalUrlResponse: URLResponse?, error optionalError: Error?, responseContentType: ResponseContentType) throws -> T? {
        if let error = optionalError {
            throw error
        }
        guard let httpResponse = optionalUrlResponse as? HTTPURLResponse else {
            throw NetworkingServiceError.responseInvalid
        }
//        guard 200 ... 299 ~= httpResponse.statusCode else {
//            throw NetworkingServiceError.statusCode(httpResponse.statusCode)
//        }
        
        switch responseContentType {
        case .empty:
            return nil
        default:
            do {
                let parser = try ParserFactory.makeParser(for: responseContentType)
                if let data = optionalData {
                    let decodedData: T = try parser.parse(data, toType: T.self)
                    return decodedData
                } else {
                    throw NetworkingServiceError.dataEmpty
                }
            } catch {
                throw error
            }
        }
    }
}
