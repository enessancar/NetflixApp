//
//  UpcomingVC.swift
//  NetflixApp
//
//  Created by Enes Sancar on 10.07.2023.
//

import UIKit

final class UpcomingVC: UIViewController {
    
    private var movies: [Movie] = []
    
    //MARK: - Properties
    private let upcomingTable: UITableView = {
        let tableview = UITableView()
        tableview.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableview
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

//MARK: - UITableView Delegate/DataSource
extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError()
        }
        
        let title = movies[indexPath.row]._originalTitle
        let posterUrl = movies[indexPath.row]._posterPath
        cell.configure(with: MovieViewModel(titleName: title, posterURL: posterUrl))
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
