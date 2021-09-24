import Foundation
import Firebase

class Administrator {
    
    var alias = ""
    var id = ""

    init(withSnap: DataSnapshot) {
        alias = withSnap.childSnapshot(forPath: "alias").value as? String ?? "No alias"
        
    }
    
    init(alias: String) {
        self.alias = alias
    }
}
