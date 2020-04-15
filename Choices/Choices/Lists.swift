//
//  Lists.swift
//  Choices
//
//  Created by Jin Cho on 4/12/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import Foundation

class Lists{
    var id: String
    var name: String
    var choices: [Choice]
    
    
    struct Choice: Codable {
        var text: String
        var id: String
    }
    
    init(id:String, name:String, choices:[Choice]){
        self.id = id
        self.name = name
        self.choices = choices
    }
}
