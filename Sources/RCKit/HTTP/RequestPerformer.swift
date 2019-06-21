//
//  RequestPerformer.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift

public struct RequestPerformerKeys {
    public static let errorBodyKey = "ErrorBodyKey"
    public static let statusCodeKey = "StatusCodeKey"
}


public protocol HTTPRequestPerformer {
    func performDataTask(with request: URLRequest)->Observable<Data>
}

private struct HTTPErrorDomains {
    static let server = "http.server.error"
}


struct ServerError{
    let statusCode: Int
    var body: [String:Any]
}

extension NSError{
    
    var serverError: ServerError?{
        guard self.domain == HTTPErrorDomains.server else{
            return nil
        }
        guard let errorBody = self.userInfo[RequestPerformerKeys.errorBodyKey] as? [String:Any] else{
            return nil
        }
        guard let statusCode = self.userInfo[RequestPerformerKeys.statusCodeKey]  as? Int else{
            return nil
        }
        return ServerError(statusCode: statusCode, body: errorBody)
    }
    
}

public class DefaultHTTPRequestPerformer: HTTPRequestPerformer {
    
    let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func performDataTask(with request: URLRequest) -> Observable<Data> {
        return Observable.create({ [weak self] (observer) in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let task =  self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let err = error {
                    observer.onError(err)
                } else {
                    if let response = response as? HTTPURLResponse {
                        guard let data = data else {
                            observer.onNext(Data())
                            observer.onCompleted()
                            return
                        }
                        
                        switch response.statusCode {
                        case 200..<300:
                            observer.onNext(data)
                            observer.onCompleted()
                        default:
                            // swiftlint:disable line_length
                            let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))  ?? [:]
                            observer.onError(NSError(domain: HTTPErrorDomains.server, code: response.statusCode, userInfo: [RequestPerformerKeys.errorBodyKey: json, RequestPerformerKeys.statusCodeKey: response.statusCode]))
                        }
                    } else {
                        observer.onError(NSError(domain: "undefined", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Undefined error", comment: "")]))
                    }
                }
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
        
        
    }
}
