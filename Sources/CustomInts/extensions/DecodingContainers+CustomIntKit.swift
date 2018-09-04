//
//  DecodingContainers+CustomIntKit.swift
//  CustomIntKit
//
//  Created by Tyler Anger on 2018-08-27.
//

import Foundation

public extension UnkeyedDecodingContainer {
    public mutating func decode<T>(_ type: T.Type) throws -> T where T : CustomIntegerHelper {
        if T.isSigned {
            let i: Int = try self.decode(Int.self)
            return T(i)
        } else {
            let i: UInt = try self.decode(UInt.self)
            return T(i)
        }
    }
    
    public mutating func decode(_ type: Int24.Type) throws -> Int24 {
        let value: Int = try self.decode(Int.self)
        return Int24(value)
    }
    public mutating func decode(_ type: UInt24.Type) throws -> UInt24 {
        let value: UInt = try self.decode(UInt.self)
        return UInt24(value)
    }
    
    public mutating func decode(_ type: Int40.Type) throws -> Int40 {
        let value: Int = try self.decode(Int.self)
        return Int40(value)
    }
    public mutating func decode(_ type: UInt40.Type) throws -> UInt40 {
        let value: UInt = try self.decode(UInt.self)
        return UInt40(value)
    }
    
    public mutating func decode(_ type: Int48.Type) throws -> Int48 {
        let value: Int = try self.decode(Int.self)
        return Int48(value)
    }
    public mutating func decode(_ type: UInt48.Type) throws -> UInt48 {
        let value: UInt = try self.decode(UInt.self)
        return UInt48(value)
    }
    
    public mutating func decode(_ type: Int56.Type) throws -> Int56 {
        let value: Int = try self.decode(Int.self)
        return Int56(value)
    }
    public mutating func decode(_ type: UInt56.Type) throws -> UInt56 {
        let value: UInt = try self.decode(UInt.self)
        return UInt56(value)
    }
}

public extension SingleValueDecodingContainer {
    public mutating func decode<T>(_ type: T.Type) throws -> T where T : CustomIntegerHelper {
        if T.isSigned {
            let i: Int = try self.decode(Int.self)
            return T(i)
        } else {
            let i: UInt = try self.decode(UInt.self)
            return T(i)
        }
    }
    
    public mutating func decode(_ type: Int24.Type) throws -> Int24 {
        let value: Int = try self.decode(Int.self)
        return Int24(value)
    }
    public mutating func decode(_ type: UInt24.Type) throws -> UInt24 {
        let value: UInt = try self.decode(UInt.self)
        return UInt24(value)
    }
    
    public mutating func decode(_ type: Int40.Type) throws -> Int40 {
        let value: Int = try self.decode(Int.self)
        return Int40(value)
    }
    public mutating func decode(_ type: UInt40.Type) throws -> UInt40 {
        let value: UInt = try self.decode(UInt.self)
        return UInt40(value)
    }
    
    public mutating func decode(_ type: Int48.Type) throws -> Int48 {
        let value: Int = try self.decode(Int.self)
        return Int48(value)
    }
    public mutating func decode(_ type: UInt48.Type) throws -> UInt48 {
        let value: UInt = try self.decode(UInt.self)
        return UInt48(value)
    }
    
    public mutating func decode(_ type: Int56.Type) throws -> Int56 {
        let value: Int = try self.decode(Int.self)
        return Int56(value)
    }
    public mutating func decode(_ type: UInt56.Type) throws -> UInt56 {
        let value: UInt = try self.decode(UInt.self)
        return UInt56(value)
    }
}

public extension KeyedDecodingContainer {
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T where T : CustomIntegerHelper {
        if T.isSigned {
            let i: Int = try self.decode(Int.self, forKey: key)
            return T(i)
        } else {
            let i: UInt = try self.decode(UInt.self, forKey: key)
            return T(i)
        }
    }
    
    public mutating func decode(_ type: Int24.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int24 {
        let value: Int = try self.decode(Int.self, forKey: key)
        return Int24(value)
    }
    public mutating func decode(_ type: UInt24.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt24 {
        let value: UInt = try self.decode(UInt.self, forKey: key)
        return UInt24(value)
    }
    
    public mutating func decode(_ type: Int40.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int40 {
        let value: Int = try self.decode(Int.self, forKey: key)
        return Int40(value)
    }
    public mutating func decode(_ type: UInt40.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt40 {
        let value: UInt = try self.decode(UInt.self, forKey: key)
        return UInt40(value)
    }
    
    public mutating func decode(_ type: Int48.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int48 {
        let value: Int = try self.decode(Int.self, forKey: key)
        return Int48(value)
    }
    public mutating func decode(_ type: UInt48.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt48 {
        let value: UInt = try self.decode(UInt.self, forKey: key)
        return UInt48(value)
    }
    
    public mutating func decode(_ type: Int56.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int56 {
        let value: Int = try self.decode(Int.self, forKey: key)
        return Int56(value)
    }
    public mutating func decode(_ type: UInt56.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt56 {
        let value: UInt = try self.decode(UInt.self, forKey: key)
        return UInt56(value)
    }
}
