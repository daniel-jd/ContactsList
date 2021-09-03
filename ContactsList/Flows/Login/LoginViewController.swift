//
//  LoginViewController.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 03.09.2021.
//

/*
 Користовач використовує програму перший раз (тобто кейчен пустий):
 1. запит на досвіл використання фейс/тач ід
 2. показуємо скрін клавіатури просемо вести паскод(4 символи)
 3. просимо підтвердити паскод(4 символи)
 4. Зберігаємо у кейчейн

 Користувач має встановлений паскод:
 Просимо  авторизуватись за допомогою faceid/touch id
 Якщо не дозволений  faceid/touch id, показуємо клавіатуру
 Якщо користувач не зміг авторизуватись за допомогою  faceid/touch id - покзауємо скрін з клавіатурою.
*/

import UIKit
import LocalAuthentication

extension UIButton {

    func digitButtonStyle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.systemIndigo.cgColor
        self.layer.borderWidth = 1.5
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var digitButton: UIButton!

    @IBOutlet var digits: [UIButton]! {
        didSet {
            let digitFont = UIFont.systemFont(ofSize: 40, weight: .thin)
            digits.forEach { button in
                button.digitButtonStyle()
                let digitValue = String(button.tag)
                button.titleLabel?.font = digitFont
                button.setTitle(digitValue, for: .normal)
//                button.setTitleColor(.systemIndigo, for: .normal)
            }
        }
    }

    private enum VCstate {
        case loggedin, loggedout, showPassCodePrompt, normal
    }

    private var state: VCstate = .loggedout {

        didSet {
            switch state {
            case .loggedin:
                print("☀️ Loggedin State")
                showHomeVC()
            case .loggedout:
                print("🔥 Loggedout State")
                loginWithFaceID()
            case .showPassCodePrompt:
                print("🐷 Show PassCode State")
                // Show PassCodeVC
            case .normal:
                print("🐶 Normal State")
            }
        }
    }

    var context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        digitButton.digitButtonStyle()

        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)

        state = .loggedout

    }

    private func showHomeVC() {
        guard let homeVC = storyboard?.instantiateViewController(identifier: "ContactsViewController") as? ContactsViewController else { return }
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()
    }

    private func loginWithFaceID() {

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
                        self.state = .loggedin
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
