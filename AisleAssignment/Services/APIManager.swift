//
//  APIManager.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://app.aisle.co/V1"
    private init() {}
    
    // Generic function to make POST requests
    func postRequest<T: Codable>(
        endPoint: String,
        parameters: [String: Any],
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endPoint) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Generic function to make GET requests
    func getRequest(endPoint: String, headers: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseURL + endPoint) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add the Authorization header
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "DataError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

