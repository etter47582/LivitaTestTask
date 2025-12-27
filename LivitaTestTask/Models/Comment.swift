//(c) Copyright PopAppFactory 2023


import Foundation
import RealmSwift

struct Comment: Codable, Identifiable {
  let id: Int
  let postId: Int
  let name: String
  let email: String
  let body: String
}

extension Comment {
  func toRealm() -> CommentRealm {
    let realm = CommentRealm()
    realm.id = self.id
    realm.postId = self.postId
    realm.name = self.name
    realm.email = self.email
    realm.body = self.body
    return realm
  }
}
