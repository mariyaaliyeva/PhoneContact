//
//  UITableViewCell+Reusable.swift
//  PhoneBook
//
//  Created by Mariya Aliyeva on 21.01.2024.
//

import Foundation
import UIKit

protocol Reusable {}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
	
	static var reuseID: String {
		return String(describing: self)
	}
}
