//
//  HomeVC.swift
//  NetflixApp
//
//  Created by Enes Sancar on 10.07.2023.
//

import UIKit

enum Sections: Int {
    case trendingMovies = 0
    case trendingTv = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}

final class HomeVC: UIViewController {
    
    let sectionTitles: [String] = [
        "Trendıng Movıes", "Trendıng Tv", "Popular", "Upcomıng Movıes", "Top rated"
    ]
    
    //MARK: - Properties
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavBar()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func fetchData() {
        APICaller.shared.getUpcomingMovies { results in
            switch results {
            case .success(let tv):
                print(tv)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

//MARK: - View Configure
extension HomeVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        let headerView = HeroHeaderView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavBar() {
        var image = UIImage(named: Constants.Images.netflixLogo.rawValue)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let personImage = UIImage(systemName: Constants.Images.person.rawValue)
        let playImage = UIImage(systemName: Constants.Images.play.rawValue)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: personImage , style: .done, target: self, action: nil),
            UIBarButtonItem(image: playImage , style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - TableView DataSource
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            fatalError()
        }
        
        switch indexPath.section {
            
        case Sections.trendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.trendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            
        case Sections.popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            
        case Sections.upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            
        case Sections.topRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = .init(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: view.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: .minimum(0, -offset))
    }
}
