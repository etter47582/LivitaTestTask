//(c) Copyright PopAppFactory 2023


import Foundation
import RealmSwift

struct User: Codable, Identifiable {
  let id: Int
  let name: String
  let username: String
}

extension User {
  func toRealm() -> UserRealm {
    let realm = UserRealm()
    realm.id = self.id
    realm.name = self.name
    realm.username = self.username
    return realm
  }
}
