//
//  xorOperator.swift
//  CustomInts
//
//  Created by Tyler Anger on 2019-09-29.
//

import Foundation

internal func xor(_ lhs: @autoclosure () -> Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
    let lhB = lhs()
    let rhB = rhs()
    return ((lhB && !rhB) || (!lhB && rhB))
}
