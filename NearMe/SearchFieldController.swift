//
//  SearchFieldController.swift
//  NearMe
//
//  Created by Саша Восколович on 18.04.2024.
//

import UIKit


class SearchTextFieldController: NSObject, UITextFieldDelegate {
    
    let field: UITextField
    let completionHandler: (String) -> Void
    
    init(field: UITextField, completionHandler: @escaping (String) -> Void) {
        self.field = field
        self.completionHandler = completionHandler
        super.init()
        self.field.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            textField.resignFirstResponder()
            completionHandler(text)
        }
        return true
    }
}
