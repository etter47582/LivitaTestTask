//(c) Copyright PopAppFactory 2023


import Foundation
import SwiftUI
import Combine

@MainActor
final class PostsViewModel: ObservableObject {
  @Published var posts: [Post] = []
  @Published var userName: String = ""
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let postService: PostServiceProtocol
  private let userService: UserServiceProtocol
  private let defaultUserId: Int
  
  init(
    postService: PostServiceProtocol? = nil,
    userService: UserServiceProtocol? = nil,
    defaultUserId: Int = 1
  ) {
    self.postService = postService ?? PostService()
    self.userService = userService ?? UserService()
    self.defaultUserId = defaultUserId
  }

  func loadData() async {
    isLoading = true
    errorMessage = nil

    do {
      async let user = userService.fetchUser(id: defaultUserId)
      async let posts = postService.fetchPosts(for: defaultUserId)

      let (fetchedUser, fetchedPosts) = try await (user, posts)

      self.userName = fetchedUser.name
      self.posts = fetchedPosts
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
