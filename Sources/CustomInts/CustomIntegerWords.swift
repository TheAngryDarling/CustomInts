//
//  CustomIntegerWords.swift
//  CustomIntKit
//
//  Created by Tyler Anger on 2018-08-22.
//

import Foundation

fileprivate let IS_BIGENDIAN: Bool = {
    let number: UInt32 = 0x12345678
    let converted = number.bigEndian
    return (number == converted)
}()

fileprivate let IS_LITTLEENDIAN: Bool = { return !IS_BIGENDIAN }()



public struct CustomIntegerWords<IntegerValue>: BidirectionalCollection, CustomStringConvertible where IntegerValue: CustomIntegerHelper {
    public typealias Indices = CountableRange<Int>
    public typealias SubSequence = Slice<CustomIntegerWords>
    
    private let _value: IntegerValue
    
    public let count: Int = 1
    public let startIndex: Int = 0
    public var endIndex: Int { return self.count }
    
    public var indices: Indices { return self.startIndex..<self.endIndex }
    
    public var description: String { return "Words(_value: \(self._value))" }
    
    public init(_ value: IntegerValue) { self._value = value }
    
    public subscript(position: Int) -> UInt {
        guard position == startIndex else { fatalError("Index out of bounds") }
        if let i = _value as? UInt { return i }
        
        var mutableSource = _value
        let size = MemoryLayout.size(ofValue: mutableSource)
        var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                let buffer = UnsafeBufferPointer(start: $0, count: size)
                return Array<UInt8>(buffer)

            }
        }
        
        if !IS_BIGENDIAN { bytes.reverse() }
        let isNeg = (IntegerValue.isSigned && ((bytes[0] & 0x80) == 0x80))
        let intSize = UInt.bitWidth / 8
        while(bytes.count < intSize) {
            if !isNeg {  bytes.insert(0x00, at: 0) }
            else { bytes.insert(0xFF, at: 0) }
        }
        //bytes = twosComplement(bytes)
        if !IS_BIGENDIAN { bytes.reverse() }
        
        return bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                return UInt($0.pointee)
            }
        }
        
    }
    
    @_transparent
    public func index(after i: Int) -> Int {
        guard i >= startIndex && i < endIndex else { fatalError("Index out of bounds") }
        return (i + 1)
    }
    @_transparent
    public func index(before i: Int) -> Int {
        guard i > startIndex && i <= endIndex else { fatalError("Index out of bounds") }
        return (i - 1)
    }

    
}
