//(c) Copyright PopAppFactory 2023


import Foundation
import RealmSwift

final class UserRealm: Object {
  @Persisted(primaryKey: true) var id: Int = 0
  @Persisted var name: String = ""
  @Persisted var username: String = ""
}

extension UserRealm {
  func toDomain() -> User {
    User(id: self.id, name: self.name, username: self.username)
  }
}
