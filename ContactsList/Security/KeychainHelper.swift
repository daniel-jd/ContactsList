//
//  KeychainHelper.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 04.09.2021.
//

import Foundation

struct KeychainHelper {

    static var secAccessControl: SecAccessControl {
        return SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, nil)!
    }

    static func save() {

    }

    static func retrieve() {

    }

    static func se() {

    }
}
