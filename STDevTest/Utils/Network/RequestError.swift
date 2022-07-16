//
//  RequestError.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

enum RequestError: Error, LocalizedError {
    case unknownError
    case connectionError
    case badHTTPStatus(status: Int, message: String?)
    case authorizationError
    case invalidRequest
    case notFound
    case serverUnavailable
    case jsonParseError
    case fieldsAreNotValid
}

extension RequestError {
    public var errorDescription: String? {
        switch self {
        case .connectionError:
            return "Internet Connection Error"
        case .badHTTPStatus(status: let status, message: let message):
            return "Error with status `\(status) and message `\(message ?? "nil")` was thrown"
        case .notFound:
            return "Request not found"
        case .jsonParseError:
            return "JSON parsing probelm, make sure response has a valid JSON"
        case .fieldsAreNotValid:
            return "Inputed fields are not valid"
        default:
            return "Network Error with` \(self)` thrown"
        }
    }
}
