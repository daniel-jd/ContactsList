//
//  KeychainHelper.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 04.09.2021.
//

import Foundation

final class KeychainHelper {

    enum KeychainError: Error {
        case noPasscode
        case unexpectedPasscodeData
        case unhandledError(status: OSStatus)
    }

    static var secAccessControl: SecAccessControl {
        return SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, nil)!
    }

    static func save() {

    }

    static func checkForPasscode(_ userCredential: Credentials) {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrCreator as String: userCredential.user,
                                    kSecValueData as String: userCredential.passcode]
    }

    static func setPasscode(_ userCredential: Credentials) {

        let passcodeData = userCredential.passcode.data(using: String.Encoding.utf8)!
        let user = userCredential.user.data(using: String.Encoding.utf8)!

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrCreator as String: user,
                                    kSecValueData as String: passcodeData]

        let status = SecItemAdd(query as CFDictionary, nil)
//        guard status == errSecSuccess else {
//            throw KeychainError.unhandledError(status: status)
//        }
    }
}
