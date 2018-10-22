//
//  RegisterViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/5/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    
    var activeTextField = UITextField()
    var currKeyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.setupKeyboardStuff()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        emailTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        passwordTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
    }
    
    @objc func textFieldWasTappedOn(textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                currKeyboardHeight = keyboardSize.height
                let textFieldY = activeTextField.frame.origin.y
                if currKeyboardHeight < textFieldY {
                    self.view.frame.origin.y -= currKeyboardHeight
                    print(currKeyboardHeight)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y += currKeyboardHeight
            print(currKeyboardHeight)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


// extention to UIViewController to add functionality of dismissing keyboard when tapped anywhere else
extension UIViewController {
    func setupKeyboardStuff() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
