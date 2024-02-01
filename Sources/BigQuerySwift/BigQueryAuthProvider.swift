import Foundation

import OAuth2

/// Response to retrieving authentication token
///
/// - token: Successful response will contain the authentication token
/// - error: Unsuccessful response will contain the error
public enum AuthResponse {
    case token(String)
    case error(Error)
}

public enum AuthError: Error {
    case noToken
}

/// Handles authenticating a service account
public struct BigQueryAuthProvider {
    /// Set scope to be BigQuery
    private let scopes = [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/bigquery.insertdata",
    ]

    public init() {}

    /// Get an authentication token to be used in API calls.
    /// The credentials file is expected to be in the same directory as the
    /// running binary (ie. $pwd/credentials.json)
    ///
    /// - Parameter completionHandler: Called upon completion
    /// - Throws: If JWT creation fails
    public func getAuthenticationToken(completionHandler: @escaping (AuthResponse) -> Void) throws {
        // Get current directory
        let currentDirectoryURL = URL(
            fileURLWithPath: FileManager.default.currentDirectoryPath
        )
        // Get URL of credentials file
        let credentialsURL = currentDirectoryURL.appendingPathComponent("credentials.json")
        guard let tokenProvider = ServiceAccountTokenProvider(
            credentialsURL: credentialsURL,
            scopes:scopes
        ) else {
            fatalError("Failed to create token provider")
        }
        // Request token
        try tokenProvider.withToken { (token, error) in
            if let token = token {
                guard let accessToken = token.accessToken else {
                    completionHandler(.error(AuthError.noToken))
                }
                completionHandler(.token(accessToken))
            } else {
                completionHandler(.error(error!))
            }
        }
    }
}
