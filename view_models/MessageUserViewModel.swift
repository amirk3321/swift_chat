//
//  MessageUserViewModel.swift
//  chat_swift
//
//  Created by MA on 28/10/2023.
//

import Foundation


class MessageUserViewModel : ObservableObject {
    
    
    @Published var users = [UserEntity]()
    @Published var errorMessage : String = ""
    
    init() {
        
        fetchListUsers()
        
    }
    
    private func fetchListUsers(){
        
        
        FirebaseManger.shared.firestore.collection("Users").getDocuments { querySnapshot, err in
        
            if let err = err {
                
                print("querySnapshot not working something wrong fetching users \(err)")
                
                
                self.errorMessage = "querySnapshot not working something wrong fetching users \(err)";
                return
            }
            
            
            querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                
                
                
                let userModels = UserEntity.fromSnapshot(queryDocumentSnapshot) ??  UserEntity(
                    name: "",email: "",uid:"",imageUrl: "")
                
                
                guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
                
                if (uid != userModels.uid){
                    self.users.append(userModels)
                }
               
            
                
            })
            
            
            
            
            
        }
        
        
    }
}
