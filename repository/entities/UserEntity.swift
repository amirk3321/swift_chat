//
//  UserEntity.swift
//  chat_swift
//
//  Created by MA on 27/10/2023.
//

import Foundation
import SwiftUI
import Firebase

struct UserEntity : Identifiable{
    
    var id: String {uid!}
    
    
    
    var name : String?
    var email : String?
    var password : String?
    var uid : String?
    var image: UIImage?
    var imageUrl : String?
    
    init(name: String? = nil, email: String? = nil, password: String? = nil, uid: String? = nil, image: UIImage? = nil, imageUrl : String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.uid = uid
        self.image = image
        self.imageUrl = imageUrl
    }
    
    
    func toDocument() -> [String: Any] {
        
        return [
            "email":email!,
            "uid":uid!,
            "name":name!,
            "imageUrl":imageUrl!
            
        ]
        
    }
    
    
    static func fromSnapshot(_ snapshot : DocumentSnapshot) -> UserEntity? {
        
        guard let snapshotData = snapshot.data() else {
            return nil
        }
        
        guard let name = snapshotData["name"] as? String,
              let email = snapshotData["email"] as? String,
              let uid = snapshotData["uid"] as? String,
              let imageUrl = snapshotData["imageUrl"] as? String else {
            return nil
        }
        
        
        return UserEntity(
            name: name ,email: email ,uid: uid , imageUrl: imageUrl )
        
    }
    
    
    
}
