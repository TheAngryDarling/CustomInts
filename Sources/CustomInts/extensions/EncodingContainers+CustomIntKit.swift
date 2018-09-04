//
//  Encoder+CustomIntKit.swift
//  CustomIntKit
//
//  Created by Tyler Anger on 2018-08-27.
//

import Foundation

public extension UnkeyedEncodingContainer {
    public mutating func encode<T>(_ value: T) throws where T : CustomIntegerHelper {
        if T.isSigned { try self.encode(Int(value)) }
        else { try self.encode(UInt(value)) }
    }
    
    public mutating func encode(_ value: Int24) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt24) throws {
        try self.encode(UInt(value))
    }
    
    public mutating func encode(_ value: Int40) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt40) throws {
        try self.encode(UInt(value))
    }
    
    public mutating func encode(_ value: Int48) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt48) throws {
        try self.encode(UInt(value))
    }
    
    public mutating func encode(_ value: Int56) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt56) throws {
        try self.encode(UInt(value))
    }
    
}

public extension SingleValueEncodingContainer {
    public mutating func encode<T>(_ value: T) throws where T : CustomIntegerHelper {
        if T.isSigned { try self.encode(Int(value)) }
        else { try self.encode(UInt(value)) }
    }
    
    public mutating func encode(_ value: Int24) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt24) throws {
        try self.encode(UInt(value))
    }
    
    public mutating func encode(_ value: Int40) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt40) throws {
        try self.encode(UInt(value))
    }
    
    public mutating func encode(_ value: Int48) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt48) throws {
        try self.encode(UInt(value))
    }
    
    public mutating func encode(_ value: Int56) throws {
        try self.encode(Int(value))
    }
    public mutating func encode(_ value: UInt56) throws {
        try self.encode(UInt(value))
    }
}

public extension KeyedEncodingContainer {
    public mutating func encode<T>(_ value: T, forKey key: KeyedEncodingContainer.Key) throws where T : CustomIntegerHelper {
        if T.isSigned { try self.encode(Int(value), forKey: key) }
        else { try self.encode(UInt(value), forKey: key) }
    }
    
    public mutating func encode(_ value: Int24, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    public mutating func encode(_ value: UInt24, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int40, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    public mutating func encode(_ value: UInt40, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int48, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    public mutating func encode(_ value: UInt48, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int56, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    public mutating func encode(_ value: UInt56, forKey key: KeyedEncodingContainer.Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
}
