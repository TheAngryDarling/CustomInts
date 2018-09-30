//
//  BinaryInteger+CustomInts.swift
//  CustomInts
//
//  Created by Tyler Anger on 2018-09-30.
//

import Foundation

public extension BinaryInteger {
    // Allows for an optional initializer that takes an optional BinaryInteger.
    // This is usefull when needing to cast one optional integer type to another optional integer type
    public init?<T>(_ source: T?) where T : BinaryInteger {
        guard let s = source else { return nil }
        self.init(s)
    }
}
