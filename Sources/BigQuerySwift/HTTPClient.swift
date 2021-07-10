import Foundation

import SwiftyRequest

/// A protocol for making HTTP requests
public protocol HTTPClient {
    func post(url: String, payload: Data,
              headers: [String:String],
              completionHandler: @escaping (Data?, Error?) -> Void)
}

/// An implementation of HTTPClient using SwiftyRequest
public class SwiftyRequestClient: HTTPClient {
    public func post(url: String, payload: Data,
              headers: [String:String],
              completionHandler: @escaping (Data?, Error?) -> Void) {
        let request = RestRequest(method: .post, url: url)
        request.messageBody = payload
        request.headerParameters = headers
        request.contentType = "application/json"
        request.response { result in
            switch result {
            case let .success(response):
                completionHandler(response.body.map({ Data.init(buffer: $0) }), nil)
            case let .failure(error):
                completionHandler(nil, error)
            }
        }
    }
}
