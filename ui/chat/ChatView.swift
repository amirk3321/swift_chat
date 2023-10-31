//
//  ChatView.swift
//  chat_swift
//
//  Created by MA on 30/10/2023.
//

import SwiftUI


struct ChatView: View {
    
    let user : UserEntity?
    
    init(user: UserEntity?) {
        self.user = user
        self.vm = .init(chatUser: user)
    }
    @ObservedObject var vm : ChatViewModel
    
    var body: some View {
        
        
        VStack {
            messageLayout
            textfieldLayout
          
        }
        
        
    }
    
    private var textfieldLayout : some View {
        HStack {
            
            Image(systemName: "photo.circle")
                .font(.system(size: 30))
                .foregroundColor(.gray)
            TextField("Enter something",text: $vm.messageController)
            Button {
                
                vm.handleSendMessage()
                
            } label : {
                Text("Send").foregroundColor(.white)
                    .padding(.horizontal,10)
                    .padding(.vertical, 4)
                
                
            }.background(Color.blue)
                .cornerRadius(8)
                
            
        }.padding(.horizontal)
            .padding(.vertical,8)
    }
    
    private var messageLayout : some View {
        
       
        ScrollView {
            
            
            ScrollViewReader {
                scrollViewControllerProxy in
                
                ForEach (vm.messages) { message in
                
                    
                    MessageLayout(message:message)
                
                
                }
                HStack {
                    Spacer()
                }.id("scrollB")
                    .onReceive(vm.$scrollCounter) {
                        _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewControllerProxy.scrollTo("scrollB", anchor: .bottom)
                        }
                 
                    }
            }
          
            
        }.background(Color(.init(white:0.95,alpha: 1)))
            .navigationTitle(Text(user?.email ?? "Messages")).navigationBarTitleDisplayMode(.inline)
           
    
        
    }
    
    
    

    
}

struct MessageLayout : View{
    
    let message : MessagesEntity;
    
    var body: some View {
        VStack {
            
            
            if (message.fromId == FirebaseManger.shared.auth.currentUser?.uid){
                
                HStack {
                    Spacer()
                    HStack {
                         
                        Text(message.message ?? "")
                            .foregroundColor(.white)
                        
                    }.padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                    
                }
                
            }else{
                HStack {
               
                    HStack {
                         
                        Text(message.message ?? "")
                            .foregroundColor(.black)
                        
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                }
            }

            
        }.padding(.horizontal)
            .padding(.top, 8)
    }
    
    
    
    
}

#Preview {
//    NavigationView {
//        ChatView(user: .init(name:"john",email: "john@gmail.com",uid: "NurQb2vmgqM14CVzNVbPtmMoMyI2"))
//    }
    MessageView()
    //MessageView()
}
