//
//  MockURLProtocol.swift
//  FlickrDemoTests
//
//  Created by uuser on 2/7/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var responseHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.responseHandler else {
            fatalError("Response handler not set.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() { }
}

extension MockURLProtocol {
    static func setSuccessHandler() {
        
        MockURLProtocol.responseHandler = { request in
            let data = mockData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    static func setEmptyDataHandler() {
        MockURLProtocol.responseHandler = { request in
            let data = emptyData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    static func setBadDataHandler() {
        MockURLProtocol.responseHandler = { request in
            let data = badData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
}
