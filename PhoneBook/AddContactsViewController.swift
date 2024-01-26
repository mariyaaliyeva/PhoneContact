//
//  AddContactsViewController.swift
//  PhoneBook
//
//  Created by Mariya Aliyeva on 21.01.2024.
//

import UIKit

protocol AddContactsViewControllerDelegate: AnyObject {

func addContactViewController(_ addContactViewController: AddContactsViewController, didAddContact contact: User)
}

enum GenderType: String, CaseIterable {
	case male = "male"
	case female = "female"
}

final class AddContactsViewController: UIViewController {
	
	weak var delegate: AddContactsViewControllerDelegate?

// MARK: - Props
	var contactImage: UIImage?
	
	var textForNameTextField: String?
	var textForPhoneTextField: String?
	var imageForPicker: UIImage?
	
	// MARK: - UI
	private lazy var nameTextField: UITextField = {
		let textField = UITextField()
		textField.textAlignment = .left
		textField.backgroundColor = .systemFill
		textField.placeholder = "Name"
		textField.font = UIFont.systemFont(ofSize: 18)
		textField.borderStyle = .roundedRect
		textField.autocapitalizationType = .words
		textField.textContentType = .name
		textField.returnKeyType = .go
		textField.delegate = self
		return textField
	}()
	
	private lazy var phoneTextField: UITextField = {
		let textField = UITextField()
		textField.textAlignment = .left
		textField.backgroundColor = .systemFill
		textField.placeholder = "Phone number"
		textField.font = UIFont.systemFont(ofSize: 18)
		textField.borderStyle = .roundedRect
		textField.keyboardType = .numberPad
		textField.delegate = self
		return textField
	}()
	
	private lazy var genderPicker: UIPickerView = {
		let picker = UIPickerView()
		picker.delegate = self
		picker.dataSource = self
		return picker
	}()
	
	let saveButton: UIButton = {
		let button = UIButton()
		button.setTitle("Save", for: .normal)
		button.backgroundColor = .systemBlue
		button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
		button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
		return button
	}()
	
	@objc
	func saveButtonPressed() {
		let firstName = nameTextField.text ?? ""
		let lastName = phoneTextField.text ?? ""
		
		let newContact = User(name: firstName, phone: lastName, image: contactImage)
		
		delegate?.addContactViewController(self, didAddContact: newContact)
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		nameTextField.text = textForNameTextField
		phoneTextField.text = textForPhoneTextField
		
		if imageForPicker == UIImage(named: "female") {
			self.genderPicker.selectRow(1, inComponent: 0, animated: true)
		} else {
			self.genderPicker.selectRow(0, inComponent: 0, animated: true)
		}
		
		setupNavigationBar()
		setupViews()
		setupConstraints()
		hideKeyboardWhenTappedAround()
	}
	
	// MARK: - Navigation bar
	private func setupNavigationBar() {
		self.navigationItem.title = "New contact"
		
	}
	// MARK: - SetupViews
	func setupViews() {
		view.backgroundColor = .white
		[nameTextField, phoneTextField, genderPicker, saveButton].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - SetupConstraints
	func setupConstraints() {
		
		nameTextField.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
		}
		
		phoneTextField.snp.makeConstraints { make in
			make.top.equalTo(nameTextField.snp.bottom).offset(30)
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
		}
		
		genderPicker.snp.makeConstraints { make in
			make.top.equalTo(phoneTextField.snp.bottom)
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
		}
		saveButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(30)
			make.trailing.equalToSuperview().offset(-30)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
			make.height.equalTo(50)
		}
	}
}

//MARK: - UITextFieldDelegate
extension AddContactsViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		nameTextField.endEditing(true)
		phoneTextField.endEditing(true)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			nameTextField.placeholder = "Type something"
			phoneTextField.placeholder = "Type something"
			return false
		}
	}
}

// MARK: - UIPickerViewDataSource
extension AddContactsViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return GenderType.allCases.count
	}
}

// MARK: - UIPickerViewDelegate
extension AddContactsViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return GenderType.allCases[row].rawValue
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let selectedValue = pickerView.selectedRow(inComponent: 0)
		let value = GenderType.allCases[selectedValue].rawValue
		
		if value == GenderType.allCases[0].rawValue {
			contactImage = UIImage(named: "male")
		} else {
			contactImage = UIImage(named: "female")
		}
	}
}

// MARK: - HideKeyboardWhenTapped
extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
