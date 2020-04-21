//
//  justButtonViewController.swift
//  Choices
//
//  Created by Callie Scholer on 4/21/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit

class justButtonViewController: UIViewController {

  @IBOutlet weak var listButton: UIButton!
  
  @IBOutlet weak var questionButton: UIButton!
  

    override func viewDidLoad() {
        super.viewDidLoad()

      self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.7058823529, blue: 0.6274509804, alpha: 1)
      listButton.layer.cornerRadius = 8
       listButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
      questionButton.layer.cornerRadius = 8
      questionButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
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
