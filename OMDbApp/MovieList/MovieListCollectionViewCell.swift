//
//  MovieListCollectionViewCell.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 28/02/2021.
//

import UIKit
import SnapKit
import Kingfisher

class MovieListCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0), UIColor.black.cgColor]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        contentView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        titleLabel.textColor = .white
        titleLabel.font = UIFont.appFont(fontType: .semiBold, size: 12)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(-6)
        }
    }
    
    func configureCell(searchItem: Search) {
        if searchItem.poster != "N/A", let url = URL(string: searchItem.poster) {
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: url)
        } else {
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.placeHolder
        }
        titleLabel.text = searchItem.title
        layoutIfNeeded()
    }
}
