//
//  NetworkError.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import Foundation

enum NetworkError: String, Error {
    case parametersNil          = "Parameters were nil"
    case encodingFailed         = "Parameter encoding failed"
    case missingURL             = "URL is nil"
    case authenticationError    = "You need to be authenticated first."
    case badRequest             = "Bad request"
    case outdated               = "The url you requested is outdated."
    case failed                 = "Network request failed."
    case noData                 = "Response returned with no data to decode."
    case unableToDecode         = "We could not decode the response."
    case failedConvertURL       = "Couldn't convert to a URL"
    case noMoreData             = "Out of unique data"
}
