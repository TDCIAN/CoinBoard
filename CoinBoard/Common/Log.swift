//
//  Log.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation

func Log<T>(
    _ object: @autoclosure () -> T,
    _ file: String = #file,
    _ function: String = #function,
    line: Int = #line
) {
#if DEBUG
    let objValue = object()
    var stringRepresentation: String = ""
    
    if let value = objValue as? CustomStringConvertible {
        stringRepresentation = value.description
    }
    
    let fileURL = URL(fileURLWithPath: file).lastPathComponent
    let queue = Thread.isMainThread ? "[Main]" : "[Others]"
    print("\(Date())C - <\(queue) \(fileURL) \(function) [Line: \(line)]\n" + stringRepresentation)
#endif
}
