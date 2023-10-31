//
//  RecentMessageEntity.swift
//  chat_swift
//
//  Created by MA on 30/10/2023.
//

import Foundation
import Firebase


class RecentMessageEntity : Identifiable {
    
    var id : String {toUid!}
    
    var fromUid : String?
    var toUid : String?
    var profileUrl : String?
    var email : String?
    var name : String?
    var timestemp : Timestamp?
    var message: String?
    var docuemntId: String?
    
    init( fromUid: String? = nil, toUid: String? = nil, profileUrl: String? = nil, email: String? = nil, name: String? = nil,timestemp : Timestamp? = nil,message : String?,docuemntId: String?) {
    
        self.fromUid = fromUid
        self.toUid = toUid
        self.profileUrl = profileUrl
        self.email = email
        self.name = name
        self.timestemp = timestemp
        self.message = message
        self.docuemntId = docuemntId
    }
    
    
    
    func toDocument() -> [String : Any] {
        return [
    
            "fromUid" : fromUid!,
            "toUid" : toUid!,
            "profileUrl" : profileUrl!,
            "email" : email!,
            "name" : name!,
            "timestemp" : timestemp!,
            "message" : message!,
            "docuemntId" : docuemntId!
        ]
    }
    
    static func fromSnapshot(_ snapshot : DocumentSnapshot) -> RecentMessageEntity?{
        
        
        
        guard let snapshotData = snapshot.data() else {return nil}
        
        
        
        guard
           
            let fromUid = snapshotData["fromUid"] as? String,
            let toUid = snapshotData["toUid"] as? String,
            let profileUrl = snapshotData["profileUrl"] as? String,
            let email = snapshotData["email"] as? String,
            let name = snapshotData["name"] as? String,
            let timestemp = snapshotData["timestemp"] as? Timestamp,
            let message = snapshotData["message"] as? String,
            let docuemntId = snapshotData["docuemntId"] as? String
        else {
           return nil
        }
        
        
        return RecentMessageEntity(

            fromUid: fromUid,
            toUid: toUid,
            profileUrl: profileUrl,
            email: email,
            name: name,
            timestemp: timestemp,
            message: message,
            docuemntId: docuemntId
        )
    }
    
    
    
}
