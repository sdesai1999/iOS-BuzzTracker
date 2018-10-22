//
//  RegisterViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 10/5/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
        
        self.setupKeyboardStuff()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
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
    
    @IBAction func registerButtonPressed(_ sender: Any) { // when they press the "Register" button
        enum Alerts: String {
            case NAME = "Name field is empty"
            case EMAIL = "Email field is empty"
            case PASSLENGTH = "Password is not long enough"
            case PASSNUMBER = "Password does not contain a number"
            case PASSMATCH = "Passwords do not match"
        }
        
        var alertsList: [Alerts] = []
        var isValid: Bool = true
        let nameText: String = nameTextField.text!
        let emailText: String = emailTextField.text!
        let passText: String = passwordTextField.text!
        let confirmPassText: String = confirmPasswordTextField.text!
        
        if nameText.count == 0 {
            isValid = false
            alertsList.append(Alerts.NAME)
        }
        
        if emailText.count == 0 {
            isValid = false
            alertsList.append(Alerts.EMAIL)
        }
        
        if passText.count < 8 { // password must be at least 8 characters long
            isValid = false
            alertsList.append(Alerts.PASSLENGTH)
        }
        
        let numbersRange = passText.rangeOfCharacter(from: .decimalDigits)
        let hasADigit: Bool = (numbersRange != nil)
        if !hasADigit { // password must have a digit 0 through 9
            isValid = false
            alertsList.append(Alerts.PASSNUMBER)
        }
        
        if passText != confirmPassText {
            isValid = false
            alertsList.append(Alerts.PASSMATCH)
        }
        
        if !isValid {
            var alertMessage: String = ""
            for i in 0..<alertsList.count {
                alertMessage.append(contentsOf: alertsList[i].rawValue)
                if i != (alertsList.count - 1) {
                    alertMessage.append(contentsOf: ", ")
                }
            }
            
            let alert = UIAlertController(title: "Invalid Input", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: emailText, password: passText) { (user, error) in
            if user == nil {
                var errorMessage: String = "Sign Up Error"
                if let myError = error?.localizedDescription {
                    errorMessage = myError
                }

                let errorAlert = UIAlertController(title: "Sign Up Error", message: errorMessage, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                if self.userTypeSegmentedControl.selectedSegmentIndex == 0 {
                    currUserType = UserType.user
                } else if self.userTypeSegmentedControl.selectedSegmentIndex == 1 {
                    currUserType = UserType.locationEmployee
                } else {
                    currUserType = UserType.admin
                }
                
                let reference: DatabaseReference = Database.database().reference()
                let signedUpUser = Auth.auth().currentUser
                print(signedUpUser!.uid)
                reference.child("Users").child(signedUpUser!.uid).child("email").setValue(emailText)
                reference.child("Users").child(signedUpUser!.uid).child("name").setValue(nameText)
                reference.child("Users").child(signedUpUser!.uid).child("userType").setValue(currUserType.rawValue)
                self.performSegue(withIdentifier: "registerToAppScreen", sender: self)
            }
        }
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
