//
//  TitleCollectionViewCell.swift
//  NetflixApp
//
//  Created by Enes Sancar on 12.07.2023.
//

import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    //MARK: - Properties
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return }
        posterImageView.kf.setImage(with: url)
    }
}
