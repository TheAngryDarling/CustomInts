//  This file was dynamically generated from 'ints.dswift' by Dynamic Swift.  Please do not modify directly.
//  Dynamic Swift can be found at https://github.com/TheAngryDarling/dswift.

//
//  ints.dswift
//  CustomInts
//
//  Created by Tyler Anger on 2019-09-29.
//

import Foundation
import NumericPatches







    public struct UInt24: FixedWidthInteger, UnsignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = UInt32
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<UInt24.Words>
          //public typealias SubSequence = Slice<UInt24.Words>

          internal var _value: UInt24

          public init(_ value: UInt24) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (UInt24.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = false
        public static let bitWidth: Int = 24
        
        public static let min: UInt24 = UInt24()
        public static let max: UInt24 = 16777215
        
        
        public static let zero: UInt24 = UInt24()
        internal static let one: UInt24 = 1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: UInt24.Words { return UInt24.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: UInt24 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return UInt24(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt24 {
            
                return self
            
        }
        
        public var bigEndian: UInt24 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: UInt24 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
        }
        
        public init(_ other: UInt24) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = UInt24.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: Int24) {
            precondition(UInt24.bitWidth == Int24.bitWidth, "BitWidth of UInt24 and Int24 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: UInt24) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: UInt24) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<UInt24>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
            // Set required specific integer type information
            let isLocalTypeSigned = UInt24.isSigned
            let localBitWidth = UInt24.bitWidth
            let localByteWidth = (localBitWidth / 8)
            let intType = UInt24.self
            
            var mutableSource = source
            
            let size = MemoryLayout<T>.size
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    return Array(UnsafeBufferPointer(start: $0, count: size))
                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> UInt24 {
            
                if self.isZero { return UInt24.zero }
                else { return UInt24.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = UInt24.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: UInt24) -> (partialValue: UInt24, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: UInt24.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt24 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt24.self, capacity: 1) {
                    return UInt24($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt32(self).addingReportingOverflow(UInt32(rhs))
            
            if r.overflow ||
               r.partialValue > UInt32(UInt24.max) ||
               r.partialValue < UInt32(UInt24.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt24(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: UInt24) -> (partialValue: UInt24, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: UInt24.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt24 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt24.self, capacity: 1) {
                    return UInt24($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && UInt24.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt32(self).subtractingReportingOverflow(UInt32(rhs))
            
            if r.overflow ||
               r.partialValue > UInt32(UInt24.max) ||
               r.partialValue < UInt32(UInt24.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt24(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: UInt24) -> (high: UInt24, low: UInt24) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: UInt24.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt24.self, capacity: 1) {
                    return UInt24(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt24.self, capacity: 1) {
                    return UInt24(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = UInt32(self).multipliedFullWidth(by: UInt32(other))
            
            let val = r.low
            
            let high = val >> UInt24.bitWidth
            let low = val - (high << UInt24.bitWidth)
            
            return (high: UInt24(high), low: UInt24(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: UInt24) -> (partialValue: UInt24, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: UInt24(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = UInt24(truncatingIfNeeded: r.low)
            //let val = UInt24(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !UInt24.isSigned && r.high == 1 { overflow = true }
            else if UInt24.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: UInt24.zero, overflow: false) }
            
            let r = UInt32(self).multipliedReportingOverflow(by: UInt32(rhs))
            
            if r.overflow ||
               r.partialValue > UInt32(UInt24.max) ||
               r.partialValue < UInt32(UInt24.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt24(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: UInt24, low: Magnitude)) -> (quotient: UInt24, remainder: UInt24) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (UInt(dividend.high.iValue) << UInt(UInt24.bitWidth)) + UInt(dividend.low)
                
                let r = UInt(self.iValue).quotientAndRemainder(dividingBy: divisor)
                return (quotient: UInt24(r.quotient), remainder: UInt24(r.remainder))
            
        }
        
        public func dividedReportingOverflow(by rhs: UInt24) -> (partialValue: UInt24, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: UInt24(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue: UInt = UInt(self.iValue) / UInt(rhs.iValue)
                let hasOverflow = (intValue > UInt24.max.iValue || intValue < UInt24.min.iValue)
                return (partialValue: UInt24(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: UInt24.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = UInt32(self).dividedReportingOverflow(by: UInt32(rhs))
            
            if r.overflow ||
               r.partialValue > UInt32(UInt24.max) ||
               r.partialValue < UInt32(UInt24.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt24(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: UInt24) -> (partialValue: UInt24, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = UInt32(self).remainderReportingOverflow(dividingBy: UInt32(rhs))
            return (partialValue: UInt24(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: UInt24) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if self > other {
                    if let result = Int(exactly: self - other) {
                        return -result
                    }
                } else {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> UInt24 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                return (n.isNegative ? (self - UInt24(-n)) : (self + UInt24(n)) )
            
        }
        
        
        public static func == (lhs: UInt24, rhs: UInt24) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: UInt24, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: UInt24.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return UInt32(lhs) == rhs
        }
        
        public static func != (lhs: UInt24, rhs: UInt24) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: UInt24, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: UInt24, rhs: UInt24) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt24.isSigned)
            return UInt32(lhs) < UInt32(rhs)
        }
        public static func < <Other>(lhs: UInt24, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt24.isSigned) */
            
            return UInt32(lhs) < UInt32(rhs)
        }
        
        public static func > (lhs: UInt24, rhs: UInt24) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt32(lhs) > UInt32(rhs)
        }
        public static func > <Other>(lhs: UInt24, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt32(lhs) > rhs
        }
        
        public static func + (lhs: UInt24, rhs: UInt24) -> UInt24 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: UInt24, rhs: UInt24) -> UInt24 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: UInt24, rhs: UInt24) -> UInt24 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: UInt24, rhs: UInt24) -> UInt24 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: UInt24, rhs: UInt24) -> UInt24 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: UInt24, rhs: UInt24) -> UInt24  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt24(lhb)
            
        }
        
        public static func | (lhs: UInt24, rhs: UInt24) -> UInt24  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt24(lhb)
            
        }
        
        public static func ^ (lhs: UInt24, rhs: UInt24) -> UInt24  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt24(lhb)
            
        }
        
        public static func >>(lhs: UInt24, rhs: UInt24) -> UInt24 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt24(bytes)
            
        }
        
        public static func >><Other>(lhs: UInt24, rhs: Other) -> UInt24 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> UInt24(rhs)
        }
        
        public static func << (lhs: UInt24, rhs: UInt24) -> UInt24  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt24(bytes)
        }
        
        public static func <<<Other>(lhs: UInt24, rhs: Other) -> UInt24 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << UInt24(rhs)
        }
        

        public static func += (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout UInt24, rhs: UInt24) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension UInt24: AdditiveArithmetic { }
    #endif
    /// MARK: - UInt24 - Codable
    extension UInt24: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(UInt24.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    
    public struct Int24: FixedWidthInteger, SignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = Int32
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<Int24.Words>
          //public typealias SubSequence = Slice<Int24.Words>

          internal var _value: Int24

          public init(_ value: Int24) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (Int24.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = true
        public static let bitWidth: Int = 24
        
        public static let min: Int24 = -8388608
        public static let max: Int24 = 8388607
        
        
        public static let zero: Int24 = Int24()
        internal static let one: Int24 = 1
        
        internal static let minusOne: Int24 = -1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: Int24.Words { return Int24.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: Int24 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return Int24(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt24 {
            
                if self.isZero { return UInt24() }
                else if self.mostSignificantByte.hasMinusBit {
                
                var bytes = self.bytes
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                bytes = IntLogic.twosComplement(bytes)
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                return UInt24(bytes)
                
                } else { return UInt24(bitPattern: self) }
            
        }
        
        public var bigEndian: Int24 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: Int24 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
        }
        
        public init(_ other: Int24) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = Int24.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: UInt24) {
            precondition(Int24.bitWidth == UInt24.bitWidth, "BitWidth of Int24 and UInt24 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: Int24) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: Int24) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<Int24>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
            // Set required specific integer type information
            let isLocalTypeSigned = Int24.isSigned
            let localBitWidth = Int24.bitWidth
            let localByteWidth = (localBitWidth / 8)
            let intType = Int24.self
            
            var mutableSource = source
            
            let size = MemoryLayout<T>.size
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    return Array(UnsafeBufferPointer(start: $0, count: size))
                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> Int24 {
            
                if self.isZero { return Int24.zero }
                else if self.mostSignificantByte.hasMinusBit { return Int24.minusOne }
                else { return Int24.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = Int24.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: Int24) -> (partialValue: Int24, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: Int24.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int24 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int24.self, capacity: 1) {
                    return Int24($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = Int32(self).addingReportingOverflow(Int32(rhs))
            
            if r.overflow ||
               r.partialValue > Int32(Int24.max) ||
               r.partialValue < Int32(Int24.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int24(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: Int24) -> (partialValue: Int24, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: Int24.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int24 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int24.self, capacity: 1) {
                    return Int24($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && Int24.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = Int32(self).subtractingReportingOverflow(Int32(rhs))
            
            if r.overflow ||
               r.partialValue > Int32(Int24.max) ||
               r.partialValue < Int32(Int24.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int24(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: Int24) -> (high: Int24, low: UInt24) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: Int24.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt24.self, capacity: 1) {
                    return UInt24(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int24.self, capacity: 1) {
                    return Int24(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = Int32(self).multipliedFullWidth(by: Int32(other))
            
            let val = r.low
            
            let high = val >> Int24.bitWidth
            let low = val - (high << Int24.bitWidth)
            
            return (high: Int24(high), low: UInt24(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: Int24) -> (partialValue: Int24, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: Int24(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = Int24(truncatingIfNeeded: r.low)
            //let val = Int24(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !Int24.isSigned && r.high == 1 { overflow = true }
            else if Int24.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: Int24.zero, overflow: false) }
            
            let r = Int32(self).multipliedReportingOverflow(by: Int32(rhs))
            
            if r.overflow ||
               r.partialValue > Int32(Int24.max) ||
               r.partialValue < Int32(Int24.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int24(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: Int24, low: Magnitude)) -> (quotient: Int24, remainder: Int24) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (dividend.high.iValue << Int24.bitWidth) + Int(dividend.low)
                
                let r = self.iValue.quotientAndRemainder(dividingBy: divisor)
                return (quotient: Int24(r.quotient), remainder: Int24(r.remainder))
                
             
        }
        
        public func dividedReportingOverflow(by rhs: Int24) -> (partialValue: Int24, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: Int24(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue = self.iValue / rhs.iValue
                let hasOverflow = (intValue > Int24.max.iValue || intValue < Int24.min.iValue)
                return (partialValue: Int24(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: Int24.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = Int32(self).dividedReportingOverflow(by: Int32(rhs))
            
            if r.overflow ||
               r.partialValue > Int32(Int24.max) ||
               r.partialValue < Int32(Int24.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int24(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int24(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: Int24) -> (partialValue: Int24, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            let isSelfNeg = selfValue.isNegative
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = Int32(self).remainderReportingOverflow(dividingBy: Int32(rhs))
            return (partialValue: Int24(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: Int24) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                let isNeg = self.isNegative
                if isNeg == other.isNegative {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                } else {
                    if let result = Int(exactly: self.magnitude + other.magnitude) {
                        return isNegative ? result : -result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> Int24 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if  (self.isNegative == n.isNegative) { return (self + Int24(n)) }
            
                return (self.magnitude < n.magnitude) ? Int24(Int(self) + n) : (self + Int24(n))
            
        }
        
        
        public static func == (lhs: Int24, rhs: Int24) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: Int24, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: Int24.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return Int32(lhs) == rhs
        }
        
        public static func != (lhs: Int24, rhs: Int24) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: Int24, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: Int24, rhs: Int24) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int24.isSigned)
            return Int32(lhs) < Int32(rhs)
        }
        public static func < <Other>(lhs: Int24, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int24.isSigned) */
            
            return Int32(lhs) < Int32(rhs)
        }
        
        public static func > (lhs: Int24, rhs: Int24) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int32(lhs) > Int32(rhs)
        }
        public static func > <Other>(lhs: Int24, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int32(lhs) > rhs
        }
        
        public static func + (lhs: Int24, rhs: Int24) -> Int24 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: Int24, rhs: Int24) -> Int24 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: Int24, rhs: Int24) -> Int24 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: Int24, rhs: Int24) -> Int24 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: Int24, rhs: Int24) -> Int24 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: Int24, rhs: Int24) -> Int24  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int24(lhb)
            
        }
        
        public static func | (lhs: Int24, rhs: Int24) -> Int24  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int24(lhb)
            
        }
        
        public static func ^ (lhs: Int24, rhs: Int24) -> Int24  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int24(lhb)
            
        }
        
        public static func >>(lhs: Int24, rhs: Int24) -> Int24 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int24(bytes)
            
        }
        
        public static func >><Other>(lhs: Int24, rhs: Other) -> Int24 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> Int24(rhs)
        }
        
        public static func << (lhs: Int24, rhs: Int24) -> Int24  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int24(bytes)
        }
        
        public static func <<<Other>(lhs: Int24, rhs: Other) -> Int24 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << Int24(rhs)
        }
        

        public static func += (lhs: inout Int24, rhs: Int24) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout Int24, rhs: Int24) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension Int24: AdditiveArithmetic { }
    #endif
    /// MARK: - Int24 - Codable
    extension Int24: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(Int24.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    


    public struct UInt40: FixedWidthInteger, UnsignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = UInt64
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<UInt40.Words>
          //public typealias SubSequence = Slice<UInt40.Words>

          internal var _value: UInt40

          public init(_ value: UInt40) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (UInt40.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = false
        public static let bitWidth: Int = 40
        
        public static let min: UInt40 = UInt40()
        public static let max: UInt40 = 1099511627775
        
        
        public static let zero: UInt40 = UInt40()
        internal static let one: UInt40 = 1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: UInt40.Words { return UInt40.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: UInt40 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return UInt40(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt40 {
            
                return self
            
        }
        
        public var bigEndian: UInt40 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: UInt40 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c, d, e] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c, d, e: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
            self.d = 0
            
            self.e = 0
            
        }
        
        public init(_ other: UInt40) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
            self.d = other.d
            
            self.e = other.e
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = UInt40.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: Int40) {
            precondition(UInt40.bitWidth == Int40.bitWidth, "BitWidth of UInt40 and Int40 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: UInt40) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: UInt40) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<UInt40>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
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
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> UInt40 {
            
                if self.isZero { return UInt40.zero }
                else { return UInt40.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = UInt40.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: UInt40) -> (partialValue: UInt40, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: UInt40.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt40 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt40.self, capacity: 1) {
                    return UInt40($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt(self).addingReportingOverflow(UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt40.max) ||
               r.partialValue < UInt(UInt40.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt40(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: UInt40) -> (partialValue: UInt40, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: UInt40.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt40 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt40.self, capacity: 1) {
                    return UInt40($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && UInt40.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt(self).subtractingReportingOverflow(UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt40.max) ||
               r.partialValue < UInt(UInt40.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt40(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: UInt40) -> (high: UInt40, low: UInt40) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: UInt40.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt40.self, capacity: 1) {
                    return UInt40(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt40.self, capacity: 1) {
                    return UInt40(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = UInt(self).multipliedFullWidth(by: UInt(other))
            
            let val = r.low
            
            let high = val >> UInt40.bitWidth
            let low = val - (high << UInt40.bitWidth)
            
            return (high: UInt40(high), low: UInt40(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: UInt40) -> (partialValue: UInt40, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: UInt40(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = UInt40(truncatingIfNeeded: r.low)
            //let val = UInt40(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !UInt40.isSigned && r.high == 1 { overflow = true }
            else if UInt40.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: UInt40.zero, overflow: false) }
            
            let r = UInt(self).multipliedReportingOverflow(by: UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt40.max) ||
               r.partialValue < UInt(UInt40.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt40(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: UInt40, low: Magnitude)) -> (quotient: UInt40, remainder: UInt40) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (UInt(dividend.high.iValue) << UInt(UInt40.bitWidth)) + UInt(dividend.low)
                
                let r = UInt(self.iValue).quotientAndRemainder(dividingBy: divisor)
                return (quotient: UInt40(r.quotient), remainder: UInt40(r.remainder))
            
        }
        
        public func dividedReportingOverflow(by rhs: UInt40) -> (partialValue: UInt40, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: UInt40(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue: UInt = UInt(self.iValue) / UInt(rhs.iValue)
                let hasOverflow = (intValue > UInt40.max.iValue || intValue < UInt40.min.iValue)
                return (partialValue: UInt40(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: UInt40.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = UInt(self).dividedReportingOverflow(by: UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt40.max) ||
               r.partialValue < UInt(UInt40.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt40(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: UInt40) -> (partialValue: UInt40, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = UInt(self).remainderReportingOverflow(dividingBy: UInt(rhs))
            return (partialValue: UInt40(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: UInt40) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if self > other {
                    if let result = Int(exactly: self - other) {
                        return -result
                    }
                } else {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> UInt40 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                return (n.isNegative ? (self - UInt40(-n)) : (self + UInt40(n)) )
            
        }
        
        
        public static func == (lhs: UInt40, rhs: UInt40) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: UInt40, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: UInt40.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return UInt(lhs) == rhs
        }
        
        public static func != (lhs: UInt40, rhs: UInt40) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: UInt40, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: UInt40, rhs: UInt40) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt40.isSigned)
            return UInt(lhs) < UInt(rhs)
        }
        public static func < <Other>(lhs: UInt40, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt40.isSigned) */
            
            return UInt(lhs) < UInt(rhs)
        }
        
        public static func > (lhs: UInt40, rhs: UInt40) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt(lhs) > UInt(rhs)
        }
        public static func > <Other>(lhs: UInt40, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt(lhs) > rhs
        }
        
        public static func + (lhs: UInt40, rhs: UInt40) -> UInt40 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: UInt40, rhs: UInt40) -> UInt40 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: UInt40, rhs: UInt40) -> UInt40 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: UInt40, rhs: UInt40) -> UInt40 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: UInt40, rhs: UInt40) -> UInt40 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: UInt40, rhs: UInt40) -> UInt40  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt40(lhb)
            
        }
        
        public static func | (lhs: UInt40, rhs: UInt40) -> UInt40  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt40(lhb)
            
        }
        
        public static func ^ (lhs: UInt40, rhs: UInt40) -> UInt40  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt40(lhb)
            
        }
        
        public static func >>(lhs: UInt40, rhs: UInt40) -> UInt40 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt40(bytes)
            
        }
        
        public static func >><Other>(lhs: UInt40, rhs: Other) -> UInt40 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> UInt40(rhs)
        }
        
        public static func << (lhs: UInt40, rhs: UInt40) -> UInt40  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt40(bytes)
        }
        
        public static func <<<Other>(lhs: UInt40, rhs: Other) -> UInt40 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << UInt40(rhs)
        }
        

        public static func += (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout UInt40, rhs: UInt40) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension UInt40: AdditiveArithmetic { }
    #endif
    /// MARK: - UInt40 - Codable
    extension UInt40: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(UInt40.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    
    public struct Int40: FixedWidthInteger, SignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = Int64
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<Int40.Words>
          //public typealias SubSequence = Slice<Int40.Words>

          internal var _value: Int40

          public init(_ value: Int40) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (Int40.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = true
        public static let bitWidth: Int = 40
        
        public static let min: Int40 = -549755813888
        public static let max: Int40 = 549755813887
        
        
        public static let zero: Int40 = Int40()
        internal static let one: Int40 = 1
        
        internal static let minusOne: Int40 = -1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: Int40.Words { return Int40.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: Int40 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return Int40(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt40 {
            
                if self.isZero { return UInt40() }
                else if self.mostSignificantByte.hasMinusBit {
                
                var bytes = self.bytes
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                bytes = IntLogic.twosComplement(bytes)
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                return UInt40(bytes)
                
                } else { return UInt40(bitPattern: self) }
            
        }
        
        public var bigEndian: Int40 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: Int40 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c, d, e] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c, d, e: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
            self.d = 0
            
            self.e = 0
            
        }
        
        public init(_ other: Int40) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
            self.d = other.d
            
            self.e = other.e
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = Int40.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: UInt40) {
            precondition(Int40.bitWidth == UInt40.bitWidth, "BitWidth of Int40 and UInt40 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: Int40) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: Int40) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<Int40>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
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
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> Int40 {
            
                if self.isZero { return Int40.zero }
                else if self.mostSignificantByte.hasMinusBit { return Int40.minusOne }
                else { return Int40.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = Int40.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: Int40) -> (partialValue: Int40, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: Int40.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int40 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int40.self, capacity: 1) {
                    return Int40($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = Int(self).addingReportingOverflow(Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int40.max) ||
               r.partialValue < Int(Int40.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int40(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: Int40) -> (partialValue: Int40, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: Int40.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int40 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int40.self, capacity: 1) {
                    return Int40($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && Int40.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = Int(self).subtractingReportingOverflow(Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int40.max) ||
               r.partialValue < Int(Int40.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int40(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: Int40) -> (high: Int40, low: UInt40) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: Int40.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt40.self, capacity: 1) {
                    return UInt40(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int40.self, capacity: 1) {
                    return Int40(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = Int(self).multipliedFullWidth(by: Int(other))
            
            let val = r.low
            
            let high = val >> Int40.bitWidth
            let low = val - (high << Int40.bitWidth)
            
            return (high: Int40(high), low: UInt40(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: Int40) -> (partialValue: Int40, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: Int40(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = Int40(truncatingIfNeeded: r.low)
            //let val = Int40(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !Int40.isSigned && r.high == 1 { overflow = true }
            else if Int40.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: Int40.zero, overflow: false) }
            
            let r = Int(self).multipliedReportingOverflow(by: Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int40.max) ||
               r.partialValue < Int(Int40.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int40(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: Int40, low: Magnitude)) -> (quotient: Int40, remainder: Int40) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (dividend.high.iValue << Int40.bitWidth) + Int(dividend.low)
                
                let r = self.iValue.quotientAndRemainder(dividingBy: divisor)
                return (quotient: Int40(r.quotient), remainder: Int40(r.remainder))
                
             
        }
        
        public func dividedReportingOverflow(by rhs: Int40) -> (partialValue: Int40, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: Int40(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue = self.iValue / rhs.iValue
                let hasOverflow = (intValue > Int40.max.iValue || intValue < Int40.min.iValue)
                return (partialValue: Int40(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: Int40.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = Int(self).dividedReportingOverflow(by: Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int40.max) ||
               r.partialValue < Int(Int40.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int40(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int40(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: Int40) -> (partialValue: Int40, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            let isSelfNeg = selfValue.isNegative
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = Int(self).remainderReportingOverflow(dividingBy: Int(rhs))
            return (partialValue: Int40(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: Int40) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                let isNeg = self.isNegative
                if isNeg == other.isNegative {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                } else {
                    if let result = Int(exactly: self.magnitude + other.magnitude) {
                        return isNegative ? result : -result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> Int40 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if  (self.isNegative == n.isNegative) { return (self + Int40(n)) }
            
                return (self.magnitude < n.magnitude) ? Int40(Int(self) + n) : (self + Int40(n))
            
        }
        
        
        public static func == (lhs: Int40, rhs: Int40) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: Int40, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: Int40.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return Int(lhs) == rhs
        }
        
        public static func != (lhs: Int40, rhs: Int40) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: Int40, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: Int40, rhs: Int40) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int40.isSigned)
            return Int(lhs) < Int(rhs)
        }
        public static func < <Other>(lhs: Int40, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int40.isSigned) */
            
            return Int(lhs) < Int(rhs)
        }
        
        public static func > (lhs: Int40, rhs: Int40) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int(lhs) > Int(rhs)
        }
        public static func > <Other>(lhs: Int40, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int(lhs) > rhs
        }
        
        public static func + (lhs: Int40, rhs: Int40) -> Int40 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: Int40, rhs: Int40) -> Int40 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: Int40, rhs: Int40) -> Int40 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: Int40, rhs: Int40) -> Int40 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: Int40, rhs: Int40) -> Int40 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: Int40, rhs: Int40) -> Int40  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int40(lhb)
            
        }
        
        public static func | (lhs: Int40, rhs: Int40) -> Int40  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int40(lhb)
            
        }
        
        public static func ^ (lhs: Int40, rhs: Int40) -> Int40  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int40(lhb)
            
        }
        
        public static func >>(lhs: Int40, rhs: Int40) -> Int40 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int40(bytes)
            
        }
        
        public static func >><Other>(lhs: Int40, rhs: Other) -> Int40 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> Int40(rhs)
        }
        
        public static func << (lhs: Int40, rhs: Int40) -> Int40  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int40(bytes)
        }
        
        public static func <<<Other>(lhs: Int40, rhs: Other) -> Int40 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << Int40(rhs)
        }
        

        public static func += (lhs: inout Int40, rhs: Int40) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout Int40, rhs: Int40) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension Int40: AdditiveArithmetic { }
    #endif
    /// MARK: - Int40 - Codable
    extension Int40: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(Int40.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    


    public struct UInt48: FixedWidthInteger, UnsignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = UInt64
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<UInt48.Words>
          //public typealias SubSequence = Slice<UInt48.Words>

          internal var _value: UInt48

          public init(_ value: UInt48) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (UInt48.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = false
        public static let bitWidth: Int = 48
        
        public static let min: UInt48 = UInt48()
        public static let max: UInt48 = 281474976710655
        
        
        public static let zero: UInt48 = UInt48()
        internal static let one: UInt48 = 1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: UInt48.Words { return UInt48.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: UInt48 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return UInt48(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt48 {
            
                return self
            
        }
        
        public var bigEndian: UInt48 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: UInt48 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c, d, e, f] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c, d, e, f: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
            self.d = 0
            
            self.e = 0
            
            self.f = 0
            
        }
        
        public init(_ other: UInt48) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
            self.d = other.d
            
            self.e = other.e
            
            self.f = other.f
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = UInt48.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: Int48) {
            precondition(UInt48.bitWidth == Int48.bitWidth, "BitWidth of UInt48 and Int48 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: UInt48) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: UInt48) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<UInt48>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
            // Set required specific integer type information
            let isLocalTypeSigned = UInt48.isSigned
            let localBitWidth = UInt48.bitWidth
            let localByteWidth = (localBitWidth / 8)
            let intType = UInt48.self
            
            var mutableSource = source
            
            let size = MemoryLayout<T>.size
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    return Array(UnsafeBufferPointer(start: $0, count: size))
                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> UInt48 {
            
                if self.isZero { return UInt48.zero }
                else { return UInt48.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = UInt48.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: UInt48) -> (partialValue: UInt48, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: UInt48.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt48 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt48.self, capacity: 1) {
                    return UInt48($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt(self).addingReportingOverflow(UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt48.max) ||
               r.partialValue < UInt(UInt48.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt48(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: UInt48) -> (partialValue: UInt48, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: UInt48.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt48 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt48.self, capacity: 1) {
                    return UInt48($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && UInt48.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt(self).subtractingReportingOverflow(UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt48.max) ||
               r.partialValue < UInt(UInt48.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt48(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: UInt48) -> (high: UInt48, low: UInt48) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: UInt48.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt48.self, capacity: 1) {
                    return UInt48(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt48.self, capacity: 1) {
                    return UInt48(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = UInt(self).multipliedFullWidth(by: UInt(other))
            
            let val = r.low
            
            let high = val >> UInt48.bitWidth
            let low = val - (high << UInt48.bitWidth)
            
            return (high: UInt48(high), low: UInt48(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: UInt48) -> (partialValue: UInt48, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: UInt48(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = UInt48(truncatingIfNeeded: r.low)
            //let val = UInt48(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !UInt48.isSigned && r.high == 1 { overflow = true }
            else if UInt48.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: UInt48.zero, overflow: false) }
            
            let r = UInt(self).multipliedReportingOverflow(by: UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt48.max) ||
               r.partialValue < UInt(UInt48.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt48(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: UInt48, low: Magnitude)) -> (quotient: UInt48, remainder: UInt48) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (UInt(dividend.high.iValue) << UInt(UInt48.bitWidth)) + UInt(dividend.low)
                
                let r = UInt(self.iValue).quotientAndRemainder(dividingBy: divisor)
                return (quotient: UInt48(r.quotient), remainder: UInt48(r.remainder))
            
        }
        
        public func dividedReportingOverflow(by rhs: UInt48) -> (partialValue: UInt48, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: UInt48(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue: UInt = UInt(self.iValue) / UInt(rhs.iValue)
                let hasOverflow = (intValue > UInt48.max.iValue || intValue < UInt48.min.iValue)
                return (partialValue: UInt48(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: UInt48.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = UInt(self).dividedReportingOverflow(by: UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt48.max) ||
               r.partialValue < UInt(UInt48.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt48(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: UInt48) -> (partialValue: UInt48, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = UInt(self).remainderReportingOverflow(dividingBy: UInt(rhs))
            return (partialValue: UInt48(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: UInt48) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if self > other {
                    if let result = Int(exactly: self - other) {
                        return -result
                    }
                } else {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> UInt48 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                return (n.isNegative ? (self - UInt48(-n)) : (self + UInt48(n)) )
            
        }
        
        
        public static func == (lhs: UInt48, rhs: UInt48) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: UInt48, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: UInt48.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return UInt(lhs) == rhs
        }
        
        public static func != (lhs: UInt48, rhs: UInt48) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: UInt48, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: UInt48, rhs: UInt48) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt48.isSigned)
            return UInt(lhs) < UInt(rhs)
        }
        public static func < <Other>(lhs: UInt48, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt48.isSigned) */
            
            return UInt(lhs) < UInt(rhs)
        }
        
        public static func > (lhs: UInt48, rhs: UInt48) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt(lhs) > UInt(rhs)
        }
        public static func > <Other>(lhs: UInt48, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt(lhs) > rhs
        }
        
        public static func + (lhs: UInt48, rhs: UInt48) -> UInt48 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: UInt48, rhs: UInt48) -> UInt48 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: UInt48, rhs: UInt48) -> UInt48 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: UInt48, rhs: UInt48) -> UInt48 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: UInt48, rhs: UInt48) -> UInt48 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: UInt48, rhs: UInt48) -> UInt48  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt48(lhb)
            
        }
        
        public static func | (lhs: UInt48, rhs: UInt48) -> UInt48  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt48(lhb)
            
        }
        
        public static func ^ (lhs: UInt48, rhs: UInt48) -> UInt48  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt48(lhb)
            
        }
        
        public static func >>(lhs: UInt48, rhs: UInt48) -> UInt48 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt48(bytes)
            
        }
        
        public static func >><Other>(lhs: UInt48, rhs: Other) -> UInt48 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> UInt48(rhs)
        }
        
        public static func << (lhs: UInt48, rhs: UInt48) -> UInt48  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt48(bytes)
        }
        
        public static func <<<Other>(lhs: UInt48, rhs: Other) -> UInt48 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << UInt48(rhs)
        }
        

        public static func += (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout UInt48, rhs: UInt48) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension UInt48: AdditiveArithmetic { }
    #endif
    /// MARK: - UInt48 - Codable
    extension UInt48: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(UInt48.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    
    public struct Int48: FixedWidthInteger, SignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = Int64
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<Int48.Words>
          //public typealias SubSequence = Slice<Int48.Words>

          internal var _value: Int48

          public init(_ value: Int48) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (Int48.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = true
        public static let bitWidth: Int = 48
        
        public static let min: Int48 = -140737488355328
        public static let max: Int48 = 140737488355327
        
        
        public static let zero: Int48 = Int48()
        internal static let one: Int48 = 1
        
        internal static let minusOne: Int48 = -1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: Int48.Words { return Int48.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: Int48 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return Int48(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt48 {
            
                if self.isZero { return UInt48() }
                else if self.mostSignificantByte.hasMinusBit {
                
                var bytes = self.bytes
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                bytes = IntLogic.twosComplement(bytes)
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                return UInt48(bytes)
                
                } else { return UInt48(bitPattern: self) }
            
        }
        
        public var bigEndian: Int48 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: Int48 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c, d, e, f] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c, d, e, f: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
            self.d = 0
            
            self.e = 0
            
            self.f = 0
            
        }
        
        public init(_ other: Int48) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
            self.d = other.d
            
            self.e = other.e
            
            self.f = other.f
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = Int48.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: UInt48) {
            precondition(Int48.bitWidth == UInt48.bitWidth, "BitWidth of Int48 and UInt48 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: Int48) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: Int48) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<Int48>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
            // Set required specific integer type information
            let isLocalTypeSigned = Int48.isSigned
            let localBitWidth = Int48.bitWidth
            let localByteWidth = (localBitWidth / 8)
            let intType = Int48.self
            
            var mutableSource = source
            
            let size = MemoryLayout<T>.size
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    return Array(UnsafeBufferPointer(start: $0, count: size))
                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> Int48 {
            
                if self.isZero { return Int48.zero }
                else if self.mostSignificantByte.hasMinusBit { return Int48.minusOne }
                else { return Int48.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = Int48.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: Int48) -> (partialValue: Int48, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: Int48.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int48 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int48.self, capacity: 1) {
                    return Int48($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = Int(self).addingReportingOverflow(Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int48.max) ||
               r.partialValue < Int(Int48.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int48(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: Int48) -> (partialValue: Int48, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: Int48.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int48 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int48.self, capacity: 1) {
                    return Int48($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && Int48.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = Int(self).subtractingReportingOverflow(Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int48.max) ||
               r.partialValue < Int(Int48.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int48(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: Int48) -> (high: Int48, low: UInt48) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: Int48.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt48.self, capacity: 1) {
                    return UInt48(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int48.self, capacity: 1) {
                    return Int48(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = Int(self).multipliedFullWidth(by: Int(other))
            
            let val = r.low
            
            let high = val >> Int48.bitWidth
            let low = val - (high << Int48.bitWidth)
            
            return (high: Int48(high), low: UInt48(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: Int48) -> (partialValue: Int48, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: Int48(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = Int48(truncatingIfNeeded: r.low)
            //let val = Int48(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !Int48.isSigned && r.high == 1 { overflow = true }
            else if Int48.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: Int48.zero, overflow: false) }
            
            let r = Int(self).multipliedReportingOverflow(by: Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int48.max) ||
               r.partialValue < Int(Int48.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int48(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: Int48, low: Magnitude)) -> (quotient: Int48, remainder: Int48) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (dividend.high.iValue << Int48.bitWidth) + Int(dividend.low)
                
                let r = self.iValue.quotientAndRemainder(dividingBy: divisor)
                return (quotient: Int48(r.quotient), remainder: Int48(r.remainder))
                
             
        }
        
        public func dividedReportingOverflow(by rhs: Int48) -> (partialValue: Int48, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: Int48(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue = self.iValue / rhs.iValue
                let hasOverflow = (intValue > Int48.max.iValue || intValue < Int48.min.iValue)
                return (partialValue: Int48(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: Int48.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = Int(self).dividedReportingOverflow(by: Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int48.max) ||
               r.partialValue < Int(Int48.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int48(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int48(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: Int48) -> (partialValue: Int48, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            let isSelfNeg = selfValue.isNegative
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = Int(self).remainderReportingOverflow(dividingBy: Int(rhs))
            return (partialValue: Int48(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: Int48) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                let isNeg = self.isNegative
                if isNeg == other.isNegative {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                } else {
                    if let result = Int(exactly: self.magnitude + other.magnitude) {
                        return isNegative ? result : -result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> Int48 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if  (self.isNegative == n.isNegative) { return (self + Int48(n)) }
            
                return (self.magnitude < n.magnitude) ? Int48(Int(self) + n) : (self + Int48(n))
            
        }
        
        
        public static func == (lhs: Int48, rhs: Int48) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: Int48, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: Int48.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return Int(lhs) == rhs
        }
        
        public static func != (lhs: Int48, rhs: Int48) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: Int48, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: Int48, rhs: Int48) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int48.isSigned)
            return Int(lhs) < Int(rhs)
        }
        public static func < <Other>(lhs: Int48, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int48.isSigned) */
            
            return Int(lhs) < Int(rhs)
        }
        
        public static func > (lhs: Int48, rhs: Int48) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int(lhs) > Int(rhs)
        }
        public static func > <Other>(lhs: Int48, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int(lhs) > rhs
        }
        
        public static func + (lhs: Int48, rhs: Int48) -> Int48 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: Int48, rhs: Int48) -> Int48 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: Int48, rhs: Int48) -> Int48 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: Int48, rhs: Int48) -> Int48 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: Int48, rhs: Int48) -> Int48 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: Int48, rhs: Int48) -> Int48  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int48(lhb)
            
        }
        
        public static func | (lhs: Int48, rhs: Int48) -> Int48  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int48(lhb)
            
        }
        
        public static func ^ (lhs: Int48, rhs: Int48) -> Int48  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int48(lhb)
            
        }
        
        public static func >>(lhs: Int48, rhs: Int48) -> Int48 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int48(bytes)
            
        }
        
        public static func >><Other>(lhs: Int48, rhs: Other) -> Int48 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> Int48(rhs)
        }
        
        public static func << (lhs: Int48, rhs: Int48) -> Int48  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int48(bytes)
        }
        
        public static func <<<Other>(lhs: Int48, rhs: Other) -> Int48 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << Int48(rhs)
        }
        

        public static func += (lhs: inout Int48, rhs: Int48) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout Int48, rhs: Int48) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension Int48: AdditiveArithmetic { }
    #endif
    /// MARK: - Int48 - Codable
    extension Int48: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(Int48.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    


    public struct UInt56: FixedWidthInteger, UnsignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = UInt64
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<UInt56.Words>
          //public typealias SubSequence = Slice<UInt56.Words>

          internal var _value: UInt56

          public init(_ value: UInt56) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (UInt56.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = false
        public static let bitWidth: Int = 56
        
        public static let min: UInt56 = UInt56()
        public static let max: UInt56 = 72057594037927935
        
        
        public static let zero: UInt56 = UInt56()
        internal static let one: UInt56 = 1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: UInt56.Words { return UInt56.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: UInt56 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return UInt56(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt56 {
            
                return self
            
        }
        
        public var bigEndian: UInt56 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: UInt56 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c, d, e, f, g] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c, d, e, f, g: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
            self.d = 0
            
            self.e = 0
            
            self.f = 0
            
            self.g = 0
            
        }
        
        public init(_ other: UInt56) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
            self.d = other.d
            
            self.e = other.e
            
            self.f = other.f
            
            self.g = other.g
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = UInt56.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: Int56) {
            precondition(UInt56.bitWidth == Int56.bitWidth, "BitWidth of UInt56 and Int56 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: UInt56) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: UInt56) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<UInt56>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
            // Set required specific integer type information
            let isLocalTypeSigned = UInt56.isSigned
            let localBitWidth = UInt56.bitWidth
            let localByteWidth = (localBitWidth / 8)
            let intType = UInt56.self
            
            var mutableSource = source
            
            let size = MemoryLayout<T>.size
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    return Array(UnsafeBufferPointer(start: $0, count: size))
                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> UInt56 {
            
                if self.isZero { return UInt56.zero }
                else { return UInt56.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = UInt56.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: UInt56) -> (partialValue: UInt56, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: UInt56.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt56 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt56.self, capacity: 1) {
                    return UInt56($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt(self).addingReportingOverflow(UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt56.max) ||
               r.partialValue < UInt(UInt56.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt56(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: UInt56) -> (partialValue: UInt56, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: UInt56.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: UInt56 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt56.self, capacity: 1) {
                    return UInt56($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && UInt56.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = UInt(self).subtractingReportingOverflow(UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt56.max) ||
               r.partialValue < UInt(UInt56.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt56(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: UInt56) -> (high: UInt56, low: UInt56) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: UInt56.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt56.self, capacity: 1) {
                    return UInt56(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt56.self, capacity: 1) {
                    return UInt56(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = UInt(self).multipliedFullWidth(by: UInt(other))
            
            let val = r.low
            
            let high = val >> UInt56.bitWidth
            let low = val - (high << UInt56.bitWidth)
            
            return (high: UInt56(high), low: UInt56(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: UInt56) -> (partialValue: UInt56, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: UInt56(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = UInt56(truncatingIfNeeded: r.low)
            //let val = UInt56(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !UInt56.isSigned && r.high == 1 { overflow = true }
            else if UInt56.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: UInt56.zero, overflow: false) }
            
            let r = UInt(self).multipliedReportingOverflow(by: UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt56.max) ||
               r.partialValue < UInt(UInt56.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt56(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: UInt56, low: Magnitude)) -> (quotient: UInt56, remainder: UInt56) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (UInt(dividend.high.iValue) << UInt(UInt56.bitWidth)) + UInt(dividend.low)
                
                let r = UInt(self.iValue).quotientAndRemainder(dividingBy: divisor)
                return (quotient: UInt56(r.quotient), remainder: UInt56(r.remainder))
            
        }
        
        public func dividedReportingOverflow(by rhs: UInt56) -> (partialValue: UInt56, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: UInt56(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue: UInt = UInt(self.iValue) / UInt(rhs.iValue)
                let hasOverflow = (intValue > UInt56.max.iValue || intValue < UInt56.min.iValue)
                return (partialValue: UInt56(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: UInt56.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = UInt(self).dividedReportingOverflow(by: UInt(rhs))
            
            if r.overflow ||
               r.partialValue > UInt(UInt56.max) ||
               r.partialValue < UInt(UInt56.min) {
                // Overflows over the bounds of our int
                return (partialValue: UInt56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: UInt56(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: UInt56) -> (partialValue: UInt56, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = UInt(self).remainderReportingOverflow(dividingBy: UInt(rhs))
            return (partialValue: UInt56(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: UInt56) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if self > other {
                    if let result = Int(exactly: self - other) {
                        return -result
                    }
                } else {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> UInt56 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                return (n.isNegative ? (self - UInt56(-n)) : (self + UInt56(n)) )
            
        }
        
        
        public static func == (lhs: UInt56, rhs: UInt56) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: UInt56, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: UInt56.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return UInt(lhs) == rhs
        }
        
        public static func != (lhs: UInt56, rhs: UInt56) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: UInt56, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: UInt56, rhs: UInt56) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt56.isSigned)
            return UInt(lhs) < UInt(rhs)
        }
        public static func < <Other>(lhs: UInt56, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: UInt56.isSigned) */
            
            return UInt(lhs) < UInt(rhs)
        }
        
        public static func > (lhs: UInt56, rhs: UInt56) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt(lhs) > UInt(rhs)
        }
        public static func > <Other>(lhs: UInt56, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return UInt(lhs) > rhs
        }
        
        public static func + (lhs: UInt56, rhs: UInt56) -> UInt56 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: UInt56, rhs: UInt56) -> UInt56 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: UInt56, rhs: UInt56) -> UInt56 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: UInt56, rhs: UInt56) -> UInt56 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: UInt56, rhs: UInt56) -> UInt56 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: UInt56, rhs: UInt56) -> UInt56  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt56(lhb)
            
        }
        
        public static func | (lhs: UInt56, rhs: UInt56) -> UInt56  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt56(lhb)
            
        }
        
        public static func ^ (lhs: UInt56, rhs: UInt56) -> UInt56  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return UInt56(lhb)
            
        }
        
        public static func >>(lhs: UInt56, rhs: UInt56) -> UInt56 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt56(bytes)
            
        }
        
        public static func >><Other>(lhs: UInt56, rhs: Other) -> UInt56 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> UInt56(rhs)
        }
        
        public static func << (lhs: UInt56, rhs: UInt56) -> UInt56  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return UInt56(bytes)
        }
        
        public static func <<<Other>(lhs: UInt56, rhs: Other) -> UInt56 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << UInt56(rhs)
        }
        

        public static func += (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout UInt56, rhs: UInt56) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension UInt56: AdditiveArithmetic { }
    #endif
    /// MARK: - UInt56 - Codable
    extension UInt56: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(UInt56.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    
    public struct Int56: FixedWidthInteger, SignedInteger, CustomReflectable {
    
        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = Int64
        
        public struct Words: RandomAccessCollection {
          public typealias Index = Int
          public typealias Element = UInt
          //public typealias Indices = DefaultIndices<Int56.Words>
          //public typealias SubSequence = Slice<Int56.Words>

          internal var _value: Int56

          public init(_ value: Int56) {
            self._value = value
          }

          public let count: Int = 1

          public var startIndex: Int = 0

          public var endIndex: Int { return count }

          //public var indices: Indices { return startIndex ..< endIndex }

          @_transparent
          public func index(after i: Int) -> Int { return i + 1 }

          @_transparent
          public func index(before i: Int) -> Int { return i - 1 }

          public subscript(position: Int) -> UInt {
            guard position == startIndex else { fatalError("Index out of bounds") }
            
            var mutableSource = _value
            let size = MemoryLayout.size(ofValue: mutableSource)
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: size)
                    return Array<UInt8>(buffer)

                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNeg = (Int56.isSigned && bytes[0].hasMinusBit )
            bytes = IntLogic.paddBinaryInteger(bytes, newSizeInBytes: (UInt.bitWidth / 8), isNegative: isNeg)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt.self, capacity: 1) {
                    return UInt($0.pointee)
                }
            }
          }
        }
    
        public static let isSigned: Bool = true
        public static let bitWidth: Int = 56
        
        public static let min: Int56 = -36028797018963968
        public static let max: Int56 = 36028797018963967
        
        
        public static let zero: Int56 = Int56()
        internal static let one: Int56 = 1
        
        internal static let minusOne: Int56 = -1
        
        
        /// Creates custom mirror to hide all details about ourselves
        public var customMirror: Mirror { return Mirror(self, children: EmptyCollection()) }
        
        public var words: Int56.Words { return Int56.Words(self) }
        
        /// Returns a count of all non zero bits in the number
        public var nonzeroBitCount: Int {
            return useUnsafeBufferPointer {
                var rtn: Int = 0
                for b in $0 {
                    for i in (0..<8) {
                        let mask = UInt8(1 << i)
                        if ((b & mask) == mask) { rtn += 1}
                    }
                }
                return rtn
            }
        }
        
        /// Returns a new instances of this number type with our byts reversed
        public var byteSwapped: Int56 {
            
            return useUnsafeBufferPointer {
                var bytes = Array<UInt8>($0)
                bytes.reverse()
                return Int56(bytes)
            }
            
        }
        
        /// Returns the number of leading zeros in this number.  If the number is negative this will return 0
        public var leadingZeroBitCount: Int {
            
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if !IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        /// Returns the number of trailing zeros in this number
        public var trailingZeroBitCount: Int {
            return useUnsafeBufferPointer {
                var range = Array<Int>(0..<$0.count)
                if IntLogic.IS_BIGENDIAN { range = range.reversed() }
                var foundBit: Bool = false
                var rtn: Int = 0
                for i in range where !foundBit {
                    for x in (0..<8).reversed() where !foundBit {
                        let mask = UInt8(1 << x)
                        foundBit = (($0[i] & mask) == mask)
                        if !foundBit { rtn += 1 }
                    }
                }
                return rtn
            }
        }
        
        public var magnitude: UInt56 {
            
                if self.isZero { return UInt56() }
                else if self.mostSignificantByte.hasMinusBit {
                
                var bytes = self.bytes
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                bytes = IntLogic.twosComplement(bytes)
                if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
                return UInt56(bytes)
                
                } else { return UInt56(bitPattern: self) }
            
        }
        
        public var bigEndian: Int56 {
            if IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        public var littleEndian: Int56 {
            if !IntLogic.IS_BIGENDIAN { return self }
            else { return self.byteSwapped }
        }
        
        internal var bytes: [UInt8] { return [a, b, c, d, e, f, g] }
        
        /// Internal property used in basic operations
        fileprivate var iValue: Int {
            /*guard !self.isZero else { return 0 }
            
            var bytes = self.bigEndian.bytes
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: (Int.bitWidth / 8), isNegative: self.isNegative)
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let rtn: Int = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int.self, capacity: 1) {
                    return Int($0.pointee)
                }
            }
            
            return rtn*/
            return Int(self)
        }
        
        #if !swift(>=4.0.9)
        public var hashValue: Int { return self.iValue.hashValue }
        #endif
        
        private var a, b, c, d, e, f, g: UInt8
        
        public init() {
            
            self.a = 0
            
            self.b = 0
            
            self.c = 0
            
            self.d = 0
            
            self.e = 0
            
            self.f = 0
            
            self.g = 0
            
        }
        
        public init(_ other: Int56) {
            
            self.a = other.a
            
            self.b = other.b
            
            self.c = other.c
            
            self.d = other.d
            
            self.e = other.e
            
            self.f = other.f
            
            self.g = other.g
            
        }
        
        fileprivate init(_ bytes: [UInt8]) {
            let intByteSize: Int = Int56.bitWidth / 8
            precondition(bytes.count == intByteSize, "Byte size missmatch. Expected \(intByteSize), recieved \(bytes.count)")
            self.init()
        
            // Copy bytes into self
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
            
        }
        
        /// Creates a new instance with the same memory representation as the given
        /// value.
        ///
        /// This initializer does not perform any range or overflow checking. The
        /// resulting instance may not have the same numeric value as
        /// `bitPattern`---it is only guaranteed to use the same pattern of bits in
        /// its binary representation.
        ///
        /// - Parameter x: A value to use as the source of the new instance's binary
        ///   representation.
        public init(bitPattern other: UInt56) {
            precondition(Int56.bitWidth == UInt56.bitWidth, "BitWidth of Int56 and UInt56 do not match")
            
            self.init(other.bytes)
        }
        
        public init(bigEndian value: Int56) {
            var bytes = value.bytes
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        
        public init(littleEndian value: Int56) {
            var bytes = value.bytes
            if IntLogic.IS_BIGENDIAN { bytes.reverse() }
            self.init(bytes)
        }
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        public init(_truncatingBits truncatingBits: UInt) {
            let typeSize: Int = MemoryLayout<Int56>.size
            var bytes: [UInt8] =  truncatingBits.bytes
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            while bytes.count > typeSize { bytes.remove(at: 0) }
            
            if !IntLogic.IS_BIGENDIAN { bytes = bytes.reversed() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryInteger {
            
            // Set required specific integer type information
            let isLocalTypeSigned = Int56.isSigned
            let localBitWidth = Int56.bitWidth
            let localByteWidth = (localBitWidth / 8)
            let intType = Int56.self
            
            var mutableSource = source
            
            let size = MemoryLayout<T>.size
            var bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
                return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                    return Array(UnsafeBufferPointer(start: $0, count: size))
                }
            }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            let isNegative = (T.isSigned && bytes[0].hasMinusBit)
            
            if !isLocalTypeSigned && T.isSigned && isNegative {
                fatalError("\(source) is not representable as a '\(intType)' instance")
            } else if isLocalTypeSigned && !T.isSigned && isNegative && bytes.count >= localByteWidth {
                fatalError("Not enough bits to represent a signed value")
            }
            
            bytes = IntLogic.resizeBinaryInteger(bytes, newSizeInBytes: localByteWidth, isNegative: (isNegative && T.isSigned))
            
            guard bytes.count == localByteWidth else { fatalError("Not enough bits to represent a signed value") }
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            self.init(bytes)
        }
        
        public init<T>(_ source: T) where T : BinaryFloatingPoint {
            let int: Int = Int(source)
            self.init(int)
        }
        #if swift(>=4.2)
        //public func hash(into hasher: inout Hasher) {
        //    self.iValue.hash(into: &hasher)
        //}
        #endif
        
        public func signum() -> Int56 {
            
                if self.isZero { return Int56.zero }
                else if self.mostSignificantByte.hasMinusBit { return Int56.minusOne }
                else { return Int56.one }
            
            
        }
        
        fileprivate mutating func invert() {
            let intByteSize: Int = Int56.bitWidth / 8
            var bytes = self.bytes
            bytes = IntLogic.twosComplement(bytes)
            withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: UInt8.self, capacity: intByteSize) {
                    let buffer = UnsafeMutableBufferPointer(start: $0, count: intByteSize)
                    
                    for i in 0..<buffer.count {
                        buffer[i] = bytes[i]
                    }
                }
            }
        }
        
        public func addingReportingOverflow(_ rhs: Int56) -> (partialValue: Int56, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            guard !self.isZero else { return (partialValue: rhs, overflow: false)  }
            
            let r = IntLogic.binaryAddition(self.bigEndian.bytes,
                                            rhs.bigEndian.bytes,
                                            isSigned: Int56.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int56 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int56.self, capacity: 1) {
                    return Int56($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !self.isZero else { return (partialValue: rhs, overflow: false) }
            
            let r = Int(self).addingReportingOverflow(Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int56.max) ||
               r.partialValue < Int(Int56.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int56(r.partialValue), overflow: false)
            
        }
        
        public func subtractingReportingOverflow(_ rhs: Int56) -> (partialValue: Int56, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: false)  }
            
            let r = IntLogic.binarySubtraction(self.bigEndian.bytes,
                                               rhs.bigEndian.bytes,
                                               isSigned: Int56.isSigned)
            
            var bytes = r.partial
            
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            let value: Int56 = bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int56.self, capacity: 1) {
                    return Int56($0.pointee)
                }
            }
            return (partialValue: value, overflow: r.overflow)*/
            
            guard !rhs.isZero else { return (partialValue: self, overflow: false) }
            guard !(self.isZero && Int56.isSigned) else { return (partialValue: rhs, overflow: false) }
            
            let r = Int(self).subtractingReportingOverflow(Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int56.max) ||
               r.partialValue < Int(Int56.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int56(r.partialValue), overflow: false)
            
        }
        
        public func multipliedFullWidth(by other: Int56) -> (high: Int56, low: UInt56) {
            /*let r = IntLogic.binaryMultiplication(self.bigEndian.bytes,
                                                  other.bigEndian.bytes,
                                                  isSigned: Int56.isSigned)
            
            let low = r.low.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: UInt56.self, capacity: 1) {
                    return UInt56(bigEndian: $0.pointee)
                }
            }
            
            let high = r.high.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Int56.self, capacity: 1) {
                    return Int56(bigEndian: $0.pointee)
                }
            }
            
            return (high: high, low: low)*/
            
            
            let r = Int(self).multipliedFullWidth(by: Int(other))
            
            let val = r.low
            
            let high = val >> Int56.bitWidth
            let low = val - (high << Int56.bitWidth)
            
            return (high: Int56(high), low: UInt56(low))
            
        }
        
        public func multipliedReportingOverflow(by rhs: Int56) -> (partialValue: Int56, overflow: Bool) {
            /*guard !self.isZero && !rhs.isZero else { return (partialValue: Int56(), overflow: false)  }
            
            let r = self.multipliedFullWidth(by: rhs)
            let val = Int56(truncatingIfNeeded: r.low)
            //let val = Int56(bitPattern: r.low)
            var overflow: Bool = false
            if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
            else if !Int56.isSigned && r.high == 1 { overflow = true }
            else if Int56.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
                overflow = true
            } else {
                if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
            }
            
            return (partialValue: val, overflow: overflow)*/
            
            guard !self.isZero && !rhs.isZero else { return (partialValue: Int56.zero, overflow: false) }
            
            let r = Int(self).multipliedReportingOverflow(by: Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int56.max) ||
               r.partialValue < Int(Int56.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int56(r.partialValue), overflow: false)
            
        }
        
        public func dividingFullWidth(_ dividend: (high: Int56, low: Magnitude)) -> (quotient: Int56, remainder: Int56) {
            // We are cheating here.  Instead of using our own code.  we are casting as base Int type
            
             
                let divisor = (dividend.high.iValue << Int56.bitWidth) + Int(dividend.low)
                
                let r = self.iValue.quotientAndRemainder(dividingBy: divisor)
                return (quotient: Int56(r.quotient), remainder: Int56(r.remainder))
                
             
        }
        
        public func dividedReportingOverflow(by rhs: Int56) -> (partialValue: Int56, overflow: Bool) {
            /*// We are cheating here.  Instead of using our own code.  we are casting as base Int type
            guard !self.isZero else { return (partialValue: Int56(), overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
            
            
                let intValue = self.iValue / rhs.iValue
                let hasOverflow = (intValue > Int56.max.iValue || intValue < Int56.min.iValue)
                return (partialValue: Int56(truncatingIfNeeded: intValue), overflow: hasOverflow)
            */
            
            guard !self.isZero else { return (partialValue: Int56.zero, overflow: false)  }
            guard !rhs.isZero else { return (partialValue: self, overflow: true) }
            
            let r = Int(self).dividedReportingOverflow(by: Int(rhs))
            
            if r.overflow ||
               r.partialValue > Int(Int56.max) ||
               r.partialValue < Int(Int56.min) {
                // Overflows over the bounds of our int
                return (partialValue: Int56(truncatingIfNeeded: r.partialValue), overflow: true)
            }
            
            return (partialValue: Int56(r.partialValue), overflow: false)
            
        }
    
        public func remainderReportingOverflow(dividingBy rhs: Int56) -> (partialValue: Int56, overflow: Bool) {
            /*guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            var selfValue = self
            let rhsValue = rhs
            
            
            let isSelfNeg = selfValue.isNegative
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            while selfValue >= rhsValue {
                //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
                selfValue = selfValue - rhsValue
            }
            
            if isSelfNeg { selfValue = selfValue * -1  }
            
            
            return (partialValue: selfValue, overflow: false)*/
            
            
            guard !rhs.isZero else { return (partialValue: self, overflow: true)  }
            
            let r = Int(self).remainderReportingOverflow(dividingBy: Int(rhs))
            return (partialValue: Int56(r.partialValue), overflow: r.overflow)
        }
        
        public func distance(to other: Int56) -> Int {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                let isNeg = self.isNegative
                if isNeg == other.isNegative {
                    if let result = Int(exactly: other - self) {
                        return result
                    }
                } else {
                    if let result = Int(exactly: self.magnitude + other.magnitude) {
                        return isNegative ? result : -result
                    }
                }
            
            preconditionFailure("Distance is not representable in Int")
            //_preconditionFailure("Distance is not representable in Int")
        }
        
        public func advanced(by n: Int) -> Int56 {
            //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
            
                if  (self.isNegative == n.isNegative) { return (self + Int56(n)) }
            
                return (self.magnitude < n.magnitude) ? Int56(Int(self) + n) : (self + Int56(n))
            
        }
        
        
        public static func == (lhs: Int56, rhs: Int56) -> Bool {
            return lhs.bytes == rhs.bytes
        }
        public static func == <Other>(lhs: Int56, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // If the two numbers don't have the same sign, we will return false right away
            guard (lhs.isNegative == rhs.isNegative) else { return false }
            
            //Get raw binary integers and reduce to smalles representation
            // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
            // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
            // matter what integer types we are comparing
            let lhb = IntLogic.minimizeBinaryInteger(lhs.bigEndian.bytes, isSigned: Int56.isSigned)
            let rhb = IntLogic.minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
            
            
            return (lhb == rhb)*/
            
            return Int(lhs) == rhs
        }
        
        public static func != (lhs: Int56, rhs: Int56) -> Bool {
            return !(lhs == rhs)
        }
        public static func != <Other>(lhs: Int56, rhs: Other) -> Bool where Other : BinaryInteger {
            return !(lhs == rhs)
        }
        
        public static func < (lhs: Int56, rhs: Int56) -> Bool {
            //return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int56.isSigned)
            return Int(lhs) < Int(rhs)
        }
        public static func < <Other>(lhs: Int56, rhs: Other) -> Bool where Other : BinaryInteger {
            /*
            // -A < B ?
            if lhs.isNegative && !rhs.isNegative { return true }
            // A < -B
            if !lhs.isNegative && rhs.isNegative { return false }
            
            // We don't care about the signed flag on the rhs type because
            // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
            return IntLogic.binaryIsLessThan(lhs.bigEndian.bytes, rhs.bigEndianBytes, isSigned: Int56.isSigned) */
            
            return Int(lhs) < Int(rhs)
        }
        
        public static func > (lhs: Int56, rhs: Int56) -> Bool {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int(lhs) > Int(rhs)
        }
        public static func > <Other>(lhs: Int56, rhs: Other) -> Bool where Other : BinaryInteger {
            //return ((lhs != rhs) && !(lhs < rhs))
            return Int(lhs) > rhs
        }
        
        public static func + (lhs: Int56, rhs: Int56) -> Int56 {
             let r = lhs.addingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func - (lhs: Int56, rhs: Int56) -> Int56 {
            let r = lhs.subtractingReportingOverflow(rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func * (lhs: Int56, rhs: Int56) -> Int56 {
            let r = lhs.multipliedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func / (lhs: Int56, rhs: Int56) -> Int56 {
            let r = lhs.dividedReportingOverflow(by: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func % (lhs: Int56, rhs: Int56) -> Int56 {
            let r = lhs.remainderReportingOverflow(dividingBy: rhs)
            guard !r.overflow else { fatalError("Overflow") }
            return r.partialValue
        }
        
        public static func & (lhs: Int56, rhs: Int56) -> Int56  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] & rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int56(lhb)
            
        }
        
        public static func | (lhs: Int56, rhs: Int56) -> Int56  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] | rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int56(lhb)
            
        }
        
        public static func ^ (lhs: Int56, rhs: Int56) -> Int56  {
            var lhb = lhs.bigEndianBytes
            let rhb = rhs.bigEndianBytes
            for i in 0..<lhb.count {
                lhb[i] = lhb[i] ^ rhb[i]
            }
            
            if !IntLogic.IS_BIGENDIAN { lhb.reverse() }
            
            return Int56(lhb)
            
        }
        
        public static func >>(lhs: Int56, rhs: Int56) -> Int56 {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftRight(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int56(bytes)
            
        }
        
        public static func >><Other>(lhs: Int56, rhs: Other) -> Int56 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs >> Int56(rhs)
        }
        
        public static func << (lhs: Int56, rhs: Int56) -> Int56  {
            guard !rhs.isZero else { return lhs }
            var bytes = IntLogic.bitShiftLeft(lhs.bigEndian.bytes, count: Int(rhs), isNegative: lhs.isNegative)
            if !IntLogic.IS_BIGENDIAN { bytes.reverse() }
            
            return Int56(bytes)
        }
        
        public static func <<<Other>(lhs: Int56, rhs: Other) -> Int56 where Other : BinaryInteger {
            guard !rhs.isZero else { return lhs }
            return lhs << Int56(rhs)
        }
        

        public static func += (lhs: inout Int56, rhs: Int56) {
            lhs = lhs + rhs
        }

        public static func -= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs - rhs
        }

        public static func *= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs * rhs
        }

        public static func /= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs / rhs
        }

        public static func %= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs % rhs
        }

        public static func |= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs | rhs
        }

        public static func &= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs & rhs
        }

        public static func ^= (lhs: inout Int56, rhs: Int56) {
            lhs = lhs ^ rhs
        }


    }
    
    #if !swift(>=5.0)
    extension Int56: AdditiveArithmetic { }
    #endif
    /// MARK: - Int56 - Codable
    extension Int56: Codable {
        public init(from decoder: Decoder) throws {
            var container = try decoder.singleValueContainer()
            self = try container.decode(Int56.self)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
    }
    
    



public extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: UInt24.Type) throws -> UInt24 {
        let value = try self.decode(UInt32.self)
        return UInt24(value)
    }
    
    mutating func decode(_ type: Int24.Type) throws -> Int24 {
        let value = try self.decode(Int32.self)
        return Int24(value)
    }
    
    mutating func decode(_ type: UInt40.Type) throws -> UInt40 {
        let value = try self.decode(UInt.self)
        return UInt40(value)
    }
    
    mutating func decode(_ type: Int40.Type) throws -> Int40 {
        let value = try self.decode(Int.self)
        return Int40(value)
    }
    
    mutating func decode(_ type: UInt48.Type) throws -> UInt48 {
        let value = try self.decode(UInt.self)
        return UInt48(value)
    }
    
    mutating func decode(_ type: Int48.Type) throws -> Int48 {
        let value = try self.decode(Int.self)
        return Int48(value)
    }
    
    mutating func decode(_ type: UInt56.Type) throws -> UInt56 {
        let value = try self.decode(UInt.self)
        return UInt56(value)
    }
    
    mutating func decode(_ type: Int56.Type) throws -> Int56 {
        let value = try self.decode(Int.self)
        return Int56(value)
    }
    
}

public extension SingleValueDecodingContainer {
    
    mutating func decode(_ type: UInt24.Type) throws -> UInt24 {
        let value = try self.decode(UInt32.self)
        return UInt24(value)
    }
    
    mutating func decode(_ type: Int24.Type) throws -> Int24 {
        let value = try self.decode(Int32.self)
        return Int24(value)
    }
    
    mutating func decode(_ type: UInt40.Type) throws -> UInt40 {
        let value = try self.decode(UInt.self)
        return UInt40(value)
    }
    
    mutating func decode(_ type: Int40.Type) throws -> Int40 {
        let value = try self.decode(Int.self)
        return Int40(value)
    }
    
    mutating func decode(_ type: UInt48.Type) throws -> UInt48 {
        let value = try self.decode(UInt.self)
        return UInt48(value)
    }
    
    mutating func decode(_ type: Int48.Type) throws -> Int48 {
        let value = try self.decode(Int.self)
        return Int48(value)
    }
    
    mutating func decode(_ type: UInt56.Type) throws -> UInt56 {
        let value = try self.decode(UInt.self)
        return UInt56(value)
    }
    
    mutating func decode(_ type: Int56.Type) throws -> Int56 {
        let value = try self.decode(Int.self)
        return Int56(value)
    }
    
}

public extension KeyedDecodingContainer {
    
    mutating func decode(_ type: UInt24.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt24 {
        let value = try self.decode(UInt32.self, forKey: key)
        return UInt24(value)
    }
    
    mutating func decode(_ type: Int24.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int24 {
        let value = try self.decode(Int32.self, forKey: key)
        return Int24(value)
    }
    
    mutating func decode(_ type: UInt40.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt40 {
        let value = try self.decode(UInt.self, forKey: key)
        return UInt40(value)
    }
    
    mutating func decode(_ type: Int40.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int40 {
        let value = try self.decode(Int.self, forKey: key)
        return Int40(value)
    }
    
    mutating func decode(_ type: UInt48.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt48 {
        let value = try self.decode(UInt.self, forKey: key)
        return UInt48(value)
    }
    
    mutating func decode(_ type: Int48.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int48 {
        let value = try self.decode(Int.self, forKey: key)
        return Int48(value)
    }
    
    mutating func decode(_ type: UInt56.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt56 {
        let value = try self.decode(UInt.self, forKey: key)
        return UInt56(value)
    }
    
    mutating func decode(_ type: Int56.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int56 {
        let value = try self.decode(Int.self, forKey: key)
        return Int56(value)
    }
    
}

public extension UnkeyedEncodingContainer {
    
    mutating func encode(_ value: UInt24) throws {
        try self.encode(UInt32(value))
    }
    
    mutating func encode(_ value: Int24) throws {
        try self.encode(Int32(value))
    }
    
    mutating func encode(_ value: UInt40) throws {
        try self.encode(UInt(value))
    }
    
    mutating func encode(_ value: Int40) throws {
        try self.encode(Int(value))
    }
    
    mutating func encode(_ value: UInt48) throws {
        try self.encode(UInt(value))
    }
    
    mutating func encode(_ value: Int48) throws {
        try self.encode(Int(value))
    }
    
    mutating func encode(_ value: UInt56) throws {
        try self.encode(UInt(value))
    }
    
    mutating func encode(_ value: Int56) throws {
        try self.encode(Int(value))
    }
    
}

public extension SingleValueEncodingContainer {
    
    mutating func encode(_ value: UInt24) throws {
        try self.encode(UInt32(value))
    }
    
    mutating func encode(_ value: Int24) throws {
        try self.encode(Int32(value))
    }
    
    mutating func encode(_ value: UInt40) throws {
        try self.encode(UInt(value))
    }
    
    mutating func encode(_ value: Int40) throws {
        try self.encode(Int(value))
    }
    
    mutating func encode(_ value: UInt48) throws {
        try self.encode(UInt(value))
    }
    
    mutating func encode(_ value: Int48) throws {
        try self.encode(Int(value))
    }
    
    mutating func encode(_ value: UInt56) throws {
        try self.encode(UInt(value))
    }
    
    mutating func encode(_ value: Int56) throws {
        try self.encode(Int(value))
    }
    
}

public extension KeyedEncodingContainer {
    
    mutating func encode(_ value: UInt24, forKey key: Key) throws {
        try self.encode(UInt32(value), forKey: key)
    }
    
    mutating func encode(_ value: Int24, forKey key: Key) throws {
        try self.encode(Int32(value), forKey: key)
    }
    
    mutating func encode(_ value: UInt40, forKey key: Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
    
    mutating func encode(_ value: Int40, forKey key: Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    
    mutating func encode(_ value: UInt48, forKey key: Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
    
    mutating func encode(_ value: Int48, forKey key: Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    
    mutating func encode(_ value: UInt56, forKey key: Key) throws {
        try self.encode(UInt(value), forKey: key)
    }
    
    mutating func encode(_ value: Int56, forKey key: Key) throws {
        try self.encode(Int(value), forKey: key)
    }
    
}

public extension NSNumber {
    
    @nonobjc
    convenience init(value:  UInt24) {
        self.init(value: UInt32(value))
    }
    
    @nonobjc
    convenience init(value:  Int24) {
        self.init(value: Int32(value))
    }
    
    @nonobjc
    convenience init(value:  UInt40) {
        self.init(value: UInt(value))
    }
    
    @nonobjc
    convenience init(value:  Int40) {
        self.init(value: Int(value))
    }
    
    @nonobjc
    convenience init(value:  UInt48) {
        self.init(value: UInt(value))
    }
    
    @nonobjc
    convenience init(value:  Int48) {
        self.init(value: Int(value))
    }
    
    @nonobjc
    convenience init(value:  UInt56) {
        self.init(value: UInt(value))
    }
    
    @nonobjc
    convenience init(value:  Int56) {
        self.init(value: Int(value))
    }
    
}
