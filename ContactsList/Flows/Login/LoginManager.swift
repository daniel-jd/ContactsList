//
//  LoginManager.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 16.09.2021.
//

import UIKit
import LocalAuthentication

protocol LoginManagerDelegate: AnyObject {
    var state: VCstate { get set }
}

enum VCstate {
    case loggedin, loggedout, showPassCodePrompt, enterPasscode, normal
}

struct LoginManager {

    var context = LAContext()
    weak var delegate: LoginManagerDelegate?

    mutating func evaluatePolicy() {
        context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    func checkIfConfirmMatches(_ passcode: String, _ confirmCode: String) -> Bool {
        return passcode == confirmCode ? true : false
    }

    mutating func loginWithFaceID() {

        context = LAContext()
        context.localizedCancelTitle = "Enter Username/Password"

        // First check if we have the needed hardware support.
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { [self] success, error in
                if success {
                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [self] in
                        delegate?.state = .loggedin
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    DispatchQueue.main.async { [self] in
                        delegate?.state = .enterPasscode
                    }
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }

}
