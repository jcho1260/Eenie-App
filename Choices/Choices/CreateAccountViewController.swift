//
//  CreateAccountViewController.swift
//  Choices
//
//  Created by Rackeb Mered on 4/11/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPushed(_ sender: Any) {
        dismiss(animated: true) {
            print ("Going Back")
        }
    }
    
    
    @IBAction func createAccountPushed(_ sender: Any) {
        guard let email = email.text else {
            showAlert(title: "Missing Email", message: "An email field cannot be empty")
          // WARNS USER THAT EMIAL IS EMPTY
          return

        }
        if email.isEmpty{
            showAlert(title: "Missing Email", message: "An email field cannot be empty")
            // WARNS USER THAT EMIAL IS EMPTY
            return

        }
        
        guard let password = password.text else {
            showAlert(title: "Missing Password", message: "A password field cannot be empty")
          // WARN USER THAT PASSWORD IS EMPTY//if its empty dont keep going
          return
        }
        if password.isEmpty{
                   showAlert(title: "Missing Password", message: "A password field cannot be empty")
                   // WARNS USER THAT EMIAL IS EMPTY
                   return

               }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

           if let err = error {
             self.showAlert(title: "Unable to sign in", message: err.localizedDescription) //if there is an error return the error message
              print("There was error! \(err)")
              return
           }
            self.dismiss(animated: true) {
                self.showAlert(title: "Please sign in with you new account!", message: "")
            }

            // TODO: Created user was successful. Go to next screen because they have already been authenticated.
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
