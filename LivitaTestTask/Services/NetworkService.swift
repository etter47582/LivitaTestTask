//(c) Copyright PopAppFactory 2023

import Foundation

protocol NetworkServiceProtocol {
  func fetch<T: Decodable>(url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func fetch<T: Decodable>(url: URL) async throws -> T {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidResponse
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingError(error)
    }
  }
}

enum NetworkError: LocalizedError {
  case invalidResponse
  case decodingError(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid response from server"
    case .decodingError(let error):
      return "Decoding error: \(error.localizedDescription)"
    }
  }
}
