//
//  justButtonsViewController.swift
//  Choices
//
//  Created by Callie Scholer on 4/21/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class justButtonsViewController: UIViewController {

  @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var magicButton: UIButton!
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logOutSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = #colorLiteral(red: 0.8586310865, green: 0.6296434658, blue: 0.5, alpha: 1)
      //self.view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
      listButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
      listButton.layer.cornerRadius = 8
      magicButton.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.568627451, blue: 0.3176470588, alpha: 1)
      magicButton.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
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
