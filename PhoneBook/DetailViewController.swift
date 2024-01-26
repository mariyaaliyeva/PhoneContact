//
//  ContactInfoViewController.swift
//  PhoneBook
//
//  Created by Mariya Aliyeva on 23.01.2024.
//

import UIKit

protocol ContactInfoViewControllerDelegate: AnyObject {
	func deleteCell()
	func replaceCell(_ detailViewController: DetailViewController, replace contact: User)
}

final class DetailViewController: UIViewController {

	weak var delegate: ContactInfoViewControllerDelegate?

	// MARK: - Props
	var contact: User?
	var changeContact: User?
	var indexForContact = IndexPath()
	var index = IndexPath()

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
	
	let callButton: UIButton = {
		let button = UIButton()
		button.setTitle("Call", for: .normal)
		button.backgroundColor = .systemGreen
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
		button.addTarget(self, action: #selector(callButtonPressed), for: .touchUpInside)
		return button
	}()
	
	let changeButton: UIButton = {
		let button = UIButton()
		button.setTitle("Change", for: .normal)
		button.backgroundColor = .systemBlue
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
		button.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
		return button
	}()
	
	let deleteButton: UIButton = {
		let button = UIButton()
		button.setTitle("Delete", for: .normal)
		button.backgroundColor = .systemRed
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
		button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
		return button
	}()
	
	@objc
	func callButtonPressed() {
		print("Call")
	}
	
	@objc
	func changeButtonPressed() {
		let addContactsViewController = AddContactsViewController()
		addContactsViewController.textForNameTextField = contact?.name
		addContactsViewController.textForPhoneTextField = contact?.phone
		addContactsViewController.imageForPicker = contact?.image
		addContactsViewController.delegate = self
		navigationController?.pushViewController(addContactsViewController, animated: true)
	}
	
	@objc
	func deleteButtonPressed() {
		
		delegate?.deleteCell()
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupViews()
		setupConstraints()
	}
	
	// MARK: - Navigation bar
	
	private func setupNavigationBar() {
		self.navigationItem.title = "Contact Info"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image:  UIImage(named: "left"), style: .done, target: self, action: #selector(backAction))
	}
	
	@objc func backAction() {
		if changeContact != nil {
			delegate?.replaceCell(self, replace: changeContact ?? User(name: "NONE", phone: "NONE", image: UIImage(systemName: "person")))
		} else {
			delegate?.replaceCell(self, replace: contact ?? User(name: "NONE", phone: "NONE", image: UIImage(systemName: "person")))
		}
		navigationController?.popViewController(animated: true)
	}
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		[tableView, callButton, changeButton, deleteButton].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		tableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(callButton.snp.top).offset(-20)
		}
		
		deleteButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
			make.height.equalTo(50)
		}
		
		changeButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
			make.bottom.equalTo(deleteButton.snp.top).offset(-20)
			make.height.equalTo(50)
		}
		
		callButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
			make.bottom.equalTo(changeButton.snp.top).offset(-20)
			make.height.equalTo(50)
		}
	}
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ContactsTableViewCell
		if changeContact == nil {
			cell.configure(contact ?? User(name: "NONE", phone: "NONE", image: UIImage(systemName: "person")))
		} else {
			cell.configure(changeContact ?? User(name: "NONE", phone: "NONE", image: UIImage(systemName: "person")))
		}
		return cell
	}
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}

}

// MARK: - AddContactsViewControllerDelegate
extension DetailViewController: AddContactsViewControllerDelegate {
	
	func addContactViewController(_ addContactViewController: AddContactsViewController, didAddContact contact: User) {
		changeContact = contact
		tableView.reloadData()
	}
}
