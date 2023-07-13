//
//  MovieTableViewCell.swift
//  NetflixApp
//
//  Created by Enes Sancar on 13.07.2023.
//

import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    //MARK: - Properties
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let playMovieButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(posterImageView, titleLabel, playMovieButton)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-50)
        }
        
        playMovieButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return }
        
        posterImageView.kf.setImage(with: url)
        titleLabel.text = model.titleName
    }
}
