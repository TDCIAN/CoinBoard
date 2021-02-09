//
//  Double + toNumberFormatted.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/09.
//

import Foundation

extension Double {
    func toNumberFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber)!
    }
}
