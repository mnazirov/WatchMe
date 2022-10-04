//
//  NetworkManager.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation
import UIKit

enum NetworkResponse: String {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

protocol NetworkManagerProtocol {
    var isFetching: Bool { get set }
    var isUniqueData: Bool { get set }
    
    func getFilms(isPagination: Bool, isRefresh: Bool, page: Int, completion: @escaping (Result<[Film], NetworkError>) -> Void)
    func getFilm(id: Int, completion: @escaping (Result<DetailFilm, NetworkError>) -> Void)
    func getFilmsByKeyword(_ keyword: String, isPagination: Bool, page: Int, completion: @escaping (Result<[Film], NetworkError>) -> Void)
    func getImage(path: String, completion: @escaping(Result<UIImage, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    private lazy var dataManager: DataManagering = DataBaseManager()
    
    static let MovieAPIKey = "2aa4a9e1-f1d1-4cf3-a64e-7be4fda35849"
    private let router = Router<KinopoiskApi>()
    
    private let cache = Cache<String, UIImage>()
    private let lock = NSLock()
    
    var isFetching = false
    var isUniqueData = true
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Any, NetworkError> {
        switch response.statusCode {
        case 200...299:     return .success(true)
        case 401...500:     return .failure(NetworkError.authenticationError)
        case 501...599:     return .failure(NetworkError.badRequest)
        case 600:           return .failure(NetworkError.outdated)
        default:            return .failure(NetworkError.failed)
        }
    }
    
    // MARK: - NetworkManagerProtocol
    func getFilms(isPagination: Bool, isRefresh: Bool, page: Int, completion: @escaping (Result<[Film], NetworkError>) -> Void) {
        if isPagination { self.isFetching = true }
        
        router.request(.bestFilms(page: page)) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.isFetching = false
                completion(.failure(.badRequest))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let filmResponse = try JSONDecoder().decode(FilmApiResponse.self, from: data)
                        
                        if filmResponse.pagesCount < page, isPagination {
                            self.isUniqueData = false
                            completion(.failure(.noMoreData))
                            return
                        }
                        let films = self.convertFilmResponseToFilm(filmResponse)
                        isRefresh ? self.dataManager.removeAllModel(entity: Film.self)
                        : self.dataManager.saveContext()
                                                
                        completion(.success(films))
                        
                    } catch {
                        completion(.failure(.unableToDecode))
                    }
                    
                case .failure:
                    completion(.failure(.badRequest))
                }
                
                self.isFetching = false
                }
            }
        
    }
    
    func getFilm(id: Int, completion: @escaping (Result<DetailFilm, NetworkError>) -> Void) {
        
        router.request(.film(id: id)) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(.badRequest))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let filmApiResponse = try JSONDecoder().decode(DetailFilmApiResponse.self, from: data)
                        
                        let model = self.convertFilmResponseToDetailFilm(filmApiResponse)
                        completion(.success(model))
                        
                    } catch {
                        completion(.failure(.unableToDecode))
                    }
                    
                case .failure:
                    completion(.failure(.badRequest))
                }
            }
        }
    }
    
    func getFilmsByKeyword(_ keyword: String, isPagination: Bool, page: Int, completion: @escaping (Result<[Film], NetworkError>) -> Void) {
        
        self.router.request(.filmsByKeyword(film: keyword, page: page)) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.isFetching = false
                completion(.failure(.badRequest))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                self.isFetching = false
                
                switch result {
                case .success:
                    guard let data = data else {
                        self.isFetching = false
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let filmResponse = try JSONDecoder().decode(FilmApiResponse.self, from: data)
                        
                        if filmResponse.pagesCount != page, isPagination {
                            self.isUniqueData = false
                            completion(.failure(.noMoreData))
                            return
                        }
                        let films = self.convertFilmResponseToFilm(filmResponse)
                        completion(.success(films))
                        
                    } catch {
                        completion(.failure(.unableToDecode))
                    }
                    
                case .failure:
                    completion(.failure(.badRequest))
                }
            }
        }
        
    }
    
    func getImage(path: String, completion: @escaping(Result<UIImage, NetworkError>) -> Void) {
        
        guard let url = URL(string: path) else {
            completion(.failure(NetworkError.failedConvertURL))
            return
        }
        
        if let image = cache[path] {
            completion(.success(image))
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.cache[path] = image
                    
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                }
            }
        }
    }
    
    private func convertFilmResponseToDetailFilm(_ model: DetailFilmApiResponse) -> DetailFilm {
        let film = DetailFilm(context: dataManager.context)
        
        film.filmId             = Int32(model.kinopoiskId)
        film.nameRu             = model.nameRu
        film.nameEn             = model.nameOriginal
        film.year               = String(model.year)
        film.desc               = model.description
        film.filmLength         = String(model.filmLength)
        film.posterUrl          = model.posterUrl
        film.slogan             = model.slogan
        film.webUrl             = model.webUrl
        
        let genres: [Genre] = model.genres.map({
            let _genre = Genre(context: dataManager.context)
            _genre.genre = $0.genre
            return _genre
        })
        film.genres = NSSet(array: genres)
        
        let countries: [Country] = model.countries.map({
            let _country = Country(context: dataManager.context)
            _country.country = $0.country
            return _country
        })
        film.countries = NSSet(array: countries)
        
        dataManager.saveContext()
        return film
    }
    
    private func convertFilmResponseToFilm(_ model: FilmApiResponse) -> [Film] {
        
        var films = [Film]()
        
        for film in model.films {
            let _film = Film(context: dataManager.context)
            
            _film.filmId             = Int32(film.filmId)
            _film.nameRu             = film.nameRu
            _film.nameEn             = film.nameEn
            _film.year               = film.year
            _film.filmLength         = film.filmLength
            _film.rating             = film.rating
            _film.ratingVoteCount    = Int32(film.ratingVoteCount)
            _film.posterUrl          = film.posterUrl
            
            let genres: [Genre] = film.genres.map({
                let _genre = Genre(context: dataManager.context)
                _genre.genre = $0.genre
                return _genre
            })
            _film.genres = NSSet(array: genres)
            
            let countries: [Country] = film.countries.map({
                let _country = Country(context: dataManager.context)
                _country.country = $0.country
                return _country
            })
            _film.countries = NSSet(array: countries)
            
            films.append(_film)
        }
        
        dataManager.saveContext()
        return films
    }
}
