//
//  RequestMaker.swift
//  Pokedex
//
//  Created by Bruno Klein on 08/06/19.
//  Copyright © 2019 CWI Software. All rights reserved.
//

import Foundation

class RequestMaker {
    
    static let decoder = JSONDecoder()
    
    enum Endpoint {
        case list
        case details(query: String)
        
        var url: String {
            switch self {
            case .list:
                return "list"
            case let .details(query):
                return "details/\(query)"
            }
        }
    }
    
    enum RequestMakerError: Error {
        case malformedURL
        case requestFailed
        case invalidData
        case decodingFailed
    }
    
    let baseUrl = "http://localhost:3000/"
    let session = URLSession.shared
    typealias RequestResult<T> = Result<T, RequestMakerError>
    typealias CompletionCallback<T: Decodable> = (RequestResult<T>) -> Void
    typealias SuccessCallback<T: Decodable> = (T) -> Void
    
    func make<T: Decodable>(withEndpoint endpoint: Endpoint, completion: @escaping SuccessCallback<T>) {
        
        make(withEndpoint: endpoint) { (result: RequestResult<T>) in
            switch result {
            case .success(let object):
                completion(object)
            case .failure:
                break
            }
        }
        
    }
    
    func make<T: Decodable>(withEndpoint endpoint: Endpoint, completion: @escaping CompletionCallback<T>) {
        guard let url = URL(string: "\(baseUrl)\(endpoint.url)") else {
            completion(.failure(.malformedURL))
            return
        }
        
        let dataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decodedObject = try RequestMaker.decoder.decode(T.self, from: data)
                
                completion(.success(decodedObject))
            } catch let error {
                completion(.failure(.decodingFailed))
                print(error)
            }
            
            //            print(String(data: data, encoding: .utf8)!)
        }
        
        dataTask.resume()
    }
}
