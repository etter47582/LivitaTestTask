//(c) Copyright PopAppFactory 2023


import RealmSwift

enum RealmManager {
  static func createRealm() throws -> Realm {
    let config = Realm.Configuration(schemaVersion: 1)

    Realm.Configuration.defaultConfiguration = config
    return try Realm()
  }

  static func createCacheService() -> CacheServiceProtocol? {
    do {
      let realm = try createRealm()
      return try CacheService(realm: realm)
    } catch {
      print("Failed to initialize Realm: \(error)")
      return nil
    }
  }
}
