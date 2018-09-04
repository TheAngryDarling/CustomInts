//
//  NSNumber+CustomIntKit.swift
//  CustomIntKit
//
//  Created by Tyler Anger on 2018-08-27.
//

import Foundation


public extension NSNumber {
    @nonobjc
    public convenience init<T>(value:  T) where T : CustomIntegerHelper {
        if T.isSigned { self.init(value: Int(value)) }
        else { self.init(value: UInt(value)) }
    }
    
    @nonobjc
    public convenience init(value:  Int24) {
        self.init(value: Int(value))
    }
    @nonobjc
    public convenience init(value:  UInt24) {
        self.init(value: UInt(value))
    }
    
    @nonobjc
    public convenience init(value:  Int40) {
        self.init(value: Int(value))
    }
    @nonobjc
    public convenience init(value:  UInt40) {
        self.init(value: UInt(value))
    }
    
    @nonobjc
    public convenience init(value:  Int48) {
        self.init(value: Int(value))
    }
    @nonobjc
    public convenience init(value:  UInt48) {
        self.init(value: UInt(value))
    }
    
    @nonobjc
    public convenience init(value:  Int56) {
        self.init(value: Int(value))
    }
    @nonobjc
    public convenience init(value:  UInt56) {
        self.init(value: UInt(value))
    }
}
