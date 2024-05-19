import Foundation

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key, value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast(1))
        output = output.replacingOccurrences (of: "@", with: "%40")
        output = output.replacingOccurrences (of: " ", with: "%20")
        output = output.replacingOccurrences (of: "\n", with: "%0D")
        output = output.replacingOccurrences (of: "-", with: "%2D")

        return output
    }
}

extension String {
    func queryString() -> String {
        var output = self
        output = output.replacingOccurrences (of: "@", with: "%40")
        output = output.replacingOccurrences (of: " ", with: "%20")
        output = output.replacingOccurrences (of: "\n", with: "%0D")
        output = output.replacingOccurrences (of: "-", with: "%2D")

        return output
    }
    
    func urlString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    }
}
