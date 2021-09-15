//
//  ContactsManager.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 15.09.2021.
//

import UIKit
import Contacts
import CoreData

class ContactsManager {

    static var shared: ContactsManager {
        return ContactsManager()
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let store = CNContactStore()

    var contactsFromPhonebook = [CNContact]()
    var contactsList: [Contact] = []

    //    func makeContact() {
    //        let newContact = Contact(context: context)
    //        newContact.name = "Dan"
    //        newContact.lastName = "Appleseed"
    //        newContact.phoneNumber = "380638009070"
    //        saveContact()
    //    }

    func saveContact() {
        do {
            try context.save()
            print("💿 SAVED!")
        } catch {
            print("🔥 \(error)")
        }
    }

    func makeContactFrom(_ cncontact: CNContact) -> Contact {
        let contact = Contact(context: context)
        contact.name = cncontact.givenName
        contact.lastName = cncontact.familyName
        contact.phoneNumber = cncontact.phoneNumbers.first?.value.stringValue
        contact.avatar = cncontact.imageData
        return contact
    }

    func fillContactsList() {
        fetchContactsFromPhonebook()
        contactsList = convertContactsFrom(contactsFromPhonebook)
        saveContact()
    }

    func convertContactsFrom(_ cncontacts: [CNContact]) -> [Contact] {
        var contacts = [Contact]()
        for cncontact in cncontacts {
            let contact = makeContactFrom(cncontact)
            contacts.append(contact)
        }
        return contacts
    }

    //        func loadContacts() {
    //            let request: NSFetchRequest<Contact> = Contact.fetchRequest()
    //            do {
    //                contactsList = try context.fetch(request)
    //                print("LOADED!")
    //            } catch {
    //                print("🔥 \(error)")
    //            }
    //        }

    func fetchContactsFromPhonebook() {

        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if let error = error {
                print("Failed to request access", error.localizedDescription)
                return
            }
            if granted {
                let keys = [
                    CNContactGivenNameKey,
                    CNContactFamilyNameKey,
                    CNContactImageDataKey,
                    CNContactImageDataAvailableKey,
                    CNContactPhoneNumbersKey
                ] as [CNKeyDescriptor]
                let request = CNContactFetchRequest(keysToFetch: keys)
                do {
                    try self?.store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self?.contactsFromPhonebook.append(contact)
                    })
                    //                    getStoredPersonsAndCompareWithcontacts(contacts: contactsFromPhone)
                    //                    getAllPersonFromCoreData()
                    //                    DispatchQueue.main.async {
                    //                        contactsCollection.reloadData()
                    //                    }

                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            }
        }
    }


}
