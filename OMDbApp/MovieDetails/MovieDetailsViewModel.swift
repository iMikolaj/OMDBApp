//
//  MovieDetailsViewModel.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

class MovieDetailsViewModel {
    let movieDetails = BehaviorRelay<MovieDetails?>(value: nil)
    let imdbID = BehaviorRelay<String?>(value: nil)
    
    private let omdbService = OMDbService()
    private let disposeBag = DisposeBag()
    
    init() {
        setupRx()
    }
    
    private func setupRx() {
        imdbID
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] id in
                guard let self = self else { return }
                self.omdbService.getMovieDetails(movieId: id)
                    .bind(to: self.movieDetails)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
