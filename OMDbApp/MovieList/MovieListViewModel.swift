//
//  MovieListViewModel.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel {
    private let omdbService = OMDbService()
    private let disposeBag = DisposeBag()
    
    let movieList = BehaviorRelay<MovieList?>(value: nil)
    let searchText = BehaviorRelay<String>(value: "")
    let itemsToBePrefetched = BehaviorRelay<[IndexPath]>(value: [])
    
    init() {
        setupRx()
    }
    
    private func setupRx() {        
        searchText
            .skip(1)
            .subscribe(onNext: { [self] searchPattern in
                omdbService.getMovieList(searchPattern: searchPattern)
                    .bind(to: movieList)
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        itemsToBePrefetched.subscribe(onNext: { [self] indexPaths in
            guard let movieListLoadedCount = self.movieList.value?.search.count,
                  let movieListTotalCount = self.movieList.value?.totalResults
            else { return }
            
            var rowsToBePrefetched = indexPaths.map{ $0.row }
            if rowsToBePrefetched.max() == movieListLoadedCount - 1 {
                rowsToBePrefetched.append(movieListLoadedCount)
            }
            
            if movieListLoadedCount < movieListTotalCount {
                let pagesToBeLoaded = rowsToBePrefetched.filter{ $0 > movieListLoadedCount-1}.map{ $0 / 10 }.reduce([], removeDuplicates)
                for page in pagesToBeLoaded {
                    omdbService.getMovieList(searchPattern: searchText.value, page: page)
                        .subscribe(onNext: { fetchedMovieList in
                            guard let fetchedMovieList = fetchedMovieList else { return }
                            var updatedMovieList = movieList.value
                            updatedMovieList?.search.append(contentsOf: fetchedMovieList.search)
                            movieList.accept(updatedMovieList)
                        })
                        .disposed(by: disposeBag)
                }
            }
        })
        .disposed(by: disposeBag)
    }
}
