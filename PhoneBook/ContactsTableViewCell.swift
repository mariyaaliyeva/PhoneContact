//
//  ContactsTableViewCell.swift
//  PhoneBook
//
//  Created by Mariya Aliyeva on 21.01.2024.
//

import UIKit

final class ContactsTableViewCell: UITableViewCell {

	static var reuseId = String(describing: ContactsTableViewCell.self)
	
	// MARK: - UI

	 lazy var photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.tintColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1215686275, alpha: 1)
		return imageView
	}()
	
	private lazy var infoStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .center
		return stack
	}()
	
	 lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = .boldSystemFont(ofSize: 14)
		label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		return label
	}()
	
	 lazy var phoneLabel: UILabel = {
		let label = UILabel()
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 12)
		label.textColor = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
		return label
	}()
	
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Setup Views
	
	private func setupViews() {
		
		[photoImageView, infoStack].forEach {
			contentView.addSubview($0)
		}
		
		[nameLabel, phoneLabel].forEach {
			infoStack.addArrangedSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	
	private func setupConstraints() {
		
		photoImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.bottom.equalToSuperview().offset(-8)
			make.leading.equalToSuperview().offset(16)
			make.size.equalTo(100)
		}
		
		infoStack.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(18)
			make.bottom.equalToSuperview().offset(-18)
			make.leading.equalTo(photoImageView.snp.trailing).offset(50)
			make.trailing.equalToSuperview().offset(-16)
		}
		
	}
	
	// MARK: - Public
	
	func configure(_ model: User) {
		photoImageView.image = model.image
		nameLabel.text = model.name
		phoneLabel.text = model.phone
	}
}
