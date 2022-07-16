//
//  RequestManager.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

typealias CodableResponse<T: Codable> = (Result<T, RequestError>) -> Void

final class RequestManager: NSObject, URLSessionDelegate {
    
    var baseApi: String = "https://stdevtask3-0510.restdb.io/rest/contacts"
    
    var session: URLSession!
    
    var responseValidator: ResponseValidatorProtocol
    
    var reponseLog: URLRequestLoggableProtocol?
    
    typealias Headers = [String: String]

    private override init() {
        self.reponseLog = STDResponseLog()
        self.responseValidator = STDResponseValidator()
        super.init()
        self.session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    public init(session: URLSession, validator: ResponseValidatorProtocol) {
        self.session = session
        self.responseValidator = validator
    }
    
    static let shared = RequestManager()
    
}

extension RequestManager: RequestManagerProtocol {
    
    var timeOutInterval: Double {
        return 40
    }
    
    func performRequestWith<T: Codable>(params:[String:Any], url: String, httpMethod: HTTPMethod, completionHandler: @escaping CodableResponse<T>) {
        let headers = headerBuilder()
        let urlRequest = urlRequestBuilder(params: params, url: url, header: headers, httpMethod: httpMethod)
        performURLRequest(urlRequest, completionHandler: completionHandler)
    }
    
    private func headerBuilder() -> Headers {
        let headers = [
            "Content-Type": "application/json",
            "x-apikey" : "a5b39dedacbffd95e1421020dae7c8b5ac3cc"
        ]
        return headers
    }
    
    private func urlRequestBuilder(params: [String:Any], url: String, header: Headers, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: baseApi + url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutInterval)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = params.toData()
        
        return urlRequest
    }
    
    private func performURLRequest<T: Codable>(_ request: URLRequest, completionHandler: @escaping CodableResponse<T>) {
        session.dataTask(with: request) { (data, response, error) in
            self.reponseLog?.logResponse(response as? HTTPURLResponse, data: data, error: error, HTTPMethod: request.httpMethod)
            if error != nil {
                return completionHandler(.failure(RequestError.connectionError))
            } else {
                let validationResult: (Result<T, RequestError>) = self.responseValidator.validation(response: response as? HTTPURLResponse, data: data)
                return completionHandler(validationResult)
            }
        }.resume()
    }
}
