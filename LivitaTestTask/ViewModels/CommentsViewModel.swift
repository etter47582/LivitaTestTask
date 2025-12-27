//(c) Copyright PopAppFactory 2023


import Foundation
import SwiftUI
import Combine

@MainActor
final class CommentsViewModel: ObservableObject {
  @Published var comments: [Comment] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let commentService: CommentServiceProtocol
  private let postId: Int

  init(
    postId: Int,
    commentService: CommentServiceProtocol? = nil
  ) {
    self.postId = postId
    let cacheService = RealmManager.createCacheService()
    self.commentService = commentService ?? CommentService(cacheService: cacheService)
  }

  func loadComments() async {
    isLoading = true
    errorMessage = nil

    do {
      comments = try await commentService.fetchComments(for: postId)
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
