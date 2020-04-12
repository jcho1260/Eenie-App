//
//  ViewController.swift
//  Choices
//
//  Created by Callie Scholer on 3/30/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    var db: OpaquePointer?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    
  }


    @IBAction func loginPushed(_ sender: Any) {
        guard let email = emailTf.text else {
            showAlert(title: "Missing Email", message: "An email field cannot be empty")
          // WARNS USER THAT EMIAL IS EMPTY
          return

        }
        if email.isEmpty{
            showAlert(title: "Missing Email", message: "An email field cannot be empty")
            // WARNS USER THAT EMIAL IS EMPTY
            return

        }
        
        
        guard let password = passwordTf.text else {
            showAlert(title: "Missing Password", message: "A password field cannot be empty")
          // WARN USER THAT PASSWORD IS EMPTY//if its empty dont keep going
          return
        }
        if password.isEmpty{
                   showAlert(title: "Missing Password", message: "A password field cannot be empty")
                   // WARNS USER THAT EMIAL IS EMPTY
                   return

               }
        
        
                                                                      
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

           if let err = error {
            self.showAlert(title: "Unable to sign in", message: err.localizedDescription) //if there is an error return the error message
              print("There was error! \(err)")
              return
           }
            self.performSegue(withIdentifier: "SignInSegueWay", sender: nil)
              // TODO: Created user was successful. Go to next screen because they have already been authenticated.
        }
    }
    
    
    @IBAction func createAccountPushed(_ sender: Any) {
    }
    
    
}
//Code below shows an alert to the user for example if email is missing it returns "email missing"/see above
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
                                                              
