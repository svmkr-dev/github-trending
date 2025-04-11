////  GithubTrendingClient.swift
//  GithubTrending
//
//  Created on 11.04.2025.
//  
//

import Foundation

struct GithubTrendingClient: TrendingClient {
    func getTrendingPage() async throws -> String {
        let request = try requestForTrending()

        let (data, response) = try await URLSession.shared.data(for: request)
        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw HTTPError(response: response)
        }

        guard let pageHtml = String(data: data, encoding: .utf8) else {
            throw InvalidDataError(data: data)
        }

        return pageHtml
    }

    private func requestForTrending() throws -> URLRequest {
        guard let url = URL(string: "https://github.com/trending") else {
            throw RequestConstructionError()
        }

        var request = URLRequest(url: url)

        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        request.setValue("text/html", forHTTPHeaderField: "Accept")

        return request
    }
}

