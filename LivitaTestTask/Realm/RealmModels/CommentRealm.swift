//(c) Copyright PopAppFactory 2023


import Foundation
import RealmSwift

final class CommentRealm: Object {
  @Persisted(primaryKey: true) var id: Int = 0
  @Persisted var postId: Int = 0
  @Persisted var name: String = ""
  @Persisted var email: String = ""
  @Persisted var body: String = ""
}

extension CommentRealm {
  func toDomain() -> Comment {
    Comment(id: self.id, postId: self.postId, name: self.name, email: self.email, body: self.body)
  }
}
