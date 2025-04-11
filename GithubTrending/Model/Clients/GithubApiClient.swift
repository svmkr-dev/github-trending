////  GithubApiClient.swift
//  GithubTrending
//
//  Created on 08.04.2025.
//  
//

import Foundation

struct ReadmeResponse: Decodable {
    let content: String
}

struct GithubApiClient {
    private let baseUrl = URL(string: "https://api.github.com/repos/")

    func getReadme(repo: String) async throws -> ReadmeResponse {
        let request = try requestForReadme(repo: repo)
        let (result, urlResponse) = try await URLSession.shared.data(for: request)
        try Task.checkCancellation()

        guard let httpResponse = urlResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw HTTPError(response: urlResponse)
        }

        let decoder = JSONDecoder()

        return try decoder.decode(ReadmeResponse.self, from: result)
    }

    private func requestForReadme(repo: String) throws -> URLRequest {
        let url = URL(string: repo, relativeTo: baseUrl)?.appending(components: "contents", "README.md")
        guard let url else { throw RequestConstructionError() }
        var request = URLRequest(url: url)

        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        return request
    }
}
