//(c) Copyright PopAppFactory 2023

import Foundation

enum APIConstants {
  static let baseURL = "https://jsonplaceholder.typicode.com"

  static var usersURL: URL {
    URL(string: "\(baseURL)/users")!
  }

  static var postsURL: URL {
    URL(string: "\(baseURL)/posts")!
  }

  static func commentsURL(for postId: Int) -> URL {
    URL(string: "\(baseURL)/posts/\(postId)/comments")!
  }
}
