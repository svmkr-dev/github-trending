////  ClientErrors.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

import Foundation

struct RequestConstructionError: Error {}

struct HTTPError: Error {
    let response: URLResponse
}

struct InvalidDataError: Error {
    let data: Data?
}

