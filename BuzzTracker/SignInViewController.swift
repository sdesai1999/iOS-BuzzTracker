//
//  SignInViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/5/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var activeTextField = UITextField()
    var currKeyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 9
        cancelButton.layer.cornerRadius = 6
        
        self.setupKeyboardStuff()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
        passwordTextField.addTarget(self, action: #selector(textFieldWasTappedOn), for: UIControl.Event.touchDown)
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
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y += currKeyboardHeight
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        enum Alerts: String {
            case EMAIL = "Email field is empty"
            case PASS = "Password field is empty"
        }
        
        var isValid: Bool = true
        var alertList: [Alerts] = []
        let emailText = emailTextField.text!
        let passText = passwordTextField.text!
        
        if emailText.count == 0 {
            isValid = false
            alertList.append(Alerts.EMAIL)
        }
        
        if passText.count == 0 {
            isValid = false
            alertList.append(Alerts.PASS)
        }
        
        if !isValid {
            var alertMessage = ""
            for i in 0..<alertList.count {
                alertMessage.append(alertList[i].rawValue)
                if i != (alertList.count - 1) {
                    alertMessage.append(", ")
                }
            }
            
            let alert = UIAlertController(title: "Invalid Input", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passText) { (user, error) in
            if user == nil {
                var errorMessage = "Sign In Error"
                if let myError = error?.localizedDescription {
                    errorMessage = myError
                }
                
                let errorAlert = UIAlertController(title: "Sign In Error", message: errorMessage, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "signInToAppScreen", sender: self)
            }
        }
    }
}
