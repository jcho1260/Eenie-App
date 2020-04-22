//
//  RandomChoice.swift
//  Choices
//
//  Created by Rackeb Mered on 4/15/20.
//  Copyright © 2020 Callie Scholer. All rights reserved.
//

import Foundation
import UIKit


class RandomChoice {
    static func selectOne<T>(choices: [T]) -> T {
        let randomChoice = Int.random(in: 0..<choices.count)
        return choices[randomChoice]
    }
}


