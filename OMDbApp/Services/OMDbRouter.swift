//
//  OMDbRouter.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import Foundation
import Alamofire

enum OMDbRouterError: Error {
    case invalidUrl
}

enum OMDbRouter: URLRequestConvertible, URLConvertible {
    case searchMovie(searchPattern: String, page: Int)
    case details(movieId: String)
    
    static let API_KEY = "b9bd48a6"
    var baseURL: URL? { URL(string: "https://www.omdbapi.com") }
    var parameters: Parameters {
        var parameters: Parameters?
        switch self {
        case .searchMovie(let searchPattern, let page):
            parameters = ["s": searchPattern, "type": "movie", "page": page]
        case .details(let movieId):
            parameters = ["i": movieId]
        }
        parameters?.merge(["apikey": OMDbRouter.API_KEY]) { (_, new) in new }
        
        return parameters ?? [:]
    }
    
    var method: HTTPMethod { .get }
    
    func asURL() throws -> URL {
        guard let baseURL = baseURL else {
            throw OMDbRouterError.invalidUrl
        }
        
        return baseURL
    }
        
    func asURLRequest() throws -> URLRequest {
        guard let baseURL = baseURL else {
            throw OMDbRouterError.invalidUrl
        }
        
        var request = URLRequest(url: baseURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
