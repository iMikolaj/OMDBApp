//
//  OMDbService.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import Foundation
import RxSwift
import RxAlamofire

class OMDbService {
    let decoder = JSONDecoder()
    
    func getMovieList(searchPattern: String, page: Int = 1) -> Observable<MovieList?> {
        let router = OMDbRouter.searchMovie(searchPattern: searchPattern, page: page)
        
        return RxAlamofire.request(router.method, router, parameters: router.parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .data()
            .map { data in
                try? self.decoder.decode(MovieList.self, from: data)
            }
            .observe(on: MainScheduler.instance)
    }
    
    func getMovieDetails(movieId: String) -> Observable<MovieDetails> {
        let router = OMDbRouter.details(movieId: movieId)
        
        return RxAlamofire.request(router.method, router, parameters: router.parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .data()
            .compactMap { data in
                try? self.decoder.decode(MovieDetails.self, from: data)
            }
            .observe(on: MainScheduler.instance)
    }
}
