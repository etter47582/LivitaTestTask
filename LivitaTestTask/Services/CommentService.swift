//(c) Copyright PopAppFactory 2023

import Foundation

protocol CommentServiceProtocol {
  func fetchComments(for postId: Int) async throws -> [Comment]
}

final class CommentService: CommentServiceProtocol {
  private let networkService: NetworkServiceProtocol
  private let cacheService: CacheServiceProtocol?

  init(
    networkService: NetworkServiceProtocol = NetworkService(),
    cacheService: CacheServiceProtocol? = nil
  ) {
    self.networkService = networkService
    self.cacheService = cacheService
  }

  func fetchComments(for postId: Int) async throws -> [Comment] {
    if let cacheService = cacheService, let cachedComments = try? cacheService.getComments(for: postId), !cachedComments.isEmpty {
      Task {
        if let networkComments = try? await networkService.fetch(url: APIConstants.commentsURL(for: postId)) as [Comment] {
          try? cacheService.saveComments(networkComments)
        }
      }
      return cachedComments
    }

    let comments: [Comment] = try await networkService.fetch(url: APIConstants.commentsURL(for: postId))

    try? cacheService?.saveComments(comments)

    return comments
  }
}

