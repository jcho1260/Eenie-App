//
//  justButtonViewController.swift
//  Choices
//
//  Created by Callie Scholer on 4/21/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class justButtonViewController: UIViewController {

  @IBOutlet weak var listButton: UIButton!
  
  @IBOutlet weak var questionButton: UIButton!
  
    @IBAction func logOutButton(_ sender: Any) {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "loginScreen")
        //        self.present(vc, animated: true)
        self.performSegue(withIdentifier: "logOutSegue", sender: self)
        try! Auth.auth().signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.7058823529, blue: 0.6274509804, alpha: 1)
      listButton.layer.cornerRadius = 8
       listButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
      
      questionButton.layer.cornerRadius = 8
      questionButton.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.568627451, blue: 0.3176470588, alpha: 1)
      
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
