//(c) Copyright PopAppFactory 2023

import Foundation

struct Comment: Codable, Identifiable {
  let id: Int
  let postId: Int
  let name: String
  let email: String
  let body: String
}
