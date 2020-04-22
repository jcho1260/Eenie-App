//
//  Random8ViewController.swift
//  Choices
//
//  Created by Callie Scholer on 4/19/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit

class Random8ViewController: UIViewController {
  
  @IBOutlet weak var myImage: UIImageView!
  
    @IBOutlet weak var generateAnswerButton: UIButton!
    @IBOutlet weak var randomAnswer: UILabel!
  
  let imageNames = ["maybe", "negative", "positive"]

    override func viewDidLoad() {
        super.viewDidLoad()
        generateAnswerButton.layer.cornerRadius = 8
        //self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.7058823529, blue: 0.6274509804, alpha: 1)
      //generateAnswerButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
  @IBAction func showRandomAnswer(_ sender: Any) {
    
      let array = ["yes", "no", "I don't know", "maybe", "definitely", "definitely not", "no chance", "lol no", "for sure", "absolutely", "yeah", "nah", "nope", "yep", "unsure"]
    
    let randomAnswerGen = Int(arc4random_uniform(UInt32(array.count)))
    randomAnswer.text = array[randomAnswerGen]
    
    if(randomAnswer.text == "yes" || randomAnswer.text == "definitely" || randomAnswer.text == "for sure" || randomAnswer.text == "absolutely" || randomAnswer.text == "yeah" || randomAnswer.text == "yep") {
      myImage.image = UIImage(named: imageNames[2])
    } else if(randomAnswer.text == "I don't know" || randomAnswer.text == "maybe" || randomAnswer.text == "unsure") {
      myImage.image = UIImage(named: imageNames[0])
    } else {
      myImage.image = UIImage(named: imageNames[1])
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
