////  GithubApiClientTests.swift
//  GithubTrending
//
//  Created on 08.04.2025.
//  
//

import Foundation
import Testing
@testable import GithubTrending

struct GithubApiClientTests {
    @Test func getReadmeShouldReturnReadmeOfKnownRepo() async throws {
        let repo = "chromium/-archived-chromium"
        let expectedContent = "IyBDaHJvbWl1bSAjCgpUaGUgbWFpbiBDaHJvbWl1bSBwcm9qZWN0IGlzIGxv\nY2F0ZWQgYXQgPGh0dHBzOi8vd3d3LmNocm9taXVtLm9yZy8+LgoKVGhlIHNv\ndXJjZSBjb2RlIGlzIGF2YWlsYWJsZSBhdCA8aHR0cHM6Ly9jaHJvbWl1bS5n\nb29nbGVzb3VyY2UuY29tLz4gYW5kIGNhbiBiZSBzZWFyY2hlZCBhdCA8aHR0\ncHM6Ly9jcy5jaHJvbWl1bS5vcmcvPi4KCkluc3RydWN0aW9ucyBmb3IgY29u\ndHJpYnV0aW5nIGNhbiBiZSBmb3VuZCBhdCA8aHR0cHM6Ly93d3cuY2hyb21p\ndW0ub3JnL2RldmVsb3BlcnM+Lgo=\n"
        let testObj = GithubApiClient()

        let result = try await testObj.getReadme(repo: repo)

        #expect(result.content == expectedContent)
    }

    @Test func getReadmeShouldThrowForInvalidRepo() async throws {
        let repo = "-archived-chromium"
        let testObj = GithubApiClient()

        await #expect(throws: HTTPError.self) {
            try await testObj.getReadme(repo: repo)
        }
    }
}
