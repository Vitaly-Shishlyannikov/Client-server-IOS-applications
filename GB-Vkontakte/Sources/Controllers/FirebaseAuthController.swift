//
//  FireBaseAuthController.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 24.07.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirebaseAuthController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("Authorized")
                self.performSegue(withIdentifier: "LoginFirebaseSegue", sender: nil)
                self.userNameTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @IBAction func enter(_ sender: Any) {
        
        guard let email = userNameTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        
        guard let email = userNameTextField.text,
            let password = passwordTextField.text
            else {
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                Auth.auth().signIn(withEmail: email, password: password)
            }
        }
    }
}


