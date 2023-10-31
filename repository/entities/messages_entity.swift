//
//  messages_entity.swift
//  chat_swift
//
//  Created by MA on 30/10/2023.
//

import Foundation
import Firebase


struct MessagesEntity : Identifiable{
    
    var id : String {docId!}
    
    var docId : String?
    var fromId : String?
    var toId : String?
    var message : String?
    var timestemp : Timestamp?
    
    
    
    init(docId : String? = nil,fromId: String? = nil, toId: String? = nil, message: String? = nil, timestemp: Timestamp? = nil) {
        self.docId = docId
        self.fromId = fromId
        self.toId = toId
        self.message = message
        self.timestemp = timestemp
    }
    
    
    
    func toDocument() -> [String : Any] {
        
        
        return [
            "docId" : docId!,
            "fromId" : fromId!,
            "toId" : toId!,
            "message" : message!,
            "timestemp" : timestemp!,
            
        ]
        
    
    }
    
    
    static func fromSnapshot(_ snapshot : DocumentSnapshot) -> MessagesEntity? {
        
        
        
        guard let snapshotData = snapshot.data() else {
            return nil
        }
        
        guard 
            let docId = snapshotData["docId"] as? String,
            let fromId = snapshotData["fromId"] as? String,
            let toId = snapshotData["toId"] as? String,
            let message = snapshotData["message"] as? String,
            let timestemp = snapshotData["timestemp"] as? Timestamp
        else {
            return nil
        }
        
        return MessagesEntity(docId: docId,
            fromId: fromId,toId: toId,message: message,timestemp: timestemp
)
              
    }
    
    
    
    
    
}
