//
//  RequestFactory.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift

public enum HTTPMethod:String{
    case GET
    case DELETE
    case PUT
    case PATCH
    case POST
}


public protocol RequestFactory {
    func makeRequest(url: String, method: HTTPMethod, parameters: [String: Any]) -> URLRequest
    func makeMultipartRequest(url: String, multipartParameters: MultipartParameters) -> Observable<URLRequest>
}

public struct MultipartParameters {
    public var parameters: [String: Any] = [:]
    public var binary: [String: [(data: Data, mimeType: String, fileName: String)]] = [:]
    
    fileprivate init() {}
    
    public class Builder {
        
        private var parameters = MultipartParameters()
        
        @discardableResult
        public func set(data: Data, mimeType: String, fileName: String, for key: String) -> Builder {
            if self.parameters.binary[key] == nil {
                self.parameters.binary = [key: [(data, mimeType, fileName)]]
            } else {
                self.parameters.binary[key]!.append((data, mimeType, fileName))
            }
            return self
        }
        
        @discardableResult
        public func set(parameter: Any, for key: String) -> Builder {
            self.parameters.parameters[key] = parameter
            return self
        }
        
        public func build() -> MultipartParameters {
            return self.parameters
        }
        
    }
    
}





extension NSError{
    convenience init(localized:String){
        self.init(domain: "app", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(localized, comment: "")])
    }
}

public typealias HTTPParameters = [String: Any]

public protocol ParametersEncoder {
    func encode(parameters: HTTPParameters, in request: URLRequest) throws -> URLRequest
}

public struct JSONParametersEncoder: ParametersEncoder {
    public func encode(parameters: HTTPParameters, in request: URLRequest) throws -> URLRequest {
        var req = request
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let value = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        req.httpBody = value
        return req
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

public struct URLParameretersEncoder: ParametersEncoder {
    
    public func encode(parameters: HTTPParameters, in request: URLRequest) throws -> URLRequest {
        var req = request
        var query = "?"
        for (key, value) in parameters {
            query.append("\(key)=\(value)&")
        }
        query.removeLast()
        
        guard let urlString = req.url?.absoluteString,
            let encoded = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: urlString + encoded) else {
                throw NSError(localized: "Error")
        }
        req.url = url
        return req
    }
    
}

public class DefaultRequestFactory: RequestFactory {
    
    public init(){}
    
    public func makeRequest(url: String, method: HTTPMethod, parameters: [String: Any]) -> URLRequest {
        let encoding: ParametersEncoder = [.GET, .DELETE].contains(method) ? URLParameretersEncoder() : JSONParametersEncoder()
        
        let url = URL(string: url)!
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 46.0)
        urlRequest.httpMethod = method.rawValue
        // swiftlint:disable force_try
        urlRequest = try! encoding.encode(parameters: parameters, in: urlRequest)
        return urlRequest
    }
    
    public func makeMultipartRequest(url: String, multipartParameters: MultipartParameters) -> Observable<URLRequest> {
        return Observable<URLRequest>.create { (observer) -> Disposable in
            DispatchQueue.global().async {
                
                var request = URLRequest(url: URL(string:url)!)
                request.httpMethod = "POST"
                
                let boundary = "Boundary-\(UUID().uuidString)"
                
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let body = NSMutableData()
                
                let boundaryPrefix = "--\(boundary)\r\n"
                
                for (key, value) in multipartParameters.parameters {
                    body.appendString(boundaryPrefix)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }
                
                for (key, binaryPacks) in multipartParameters.binary {
                    for (binary, mimeType, fileName) in binaryPacks {
                        body.appendString(boundaryPrefix)
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
                        body.append(binary)
                        body.appendString("\r\n")
                    }
                }
                
                body.appendString("--".appending(boundary.appending("--")))
                request.httpBody = body as Data
                
                observer.onNext(request)
                observer.onCompleted()
                
            }
            return Disposables.create()
        }
    }
    
}

