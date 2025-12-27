//(c) Copyright PopAppFactory 2023


import RealmSwift

protocol CacheServiceProtocol {
  func saveUsers(_ users: [User]) throws
  func getUsers() throws -> [User]
  func getUser(id: Int) throws -> User?

  func savePosts(_ posts: [Post]) throws
  func getPosts() throws -> [Post]
  func getPosts(for userId: Int) throws -> [Post]
  func getPost(id: Int) throws -> Post?

  func saveComments(_ comments: [Comment]) throws
  func getComments(for postId: Int) throws -> [Comment]
}

final class CacheService: CacheServiceProtocol {
  private let realm: Realm

  init(realm: Realm? = nil) throws {
    if let realm = realm {
      self.realm = realm
    } else {
      self.realm = try Realm()
    }
  }

  // MARK: - Users

  func saveUsers(_ users: [User]) throws {
    try realm.write {
      let realmUsers = users.map { $0.toRealm() }
      realm.add(realmUsers, update: .modified)
    }
  }

  func getUsers() throws -> [User] {
    let realmUsers = realm.objects(UserRealm.self)
    return Array(realmUsers.map { $0.toDomain() })
  }

  func getUser(id: Int) throws -> User? {
    guard let realmUser = realm.object(ofType: UserRealm.self, forPrimaryKey: id) else {
      return nil
    }
    return realmUser.toDomain()
  }

  // MARK: - Posts

  func savePosts(_ posts: [Post]) throws {
    try realm.write {
      let realmPosts = posts.map { $0.toRealm() }
      realm.add(realmPosts, update: .modified)
    }
  }

  func getPosts() throws -> [Post] {
    let realmPosts = realm.objects(PostRealm.self)
    return Array(realmPosts.map { $0.toDomain() })
  }

  func getPosts(for userId: Int) throws -> [Post] {
    let realmPosts = realm.objects(PostRealm.self).filter("userId == %@", userId)
    return Array(realmPosts.map { $0.toDomain() })
  }

  func getPost(id: Int) throws -> Post? {
    guard let realmPost = realm.object(ofType: PostRealm.self, forPrimaryKey: id) else {
      return nil
    }
    return realmPost.toDomain()
  }

  // MARK: - Comments

  func saveComments(_ comments: [Comment]) throws {
    try realm.write {
      let realmComments = comments.map { $0.toRealm() }
      realm.add(realmComments, update: .modified)
    }
  }

  func getComments(for postId: Int) throws -> [Comment] {
    let realmComments = realm.objects(CommentRealm.self).filter("postId == %@", postId)
    return Array(realmComments.map { $0.toDomain() })
  }
}

