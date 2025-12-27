//(c) Copyright PopAppFactory 2023


import Foundation
import RealmSwift

final class PostRealm: Object {
  @Persisted(primaryKey: true) var id: Int = 0
  @Persisted var userId: Int = 0
  @Persisted var title: String = ""
  @Persisted var body: String = ""
}

extension PostRealm {
  func toDomain() -> Post {
    Post(id: self.id, userId: self.userId, title: self.title, body: self.body)
  }
}
