//
//  MovieSearchViewController.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit
import CoreData

final class MovieSearchViewController: UIViewController {
    
    weak var movieSearchCoordinatorHandler: MovieSearchFlowCoordinator?
    
    // MARK: - Private propertis of data
    private var filterMovieModels = [Film]()
    private var films = [NSManagedObject]()
    
    // MARK: - Private propertis
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    private lazy var dataManager: DataManagering = DataBaseManager()
    
    private var isSearchBarEmpty: Bool {
        searchController?.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      searchController.isActive && !isSearchBarEmpty
    }
    
    private var pageCounter = 1
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self,
                          action: #selector(pullToRefresh(sender:)),
                          for: .valueChanged)
        return refresh
    }()
    
    // MARK: - Private UI properties
    private var searchController: UISearchController!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Layout.backgroundColor
        
        setupSearchController()
        setupTableView()
        fetchFilms(isPagination: false, isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - Private methods
private extension MovieSearchViewController {
    
    func fetchFilms(isPagination: Bool, isRefresh: Bool) {
        networkManager.isFetching = true
        
        if isPagination { pageCounter += 1 }
        if isRefresh { pageCounter = 1 }
        
        let model = dataManager.fetch(entity: Film.self)
        
        if model.isEmpty || isPagination || isRefresh {
            networkManager.getFilms(isPagination: isPagination, isRefresh: isRefresh, page: pageCounter) { [weak self] result in
                
                switch result {
                case let .success(films):
                    DispatchQueue.main.async {
                        
                        if isRefresh {
                            self?.films = films
                            self?.refreshControl.endRefreshing()
                        } else {
                            self?.films.append(contentsOf: films)
                        }
                        
                        self?.tableView.reloadData()
                    }
                case let .failure(error):
                    print("WARNING: Error on network request \(error)")
                }
                
                self?.movieSearchCoordinatorHandler?.dissmisLoading()
            }
            
        } else {
            films = model
            networkManager.isFetching = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
                
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Layout.SearchController.placeholder
        searchController.searchBar.setImage(UIImage(systemName: Layout.SearchController.systemName),
                                            for: .bookmark, state: .normal)
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.showsCancelButton = false
        
        searchController.searchBar.addLine()

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: FilmCell.cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: FilmCell.cellIdentifier)
        
        tableView.refreshControl = refreshControl
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func fetchFilms(keywords: String, isPagination: Bool) {
        networkManager.isFetching = true
        
        if isPagination { pageCounter += 1 }
        
        networkManager.getFilmsByKeyword(keywords, isPagination: isPagination, page: pageCounter) { [weak self] result in
            
            switch result {
            case let .success(films):
                DispatchQueue.main.async {
                    if isPagination {
                        self?.filterMovieModels.append(contentsOf: films)
                    } else {
                        self?.filterMovieModels = films
                    }
                    
                    self?.tableView.reloadData()
                    
                }
            case let .failure(error):
                print("WARNING: Error on network request \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @objc func pullToRefresh(sender: UIRefreshControl) {
        fetchFilms(isPagination: false, isRefresh: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterMovieModels.count
        }
        
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFiltering {
            let movie = filterMovieModels[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmCell.cellIdentifier, for: indexPath) as? FilmCell else { fatalError("Couldn't creat reusable cell")}
            
            cell.tag = indexPath.row
            cell.configure(movie, andTag: indexPath.row)
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilmCell.cellIdentifier, for: indexPath) as? FilmCell
            guard let cell = cell else { fatalError("Couldn't create dequeue reusable MovieCell") }
            
            guard let film = films[indexPath.row] as? Film else { return UITableViewCell()}
            cell.tag = indexPath.row
            cell.configure(film, andTag: indexPath.row)
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            let movie = filterMovieModels[indexPath.row]
            movieSearchCoordinatorHandler?.didPressOnCell(id: Int(movie.filmId))
        } else {
            
            guard let film = films[indexPath.row] as? Film else { return }
            movieSearchCoordinatorHandler?.didPressOnCell(id: Int(film.filmId))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = scrollView.contentOffset.y + scrollView.frame.size.height
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            if scrollHeight > scrollView.contentSize.height
                && !self.networkManager.isFetching
                && self.networkManager.isUniqueData {
                if self.isFiltering {
                    guard let text = self.searchController.searchBar.text, text != "" else { return }
                    self.fetchFilms(keywords: text, isPagination: true)
                } else {
                    self.fetchFilms(isPagination: true, isRefresh: false)
                }
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MovieSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" else { return
            tableView.reloadData()
        }
        
        networkManager.isUniqueData = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 ) {
            guard let text = searchController.searchBar.text else {
                return self.tableView.reloadData()
            }
            
            if !self.networkManager.isFetching {
                self.fetchFilms(keywords: text, isPagination: false)
            }
        }
    }
}

// MARK: - Layout
private extension MovieSearchViewController {
    struct Layout {
        static let backgroundColor: UIColor = .systemBackground
        
        struct SearchController {
            static let placeholder = "Фильмы"
            static let systemName = "slider.horizontal.3"
        }
        
        struct TableView {
            static let header = "Результаты поиска"
            static let heightForRowAtPerson: CGFloat = 236
            static let spaceBetweenSections: CGFloat = 10
        }
        
        struct CollectionView {
            static let sizeForCollectionView = CGSize(width: 150, height: 220)
        }
    }
}
