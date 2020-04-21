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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var eenieNameLabel: UILabel!
    
//    var gradientLayer: CAGradientLayer!
//
//    func createGradientLayer() {
//        gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.view.bounds
//
//        let colorTop = UIColor(red: 245.0/255.0, green: 138.0/255.0, blue: 48.0/255.0, alpha: 1.0)
//
//        let colorBottom = UIColor.white.cgColor
//
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//
//        gradientLayer.colors = [colorTop, colorBottom]
//
//        self.view.layer.addSublayer(gradientLayer)
//    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.cornerRadius = 5
    eenieNameLabel.text = "eenie"
    // Do any additional setup after loading the view.

    
  }
    //Below lets us make sure that the user stays logged when they open and close the app
    
    // Under the if statements we are checking whether the user is signed in
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if the user is already authenicated. If so, go ahead and log in
        // Auth.auth().currenterUser = currentUser is an optional variable
        if let user = Auth.auth().currentUser {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NavController")
            UIApplication.shared.keyWindow?.rootViewController = viewController
                        //self.performSegue(withIdentifier: "SignInSegueWay", sender: nil)
        }
    }
    
 @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
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
            
        // Same logic from lines 33-36 below. Here we are actually changing the main page as the root controller to the user (nav controller)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NavController")
            UIApplication.shared.keyWindow?.rootViewController = viewController
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
                                                              
