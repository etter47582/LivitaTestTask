//(c) Copyright PopAppFactory 2023

import Foundation

protocol UserServiceProtocol {
  func fetchUsers() async throws -> [User]
  func fetchUser(id: Int) async throws -> User
}

final class UserService: UserServiceProtocol {
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }
  
  func fetchUsers() async throws -> [User] {
    try await networkService.fetch(url: APIConstants.usersURL)
  }
  
  func fetchUser(id: Int) async throws -> User {
    let url = URL(string: "\(APIConstants.baseURL)/users/\(id)")!
    return try await networkService.fetch(url: url)
  }
}
