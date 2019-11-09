import XCTest
import Foundation
#if os(Linux)
import Glibc
#endif
@testable import CustomInts
import CustomCoders

fileprivate let IS_BIGENDIAN: Bool = {
    let number: UInt32 = 0x12345678
    let converted = number.bigEndian
    return (number == converted)
}()

/// PatchedNumeric is used to help patch the Magnitude to include Fixed With Int
protocol PatchedFixedWidthInteger: FixedWidthInteger where Magnitude: PatchedFixedWidthInteger { }

extension Int8: PatchedFixedWidthInteger { }
extension UInt8: PatchedFixedWidthInteger { }
extension Int16: PatchedFixedWidthInteger { }
extension UInt16: PatchedFixedWidthInteger { }
extension Int32: PatchedFixedWidthInteger { }
extension UInt32: PatchedFixedWidthInteger { }
extension Int64: PatchedFixedWidthInteger { }
extension UInt64: PatchedFixedWidthInteger { }
extension Int: PatchedFixedWidthInteger { }
extension UInt: PatchedFixedWidthInteger { }

extension Int24: PatchedFixedWidthInteger { }
extension UInt24: PatchedFixedWidthInteger { }
extension Int40: PatchedFixedWidthInteger { }
extension UInt40: PatchedFixedWidthInteger { }
extension Int48: PatchedFixedWidthInteger { }
extension UInt48: PatchedFixedWidthInteger { }
extension Int56: PatchedFixedWidthInteger { }
extension UInt56: PatchedFixedWidthInteger { }


/*fileprivate func binaryDivision(_ lhs: [UInt8], _ rhs: [UInt8], isSigned signed: Bool) -> (quotient: [UInt8], remainder: [UInt8]) {
 
     var lhvNeg = (signed && lhs[0].hasMinusBit)
     var rhvNeg = (signed && rhs[0].hasMinusBit)
 
     //Reduce both numbers to their smallest byte form
     var lhB = minimizeBinaryInteger(lhs, isSigned: signed)
     var rhB = minimizeBinaryInteger(rhs, isSigned: signed)
 
     guard !(lhB == rhB) else { return (quotient: [0x01], remainder: [0x00]) }
     guard !(binaryIsLessThan(lhs, rhs, isSigned: signed)) else { return (quotient: [0x00], remainder: lhs)  }
 
     //Resize rhs to be the same size as lhB.  But padding to the right.
     while rhB.count < lhB.count { rhB.append(0x00) }
 
 
 
 
     //Multiplying two negatives is the same as multiplying two positives
     // -A / -B ~ A / B
     if lhvNeg && rhvNeg {
        lhB = twosComplement(lhB)
        rhB = twosComplement(rhB)
        lhvNeg = false
        rhvNeg = false
     }
 
 
 
 }*/
fileprivate extension UnsafeBufferPointer {
    #if !swift(>=4.0.4)
        func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
            var rtn: [ElementOfResult] = []
            for element in self {
                if let nE = try transform(element) {
                    rtn.append(nE)
                }
            }
            return rtn
        }
    #endif
}
fileprivate func getBinaryString(for value: [UInt8]) -> String {
    var rtn: String = ""
    for b in value {
        var s = String(b, radix: 2)
        while s.count < UInt8.bitWidth { s = "0" + s }
        rtn += s
    }
    return rtn
}

fileprivate extension UInt8 {
    var hasMinusBit: Bool {
        return ((self & 0x80) == 0x80)
    }
}


fileprivate extension BinaryInteger {
    var isZero: Bool {
        var mutableSource = self
        let size = MemoryLayout.size(ofValue: mutableSource)
        let rtn: Bool =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                let buffer = UnsafeBufferPointer(start: $0, count: size)
                return !buffer.contains(where: { $0 != 0x00 })
            }
        }
        return rtn
    }
    
    var mostSignificantByte: UInt8 {
        var mutableSource = self
        let size = MemoryLayout.size(ofValue: mutableSource)
        let msb: UInt8 = withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                let buffer = UnsafeBufferPointer(start: $0, count: size)
                let bytes = Array<UInt8>(buffer)
                if IS_BIGENDIAN { return UInt8(bytes[0]) }
                else { return UInt8(bytes[bytes.count - 1]) }
            }
        }
        return msb
    }
    
    var isNegative: Bool {
        guard Self.isSigned else { return false }
        
        return ((self.mostSignificantByte & 0x80) == 0x80)
    }
    
    
    var integerBytes: [UInt8] {
        var mutableSource = self
        let size = MemoryLayout.size(ofValue: mutableSource)
        let bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                let buffer = UnsafeBufferPointer(start: $0, count: size)
                return Array<UInt8>(buffer)
            }
        }
        return bytes
    }
    
    
    var bigEndianBytes: [UInt8] {
        var rtn = self.integerBytes
        if !IS_BIGENDIAN { rtn.reverse() }
        return rtn
    }
}






extension FixedWidthInteger {
    var rawBytes: [UInt8] {
        var mutableSource = self
        let size = MemoryLayout.size(ofValue: self)
        let bytes: [UInt8] =  withUnsafePointer(to: &mutableSource) {
            return $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                return Array(UnsafeBufferPointer(start: $0, count: size))
            }
        }
        return bytes
    }
    var bigEndianBytes: [UInt8] {
        var bytes: [UInt8] = self.rawBytes
        if !IS_BIGENDIAN { bytes.reverse() }
        return bytes
    }
    var littleEndianBytes: [UInt8] {
        var bytes: [UInt8] = self.rawBytes
        if IS_BIGENDIAN { bytes.reverse() }
        return bytes
    }
    

}
final class CustomIntsTests: XCTestCase {
    
    struct BasicStructure<T>: Codable where T: PatchedFixedWidthInteger, T: Codable {
        let value: T
    }
    
    func testMinMaxOverflowCheck<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        
        
        if true {
            let val: Number = Number.min
            let r = val.subtractingReportingOverflow(1)
            XCTAssert(r.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(r.partialValue)")
            XCTAssertEqual(r.partialValue, Number.max)
        }
        if true {
            let val: Number = Number.max
            let r = val.addingReportingOverflow(1)
             XCTAssert(r.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(r.partialValue)")
             XCTAssertEqual(r.partialValue, Number.min)
        }
        
        
    }
    
    /*func testAddition<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        if Number.isSigned {
            var number: Number = Number.min
            //print(number)
            var comparitor: Int = Int(Number.min)
            while number < Number.max {
                //var formula = "\(number) + 1 = "
                number = number + 1
                //formula += "\(number)"
                //print(formula)
                comparitor = comparitor + 1
                XCTAssert(number == comparitor, "[\(numberType)]: Expected \(comparitor), but found \(number)")
                if (number != comparitor) { fatalError() }
            }
        } else {
            var number: Number = Number.min
            var comparitor: UInt = UInt(Number.min)
            while number < Number.max {
                number = number + 1
                comparitor = comparitor + 1
                XCTAssert(number == comparitor, "[\(numberType)]: Expected \(comparitor), but found \(number)")
                if (number != comparitor) { fatalError() }
            }
        }
    }*/
    
    func testSubtraction<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        if Number.isSigned {
            var number: Number = Number.max
            var comparitor: Int = Int(Number.max)
            while number > Number.min {
                number = number - 1
                comparitor = comparitor - 1
                XCTAssert(number == comparitor, "[\(numberType)]: Expected \(comparitor), but found \(number)")
                if (number != comparitor) { fatalError() }
            }
        } else {
            var number: Number = Number.max
            var comparitor: UInt = UInt(Number.max)
            while number > Number.min {
                number = number - 1
                comparitor = comparitor - 1
                XCTAssert(number == comparitor, "[\(numberType)]: Expected \(comparitor), but found \(number)")
                if (number != comparitor) { fatalError() }
            }
        }
    }
    
    func testBasicAddition<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        var number: Number = Number()
        var additionValue = (number + 1)
        XCTAssert(additionValue == 1, "[\(numberType)]: Invalid addition of 0 with 1.  Expected 1, found \(additionValue)")
        if Number.isSigned {
            number = Number(-1)
            additionValue = (number + 1)
            XCTAssert(additionValue == 0, "[\(numberType)]: Invalid addition of -1 with 1.  Expected 0, found \(additionValue)")
        }
        if Number.isSigned {
            number = Number(-1)
            additionValue = (number + 2)
            XCTAssert(additionValue == 1, "[\(numberType)]: Invalid addition of -1 with 2.  Expected 1, found \(additionValue)")
        }
    }
    
    func testAdditionWithOverflow<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number: Number = Number.max
        let value = number.addingReportingOverflow(1)
        XCTAssert(value.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(value.partialValue)")
    }
    
    func testBasicSubtraction<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        var number: Number = 1
        var subtractionValue: Number = (number - 1)
        XCTAssert(subtractionValue == 0, "[\(numberType)]: Invalid subtraction of 1 with 1.  Expected 0, found \(subtractionValue)")
        if Number.isSigned {
            number = Number(-1)
            subtractionValue = (number - 1)
            XCTAssert(subtractionValue == -2, "[\(numberType)]: Invalid subtraction of -1 with 1.  Expected -2, found \(subtractionValue)")
        }
        if Number.isSigned {
            number = Number(-1)
            subtractionValue = (number - Number(-1))
            XCTAssert(subtractionValue == 0, "[\(numberType)]: Invalid subtraction of -1 with -1.  Expected 0, found \(subtractionValue)")
        }
        
        if Number.isSigned {
            number = Number(5)
            subtractionValue = (number - 10)
            XCTAssert(subtractionValue == -5, "[\(numberType)]: Invalid subtraction of 5 with 10.  Expected -5, found \(subtractionValue)")
        }
    }
    
    func testSubtractionWithOverflow<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number: Number = Number.min
        let value = number.subtractingReportingOverflow(1)
        XCTAssert(value.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(value.partialValue)")
    }
    
    func testBasicMultiplication<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        var number: Number = 2
        var value = (number * 2)
        XCTAssert(value == 4, "[\(numberType)]: Invalid multiplication of 2 with 2.  Expected 4, found \(value)")
        if Number.isSigned {
            number = Number(-2)
            value = (number * 2)
            XCTAssert(value == -4, "[\(numberType)]: Invalid multiplication of -2 with 2.  Expected -4, found \(value)")
        }
    }
    
    func testMultiplicationWithOverflow<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number: Number = Number.max
        let value = number.multipliedReportingOverflow(by: 2)
        XCTAssert(value.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(value.partialValue)")
    }
    
    func testBasicDivision<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        
        var number: Number = 2
        var value = (number / 2)
        XCTAssert(value == 1, "[\(numberType)]: Invalid division of 2 with 2.  Expected 1, found \(value)")
        if true {
            number = 3
            value = (number / 2)
            XCTAssert(value == 1, "[\(numberType)]: Invalid division of 3 with 2.  Expected 1, found \(value)")
        }
        if Number.isSigned {
            number = Number(-2)
            value = (number / 2)
            XCTAssert(value == -1, "[\(numberType)]: Invalid division of -2 with 2.  Expected -1, found \(value)")
        }
        
        if Number.isSigned {
            number = Number(-2)
            value = (number / Number(-2))
            XCTAssert(value == 1, "[\(numberType)]: Invalid division of -2 with -2.  Expected 1, found \(value)")
        }
    }
    
    func testDivisionWithOverflow<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number: Number = Number.max
        let value = number.dividedReportingOverflow(by: 0)
        XCTAssert(value.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(value.partialValue)")
    }
    
    
    func testBasicRemainder<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number: Number = 20
        let value = (number % 2)
        XCTAssert(value == 0, "[\(numberType)]: Invalid remainder of \(number) with 2.  Expected 0, found \(value)")
        
        let number2: Number = 5
        let value2 = (number2 % 2)
        XCTAssert(value2 == 1, "[\(numberType)]: Invalid remainder of \(number2) with 2.  Expected 1, found \(value2)")
    }
    
    func testRemainderWithOverflow<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number: Number = Number.max
        let value = number.remainderReportingOverflow(dividingBy: 0)
        XCTAssert(value.overflow, "[\(numberType)]: Expected overflow but was not signaled. \(value.partialValue)")
    }

    
    func testMultipliedFullWidth<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let number = Number.max
        let r = number.multipliedFullWidth(by: 2)
        let h = Number.isSigned ? 0 : 1
        XCTAssert(r.high == h && r.low == (Number.Magnitude.max - 1), "[\(numberType)]: Invalid remainder of \(Number.max) * 2.  Expected (\(h),\(Number.Magnitude.max - 1)), found (\(r.high),\(r.low))")
    }
    
    func testShift<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        var value: Number = 1
        value = value << 1
        XCTAssert(value == 2, "[\(numberType)]: Invalid shift of 1 << 1.  Expected 2, found \(value)")
        value = value >> 1
        XCTAssert(value == 1, "[\(numberType)]: Invalid shift of 2 >> 1.  Expected 1, found \(value)")
        if Number.isSigned {
            value = Number(-1)
            value = value >> 1
            XCTAssert(value == -1, "[\(numberType)]: Invalid shift of -1 >> 1.  Expected -1, found \(value)")
        }
        if Number.isSigned {
            value = Number(-1)
            value = value << 1
            XCTAssert(value == -2, "[\(numberType)]: Invalid shift of -1 << 1.  Expected -2, found \(value)")
        }
        
        if Number.isSigned {
            value = Number(-50)
            value = value >> Number.bitWidth
            XCTAssert(value == -1, "[\(numberType)]: Invalid shift of -50 >> \(Number.bitWidth).  Expected -1, found \(value)")
        }
        
        if Number.isSigned {
            value = Number(-50)
            value = value << Number.bitWidth
            XCTAssert(value == 0, "[\(numberType)]: Invalid shift of -50 << \(Number.bitWidth).  Expected 0, found \(value)")
        }
        
    }
    
    
    func rand(_ int: Int) -> Int {
        #if os(Linux)
        return random() % int
        #else
        return Int(arc4random_uniform(UInt32(int)))
        #endif
    }
    
    func rand<Number>(_ numberType: Number.Type) -> Number where Number: PatchedFixedWidthInteger {
        var upper: Int
        
        if (Number.max > UInt32.max) { upper = Int(UInt32.max) }
        else { upper = Int(Number.max) }
        var val = Number(rand(upper))
        if Number.isSigned {
            if (Int(rand(10)) % 2) == 0 {
                val = val * Number(-1)
            }
        }
        
        return val
    }
    
    func testDataRead<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger {
        let arraySize: Int = {
            var rtn: Int = 0
            while rtn <= 1 {
                rtn = Int(rand(10))
            }
            return rtn
        }()
        
        var upper: Int
        
        if (Number.max > UInt32.max) { upper = Int(UInt32.max) }
        else { upper = Int(Number.max) }
        
        var ints: [Number] = []
        for _ in 0..<arraySize {
            
            var val = Int(rand(upper))
            if Number.isSigned {
                if (Int(rand(10)) % 2) == 0 {
                    val = val * -1
                }
            }
            ints.append(Number(val))
        }
        
        var bigEndianBytes: [UInt8] = []
        var littleEndianBytes: [UInt8] = []
        for i in ints {
            bigEndianBytes.append(contentsOf: i.bigEndianBytes)
            littleEndianBytes.append(contentsOf: i.littleEndianBytes)
        }
        
        let arraySizeFromBytes = bigEndianBytes.count / (Number.bitWidth / 8)
        let bigEndianNumbers: [Number] = bigEndianBytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Number.self, capacity: arraySizeFromBytes) {
                let buffer = UnsafeBufferPointer(start: $0, count: arraySizeFromBytes)
                return buffer.compactMap({Number(bigEndian: $0)})
            }
        }
        
        XCTAssert(ints == bigEndianNumbers, "[\(numberType)]: Invalid BigEndian read.  Expected \(ints) found \(bigEndianNumbers)")
        
        let littleEndianNumbers: [Number] = littleEndianBytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: Number.self, capacity: arraySizeFromBytes) {
                let buffer = UnsafeBufferPointer(start: $0, count: arraySizeFromBytes)
                return buffer.compactMap({Number(littleEndian: $0)})
            }
        }
        XCTAssert(ints == littleEndianNumbers, "[\(numberType)]: Invalid LittleEndian read.  Expected \(ints) found \(littleEndianNumbers)")
        
        /*print(ints)
        print(bigEndianNumbers)
        print(littleEndianNumbers)*/
    }
    
    func testEncodeDecode<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger, Number: Codable {
        let s: BasicStructure<Number> = BasicStructure(value: rand(numberType))
        do {
            let encoder = JSONEncoder()
            let dta = try encoder.encode(s)
            let decoder = JSONDecoder()
            let dS: BasicStructure<Number> = try decoder.decode(BasicStructure<Number>.self, from: dta)
            
            XCTAssert(s.value == dS.value, "[\(numberType)]: JSON Encode/Decode data missmatch.  Expected value \(s.value), returned \(dS.value)")
            
        } catch {
            XCTFail("[\(numberType)]: JSON Encode/Decode: \(error)")
        }
        
        //#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        do {
            let encoder = PropertyListEncoder()
            let dta = try encoder.encode(s)
            let decoder = PropertyListDecoder()
            let dS: BasicStructure<Number> = try decoder.decode(BasicStructure<Number>.self, from: dta)
            
            XCTAssert(s.value == dS.value, "[\(numberType)]: Property List Encode/Decode data missmatch.  Expected value \(s.value), returned \(dS.value)")
            
        } catch {
            XCTFail("[\(numberType)]: Property List Encode/Decode: \(error)")
        }
        //#endif
    }
    
    
    func numberTests<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger, Number: Codable {
        testBasicAddition(numberType)
        //testAddition(numberType)
        testAdditionWithOverflow(numberType)
        testBasicSubtraction(numberType)
        testSubtractionWithOverflow(numberType)
        testBasicMultiplication(numberType)
        testMultiplicationWithOverflow(numberType)
        testMultipliedFullWidth(numberType)
        testBasicDivision(numberType)
        testDivisionWithOverflow(numberType)
        testBasicRemainder(numberType)
        testRemainderWithOverflow(numberType)
        testMinMaxOverflowCheck(numberType)
 
        testShift(numberType)
        testDataRead(numberType)
        testEncodeDecode(numberType)
    }
    
    func numberTestBase<Number>(_ numberType: Number.Type) where Number: PatchedFixedWidthInteger, Number: SignedInteger, Number: Codable, Number.Magnitude: Codable {
        numberTests(Number.self)
        numberTests(Number.Magnitude.self)
    }
    
    func test24BitInts() { numberTestBase(Int24.self) }
    func test40BitInts() { numberTestBase(Int40.self) }
    func test48BitInts() { numberTestBase(Int48.self) }
    func test56BitInts() { numberTestBase(Int56.self) }
    
    
    //Standard Int Types
    func test8BitInts() { numberTestBase(Int8.self) }
    func test16BitInts() { numberTestBase(Int16.self) }
    func test32BitInts() { numberTestBase(Int32.self) }
    func test64BitInts() { numberTestBase(Int64.self) }
    func testBitInts() { numberTestBase(Int.self) }
    
    
    static var allTests = [
        ("test24BitInts", test24BitInts),
        ("test40BitInts", test40BitInts),
        ("test48BitInts", test48BitInts),
        ("test56BitInts", test56BitInts),
        // Run standard tests to ensure all custom and standard ints function the same
        ("test8BitInts", test8BitInts),
        ("test16BitInts", test16BitInts),
        ("test32BitInts", test32BitInts),
        ("test64BitInts", test64BitInts),
        ("testBitInts", testBitInts),
    ]
}
