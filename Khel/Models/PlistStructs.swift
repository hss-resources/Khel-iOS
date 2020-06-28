//  Copyright © 2020 App Ktchn. All rights reserved.

class Lists: Codable {
    var payload: [List]
    
    init() {
        self.payload = []
    }
    
}

class List: Codable {
    
    var name: String
    var list: [Khel]
    
    internal init(name: String, list: [Khel]) {
        self.name = name
        self.list = list
    }
    
    var enumeratedList: String {
        list.enumerated().map({ index, khel -> String in
            "\(index+1). \(khel.name)"
        }).joined(separator: "\n")
    }
    
}
