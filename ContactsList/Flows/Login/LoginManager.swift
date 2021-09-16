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
    case loggedin, loggedout, showPassCodePrompt, normal
}

final class LoginManager {

    var context = LAContext()
    weak var delegate: LoginManagerDelegate?

    func evaluatePolicy() {
        context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    func loginWithFaceID() {

        context = LAContext()
        context.localizedCancelTitle = "Enter Username/Password"

        // First check if we have the needed hardware support.
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [unowned self] in
                        delegate?.state = .loggedin
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }

}
