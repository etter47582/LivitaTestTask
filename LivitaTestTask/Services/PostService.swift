//(c) Copyright PopAppFactory 2023

import Foundation

protocol PostServiceProtocol {
  func fetchPosts() async throws -> [Post]
  func fetchPosts(for userId: Int) async throws -> [Post]
}

final class PostService: PostServiceProtocol {
  private let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }

  func fetchPosts() async throws -> [Post] {
    try await networkService.fetch(url: APIConstants.postsURL)
  }

  func fetchPosts(for userId: Int) async throws -> [Post] {
    let url = URL(string: "\(APIConstants.baseURL)/posts?userId=\(userId)")!
    return try await networkService.fetch(url: url)
  }
}
