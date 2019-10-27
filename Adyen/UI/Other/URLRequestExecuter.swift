//
//  URLRequestExecuter.swift
//  Adyen
//
//  Created by mohamed mohamed El Dehairy on 10/27/19.
//  Copyright © 2019 Adyen. All rights reserved.
//

import Foundation

protocol Cancelable {
    func cancel()
}

protocol URLRequestExecuter {
    func execute(request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> Cancelable
}

extension URLSessionDataTask: Cancelable { }

extension URLSession: URLRequestExecuter {
    func execute(request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> Cancelable {
        let task = dataTask(with: request) { data, response, error in
            guard
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data, error == nil
            else {
                return
            }
            
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        task.resume()
        return task
    }
}
