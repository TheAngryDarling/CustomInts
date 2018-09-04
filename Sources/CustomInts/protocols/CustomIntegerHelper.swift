//
//  CustomIntegerHelper.swift
//  CustomIntKit
//
//  Created by Tyler Anger on 2018-08-21.
//

import Foundation


// MARK: - Constants
fileprivate let IS_BIGENDIAN: Bool = {
    let number: UInt32 = 0x12345678
    let converted = number.bigEndian
    return (number == converted)
}()

fileprivate let IS_LITTLEENDIAN: Bool = { return !IS_BIGENDIAN }()

// MARK: - Binary helper methods

//Generate two's complement of the big endian integer
fileprivate func twosComplement(_ bytes: [UInt8]) -> [UInt8] {
    var rtn: [UInt8] = bytes
    for i in 0..<rtn.count { rtn[i] = ~rtn[i] }
    var addOne: Bool = true
    for i in (0..<rtn.count).reversed() where addOne {
        addOne = false
        if (Int(rtn[i]) + 1) > Int(UInt8.max) {
            rtn[i] = 0
            addOne = true
        } else {
            rtn[i] = rtn[i] + 1
        }
    }
    return rtn
}

//Padds the big endian integer to a new size if current size is smaller.
//Padding value is 0x00 if number is positive and 0xFF if the number is negative
fileprivate func paddBinaryInteger(_ bigEndianInteger: [UInt8], newSizeInBytes: Int, isNegative: Bool) -> [UInt8] {
    var rtn: [UInt8] = bigEndianInteger
    let padding: UInt8 = (isNegative) ? 0xFF : 0x00
    let diff = newSizeInBytes - rtn.count
    if diff > 0 {
        rtn.insert(contentsOf: [UInt8](repeating: padding, count: diff), at: 0)
    }
    return rtn
}

//Reduces the big endian integer to its smallest byte size while retaining the origional value.
//If the number is a signed type and has a negative indicator this will keep removing the first byte while it equals 0xFF.
//Otherwise if the number is a positive number this will keep removing the first byte while it equals 0x00.
//If the results is an empty byte array then the last byte that we removed will be put back. (this happens for values of 0 and values of -1)
fileprivate func minimizeBinaryInteger(_ bigEndianInteger: [UInt8], isSigned: Bool) -> [UInt8] {
    var rtn: [UInt8] = bigEndianInteger
    let padding: UInt8 = (isSigned && bigEndianInteger[0].hasMinusBit) ? 0xFF : 0x00
    while rtn.count > 1 && rtn[0] == padding { rtn.removeFirst() }
    return rtn
}

//Counts the number of leading zero bits from a big endian integer
fileprivate func leadingZeroBitCount(_ bigEndianInteger: [UInt8]) -> Int {
    var foundBit: Bool = false
    var rtn: Int = 0
    for i in (0..<bigEndianInteger.count) where !foundBit {
        for x in (0..<8).reversed() where !foundBit {
            let mask = UInt8(1 << x)
            foundBit = ((bigEndianInteger[i] & mask) == mask)
            if !foundBit { rtn += 1 }
        }
    }
    return rtn
}

//Provides an indicator if the bit at the given location is 1.
//bit order goes from least significant bit to most significant bit
fileprivate func hasBit(at location: Int, in bytes: [UInt8]) -> Bool {
    precondition(location >= 0, "Location must be >= 0")
    precondition(location < (bytes.count * 8), "Index out of bounds")
    var bts = bytes
    var idx = location
    while idx > 7 {
        bts.removeLast()
        idx = idx - 8
    }
    let mask: UInt8 = 1 << idx
    return ((bts.last! & mask) == mask)
}
//Provides an indicator if the bit at the given location is 1.
//bit order goes from least significant bit to most significant bit
fileprivate func hasBit(at location: Int, in byte: UInt8) -> Bool {
    return hasBit(at: location, in: [byte])
}


//Converts the byte array into a binary string
fileprivate func getBinaryString(for value: [UInt8]) -> String {
    var rtn: String = ""
    for b in value {
        var s = String(b, radix: 2)
        while s.count < UInt8.bitWidth { s = "0" + s }
        rtn += s
    }
    return rtn
}


// MARK: - Binary Operations
fileprivate func xor(_ lhs: @autoclosure () -> Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
    let lhB = lhs()
    let rhB = rhs()
    return ((lhB && !rhB) || (!lhB && rhB))
}


// Right bit shift of a big endian integer in byte format
fileprivate func bitShiftRight(_ bigEndianInt: [UInt8], count: Int, isNegative: Bool) -> [UInt8] {
    guard count != 0 else { return bigEndianInt  }
    guard count > 0 else { return bitShiftLeft(bigEndianInt, count: (count * -1), isNegative: isNegative) }
    
    //Trying to shift larger then the actual number.  This results in all zeros for positive and all ones for negative
    guard count < (bigEndianInt.count * 8) else {
        let padding: UInt8 = isNegative ? 0xFF : 0x00
        return [UInt8](repeating: padding, count: bigEndianInt.count)
    }
    
    var bytes = bigEndianInt
    var cnt = count
    
    //Do large shift while whole bytes are involved
    let byteShift = (cnt - (cnt % 8)) / 8
    if byteShift > 0 {
        bytes.removeLast(byteShift)
        let padding: UInt8 = isNegative ? 0xFF : 0x00
        bytes.insert(contentsOf: [UInt8](repeating: padding, count: byteShift), at: 0)
        cnt = cnt - (byteShift * 8)
    }
    
    // Shift individual bits
    for _ in 0..<cnt {
        for i in (0..<bytes.count).reversed() {
            bytes[i] = bytes[i] >> 1
            if i == 0 && isNegative { bytes[i] = bytes[i] | 0x80 }
            else if i > 0 {
                if ((bytes[i-1] & 0x01) == 0x01) {
                    bytes[i] = bytes[i] | 0x80
                }
            }
        }
    }
    
    return bytes
    
    
}

// Left bit shift of a big endian integer in byte format
fileprivate func bitShiftLeft(_ bigEndianInt: [UInt8], count: Int, isNegative: Bool) -> [UInt8] {
    guard count != 0 else { return bigEndianInt  }
    guard count > 0 else { return bitShiftRight(bigEndianInt, count: (count * -1), isNegative: isNegative) }
    
    //Trying to shift larger then the actual number.  This results in all zeros
    guard count < (bigEndianInt.count * 8) else { return [UInt8](repeating: 0x00, count: bigEndianInt.count) }
    
    var bytes = bigEndianInt
    var cnt = count
    
    //Do large shift while whole bytes are involved
    let byteShift = (cnt - (cnt % 8)) / 8
    if byteShift > 0 {
        bytes.removeLast(byteShift)
        bytes.insert(contentsOf: [UInt8](repeating: 0x00, count: byteShift), at: 0)
        cnt = cnt - (byteShift * 8)
    }
    
    
    // Shift individual bits
    for _ in 0..<cnt {
        for i in (0..<bytes.count) {
            bytes[i] = bytes[i] << 1
            if i < (bytes.count - 1) && ((bytes[i+1] & 0x80) == 0x80) {
                bytes[i] = bytes[i] | 0x01
            }
        }
    }
    
    return bytes
}

// Big Endian integer addition base in byte format returning results and remainder indicator.  Does not do any overflow detection
fileprivate func binaryAdditionBase(_ lhs: [UInt8], _ rhs: [UInt8]) -> (partial: [UInt8], overflow: Bool) {
    var rtn = lhs
    
    guard lhs.count == rhs.count else { fatalError("Int size missmatch") }
    
    
    var hasRemainder: Bool = false
    for byteIndex in (0..<rtn.count).reversed() {
        let addition: UInt16 = (hasRemainder ? 1 : 0 ) + UInt16(rhs[byteIndex])
        hasRemainder = false
        var newVal = UInt16(rtn[byteIndex]) + addition
        if newVal > UInt8.max {
            hasRemainder = true
            newVal = newVal - 256
        }
        rtn[byteIndex] = UInt8(newVal)
    }
    
    
    return (partial: rtn, overflow: hasRemainder)
    
}

// Big Endian integer addition in byte format returning results and overflow indicator
fileprivate func binaryAddition(_ lhs: [UInt8], _ rhs: [UInt8], isSigned signed: Bool) -> (partial: [UInt8], overflow: Bool) {
    // If lhs = A and rhs = -A then the formula would be A + -A. That means that the result will be 0
    // So instead of doing the calculation.  Lets just return 0
    guard !(signed && lhs == twosComplement(rhs)) else {
        return  (partial: [UInt8](repeating: 0x00, count: lhs.count), overflow: false)
    }
    
    let r = binaryAdditionBase(lhs, rhs)
    var o = r.overflow
    
    if signed {
        // -A + B = +C || B - A = +C
        if o && xor(lhs[0].hasMinusBit, rhs[0].hasMinusBit) && !r.partial[0].hasMinusBit { o = false }
        else if !o && !lhs[0].hasMinusBit && !rhs[0].hasMinusBit && r.partial[0].hasMinusBit { o = true } // Rolled over ma from positive to negative
        
    }
    
    /*var printLn: String = ""
     printLn += "   " + getBinaryString(for: lhs) + "\n"
     printLn += " + " + getBinaryString(for: rhs) + "\n"
     printLn += "   " + String(repeating: "_", count: (lhs.count * 8)) + "\n"
     
     printLn += "   " + getBinaryString(for: r.partial) + "  hasRemainder: \(o)" + "\n"
     
     if (o) { print(printLn) }*/
    
    return (partial: r.partial, overflow: o)
}

// Big Endian integer subtraction in byte format returning results and overflow indicator
fileprivate func binarySubtraction(_ lhs: [UInt8], _ rhs: [UInt8], isSigned signed: Bool) -> (partial: [UInt8], overflow: Bool) {
    
    // Zero Sum check
    // If lhs = A and rhs = A then the formula would be A - A. That means that the result will be 0
    // So instead of doing the calculation.  Lets just return 0
    guard !(lhs == rhs) else {
        return  (partial: [UInt8](repeating: 0x00, count: lhs.count), overflow: false)
    }
    
    
    let r = binaryAdditionBase(lhs, twosComplement(rhs))
    var o = r.overflow
    
    if !signed {
        if !o && !lhs[0].hasMinusBit && !rhs[0].hasMinusBit && r.partial[0].hasMinusBit { o = true }
        else if o && lhs[0].hasMinusBit && !rhs[0].hasMinusBit && !r.partial[0].hasMinusBit { o = false }
        else if o && !lhs[0].hasMinusBit && !rhs[0].hasMinusBit && !r.partial[0].hasMinusBit { o = false }
        else if o && xor(lhs[0].hasMinusBit, rhs[0].hasMinusBit) && r.partial[0].hasMinusBit { o = false }
    } else {
        if o && xor(lhs[0].hasMinusBit, rhs[0].hasMinusBit) && r.partial[0].hasMinusBit { o = false }
        else if o && !lhs[0].hasMinusBit && !rhs[0].hasMinusBit && !r.partial[0].hasMinusBit { o = false } // MAX - 1
        
    }
    
    /*var printLn: String = ""
     printLn += "   " + getBinaryString(for: lhs) + "\n"
     printLn += " - " + getBinaryString(for: rhs) + "\n"
     printLn += "   " + String(repeating: "_", count: (lhs.count * 8)) + "\n"
     
     printLn += "   " + getBinaryString(for: r.partial) + "  hasRemainder: \(o)" + "\n"
     
     if (o) { print(printLn) }*/
    
    return (partial: r.partial, overflow: o)
    
}

// Big Endian integer multiplication in byte format returning high and low order
fileprivate func binaryMultiplication(_ lhs: [UInt8], _ rhs: [UInt8], isSigned signed: Bool) -> (high: [UInt8], low: [UInt8]) {
    var lhB = lhs
    var rhB = rhs
    
    let lhvNeg = (signed && lhs[0].hasMinusBit)
    let rhvNeg = (signed && rhs[0].hasMinusBit)
    //Reduce both numbers to their smallest byte form
    lhB = minimizeBinaryInteger(lhB, isSigned: signed)
    rhB = minimizeBinaryInteger(rhB, isSigned: signed)
    
    let isResultsNegative: Bool = xor(lhvNeg, rhvNeg)
    
    //Multiplying two negatives is the same as multiplying two positives
    // -A * -B ~ A * B
    /*if lhvNeg && rhvNeg {
        lhB = twosComplement(lhB)
        rhB = twosComplement(rhB)
        lhvNeg = false
        rhvNeg = false
    }*/
    if lhvNeg {
        // We will do multiplication all in positive numbers and just turn in negative at the end
        lhB = twosComplement(lhB)
    }
    if rhvNeg {
        // We will do multiplication all in positive numbers and just turn in negative at the end
        rhB = twosComplement(rhB)
    }
    
    
    let largestBytesSize = max(lhB.count, rhs.count)
    
    lhB = paddBinaryInteger(lhB, newSizeInBytes: largestBytesSize, isNegative: false)
    rhB = paddBinaryInteger(rhB, newSizeInBytes: largestBytesSize, isNegative: false)
    
    
    let rhActiveBits = (largestBytesSize * 8) - leadingZeroBitCount(rhB)
    var newBufferBitSize = (largestBytesSize * 8) + rhActiveBits
    while (newBufferBitSize % 8 != 0) { newBufferBitSize += 1  }
    let newBufferSize = (newBufferBitSize / 8)
    
    var additionBuffer: [[UInt8]] = []
    for i in 0..<rhActiveBits {
        let hasB = hasBit(at: i, in: rhs)
        var value: [UInt8]
        
        if !hasB { value = [UInt8](repeating: 0x00, count: newBufferSize)  }
        else { value = paddBinaryInteger(lhB, newSizeInBytes: newBufferSize, isNegative: false) }
        value = bitShiftLeft(value, count: i, isNegative: false)
        additionBuffer.append(value)
    }
    
    var finalBinaryValue: [UInt8] = [UInt8](repeating: 0x00, count: newBufferSize)
    var hasOverflow: Bool = false
    for v in additionBuffer where !hasOverflow {
        let r = binaryAddition(finalBinaryValue, v, isSigned: signed)
        
        //let r = binaryAddition(finalBinaryValue, v)
        hasOverflow = r.overflow
        finalBinaryValue = r.partial
    }
    
    // one of the multiplied numbers was negative so we must make our number negative
    if isResultsNegative { finalBinaryValue = twosComplement(finalBinaryValue) }
    
    finalBinaryValue = paddBinaryInteger(finalBinaryValue, newSizeInBytes: (lhs.count * 2), isNegative: isResultsNegative)
    //finalBinaryValue = paddBinaryInteger(finalBinaryValue, newSizeInBytes: (lhs.count * 2), isSigned: signed)
    let highBytes = finalBinaryValue[0 ..< lhs.count]
    let lowBytes = finalBinaryValue[lhs.count ..< finalBinaryValue.count]
    
    /*var printLn: String = ""
    printLn += "   " + getBinaryString(for: paddBinaryInteger(lhs, newSizeInBytes: (lhs.count * 2), isNegative: lhvNeg)) + "\n"
    printLn += " * " + getBinaryString(for: paddBinaryInteger(rhs, newSizeInBytes: (lhs.count * 2), isNegative: rhvNeg)) + "\n"
    printLn += "   " + String(repeating: "_", count: (lhs.count * 8)) + "\n"
 
    printLn += "   " + getBinaryString(for: finalBinaryValue) + "\n"
    
    print(printLn)
    
    if xor(lhvNeg, rhvNeg) {
        printLn = ""
        printLn += "   " + getBinaryString(for: paddBinaryInteger(lhB, newSizeInBytes: (lhs.count * 2), isNegative: lhvNeg)) + "\n"
        printLn += " * " + getBinaryString(for: paddBinaryInteger(rhB, newSizeInBytes: (lhs.count * 2), isNegative: rhvNeg)) + "\n"
        printLn += "   " + String(repeating: "_", count: (lhs.count * 8)) + "\n"
        
        printLn += "   " + getBinaryString(for: finalBinaryValue) + "\n"
        
        print(printLn)
    }*/
    
    //print("high: \(getBinaryString(for: Array(highBytes))), low: \(getBinaryString(for: Array(lowBytes)))")
    
    return (high: Array(highBytes), low: Array(lowBytes))
    
    
}

// Big Endian integer less than operator.  checks to see if first integer is less than the second
fileprivate func binaryIsLessThan(_ lhs: [UInt8], _ rhs: [UInt8], isSigned signed: Bool) -> Bool {
    // A == B
    guard !(lhs == rhs) else { return false }
    let lhvNeg = (signed && lhs[0].hasMinusBit)
    let rhvNeg = (signed && rhs[0].hasMinusBit)
    // -A < B
    if lhvNeg && !rhvNeg { return true }
    // A < -B
    if !lhvNeg && rhvNeg { return false }
    
    
    // Make integers the smalles byte size they can be
    var lhv = minimizeBinaryInteger(lhs, isSigned: signed)
    var rhv = minimizeBinaryInteger(rhs, isSigned: signed)
    
    let largestBytesSize = max(lhv.count, rhv.count)
    
    //padd integers so they are the same size
    lhv = paddBinaryInteger(lhv, newSizeInBytes: largestBytesSize, isNegative: lhvNeg)
    rhv = paddBinaryInteger(rhv, newSizeInBytes: largestBytesSize, isNegative: rhvNeg)
    
    for i in (0..<(lhv.count * 8)).reversed() {
        let lhB = hasBit(at: i, in: lhv)
        let rhB = hasBit(at: i, in: rhv)
        
        if lhB != rhB { return rhB }
    }
    
    return false
}



// MARK: - Extensions
fileprivate extension UInt8 {
    // Indicates if bit 8 is set
    var hasMinusBit: Bool { return ((self & 0x80) == 0x80) }
}

fileprivate extension BinaryInteger {
    
    // Provides an unsafe UInt8 buffer pointer for use
    fileprivate func useUnsafeBufferPointer<T>(_ function: @escaping (UnsafeBufferPointer<UInt8>) -> T) -> T {
        var mutableSource = self
        let size = MemoryLayout.size(ofValue: mutableSource)
        let rtn: T =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                let buffer = UnsafeBufferPointer(start: $0, count: size)
                return function(buffer)
            }
        }
        return rtn
    }
    // Compares all bytes within integer to make sure they are all zero
    fileprivate var isZero: Bool {
        return useUnsafeBufferPointer {
            return !$0.contains(where: { $0 != 0x00 })
        }
    }
    
    // returns the most significant byte of the integers.  for big endian systems this is byte[0].  For little endian systems this is byte[byte.count - 1]
    fileprivate var mostSignificantByte: UInt8 {
        return useUnsafeBufferPointer {
            if IS_BIGENDIAN { return UInt8($0.first!) }
            else { return UInt8($0.last!) }
        }
    }
    
    // Indicates if this number is a negative.  First checks number type for isSigned flag.  Then check the 8 bit on the most significant byte
    fileprivate var isNegative: Bool {
        guard Self.isSigned else { return false }
        return self.mostSignificantByte.hasMinusBit
    }
    
    // Returns the raw bytes of the integer in their origional order
    fileprivate var integerBytes: [UInt8] {
        return useUnsafeBufferPointer { return Array<UInt8>($0) }
    }
    
    // Returns the raw bytes in big endian order.  Most significat byte is byte[0]
    fileprivate var bigEndianBytes: [UInt8] {
        var rtn = self.integerBytes
        if !IS_BIGENDIAN { rtn.reverse() }
        return rtn
    }
}


// MARK: - Custom Integer
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
public protocol CustomIntegerHelper: FixedWidthInteger, _ExpressibleByBuiltinIntegerLiteral, CustomReflectable, Codable, _ObjectiveCBridgeable {
    associatedtype InverseInteger: CustomIntegerHelper
}
#else
public protocol CustomIntegerHelper: FixedWidthInteger, _ExpressibleByBuiltinIntegerLiteral, CustomReflectable, Codable {
    associatedtype InverseInteger: CustomIntegerHelper
}
#endif

extension CustomIntegerHelper {
    
    // Returns indicator if this is a negative(-1), Zero(0), or positive(+1)
    public func signum() -> Self {
        if self.isZero { return 0 }
        else if self.isNegative { return -1 }
        else { return 1 }
    }
    
    // Returns a new word object for this integer.  This is used when other integers try and convert our integer to theirs
    public var words: CustomIntegerWords<Self> {
        return CustomIntegerWords(self)
    }
    
    // Internal property used in basic operations
    fileprivate var iValue: Int {
        guard !self.isZero else { return 0 }
        
        var bytes = self.bigEndianBytes

        let isNegative = (Self.isSigned && bytes[0].hasMinusBit)
        //If we are a negative number, lets get the abs value for now.
        if isNegative { bytes = twosComplement(bytes)  }
        
        //Build our integer
        var rtn: Int = 0
        for b in bytes {
            rtn = (Int(rtn) << 8) + Int(b)
        }
        // If we were a negative number, lts times the results by -1 to make the results a negative number
        if isNegative { rtn = rtn * -1 }
        return rtn
    }
    
    // Hash Values of integers are the integer numeric value
    public var hashValue: Int { return iValue }
    
    // Creats custom mirror to hide all details about ourselves
    public var customMirror: Mirror { return Mirror(self, children: []) }
    
    // Returns a count of all non zero bits in the number
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
    
    // Returns a new instances of this number type with our byts reversed
    public var byteSwapped: Self {
        
        return useUnsafeBufferPointer {
            var bytes = Array<UInt8>($0)
            bytes.reverse()
            return bytes.withUnsafeBufferPointer {
                return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) { return $0.pointee }
            }
        }
        
    }
    
    // Returns the number of leading zeros in this number.  If the number is negative this will return 0
    public var leadingZeroBitCount: Int {
        
        return useUnsafeBufferPointer {
            var range = Array<Int>(0..<$0.count)
            if !IS_BIGENDIAN { range = range.reversed() }
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
    
    // Returns the number of trailing zeros in this number
    public var trailingZeroBitCount: Int {
        return useUnsafeBufferPointer {
            var range = Array<Int>(0..<$0.count)
            if IS_BIGENDIAN { range = range.reversed() }
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
}

// MARK: - Custom Integer Comparitor Operators
extension CustomIntegerHelper {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.bigEndianBytes == rhs.bigEndianBytes
    }
    public static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other : BinaryInteger {
        
        // If the two numbers don't have the same sign, we will return false right away
        guard (lhs.isNegative == rhs.isNegative) else { return false }
        
        //Get raw binary integers and reduce to smalles representation
        // Must reduce otherwise equals will return false if integer value is the same but array sizes are different
        // So if we reduce to the smalles byte size that can represent the integers it makes it easier to compare no
        // matter what integer types we are comparing
        let lhb = minimizeBinaryInteger(lhs.bigEndianBytes, isSigned: Self.isSigned)
        let rhb = minimizeBinaryInteger(rhs.bigEndianBytes, isSigned: Other.isSigned)
        
        
        return (lhb == rhb)
    }
    
    public static func != (lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }
    public static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other : BinaryInteger {
        return !(lhs == rhs)
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return binaryIsLessThan(lhs.bigEndianBytes, rhs.bigEndianBytes, isSigned: Self.isSigned)
    }
    public static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other : BinaryInteger {
        // -A < B ?
        if lhs.isNegative && !rhs.isNegative { return true }
        // A < -B
        if !lhs.isNegative && rhs.isNegative { return false }
        
        // We don't care about the signed flag on the rhs type because
        // for formulate will be -A < -B || A < B so the sign on A will be the same as the sign on B
        return binaryIsLessThan(lhs.bigEndianBytes, rhs.bigEndianBytes, isSigned: Self.isSigned)
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return ((lhs != rhs) && !(lhs < rhs))
    }
    public static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other : BinaryInteger {
        return ((lhs != rhs) && !(lhs < rhs))
    }
    
}
// MARK: - Custom Integer Binary Operators
extension CustomIntegerHelper {
    
    public static func >>(lhs: Self, rhs: Self) -> Self {
        guard !rhs.isZero else { return lhs }
        guard !rhs.isNegative else {
            guard rhs < (Self.bitWidth * -1) else { return Self() }
            return lhs << Self(rhs.magnitude)
        }
        
        var bytes = bitShiftRight(lhs.bigEndianBytes, count: Int(rhs), isNegative: lhs.isNegative)
        if !IS_BIGENDIAN { bytes.reverse() }
        
        return bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
        
    }
    
    public static func >>=(lhs: inout Self, rhs: Self) {
        lhs = lhs << rhs
    }
    
    public static func >><Other>(lhs: Self, rhs: Other) -> Self where Other : BinaryInteger {
        //guard rhs < Self.bitWidth else { return Self() }
        guard !rhs.isZero else { return lhs }
        if rhs.isNegative { return lhs << rhs }
        return lhs >> Self(rhs)
    }
    
    public static func >>=<Other>(lhs: inout Self, rhs: Other) where Other : BinaryInteger {
        lhs = lhs << rhs
    }
    
    public static func << (lhs: Self, rhs: Self) -> Self  {
        guard !rhs.isZero else { return lhs }
        guard !rhs.isNegative else {
            // We are shifting negativly.  That means the shift is the other way
            guard rhs < (Self.bitWidth * -1) else {
                guard lhs.isNegative else { return Self() }
                let bytes = [UInt8](repeating: 0xFF, count: (Self.bitWidth / 8))
                
                return bytes.withUnsafeBufferPointer {
                    return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                        return Self($0.pointee)
                    }
                }
                
            }
            return lhs >> Self(rhs.magnitude)
        }
        
        var bytes = bitShiftLeft(lhs.bigEndianBytes, count: Int(rhs), isNegative: lhs.isNegative)
        if !IS_BIGENDIAN { bytes.reverse() }
        
        
        
        return bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
    }
    
    public static func <<= (lhs: inout Self, rhs: Self)  {
        lhs = lhs << rhs
    }
    
    public static func <<<Other>(lhs: Self, rhs: Other) -> Self where Other : BinaryInteger {
        guard rhs < Self.bitWidth else { return Self() }
        guard !rhs.isZero else { return lhs }
        if rhs.isNegative { return lhs >> rhs }
        return lhs << Self(rhs)
    }
    
    public static func <<=<Other>(lhs: inout Self, rhs: Other) where Other : BinaryInteger {
        lhs = lhs << rhs
    }
    
    public static func | (lhs: Self, rhs: Self) -> Self  {
        var lhb = lhs.bigEndianBytes
        let rhb = rhs.bigEndianBytes
        for i in 0..<lhb.count {
            lhb[i] = lhb[i] | rhb[i]
        }
        
        if !IS_BIGENDIAN { lhb.reverse() }
        
        return lhb.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
        
    }
    
    public static func |= (lhs: inout Self, rhs: Self)  {
        lhs = lhs | rhs
    }
    
    public static func & (lhs: Self, rhs: Self) -> Self  {
        var lhb = lhs.bigEndianBytes
        let rhb = rhs.bigEndianBytes
        for i in 0..<lhb.count {
            lhb[i] = lhb[i] & rhb[i]
        }
        
        if !IS_BIGENDIAN { lhb.reverse() }
        
        return lhb.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
        
    }
    
    public static func &= (lhs: inout Self, rhs: Self)  {
        lhs = lhs & rhs
    }
    
    public static func ^ (lhs: Self, rhs: Self) -> Self  {
        var lhb = lhs.bigEndianBytes
        let rhb = rhs.bigEndianBytes
        for i in 0..<lhb.count {
            lhb[i] = lhb[i] ^ rhb[i]
        }
        
        if !IS_BIGENDIAN { lhb.reverse() }
        
        return lhb.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
        
    }
    
    public static func ^= (lhs: inout Self, rhs: Self)  {
        lhs = lhs ^ rhs
    }
}

// MARK: - Custom Integer Algorithmic Operations with Overflow Indicators
extension CustomIntegerHelper {
    
    public func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        guard !rhs.isZero else { return (partialValue: Self(self), overflow: false)  }
        guard !self.isZero else { return (partialValue: Self(rhs), overflow: false)  }
        
        let r = binaryAddition(self.bigEndianBytes, rhs.bigEndianBytes, isSigned: Self.isSigned)
        
        var bytes = r.partial
        
        if !IS_BIGENDIAN { bytes.reverse() }
        
        let value: Self = bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
        return (partialValue: value, overflow: r.overflow)
        
    }
    
    public func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        guard !rhs.isZero else { return (partialValue: Self(self), overflow: false)  }
        
        let r = binarySubtraction(self.bigEndianBytes, rhs.bigEndianBytes, isSigned: Self.isSigned)
        
        var bytes = r.partial
        
        if !IS_BIGENDIAN { bytes.reverse() }
        
        let value: Self = bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self($0.pointee)
            }
        }
        return (partialValue: value, overflow: r.overflow)
        
    }
    
    public func multipliedFullWidth(by other: Self) -> (high: Self, low: Magnitude) {
        
        let r = binaryMultiplication(self.bigEndianBytes, other.bigEndianBytes, isSigned: Self.isSigned)
        
        let low = r.low.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.Magnitude.self, capacity: 1) {
                return Self.Magnitude(bigEndian: $0.pointee)
            }
        }
        
        let high = r.high.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Self(bigEndian: $0.pointee)
            }
        }
        
        return (high: high, low: low)
    }
    
    public func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        guard !self.isZero && !rhs.isZero else { return (partialValue: Self(), overflow: false)  }
        
        let r = self.multipliedFullWidth(by: rhs)
        let val = Self(truncatingIfNeeded: r.low)
        //let val = Self(bitPattern: r.low)
        var overflow: Bool = false
        if !self.isZero && !rhs.isZero && val.isZero { overflow = true }
        else if !Self.isSigned && r.high == 1 { overflow = true }
        else if Self.isSigned && !self.isNegative && !rhs.isNegative && val.isNegative {
            overflow = true
        } else {
            if xor(self.isNegative, rhs.isNegative) && !val.isNegative { overflow = true }
        }
        
        return (partialValue: val, overflow: overflow)
        
        
    }
    
    public func dividingFullWidth(_ dividend: (high: Self, low: Magnitude)) -> (quotient: Self, remainder: Self) {
        // We are cheating here.  Instead of using our own code.  we are casting as base Int type
        
         if Self.isSigned {
            let divisor = (dividend.high.iValue << Self.bitWidth) + Int(dividend.low)
            
            let r = self.iValue.quotientAndRemainder(dividingBy: divisor)
            return (quotient: Self(r.quotient), remainder: Self(r.remainder))
            
         } else {
            let divisor = (UInt(dividend.high.iValue) << UInt(Self.bitWidth)) + UInt(dividend.low)
            
            let r = UInt(self.iValue).quotientAndRemainder(dividingBy: divisor)
            return (quotient: Self(r.quotient), remainder: Self(r.remainder))
        }
       
        
    }
    
    public func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        // We are cheating here.  Instead of using our own code.  we are casting as base Int type
        guard !self.isZero else { return (partialValue: Self(), overflow: false)  }
        guard !rhs.isZero else { return (partialValue: self, overflow: true)   }
        
        if Self.isSigned {
            let intValue = self.iValue / rhs.iValue
            let hasOverflow = (intValue > Self.max.iValue || intValue < Self.min.iValue)
            return (partialValue: Self(truncatingIfNeeded: intValue), overflow: hasOverflow)
        } else {
            let intValue: UInt = UInt(self.iValue) / UInt(rhs.iValue)
            let hasOverflow = (intValue > Self.max.iValue || intValue < Self.min.iValue)
            return (partialValue: Self(truncatingIfNeeded: intValue), overflow: hasOverflow)
        }
        
        
    }
    
    public func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
        guard rhs != 0 else { return (partialValue: self, overflow: true)  }
        
        var selfValue = self
        var rhsValue = rhs
        let isSelfNeg = selfValue.isNegative
        let isRHNeg = rhsValue.isNegative
        //let xorNeg = (isSelfNeg && !isRHNeg) || (!isSelfNeg && isRHNeg)
        
        if isSelfNeg { selfValue = selfValue * -1  }
        if isRHNeg { rhsValue = rhsValue * -1  }
        
        while selfValue >= rhsValue {
            //print("selfValue: \(selfValue), rhsValue: \(rhsValue)")
            selfValue = selfValue - rhsValue
        }
        
        if isSelfNeg { selfValue = selfValue * -1  }
        
        return (partialValue: selfValue, overflow: false)
    }
    
}


// MARK: - Custom Integer Algorithmic Operators
extension CustomIntegerHelper {
    
    public static func + (lhs: Self, rhs: Self) -> Self {
         let r = lhs.addingReportingOverflow(rhs)
        guard !r.overflow else { fatalError("Overflow") }
        return r.partialValue
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        let r = lhs.subtractingReportingOverflow(rhs)
        guard !r.overflow else { fatalError("Overflow") }
        return r.partialValue
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        let r = lhs.multipliedReportingOverflow(by: rhs)
        guard !r.overflow else { fatalError("Overflow") }
        return r.partialValue
    }
    
    public static func / (lhs: Self, rhs: Self) -> Self {
        let r = lhs.dividedReportingOverflow(by: rhs)
        guard !r.overflow else { fatalError("Overflow") }
        return r.partialValue
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        let r = lhs.remainderReportingOverflow(dividingBy: rhs)
        guard !r.overflow else { fatalError("Overflow") }
        return r.partialValue
    }
    
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs = lhs % rhs
    }
    
    
    //@inline(__always)
    public func distance(to other: Self) -> Int {
        //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
        if !Self.isSigned {
            if self > other {
                if let result = Int(exactly: self - other) {
                    return -result
                }
            } else {
                if let result = Int(exactly: other - self) {
                    return result
                }
            }
        } else {
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
        }
        _preconditionFailure("Distance is not representable in Int")
    }
    
    //@inline(__always)
    public func advanced(by n: Int) -> Self {
        //Taken from https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb
        if !Self.isSigned {
            return (n.isNegative ? (self - Self(-n)) : (self + Self(n)) )
        }
        
        if  (self.isNegative == n.isNegative) { return (self + Self(n)) }
        
        return (self.magnitude < n.magnitude) ? Self(Int(self) + n) : (self + Self(n))
    }
    
}


// MARK: - Custom Integer Initializers
extension CustomIntegerHelper {
    
    
    
    public init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        self.init(Int(_builtinIntegerLiteral: value))
    }
    
    public init(integerLiteral value: Self.Magnitude) {
        self.init(value)
    }
    
    public init(_truncatingBits truncatingBits: UInt) {
        let typeSize: Int = MemoryLayout<Self>.size
        let intSize: Int = MemoryLayout<UInt>.size
        var intValue = truncatingBits
        var bytes: [UInt8] =  withUnsafePointer(to: &intValue) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: intSize) {
                return Array(UnsafeBufferPointer(start: $0, count: intSize))
            }
        }
        
        if !IS_BIGENDIAN { bytes = bytes.reversed() }
        while bytes.count > typeSize { bytes.remove(at: 0) }
        while bytes.count < typeSize { bytes.insert(0x00, at: 0) }
        
        if !IS_BIGENDIAN { bytes = bytes.reversed() }
        
        
        
        self.init()
        withUnsafeMutablePointer(to: &self) {
            $0.withMemoryRebound(to: UInt8.self, capacity: typeSize) {
                let buffer = UnsafeMutableBufferPointer(start: $0, count: typeSize)
                
                guard buffer.count == bytes.count else { fatalError("Memory size missmatch") }
                for i in 0..<buffer.count {
                    buffer[i] = bytes[i]
                }
            }
        }
        
    }
    
    public init(bitPattern x: Self) {
        guard Self.bitWidth == Self.InverseInteger.bitWidth else { fatalError("Bit Pattern sizes must match") }
        
        let typeSize: Int = MemoryLayout<Self>.size
        var intValue = x
        var bytes: [UInt8] =  withUnsafePointer(to: &intValue) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: typeSize) {
                return Array(UnsafeBufferPointer(start: $0, count: typeSize))
            }
        }
        
        
        
        self.init()
        withUnsafeMutablePointer(to: &self) {
            $0.withMemoryRebound(to: UInt8.self, capacity: typeSize) {
                let buffer = UnsafeMutableBufferPointer(start: $0, count: typeSize)
                
                guard buffer.count == bytes.count else { fatalError("Memory size missmatch") }
                for i in 0..<buffer.count {
                    buffer[i] = bytes[i]
                }
            }
        }
    }
    
    public init(bitPattern x: Self.InverseInteger) {
        guard Self.bitWidth == Self.InverseInteger.bitWidth else { fatalError("Bit Pattern sizes must match") }
        
        let typeSize: Int = MemoryLayout<Self>.size
        let intSize: Int = MemoryLayout<Self.InverseInteger>.size
        var intValue = x
        let bytes: [UInt8] =  withUnsafePointer(to: &intValue) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: intSize) {
                return Array(UnsafeBufferPointer(start: $0, count: intSize))
            }
        }
        
        
        
        self.init()
        withUnsafeMutablePointer(to: &self) {
            $0.withMemoryRebound(to: UInt8.self, capacity: typeSize) {
                let buffer = UnsafeMutableBufferPointer(start: $0, count: typeSize)
                
                guard buffer.count == bytes.count else { fatalError("Memory size missmatch") }
                for i in 0..<buffer.count {
                    buffer[i] = bytes[i]
                }
            }
        }
    }
    
    
}

// MARK: - Codable logic
extension CustomIntegerHelper {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if Self.isSigned {
            let v = try container.decode(Int.self)
            self = Self(v)
        } else {
            let v = try container.decode(UInt.self)
            self = Self(v)
        }
        //self = try container.decode(Self.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if Self.isSigned { try container.encode(Int(self)) }
        else { try container.encode(UInt(self)) }
    }
}

// MARK: - NSNumber bridging
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
extension CustomIntegerHelper {
    @available(swift, deprecated: 4, renamed: "init(truncating:)")
    public init(_ number: NSNumber) {
        if Self.isSigned { self.init(number.intValue) }
        else { self.init(number.uintValue) }
    }
    
    public init(truncating number: NSNumber) {
        if Self.isSigned { self.init(truncatingIfNeeded: number.intValue) }
        else { self.init(truncatingIfNeeded: number.uintValue) }
    }
    
    public init?(exactly number: NSNumber) {
        if Self.isSigned {
            let value = number.intValue
            guard NSNumber(value: value) == number else { return nil }
            self.init(value)
        } else {
            let value = number.uintValue
            guard NSNumber(value: value) == number else { return nil }
            self.init(value)
        }
    }
    
    @_semantics("convertToObjectiveC")
    public func _bridgeToObjectiveC() -> NSNumber {
        return NSNumber(value: self)
    }
    
    public static func _forceBridgeFromObjectiveC(_ x: NSNumber, result: inout Self?) {
        if !_conditionallyBridgeFromObjectiveC(x, result: &result) {
            fatalError("Unable to bridge \(_ObjectiveCType.self) to \(self)")
        }
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ x: NSNumber, result: inout Self?) -> Bool {
        guard let value = Self(exactly: x) else { return false }
        result = value
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSNumber?) -> Self {
        var result: Self?
        guard let src = source else { return 0 }
        guard _conditionallyBridgeFromObjectiveC(src, result: &result) else { return 0 }
        return result!
    }
}
#endif
// Used when creating custom unsigned integers
internal protocol CustomUnsignedIntegerHelper: CustomIntegerHelper, UnsignedInteger { }
// Used when creating custom signed integers
internal protocol CustomSignedIntegerHelper: CustomIntegerHelper, SignedInteger { }
extension CustomSignedIntegerHelper {
    public var magnitude: Magnitude {
        guard self.isNegative else { return Magnitude(self) }
        var bytes = self.bigEndianBytes
        //bytes = twosComplement(bytes)
        
        if !IS_BIGENDIAN { bytes.reverse() }
        
        let mag: Magnitude = bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return Magnitude($0.pointee)
            }
        }
        
        return mag
    }
}

// MARK: - Template for required init in each custom integer
/*public init<T>(_ source: T) where T : BinaryInteger {
    // This was built from template in CustomIntegerHelper because implementation of
    // BinaryInteger and FixedWidthInteger seem to require this init be places directly
    // in the structure
    //
    //
    // Initialize all bytes in structure to zero
    // self.a = 0
    // self.b = 0
    // ......
 
    // Set required specific integer type information
    let isLocalTypeSigned = {Self}.isSigned
    let localBitWidth = {Self}.bitWidth
    let localByteWidth = (localBitWidth / 8)
    let intType = Int24.self
    
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
*/
