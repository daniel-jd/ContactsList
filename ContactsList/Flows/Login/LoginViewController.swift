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

class LoginViewController: UIViewController, LoginManagerDelegate {

    @IBOutlet weak var passcodeInfoLabel: UILabel!
    
    @IBOutlet var inputLabel: [UILabel]!
    @IBOutlet weak var digitButton: UIButton!
    @IBOutlet var digits: [UIButton]! {
        didSet {
            let digitFont = UIFont.systemFont(ofSize: 40, weight: .thin)
            digits.forEach { button in
                button.digitButtonStyle()
                let digitValue = String(button.tag)
                button.titleLabel?.font = digitFont
                button.setTitle(digitValue, for: .normal)
            }
        }
    }

    var loginManager = LoginManager() {
        didSet {
            loginManager.delegate = self
        }
    }

    internal var state: VCstate = .loggedout {
        didSet {
            switch state {
            case .loggedin:
                print("☀️ Loggedin State")
                showHomeVC()
            case .loggedout:
                print("🍄 Loggedout State")
                loginManager.loginWithFaceID()
            case .showPassCodePrompt:
                print("🐷 Prompt Passcode")
                promptPasscode()
            case .normal:
                print("🐶 Normal State")
            }
        }
    }

// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        digitButton.digitButtonStyle()

        let isPasscodeSet = KeychainHelper.isPasscodeSet()
        if !isPasscodeSet {
            state = .showPassCodePrompt
        } else {
            state = .loggedout
        }

    }

// MARK: - Methods

    private func showHomeVC() {
        guard let homeVC = storyboard?.instantiateViewController(identifier: "ContactsViewController") as? ContactsViewController else { return }
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()
    }

    private func promptPasscode() {

    }

}

// MARK: - UIButton Extension

extension UIButton {
    func digitButtonStyle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.systemIndigo.cgColor
        self.layer.borderWidth = 1.5
    }
}
