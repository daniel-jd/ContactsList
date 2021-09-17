//
//  KeychainHelper.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 04.09.2021.
//

import Foundation

//class KeyChain {
//
//    class func save(key: String, data: Data) -> OSStatus {
//        let query = [
//            kSecClass as String       : kSecClassGenericPassword as String,
//            kSecAttrAccount as String : key,
//            kSecValueData as String   : data ] as [String : Any]
//
//        SecItemDelete(query as CFDictionary)
//
//        return SecItemAdd(query as CFDictionary, nil)
//    }
//
//    class func load(key: String) -> Data? {
//        let query = [
//            kSecClass as String       : kSecClassGenericPassword,
//            kSecAttrAccount as String : key,
//            kSecReturnData as String  : kCFBooleanTrue!,
//            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
//
//        var dataTypeRef: AnyObject? = nil
//
//        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//
//        if status == noErr {
//            return dataTypeRef as! Data?
//        } else {
//            return nil
//        }
//    }
//
//    class func createUniqueID() -> String {
//        let uuid: CFUUID = CFUUIDCreate(nil)
//        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
//
//        let swiftString: String = cfStr as String
//        return swiftString
//    }
//}
//
//extension Data {
//
//    init<T>(from value: T) {
//        var value = value
//        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
//    }
//
//    func to<T>(type: T.Type) -> T {
//        return self.withUnsafeBytes { $0.load(as: T.self) }
//    }
//}


final class KeychainHelper {

    enum KeychainError: Error {
        case noPasscode
        case unexpectedPasscodeData
        case unhandledError(status: OSStatus)
    }

    static let server = "com.com.danielyarmak.ContactsList"
    static var secAccessControl: SecAccessControl {
        return SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, nil)!
    }

    static func isPasscodeSet() -> Bool {
        return false
    }

    static func loadPasscodeFor(_ userName: String) throws -> String? {

        let query: [String: AnyObject] = [
                    kSecAttrService as String: server as AnyObject,
                    kSecAttrAccount as String: userName as AnyObject,
                    kSecClass as String: kSecClassGenericPassword,
                    kSecMatchLimit as String: kSecMatchLimitOne,
                    kSecReturnData as String: kCFBooleanTrue
                ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPasscode }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        if let passcode = item as? Data,
           let passcodeString = String(data: passcode, encoding: .utf8) {
            return passcodeString
        }
        return nil
    }

    static func setPasscode(_ userCredential: Credentials) throws {

        let passcodeData = userCredential.passcode.data(using: String.Encoding.utf8)!
        let account = userCredential.user.data(using: String.Encoding.utf8)!

        let query: [String: AnyObject] = [
                    kSecAttrService as String: server as AnyObject,
                    kSecAttrAccount as String: account as AnyObject,
                    kSecClass as String: kSecClassGenericPassword,
                    kSecValueData as String: passcodeData as AnyObject
                ]

        let status = SecItemAdd(query as CFDictionary, nil)
                guard status == errSecSuccess else {
                    print("status: \(status)")
                    throw KeychainError.unhandledError(status: status)
                }
    }
}
