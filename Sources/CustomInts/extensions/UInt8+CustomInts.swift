//
//  UInt8+CustomInts.swift
//  CustomInts
//
//  Created by Tyler Anger on 2019-09-29.
//

import Foundation

internal extension UInt8 {
    /// Indicates if bit 8 is set
    var hasMinusBit: Bool { return ((self & 0x80) == 0x80) }
}
