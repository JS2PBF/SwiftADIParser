import Foundation
import RegexBuilder

enum ADIRegex {
    // field name
    // ADIF 'Character's except comma, colon, angle-brackets, curly-brackets
    static let fieldName = #/[\x21-\x2B\x2D-\x39\x3B\x3D\x3F-\x7A\x7C\x7E](?:[\x20-\x2B\x2D-\x39\x3B\x3D\x3F-\x7A\x7C\x7E]*[\x21-\x2B\x2D-\x39\x3B\x3D\x3F-\x7A\x7C\x7E])?/#
    
    // data length
    static let dataLength = #/[0-9]+/#
    
    // data type indicator
    static let dataType = #/[A-Za-z]/#
    
    
    private static let lenTypeRe = Regex {
        ":"
        TryCapture {
            dataLength
        } transform: { str -> Int? in
            return Int(str)
        }
        Optionally {
            Regex {
                ":"
                TryCapture {
                    dataType
                } transform: { str -> String in
                    return String(str)
                }
            }
        }
    }
    
    static let tag = Regex {
        "<"
        TryCapture {
            fieldName
        } transform: { str -> String in
            return String(str)
        }
        Optionally {
            lenTypeRe
        }
        ">"
    }
}
