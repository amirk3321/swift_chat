//
//  repository.swift
//  chat_swift
//
//  Created by MA on 25/10/2023.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI
import FirebaseFirestore



class Repository {
    
    var errorMessage = "";
    
    
    
    
    
    func signOut(){
        
        do {
           try FirebaseManger.shared.auth.signOut()
        } catch {
            
        }
       
        
    }
    
    func getCurrentUserId() -> String {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return ""}
        
        
        return uid;
    }
    
    
    func getCurrentUserInformation(uid : String,completion: @escaping (UserEntity) -> Void) {
        
        
        FirebaseManger.shared.firestore.collection("Users").document(uid)
            .getDocument {
                snapshot,err in
                
                
                if let err = err {
                    print("Failed to fatch current user",err)
                    return
                }
                
                
                guard let user = UserEntity.fromSnapshot(snapshot!) else {
                    return
                }
               
                print("fatch User successfully :",user)
                
                completion(user)
                
            }
        
        
        
    }
    
    
    func createNewAccount(user: UserEntity,onComplete : @escaping () -> Void) -> String {
        
        
         FirebaseManger.shared.auth.createUser(withEmail: (user.email)!, password: (user.password)!) {
            result, err in
            
            
            if let err = err {
                
                print("Failed to create user: ",err)
                
                self.errorMessage = "Failed to create user \(err)"
                return;
                
            }
            
            
            print("SuccessFully created user \(String(describing: result?.user.uid))")
            
            
            self.errorMessage = "SuccessFully created user \(result?.user.uid ?? "no uid")"
            
         
             self.presistImageToStorage(user:user,onComplete:onComplete)

            return;
            
        }
        
        return errorMessage;
        
    }
    
    func loginUser(email: String, password : String, listener: @escaping (_ message : String) -> Void, onComplete : @escaping () -> Void) -> String {
        
        
        FirebaseManger.shared.auth.signIn(withEmail: email, password: password) {
            
            result, err in
            
            
            if let err = err {
                
                
               
                self.errorMessage = "Failed to login user \(err)"
                listener(self.errorMessage)
                return;
            }
            
            
            
            print("Login Successfull")
            self.errorMessage = "Login Successfull \(result?.user.uid ?? "no uid")"
            
            listener(self.errorMessage)
            onComplete()
            return;
            
        }
        return "";
        
        
    }
    
    
    
    private func presistImageToStorage(user : UserEntity,onComplete : @escaping () -> Void) {
        
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return;
        }
        
        let storageRef = FirebaseManger.shared.storage.reference(withPath: uid)
        
        
        
        guard let imageData = user.image?.jpegData(compressionQuality: 0.5) else {return}
        
        
        storageRef.putData(imageData, metadata: nil) { metadata,err in
            
            
            if let err = err {
                
                print("Image uploading Errro \(err)")
                
                return;
            }
            
            
            storageRef.downloadURL {
                url, err in
                
                
                if let err = err {
                    
                    print("failed to retrive downloadURL \(err)")
                    return
                }
                
                print("Download Sucessfull \(url?.absoluteString ?? "")")
                
                guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {return}
                
                self.getInitilizeNewUser(user: UserEntity(name: user.name,email: user.email,password: user.password,uid: uid, imageUrl: url?.absoluteString ?? ""),onComplete: onComplete)
            }
            
        }
        
        
    }
    
    
    private func getInitilizeNewUser(user : UserEntity,onComplete: @escaping () -> Void){
        
     
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return
        }
        
        
        FirebaseManger.shared.firestore.collection("Users").document(uid)
            .setData(user.toDocument())
            
        onComplete()

    }
    
    
}


class FirebaseManger: NSObject {
    let auth : Auth
    let storage : Storage
    let firestore : Firestore
    
    static let shared  = FirebaseManger();
    
    override init(){
        
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init();
        
    }
}

