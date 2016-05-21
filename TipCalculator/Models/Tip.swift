//
//  Tip.swift
//  TipCalculator
//
//  Created by Lam Tran on 5/21/16.
//  Copyright © 2016 Lam Tran. All rights reserved.
//

import Foundation

enum Tip : Int {
    case Low = 0, Medium, High
    
    func tipPercentage() -> Float {
        switch self {
        case .Low:
            return 0.1
        case .Medium:
            return 0.15
        case .High:
            return 0.2
        }
    }
}
