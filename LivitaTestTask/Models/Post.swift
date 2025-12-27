//(c) Copyright PopAppFactory 2023


import Foundation
import RealmSwift

struct Post: Codable, Identifiable {
  let id: Int
  let userId: Int
  let title: String
  let body: String
}

extension Post {
  func toRealm() -> PostRealm {
    let realm = PostRealm()
    realm.id = self.id
    realm.userId = self.userId
    realm.title = self.title
    realm.body = self.body
    return realm
  }
}

