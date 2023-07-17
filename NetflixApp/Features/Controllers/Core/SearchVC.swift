//
//  SearchVC.swift
//  NetflixApp
//
//  Created by Enes Sancar on 10.07.2023.
//

import UIKit

final class SearchVC: UIViewController {
    
    private var movies: [Movie] = []
    
    //MARK: - Properties
    private let discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultVC())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv Show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchDiscoverMovies()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = "Search"
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

//MARK: - UITableView Delegate/DataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError()
        }
        let movies = movies[indexPath.row]
        let model = MovieViewModel(titleName: movies._originalTitle, posterURL: movies._posterPath)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titleName = movies[indexPath.row]._originalTitle
        let movies = movies[indexPath.row]
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = MoviePreviewVC()
                    vc.configure(with: MoviePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: movies._overview))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UISearchBar Update
extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultVC else {
            return
        }
        
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    resultController.movies = movies
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}

//MARK: - SearchResultsVCDelegate
extension SearchVC: SearchResultsVCDelegate {
    func searchResultsVCDidTapItem(_ viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
