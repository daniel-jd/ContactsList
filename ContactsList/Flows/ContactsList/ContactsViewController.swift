//
//  ContactsViewController.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 03.09.2021.
//
// MARK: - TASK
/*
 Перевіряємо чи наданий момент існує наступний флоу:
 Стартує перший раз програмка:
 1. Просимо встановити паскод
 2. Просимо підтвердити паскод
 3. 1 пункт = 2 пункти записуємо паскод у кейчейн.
 4. Просимо дозвіл на біометрику
 5. Витягуємо усі контакти з телефоної книжки
 6. Записуємо усі наші контакти у кордату

 Аплікейшен був уже встановлений:
 1. Показуємо користовачеві скрін з паскодом, поверх показуємо авторизацію з тач/фейс ід
 2. Авторизація успішна показуємо, усі контакти(контакти відображаються з кордати)
 3. Перевіряємо чи були додані нові контакти у телефонній книжці, якщо так догружаємо їх у кордату.

 ______
 При кліку на контакт переходимо на детайл контакту:
 Сторінка має показатись з низу до гори.
 існуюча сторінка усіх контактів має їхати до гори, а з низу має показуватись сторінка детайл контактів.
 при кліку на плюсик кнопочку, повинно анімовано змінюватись 4 групи контактів
 */

import UIKit
import CoreData

class ContactsViewController: UIViewController {
// MARK: - Properties
    private let ContactsCellNibName = "ContactsCollectionViewCell"
    private let ContactsCellIdn = "contactCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var contactsList: [Contact] = []

    @IBOutlet private weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }

// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        registerCells()
        makeContact()
        loadContacts()
    }

    private func registerCells() {
        collectionView?.register(UINib(nibName: ContactsCellNibName, bundle: nil), forCellWithReuseIdentifier: ContactsCellIdn)
    }

// MARK: - Methods
        func makeContact() {
            let newContact = Contact(context: context)
            newContact.name = "Dan"
            newContact.lastName = "Appleseed"
            newContact.phoneNumber = "380638009070"
            saveContact()
        }

        func saveContact() {
            do {
                try context.save()
                print("SAVED!")
            } catch {
                print("🔥 \(error)")
            }
        }

        func loadContacts() {
            let request: NSFetchRequest<Contact> = Contact.fetchRequest()
            do {
                contactsList = try context.fetch(request)
                print("LOADED!")
            } catch {
                print("🔥 \(error)")
            }
        }

// MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }

}


// MARK: - CollectionView Delegate & Data Source

extension ContactsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactsList.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController
        else { return }
        vc.contact = contactsList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactsCellIdn, for: indexPath) as? ContactsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.contactNameLabel.text = contactsList[indexPath.row].name! +
            " " + contactsList[indexPath.row].lastName!
        cell.contactImageView.image = UIImage(systemName: "person.crop.circle") // TODO: Avatar

        return cell
    }
}

