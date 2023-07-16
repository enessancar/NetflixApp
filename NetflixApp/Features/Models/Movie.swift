//
//  Movie.swift
//  NetflixApp
//
//  Created by Enes Sancar on 12.07.2023.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int?
    let releaseDate: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    var _posterPath: String {
        posterPath ?? "N/A"
    }
    
    var _originalTitle: String {
        originalTitle ?? "N/A"
    }
    
    var _overview: String {
        overview ?? "N/A"
    }
}
