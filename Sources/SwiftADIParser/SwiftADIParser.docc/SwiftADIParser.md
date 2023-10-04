# ``SwiftADIParser``

Swift package of the ADIF (Amateur Data Interchange Format) documents parser.

## Overview

The ADIParser notifies its delegate about the ADI data-specifiers (field name, data length, data type indicator, data, and so on) during the parsing of ADI documents.
It does not itself do anything with those parsed items except report them.

```swift
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

> Note: The length of the parsed data is exactly the same as the data-length in the ADI data-specifier.
If the specified length is smaller thant the actual length of data, only the partial data of the specified length is provided to ``ADIParserDelegate/parser(_:foundDataSpecifier:dataLength:dataType:data:)-7bflj``, and the lest part is treated as "comment" and provided to ``ADIParserDelegate/parser(_:foundComment:)-1q0ca``.
On the other hand, if the specified length is larger than the actual length, the following data-specifier will be treated as "data".


## Topics

### Event-Based Processing

- ``ADIParser``
- ``ADIParserDelegate``

### Error Information

- ``ADIParseError``
