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
    }
    
    override func viewDidLayoutSubviews() {
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
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
}
