//
//  NetworkManager.swift
//  NetflixApp
//
//  Created by Enes Sancar on 12.07.2023.
//

import UIKit

extension URLSession {
    func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, CustomError>) -> ()
    ) {
        guard let url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.unableToComplete))
                return
            }
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data else {
                completion(.failure(.invalidData))
                 return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }
        task.resume()
    }
}
