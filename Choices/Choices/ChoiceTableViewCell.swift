//
//  ChoiceTableViewCell.swift
//  Choices
//
//  Created by Jin Cho on 4/12/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var choiceText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(choice:Choices){
        choiceText.text = choice.text
    }

}
