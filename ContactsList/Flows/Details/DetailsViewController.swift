//
//  DetailsViewController.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 03.09.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumber: UILabel!

    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        if contact != nil {
            showContactDetails(contact: contact!)
        }
    }

    func showContactDetails(contact: Contact) {
        let fullName = contact.name! + " " + contact.lastName!
        contactNameLabel.text = fullName
        contactPhoneNumber.text = contact.phoneNumber ?? "no number"
        if let imageData = contact.avatar {
            avatarView.image = UIImage(data: imageData)
        } else {
            avatarView.image = UIImage(systemName: "person.crop.circle")
        }

    }

    func setupView() {
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
