//
//  KinopoiskApi.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

public enum KinopoiskApi {
    case film(id: Int)
    case filmsByKeyword(film: String, page: Int)
    case bestFilms(page: Int)
}

enum ApiVarsion: String {
    case newVersion = "v2.2"
    case previousVersion = "v2.1"
}

extension KinopoiskApi: EndPointType {
    
    var environmentBaseURL: String {
        let base = "https://kinopoiskapiunofficial.tech/api/"
        
        switch self {
        case .filmsByKeyword:
            return base + ApiVarsion.previousVersion.rawValue
        default:
            return base + ApiVarsion.newVersion.rawValue
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case let .film(id): return "/films/\(id)"
        case .filmsByKeyword: return "/films/search-by-keyword"
        case .bestFilms: return "/films/top"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .filmsByKeyword(film, page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["keyword": "\(film)",
                                                      "page": "\(page)"])
        case let .bestFilms(page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["type": "TOP_250_BEST_FILMS",
                                                      "page": "\(page)"])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return ["X-API-KEY": "\(NetworkManager.MovieAPIKey)"]
    }
}
