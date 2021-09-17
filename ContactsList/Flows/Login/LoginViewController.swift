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

    private var loginManager = LoginManager() {
        didSet {
            loginManager.delegate = self
        }
    }

    private var isPasscodeSet        = false
    private var passcodeEntry        = ""
    private var confirmEntry         = ""
    private var passcodeInput        = ""
    private var isEnteringPasscode   = false
    private var isConfirmingPasscode = false
    private var inputCounter         = 0

    internal var state: VCstate = .loggedout {
        didSet {
            switch state {
            case .loggedin:
                print("☀️ Loggedin State")
                showHomeVC()
            case .loggedout:
                print("🍄 Loggedout State")
                loginManager.loginWithFaceID()
            case .enterPasscode:
                print("🔐 Enter Passcode")
                enterPasscode()
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

        setBullets()
//        isPasscodeSet = KeychainHelper.isPasscodeSet()
        if !isPasscodeSet {
            state = .enterPasscode
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
        isEnteringPasscode = true
        isConfirmingPasscode = false
        passcodeInfoLabel.text = "Enter Passcode"
        setBullets()
        inputCounter = 0
        passcodeInput = ""
    }

    private func confirmPasscode() {
        isConfirmingPasscode = true
        isEnteringPasscode = false
        passcodeInfoLabel.text = "Confirm Passcode"
        setBullets()
        inputCounter = 0
        passcodeInput = ""
    }

    private func enterPasscode() {
        isEnteringPasscode = true
        isConfirmingPasscode = false
        passcodeInfoLabel.text = "Passcode"
        setBullets()
        inputCounter = 0
        passcodeInput = ""
    }

    private func setBullets() {
        inputLabel.forEach { label in
            label.text = "○"
        }
    }

    @IBAction func digitButtonPressed(_ sender: UIButton) {
        if inputCounter < 6 {
            let digit = sender.titleLabel!.text!
            inputLabel[inputCounter].text = "●"
            passcodeInput.append(digit)
            inputCounter += 1
            print(passcodeInput)
            if inputCounter == 6 {
                if isEnteringPasscode {
                    passcodeEntry = passcodeInput
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.confirmPasscode()
                    }
                } else {
                    confirmEntry = passcodeInput
                    print(passcodeEntry)
                    print(confirmEntry)
                    let isMatch = loginManager.checkIfConfirmMatches(passcodeEntry, confirmEntry)
                    if isMatch {
                        isPasscodeSet = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            self.state = .loggedin
                        }
                    } else {
                        passcodeInfoLabel.text = "Passcode doesn't match"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                            self.promptPasscode()
                        }
                    }
                }
            }
        } else {
            return
        }
    }

    @IBAction func deleteDigitPressed(_ sender: Any) {
        if inputCounter > 0 {
            inputLabel[inputCounter-1].text = "○"
            passcodeInput.removeLast()
            print(passcodeInput)
            inputCounter -= 1
        } else {
            return
        }
    }

    @IBAction func faceIDButtonPressed(_ sender: Any) {
        if isPasscodeSet {
            print("Face ID pressed")
            state = .loggedout
        } else {
            return
        }
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
