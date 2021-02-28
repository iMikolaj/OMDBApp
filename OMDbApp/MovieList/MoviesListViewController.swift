//
//  MoviesListViewController.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class MoviesListViewController: UIViewController {
    private let titleLabel = UILabel()
    private let searchTextField = UITextField()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let disposeBag = DisposeBag()
    fileprivate let viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        setupLayout()
        rxSetup()
    }
    
    private func rxSetup() {
        viewModel.movieList.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx.text
            .orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter{ $0.count >= 3 }
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
    }


    private func setupLayout() {
        let itemsSpacing: CGFloat = 15
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)

        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        
        titleLabel.text = "Film list"
        titleLabel.font = UIFont.appFont(fontType: .bold, size: 22)
        searchTextField.placeholder = "Enter at least 3 characters"
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.appFont(fontType: .regular, size: 17)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (UIScreen.main.bounds.width - 3 * itemsSpacing) / 2.0
        layout.itemSize = CGSize(width: cellWidth, height: 4.0/3 * cellWidth)
        layout.minimumInteritemSpacing = itemsSpacing
        layout.minimumLineSpacing = itemsSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemsSpacing, bottom: 0, right: itemsSpacing)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview().inset(itemsSpacing)
        }
        searchTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-10)
        }
    }
}


extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movieList.value?.search.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.id, for: indexPath)
            
        if let movieListcell = cell as? MovieListCollectionViewCell,
           let searchItem = viewModel.movieList.value?.search[indexPath.row] {
            movieListcell.configureCell(searchItem: searchItem)
        }
        
        return cell
    }
}

extension MoviesListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.itemsToBePrefetched.accept(indexPaths)
    }
}

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController()
        if let imdbID = viewModel.movieList.value?.search[indexPath.row].imdbID {
//            vc.imdbID = imdbID
//            present(vc, animated: true, completion: nil)
        }
    }
}
 


