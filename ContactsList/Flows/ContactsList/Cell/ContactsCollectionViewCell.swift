//
//  ContactsCollectionViewCell.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 03.09.2021.
//

import UIKit

class ContactsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contactImageView: UIImageView! {
        didSet {
            contactImageView.layer.cornerRadius = contactImageView.frame.width / 2
            contactImageView.clipsToBounds = true
            contactImageView.layer.borderColor = UIColor.white.cgColor
            contactImageView.layer.borderWidth = 1.5
        }
    }
    
    @IBOutlet weak var contactNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
