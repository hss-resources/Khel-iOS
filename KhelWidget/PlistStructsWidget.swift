//  Copyright © 2020 App Ktchn. All rights reserved.
import Foundation

class StoredWidgetData: Codable {
    
    let date: String
    let khel: Khel
    
    internal init(date: String, khel: Khel) {
        self.date = date
        self.khel = khel
    }
    
}
