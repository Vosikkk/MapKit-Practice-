//
//  SearchFieldController.swift
//  NearMe
//
//  Created by Саша Восколович on 18.04.2024.
//

import UIKit


class SearchTextFieldController: NSObject, UITextFieldDelegate {
    
    let field: UITextField
    let callback: (String) -> Void
    
    init(field: UITextField, callback: @escaping (String) -> Void) {
        self.field = field
        self.callback = callback
        super.init()
        self.field.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            textField.resignFirstResponder()
            callback(text)
        }
        return true
    }
}
