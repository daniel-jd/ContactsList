//
//  Credentials.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 04.09.2021.
//

import Foundation

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
