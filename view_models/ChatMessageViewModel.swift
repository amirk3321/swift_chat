//
//  ChatMessageViewModel.swift
//  chat_swift
//
//  Created by MA on 30/10/2023.
//

import Foundation
import Firebase



class ChatViewModel : ObservableObject {
    
    
    @Published var messageController = ""
    @Published var errorMessage = ""
    @Published var messages = [MessagesEntity]()

    @Published var scrollCounter = 0
    
    let chatUser : UserEntity?
    
    
    init(chatUser : UserEntity?) {
        self.chatUser = chatUser
        handleMessagesLoaded()
    }
    
    

    
    
    func handleMessagesLoaded() {
        
        guard let fromId = FirebaseManger.shared.auth.currentUser?.uid else {
            return
        }
        
        
        guard let toId = chatUser?.uid else {
            return
        }
        
       
        FirebaseManger.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestemp")
            .addSnapshotListener { querySnapshot, err in
                
                
                if let err = err {
                    
                    print("not fetching messages",err)
                    return
                }
                
                
                
        
                querySnapshot?.documentChanges.forEach({ change in
                    
                    if change.type == .added {
                        
                        
                        

                        let singleChatMessage = MessagesEntity.fromSnapshot(change.document)
                        self.messages.append(singleChatMessage!)
                    
                    }
                    
                
                })
                
                DispatchQueue.main.async {
                    self.scrollCounter += 1
                }
                
                
            }
        
        
    }
    
    func handleSendMessage() {
        guard let fromId = FirebaseManger.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {
            return
        }
        
        
        let documentId =
        FirebaseManger.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId).document().documentID;
        
        
        let newMessage = MessagesEntity(docId: documentId,fromId: fromId,toId: toId,message: messageController,timestemp: Timestamp()).toDocument();
        
        FirebaseManger.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document(documentId)
            .setData(newMessage) {
                err in
                
                
                if let err = err {
                    self.errorMessage = "Field to save message into firestore: \(err)"
                    print("Field to save message into firestore: \(err)")
                    return
                }
                self.persistRecentMessage()
                self.messageController = ""
                print("sender emssage send Successfully")
                self.scrollCounter += 1
          
            }
    
        
        FirebaseManger.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document(documentId)
            .setData(newMessage) {
                err in
                
            
                if let err = err {
                    self.errorMessage = "Field to save message into firestore: \(err)"
                    print("Field to save message into firestore: \(err)")
                    return
                }
                
                print("Receipent emssage send Successfully")
            }
    
        
    }

    
    private func persistRecentMessage() {
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {return}

        
        guard let toUid = chatUser?.uid else {return}
        
        
        let docuemntFrom = FirebaseManger.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toUid);
        
        
        let newRecentMessage  = RecentMessageEntity(
            fromUid: uid,
            toUid: toUid,
            profileUrl: chatUser?.imageUrl,
            email: chatUser?.email,
            name: chatUser?.name,
            timestemp: Timestamp(),
            message: messageController,
            docuemntId: docuemntFrom.documentID
        ).toDocument()
        
        
        let docuemntTo = FirebaseManger.shared.firestore
            .collection("recent_messages")
            .document(toUid)
            .collection("messages")
            .document(uid);
        
        docuemntFrom.setData(newRecentMessage) {err in
            
            
            if let err = err {
                
                print("set new recent message failed \(err)")
                self.errorMessage = "set new recent message failed \(err)"
                return
            }
        }
        
        
        docuemntTo.setData(newRecentMessage) {
            err in
            
            if let err = err {
                print("set new recent message failed \(err)")
                self.errorMessage = "set new recent message failed receipient \(err)"
                return
            }
            
        
            
        }
        
        
    }
    
    
}
