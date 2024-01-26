//
//  ViewController.swift
//  PhoneBook
//
//  Created by Mariya Aliyeva on 21.01.2024.
//

import UIKit
import SnapKit

final class ContactsViewController: UIViewController {

	// MARK: - Props
	var indexForDelete = IndexPath()
	private lazy var contacts = [User]()
	
	// MARK: - UI
	
	private lazy var tableView: UITableView = {
		var tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
		tableView.separatorStyle = .none
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerCell(ContactsTableViewCell.self)
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - Navigation bar
	
	private func setupNavigationBar() {
		self.navigationItem.title = "Contacts"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
	}
	
	@objc
	func addTapped() {
		let addContactsViewController = AddContactsViewController()
		addContactsViewController.delegate = self
		navigationController?.pushViewController(addContactsViewController, animated: true)
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.addSubview(tableView)
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ContactsTableViewCell
		let contact = contacts[indexPath.row]
		cell.configure(contact)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let contactInfoViewController = DetailViewController()
		contactInfoViewController.indexForContact = indexPath
		indexForDelete = indexPath
		contactInfoViewController.contact = contacts[indexPath.row]
		contactInfoViewController.delegate = self
		navigationController?.pushViewController(contactInfoViewController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			tableView.beginUpdates()
			contacts.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.endUpdates()
		}
	}
}

// MARK: - AddContactsViewControllerDelegate
extension ContactsViewController: AddContactsViewControllerDelegate {
	
	func addContactViewController(_ addContactViewController: AddContactsViewController, didAddContact contact: User) {
		contacts.append(contact)
		tableView.reloadData()
	}
}

// MARK: - ContactInfoViewControllerDelegate
extension ContactsViewController: ContactInfoViewControllerDelegate {
	
	func replaceCell(_ detailViewController: DetailViewController, replace contact: User) {
		contacts[indexForDelete.row] = contact
		//contacts.append(contact)
		print(contact)
		tableView.reloadData()
	}
	
	func deleteCell() {
		contacts.remove(at: indexForDelete.row)
		tableView.deleteRows(at: [indexForDelete], with: .automatic)
		tableView.reloadData()
	}
}
