//(c) Copyright PopAppFactory 2023


import Foundation
import SwiftUI
import Combine

@MainActor
final class UsersViewModel: ObservableObject {
  @Published var users: [User] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let userService: UserServiceProtocol

  init(userService: UserServiceProtocol? = nil) {
    let cacheService = RealmManager.createCacheService()
    self.userService = userService ?? UserService(cacheService: cacheService)
  }

  func loadUsers() async {
    isLoading = true
    errorMessage = nil
    
    do {
      users = try await userService.fetchUsers()
    } catch {
      if let localizedError = error as? LocalizedError {
        errorMessage = localizedError.errorDescription ?? error.localizedDescription
      } else {
        errorMessage = error.localizedDescription
      }
    }

    isLoading = false
  }
}
