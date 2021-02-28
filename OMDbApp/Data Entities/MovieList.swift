//
//  MovieList.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import Foundation


struct MovieList: Codable {
    var search: [Search]
    private let totalResultsAsString: String
    let response: String
    var totalResults: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResultsAsString = "totalResults"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        search = try values.decode([Search].self, forKey: .search)
        response = try values.decode(String.self, forKey: .response)
        totalResultsAsString = try values.decode(String.self, forKey: .totalResultsAsString)
        totalResults = Int(totalResultsAsString)
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
}
