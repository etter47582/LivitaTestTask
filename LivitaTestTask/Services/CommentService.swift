//(c) Copyright PopAppFactory 2023

import Foundation

protocol CommentServiceProtocol {
  func fetchComments(for postId: Int) async throws -> [Comment]
}

final class CommentService: CommentServiceProtocol {
  private let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }

  func fetchComments(for postId: Int) async throws -> [Comment] {
    try await networkService.fetch(url: APIConstants.commentsURL(for: postId))
  }
}
