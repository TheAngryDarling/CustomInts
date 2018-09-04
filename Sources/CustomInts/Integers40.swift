//
//  Integers40.swift
//  CustomIntKit
//
//  Created by Tyler Anger on 2018-08-24.
//

import Foundation


fileprivate let IS_BIGENDIAN: Bool = {
    let number: UInt32 = 0x12345678
    let converted = number.bigEndian
    return (number == converted)
}()

fileprivate let IS_LITTLEENDIAN: Bool = { return !IS_BIGENDIAN }()

public struct Int40: CustomSignedIntegerHelper {
    public typealias InverseInteger = UInt40
    public typealias Magnitude = UInt40 // Required for use with SignedInteger and CustomSignedIntegerHelper
    public static let bitWidth: Int = 40
    
    // Must define these variables here.  The system fails to properly automatically generate the min and max on signed instances
    public static let min: Int40 = 0x8000000000
    public static let max: Int40 = 0x7FFFFFFFFF
    
    
    private var a,b,c,d,e: UInt8
    
    public init() {
        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
    }
    
    
    public init<T>(_ source: T) where T : BinaryInteger {
        // This was built from template in CustomIntegerHelper because implementation of
        // BinaryInteger and FixedWidthInteger seem to require this init be places directly
        // in the structure
        //
        //
        // This was built from template in CustomIntegerHelper
        // Initialize all bytes in structure to zero
        // self.a = 0
        // self.b = 0
        // ......
        
        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
        
        
        // Set required specific integer type information
        let isLocalTypeSigned = Int40.isSigned
        let localBitWidth = Int40.bitWidth
        let localByteWidth = (localBitWidth / 8)
        let intType = Int40.self
        
        var mutableSource = source
        
        let size = MemoryLayout<T>.size
        var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                return Array(UnsafeBufferPointer(start: $0, count: size))
            }
        }
        
        if !IS_BIGENDIAN { bytes.reverse() }
        let isNegative = (((bytes[0] & 0x80) == 0x80))
        
        if !isLocalTypeSigned && T.isSigned && isNegative {
            fatalError("\(source) is not representable as a '\(intType)' instance")
        } else if isLocalTypeSigned && !T.isSigned && isNegative && (bytes.count * 8) >= localByteWidth {
            fatalError("Not enough bits to represent a signed value")
        }
        
        let paddingValue: UInt8 = (isNegative && T.isSigned) ? 0xFF : 0x00
        
        while bytes.count > localByteWidth && bytes[0] == paddingValue { bytes.remove(at: 0) }
        while bytes.count < localByteWidth { bytes.insert(paddingValue, at: 0) }
        
        guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
        
        if !IS_BIGENDIAN { bytes.reverse() }
        
        
        // Copy bytes into self
        withUnsafeMutablePointer(to: &self) {
            $0.withMemoryRebound(to: UInt8.self, capacity: localByteWidth) {
                let buffer = UnsafeMutableBufferPointer(start: $0, count: localByteWidth)
                
                for i in 0..<buffer.count {
                    buffer[i] = bytes[i]
                }
            }
        }
    }
    
}


public struct UInt40: CustomUnsignedIntegerHelper {
    public typealias InverseInteger = Int40
    public static let bitWidth: Int = 40
    
    // Must define these variables here.  The system fails to properly automatically generate the min and max on signed instances
    public static let min: UInt40 = 0x0000000000
    public static let max: UInt40 = 0xFFFFFFFFFF
    
    
    private var a,b,c,d,e: UInt8
    
    
    public init() {
        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
    }
    
    public init<T>(_ source: T) where T : BinaryInteger {
        // This was built from template in CustomIntegerHelper because implementation of
        // BinaryInteger and FixedWidthInteger seem to require this init be places directly
        // in the structure
        //
        //
        // This was built from template in CustomIntegerHelper
        // Initialize all bytes in structure to zero
        // self.a = 0
        // self.b = 0
        // ......
        
        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
        
        
        // Set required specific integer type information
        let isLocalTypeSigned = UInt40.isSigned
        let localBitWidth = UInt40.bitWidth
        let localByteWidth = (localBitWidth / 8)
        let intType = UInt40.self
        
        var mutableSource = source
        
        let size = MemoryLayout<T>.size
        var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                return Array(UnsafeBufferPointer(start: $0, count: size))
            }
        }
        
        if !IS_BIGENDIAN { bytes.reverse() }
        let isNegative = (((bytes[0] & 0x80) == 0x80))
        
        if !isLocalTypeSigned && T.isSigned && isNegative {
            fatalError("\(source) is not representable as a '\(intType)' instance")
        } else if isLocalTypeSigned && !T.isSigned && isNegative && (bytes.count * 8) >= localByteWidth {
            fatalError("Not enough bits to represent a signed value")
        }
        
        let paddingValue: UInt8 = (isNegative && T.isSigned) ? 0xFF : 0x00
        
        while bytes.count > localByteWidth && bytes[0] == paddingValue { bytes.remove(at: 0) }
        while bytes.count < localByteWidth { bytes.insert(paddingValue, at: 0) }
        
        guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
        
        if !IS_BIGENDIAN { bytes.reverse() }
        
        
        // Copy bytes into self
        withUnsafeMutablePointer(to: &self) {
            $0.withMemoryRebound(to: UInt8.self, capacity: localByteWidth) {
                let buffer = UnsafeMutableBufferPointer(start: $0, count: localByteWidth)
                
                for i in 0..<buffer.count {
                    buffer[i] = bytes[i]
                }
            }
        }
    }
}
