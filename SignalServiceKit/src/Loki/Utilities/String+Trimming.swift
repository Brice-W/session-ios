
public extension String {
    
    public func removing05PrefixIfNeeded() -> String {
        var result = self
        if result.count == 66 && result.hasPrefix("05") { result.removeFirst(2) }
        return result
    }
}

@objc extension NSString {
    
    @objc public func removing05PrefixIfNeeded() -> NSString {
        var result = self as String
        if result.count == 66 && result.hasPrefix("05") { result.removeFirst(2) }
        return result as NSString
    }
}
