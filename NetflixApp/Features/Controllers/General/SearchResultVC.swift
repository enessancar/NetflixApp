//
//  SearchResultVC.swift
//  NetflixApp
//
//  Created by Enes Sancar on 13.07.2023.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsVCDidTapItem(_ viewModel: MoviePreviewViewModel)
}

final class SearchResultVC: UIViewController {
    
    public var movies: [Movie] = []
    public weak var delegate: SearchResultsVCDelegate?
    
    //MARK: - Properties
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: .deviceWidth / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

//MARK: - UICollectionView Delegate/DataSource
extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Cell not found")
        }
        let movies = movies[indexPath.row]
        cell.configure(with: movies._posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let titleName = movies[indexPath.item]._originalTitle
        let movies = movies[indexPath.item]
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultsVCDidTapItem(MoviePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: movies._overview))
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
