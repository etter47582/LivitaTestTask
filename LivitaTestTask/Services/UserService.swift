//(c) Copyright PopAppFactory 2023

import Foundation

protocol UserServiceProtocol {
  func fetchUsers() async throws -> [User]
  func fetchUser(id: Int) async throws -> User
}

final class UserService: UserServiceProtocol {
  private let networkService: NetworkServiceProtocol
  private let cacheService: CacheServiceProtocol?

  init(
    networkService: NetworkServiceProtocol = NetworkService(),
    cacheService: CacheServiceProtocol? = nil
  ) {
    self.networkService = networkService
    self.cacheService = cacheService
  }

  func fetchUsers() async throws -> [User] {
    let users: [User] = try await networkService.fetch(url: APIConstants.usersURL)

    try? cacheService?.saveUsers(users)

    return users
  }

  func fetchUser(id: Int) async throws -> User {
    if let cacheService = cacheService, let cachedUser = try? cacheService.getUser(id: id) {
      Task {
        let url = URL(string: "\(APIConstants.baseURL)/users/\(id)")!
        if let networkUser = try? await networkService.fetch(url: url) as User {
          try? cacheService.saveUsers([networkUser])
        }
      }
      return cachedUser
    }

    let url = URL(string: "\(APIConstants.baseURL)/users/\(id)")!
    let user: User = try await networkService.fetch(url: url)

    try? cacheService?.saveUsers([user])

    return user
  }
}
