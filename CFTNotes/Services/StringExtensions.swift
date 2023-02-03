public extension String {
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left),
            let rightRange = range(of: right, options: .backwards),
            leftRange.upperBound <= rightRange.lowerBound
        else { return nil }

        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }

    var length: Int {
        get {
            return self.count
        }
    }

    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }

    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
}
