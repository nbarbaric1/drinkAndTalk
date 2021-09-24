import Foundation
import Firebase

class Player {
    
    var alias = ""

    init(withSnap: DataSnapshot) {
        alias = withSnap.childSnapshot(forPath: "alias").value as? String ?? "No alias"
    }
    
    init(alias: String) {
        self.alias = alias
    }
}
