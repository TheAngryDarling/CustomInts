# Custom Integers

![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

> Note: Versions <= 1.0.2 unfortunately does not actually work out side of the Mac Ecosystem

This kit adds additional integers with custom sizes.  They are as follows:
24 bit ints: Int24, UInt24
40 bit ints: Int40, UInt40
48 bit ints: Int48, UInt48
56 bit ints: Int56, UInt56

Reasoning behind these custom types are when you need to read file formats that require one or more of these int sizes

## Requirements

* Xcode 9.0.1+ (If working within Xcode)
* Swift 4.0+

> Note: This package used [Dynamic Swift](https://github.com/TheAngryDarling/dswift) to generate some, or all, of its source code.  While the generated source code should be included and available in this package so building directly with swift is possible, if missing, you may need to download and build with [Dynamic Swift](https://github.com/TheAngryDarling/dswift)

## Usage

You can use thes custom integer types like you would any other integer type

## Dependencies

* **[Custom Coders](https://github.com/TheAngryDarling/SwiftCustomCoders)** - Provides the base for creating custom coders as well as a few complete coders like PListEncoder and PListDecoder which are cross platform Property List Coders.  (Used only when testing)

## Author

* **Tyler Anger** - *Initial work* - [TheAngryDarling](https://github.com/TheAngryDarling)

## License

This project is licensed under Apache License v2.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

[Swift](https://github.com/apple/swift) Specifically the section on [integers](https://github.com/apple/swift/blob/master/stdlib/public/core/Integers.swift.gyb)
