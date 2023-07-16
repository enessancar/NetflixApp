//
//  APICaller.swift
//  NetflixApp
//
//  Created by Enes Sancar on 12.07.2023.
//

import Foundation

struct APIConstants {
    static let apiKey = "e112ed72df8da5c3b38e4e6579896bc6"
    static let youtubeApiKey = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let baseURL = "https://api.themoviedb.org"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let trendingMovies = "\(baseURL)/3/trending/movie/day?api_key=\(apiKey)"
    static let trendingTv = "\(baseURL)/3/trending/tv/day?api_key=\(apiKey)"
    static let upcomingMovies = "\(baseURL)/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1"
    static let popularMovies = "\(baseURL)/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1"
    static let topRatedMovies = "\(baseURL)/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1"
    static let discoverMovies = "\(baseURL)/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
}

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        guard let url = URL(string: APIConstants.trendingMovies) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            }catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping(Result<[Movie], CustomError>) -> ()) {
        guard let url = URL(string: APIConstants.trendingTv) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping(Result<[Movie], CustomError>) -> ()) {
        guard let url = URL(string: APIConstants.upcomingMovies) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping(Result<[Movie], CustomError>) -> ()) {
        guard let url = URL(string: APIConstants.upcomingMovies) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping(Result<[Movie], CustomError>) -> ()) {
        guard let url = URL(string: APIConstants.topRatedMovies) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping(Result<[Movie], CustomError>) -> ()) {
        guard let url = URL(string: APIConstants.discoverMovies) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping(Result<[Movie], CustomError>) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let url = URL(string: "\(APIConstants.baseURL)/3/search/movie?api_key=\(APIConstants.apiKey)&query=\(query)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.unableToParseFromJSON))
                return
            }
            do {
                let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(result.results))
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping(Result<VideoElement, CustomError>) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(APIConstants.youtubeBaseURL)q=\(query)&key=\(APIConstants.youtubeApiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            }catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }
        task.resume()
    }
}
