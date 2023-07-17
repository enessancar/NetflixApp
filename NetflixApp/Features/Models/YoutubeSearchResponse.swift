//
//  YoutubeSearchResponse.swift
//  NetflixApp
//
//  Created by Enes Sancar on 15.07.2023.
//

import Foundation

struct YoutubeSearchResponse: Decodable {
    let items: [VideoElement]
}

struct VideoElement: Decodable {
    let id: IdVideoElement
}

struct IdVideoElement: Decodable {
    let kind: String
    let videoId: String
}
