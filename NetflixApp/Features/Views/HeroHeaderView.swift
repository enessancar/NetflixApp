//
//  HeroHeaderView.swift
//  NetflixApp
//
//  Created by Enes Sancar on 10.07.2023.
//

import UIKit
import SnapKit

final class HeroHeaderView: UIView {
    
    //MARK: - Properties
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "fb")
        return imageView
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeroHeaderView {
    private func configureView() {
        addSubview(heroImageView)
        addGradient()
        addSubviews(playButton, downloadButton)
    }
    
    private func configureConstraints() {
        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(120)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(120)
        }
    }
}
