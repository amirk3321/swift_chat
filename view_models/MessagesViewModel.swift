//
//  MessagesViewModel.swift
//  chat_swift
//
//  Created by MA on 27/10/2023.
//

import Foundation
import SwiftUI
import Firebase


class MessagesViewModel : ObservableObject {
    
    
    @Published var errorMessage = ""
    @Published var user : UserEntity?
    @Published var isUserSignIn = false
    @Published var recentMessagesList = [RecentMessageEntity]()
    
    private var repository = Repository();
    private var firebaseListner  : ListenerRegistration?
 
    
    init() {
        
        
        DispatchQueue.main.async {
            
            self.isUserSignIn = FirebaseManger.shared.auth.currentUser?.uid == nil
            
        }
        
        fetchCurrentUser()
        handleRecentMessagesLoaded()
    }
    
    
    func handleRecentMessagesLoaded(){
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return
        }
        
        self.firebaseListner?.remove()
        recentMessagesList.removeAll();
        
        
        firebaseListner = FirebaseManger.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestemp")
            .addSnapshotListener { querySnapshot, err in
                
                
                if let err = err {
                    self.errorMessage = "Field to load reacet message into firestore: \(err)"
                    print("Field to load reacet message into firestore: \(err)")
                    return
                }
                
             
                querySnapshot?.documentChanges.forEach({ change in
                    
                    
                   let recentMessages = RecentMessageEntity.fromSnapshot(change.document)
                    
                    if let index = self.recentMessagesList.firstIndex(where: { rme in
                        
                        return rme.docuemntId == recentMessages?.docuemntId
                    }) {
                        self.recentMessagesList.remove(at: index)
                    }
                    
                    
                    self.recentMessagesList.insert(recentMessages!, at: 0)
                  
                    
                    
                })
                
            }
                
                
                
            
        
        
    }
    
    func handleSignout(){
        isUserSignIn.toggle()
        print(isUserSignIn)
        repository.signOut()
    }
    
     func fetchCurrentUser() {
        
        errorMessage = "Fetching Users"
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return
        }
        
        
        print(uid)
        
        FirebaseManger.shared.firestore.collection("Users").document(uid)
            .getDocument {
                snapshot,err in
                
                
                if let err = err {
                    print("Failed to fatch current user",err)
                    return
                }
                
                
                
//                guard let data = snapshot?.data() else {
//                    return
//                }
//
//                let uid = data["uid"] as? String ?? ""
//                let name = data["name"] as? String ?? ""
//                let imageUrl = data["imageUrl"] as? String ?? ""
//                let email = data["email"] as? String ?? ""
//                
//                self.user = UserEntity(name:name,email: email,uid: uid,imageUrl: imageUrl)
                
                self.user = UserEntity.fromSnapshot(snapshot!) ?? UserEntity(
                    name: "",email: "",uid:"",imageUrl: "")
               
                //print("fatch User successfully :",user)
                
                
               // self.user = userModel
                
            }
        
        
    }
    
    
}
