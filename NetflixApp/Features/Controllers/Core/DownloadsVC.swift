//
//  DownloadsVC.swift
//  NetflixApp
//
//  Created by Enes Sancar on 10.07.2023.
//

import UIKit

final class DownloadsVC: UIViewController {
    
    private var movies: [MovieItem] = []
    
    //MARK: - Properties
    private let downloadedTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _  in
            self.fetchLocalStorageForDownload()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(downloadedTable)
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

//MARK: - UITableView Delegata/DataSource
extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError()
        }
        let movies = movies[indexPath.row]
        cell.configure(with: MovieViewModel(titleName: movies.originalTitle ?? "", posterURL: movies.posterPath ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: movies[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Delete from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titleName = movies[indexPath.row].originalTitle
        let movies = movies[indexPath.row]
        
        APICaller.shared.getMovie(with: titleName ?? movies.originalName ?? "" + " trailer") { result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = MoviePreviewVC()
                    vc.configure(with: .init(title: titleName ?? "", youtubeVideo: videoElement, titleOverview: movies.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
