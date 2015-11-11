//
//  MemeTextFieldDelegate.swift
//  Meme
//
//  Created by Alexandre Gonzalo on 1/11/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == EditorViewController.textFieldLabel.Top.rawValue || textField.text == EditorViewController.textFieldLabel.Bottom.rawValue {
            textField.text = ""
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
