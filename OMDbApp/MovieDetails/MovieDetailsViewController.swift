//
//  MovieDetailsViewController.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieDetailsViewController: UIViewController {
    private let closeButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let titleSectionView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    
    private let descriptionSectionView = UIView()
    private let genreLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let upperRaitingLabel = UILabel()
    private let synopisLabel = UILabel()
    private let scoreLabel = UILabel()
    private let reviewsLabel = UILabel()
    
    private let crewSectionView = UIView()
    private let directorLabel = UILabel()
    private let writerLabel = UILabel()
    private let actorsLabel = UILabel()
    
    private let viewModel = MovieDetailsViewModel()
    
    var imdbID: String? {
        get { viewModel.imdbID.value }
        set { viewModel.imdbID.accept(newValue) }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        scrollView.isHidden = true
    }
    
    private func separatorLineView() -> UIView {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .black
        separatorLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
        }
        return separatorLine
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 1
        
        stackView.addArrangedSubview(titleSectionView)
        stackView.addArrangedSubview(separatorLineView())
        stackView.addArrangedSubview(descriptionSectionView)
        stackView.addArrangedSubview(separatorLineView())
        stackView.addArrangedSubview(crewSectionView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.leading.trailing.equalTo(view).inset(6)
        }
        
        setupTitleSection(titleSectionView)
        setupDescriptionSection(descriptionSectionView)
        setupCrewSection(crewSectionView)
    }
    
    private func setupRx() {
        viewModel.movieDetails.subscribe(onNext: { [weak self] movieDetails in
            if let movieDetails = movieDetails {
                self?.setMovieDetails(movieDetails: movieDetails)
            }
        })
        .disposed(by: disposeBag)
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    
    private func setupTitleSection(_ titleSectionView: UIView) {
        titleSectionView.addSubview(imageView)
        titleSectionView.addSubview(titleLabel)
        titleSectionView.addSubview(yearLabel)
        titleSectionView.addSubview(closeButton)
        
        titleLabel.numberOfLines = 0
        titleLabel.minimumScaleFactor = 0.5
        imageView.image = UIImage.placeHolder
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.appFont(fontType: .bold, size: 22)
        yearLabel.font = UIFont.appFont(fontType: .semiBold, size: 17)
        closeButton.setImage(UIImage(named: "close-icon"), for: .normal)
        
        imageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.height.equalTo(150)
            make.width.equalTo(titleSectionView.snp.width).dividedBy(3)
        }
        
        yearLabel.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(0)
            make.leading.equalTo(yearLabel)
            make.trailing.equalTo(imageView.snp.leading).offset(-10)
            make.bottom.equalTo(yearLabel.snp.top)
        }
        closeButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(6)
        }
    }
    
    private func setupDescriptionSection(_ descriptionSectionView: UIView) {
        let starImageView = UIImageView(image: UIImage(named: "gold-star-icon"))
        let synopisTitleLabel = UILabel()
        let scoreTitleLabel = UILabel()
        let reviewsTitleLabel = UILabel()
        
        descriptionSectionView.addSubview(genreLabel)
        descriptionSectionView.addSubview(runtimeLabel)
        descriptionSectionView.addSubview(upperRaitingLabel)
        descriptionSectionView.addSubview(starImageView)
        descriptionSectionView.addSubview(synopisTitleLabel)
        descriptionSectionView.addSubview(synopisLabel)
        descriptionSectionView.addSubview(scoreTitleLabel)
        descriptionSectionView.addSubview(reviewsTitleLabel)
        descriptionSectionView.addSubview(scoreLabel)
        descriptionSectionView.addSubview(reviewsLabel)
        
        let labelsFont = UIFont.appFont(fontType: .regular, size: 11)
        let titleLabelsFont = UIFont.appFont(fontType: .semiBold, size: 12)
        genreLabel.font = labelsFont
        genreLabel.numberOfLines = 2
        runtimeLabel.font = labelsFont
        starImageView.contentMode = .scaleAspectFit
        upperRaitingLabel.font = labelsFont
        synopisTitleLabel.font = titleLabelsFont
        synopisTitleLabel.text = "Synopis"
        synopisLabel.font = labelsFont
        synopisLabel.numberOfLines = 0
        reviewsTitleLabel.font = titleLabelsFont
        reviewsTitleLabel.text = "Reviews"
        scoreTitleLabel.font = titleLabelsFont
        scoreTitleLabel.text = "Score"
        scoreLabel.font = labelsFont
        reviewsLabel.font = labelsFont
        
        runtimeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(6)
            make.width.equalTo(50)
        }
        genreLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(6)
            make.firstBaseline.equalTo(runtimeLabel)
            make.trailing.equalTo(runtimeLabel.snp.leading).offset(-6)
        }
        upperRaitingLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.firstBaseline.equalTo(runtimeLabel)
        }
        starImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(16)
            make.centerY.equalTo(runtimeLabel)
            make.trailing.equalTo(upperRaitingLabel.snp.leading).offset(-6)
            make.leading.greaterThanOrEqualTo(runtimeLabel.snp.trailing).offset(6)
        }
        synopisTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(genreLabel)
            make.top.equalTo(genreLabel.snp.bottom).offset(12)
        }
        synopisLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(synopisTitleLabel)
            make.top.equalTo(synopisTitleLabel.snp.bottom)
            make.trailing.equalTo(upperRaitingLabel)
        }
        reviewsTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(synopisLabel.snp.bottom).offset(11)
        }
        scoreTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(reviewsTitleLabel)
            make.leading.equalTo(synopisTitleLabel)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scoreTitleLabel.snp.bottom)
            make.centerX.equalTo(scoreTitleLabel)
            make.bottom.equalTo(-10)
        }
        reviewsLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(scoreLabel)
            make.centerX.equalTo(reviewsTitleLabel)
        }
    }
    
    private func setupCrewSection(_ crewSectionView: UIView) {
        let directorTitleLabel = UILabel()
        let writerTitleLabel = UILabel()
        let actorsTitleLabel = UILabel()
        
        crewSectionView.addSubview(directorTitleLabel)
        crewSectionView.addSubview(directorLabel)
        crewSectionView.addSubview(writerTitleLabel)
        crewSectionView.addSubview(writerLabel)
        crewSectionView.addSubview(actorsTitleLabel)
        crewSectionView.addSubview(actorsLabel)
        
        let labelsFont = UIFont.appFont(fontType: .regular, size: 11)
        let titleLabelsFont = UIFont.appFont(fontType: .semiBold, size: 12)
        directorTitleLabel.font = titleLabelsFont
        directorTitleLabel.text = "Director"
        directorTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        directorLabel.font = labelsFont
        directorLabel.numberOfLines = 0
        directorLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        writerTitleLabel.font = titleLabelsFont
        writerTitleLabel.text = "Writer"
        writerTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        writerLabel.font = labelsFont
        writerLabel.numberOfLines = 0
        writerLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        actorsTitleLabel.font = titleLabelsFont
        actorsTitleLabel.text = "Actors"
        actorsTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        actorsLabel.font = labelsFont
        actorsLabel.numberOfLines = 0
        actorsLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        
        directorTitleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalTo(10)
        }
        directorLabel.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualTo(directorTitleLabel.snp.trailing).offset(10)
            make.firstBaseline.equalTo(directorTitleLabel)
            make.trailing.equalTo(-10)
        }
        writerTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(directorTitleLabel)
        }
        writerLabel.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualTo(writerTitleLabel.snp.trailing).offset(10)
            make.leading.trailing.equalTo(directorLabel)
            make.firstBaseline.equalTo(writerTitleLabel)
            make.top.equalTo(directorLabel.snp.bottom).offset(2)
        }
        actorsTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(directorTitleLabel)
        }
        actorsLabel.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualTo(actorsTitleLabel.snp.trailing).offset(10)
            make.leading.trailing.equalTo(directorLabel)
            make.firstBaseline.equalTo(actorsTitleLabel)
            make.top.equalTo(writerLabel.snp.bottom).offset(2)
            make.bottom.equalTo(-10)
        }
    }

    private func setMovieDetails(movieDetails: MovieDetails) {
        titleLabel.text = movieDetails.title
        yearLabel.text = movieDetails.year
        genreLabel.text = movieDetails.genre
        runtimeLabel.text = movieDetails.runtime
        upperRaitingLabel.text = movieDetails.imdbRating
        synopisLabel.text = movieDetails.plot
        scoreLabel.text = movieDetails.imdbRating
        reviewsLabel.text = movieDetails.imdbVotes
        directorLabel.text = movieDetails.director
        writerLabel.text = movieDetails.writer
        actorsLabel.text = movieDetails.actors
        
        if movieDetails.poster != "N/A", let imageUrl = URL(string: movieDetails.poster) {
            let processor = RoundCornerImageProcessor(cornerRadius: 15)
            imageView.kf.setImage(
                with: imageUrl,
                options: [
                    .processor(processor)
                ])
        }
        scrollView.isHidden = false
    }
}
