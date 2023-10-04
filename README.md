# SwiftADIParser

Swift package of the ADIF (Amateur Data Interchange Format) documents parser.

The ADIParser notifies its delegate about the ADI data-specifiers (field name, data length, data type indicator, data, and so on) during the parsing of ADI documents.
It does not itself do anything with those parsed items except report them.

Read more about this package on the [document](https://js2pbf.github.io/SwiftADIParser/documentation/swiftadiparser/).


## Requirement

- Swift >= 5.7


## Using the SwiftADIParser in your project

```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .package(
            url: "https://github.com/JS2PBF/SwiftADIParser/",
              .upToNextMinor(from: "2.0.0")  // or .upToNextMajor
        ),
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                "SwiftADIParser",
            ]
        )
    ]
)
```


## Sample code

```swift
import SwiftADIParser

let sampleADI = """
    <QSO_DATE:8>19900620
    <TIME_ON:4>1523
    <CALL:6>JS2PBF
    <BAND:3>40M
    <MODE:3>FT8
    <EOR>
"""

struct Field {
    var fieldName: String
    var dataLength: Int?
    var dataType: String?
    var data: String?
}

class MyDelegate: ADIParserDelegate {
    var fields: [Field] = []

    init() { }
    
    func parser(_ parser: ADIParser, foundDataSpecifier fieldName: String, dataLength: Int?, dataType: String?, data: String?) {
        let field = Field(fieldName: fieldName, dataLength: dataLength, dataType: dataType, data: data)
        fields.append(field)
    }
}

let delegate = MyDelegate()
let parser = ADIParser(string: sampleADI, ADIParserDelegate: delegate)
let state = parser.parse()

print(state)  // true
print(delegate.fields)
// [
//     Field(fieldName: "QSO_DATE", dataLength: Optional(8), dataType: nil, data: Optional("19900620")),
//     Field(fieldName: "TIME_ON", dataLength: Optional(4), dataType: nil, data: Optional("1523")),
//     Field(fieldName: "CALL", dataLength: Optional(6), dataType: nil, data: Optional("JS2PBF")),
//     Field(fieldName: "BAND", dataLength: Optional(3), dataType: nil, data: Optional("40M")),
//     Field(fieldName: "MODE", dataLength: Optional(3), dataType: nil, data: Optional("FT8")),
//     Field(fieldName: "EOR", dataLength: nil, dataType: nil, data: nil)
// ]
```
