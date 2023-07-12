//
//  APICaller.swift
//  NetflixApp
//
//  Created by Enes Sancar on 12.07.2023.
//

import Foundation

struct APIConstants {
    static let apiKey = "e112ed72df8da5c3b38e4e6579896bc6"
    static let baseURL = "https://api.themoviedb.org"
    static let trendMovie = "\(baseURL)/3/trending/all/day?api_key=\(apiKey)"
}

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        guard let url = URL(string: APIConstants.trendMovie) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
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
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }
        task.resume()
    }
}
