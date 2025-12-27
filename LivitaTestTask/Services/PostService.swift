//(c) Copyright PopAppFactory 2023

import Foundation

protocol PostServiceProtocol {
  func fetchPosts() async throws -> [Post]
  func fetchPosts(for userId: Int) async throws -> [Post]
}

final class PostService: PostServiceProtocol {
  private let networkService: NetworkServiceProtocol
  private let cacheService: CacheServiceProtocol?
  
  init(
    networkService: NetworkServiceProtocol = NetworkService(),
    cacheService: CacheServiceProtocol? = nil
  ) {
    self.networkService = networkService
    self.cacheService = cacheService
  }
  
  func fetchPosts() async throws -> [Post] {
    if let cacheService = cacheService,
       let cachedPosts = try? cacheService.getPosts(),
       !cachedPosts.isEmpty {
      Task {
        if let networkPosts = try? await networkService.fetch(url: APIConstants.postsURL) as [Post] {
          try? cacheService.savePosts(networkPosts)
        }
      }
      return cachedPosts
    }
    
    let posts: [Post] = try await networkService.fetch(url: APIConstants.postsURL)
    
    try? cacheService?.savePosts(posts)
    
    return posts
  }
  
  func fetchPosts(for userId: Int) async throws -> [Post] {
    if let cacheService = cacheService, let cachedPosts = try? cacheService.getPosts(for: userId), !cachedPosts.isEmpty {
      Task {
        let url = URL(string: "\(APIConstants.baseURL)/posts?userId=\(userId)")!
        if let networkPosts = try? await networkService.fetch(url: url) as [Post] {
          try? cacheService.savePosts(networkPosts)
        }
      }
      return cachedPosts
    }
    
    let url = URL(string: "\(APIConstants.baseURL)/posts?userId=\(userId)")!
    let posts: [Post] = try await networkService.fetch(url: url)
    
    try? cacheService?.savePosts(posts)
    
    return posts
  }
}
