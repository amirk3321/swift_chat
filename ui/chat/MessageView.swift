//
//  MessageView.swift
//  chat_swift
//
//  Created by MA on 26/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MessageView: View {
    
    @State var shouldShowLogoutOption : Bool = false
    @State var loginToSingleChatView : Bool = false
    
    
    @ObservedObject var vm = MessagesViewModel()
    

    
    var body: some View {
        NavigationView {
            VStack {
              
                customNavBar
                usersScrollControllerList
                messagingButton
                
                NavigationLink("",isActive: $loginToSingleChatView) {
                    ChatView(user: self.user)
                }
                
            }
           
            
            
        }.navigationTitle("Messages")
    }
    
    
    private var customNavBar : some View {
        HStack(spacing:16){
            
            WebImage(url: URL(string: vm.user?.imageUrl ?? ""))
                .frame(width: 45,height: 45)
                .padding(4)
                .cornerRadius(45)
                .overlay(RoundedRectangle(cornerRadius: 34).stroke(.black,lineWidth: 1))
//            Image(systemName: "person.fill").font(.system(size: 34,weight: .heavy))
//                .frame(width: 45,height: 45)
//                .padding(4)
//                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black, lineWidth: 1))
            
            
            VStack (alignment: .leading,spacing: 4) {
                
                Text("\(vm.user?.name ?? "")").font(.system(size: 24))
                HStack {
                    
                    Circle().foregroundColor(.green)
                        .frame(width: 14,height: 14)
                    
                    Text("\(vm.user?.email ?? "")").font(.system(size: 12)).foregroundColor(Color(.lightGray))
                }
                
            }
            Spacer()
            
            Button {
                
                shouldShowLogoutOption.toggle()
                
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24,weight: .bold))
                    .foregroundColor(Color(.label))
            }
            
        }.padding()
            .actionSheet(isPresented: $shouldShowLogoutOption) {
                .init(title: Text("Settings"),message: Text("What do you want to do?"),buttons: [
                    .destructive(Text("Sign Out"),action: {
                        vm.handleSignout()
                    }),
                    Alert.Button.cancel()
                    
                ])
            }.fullScreenCover(isPresented: $vm.isUserSignIn,onDismiss: nil) {
                LoginView {
                    self.vm.isUserSignIn = false
                    self.vm.fetchCurrentUser()
                }
            }
    }
    
    private var usersScrollControllerList : some View {
        ScrollView {
            
            ForEach (vm.recentMessagesList) { message in
                
                NavigationLink {
                    
                    Text("Chat Page")
                    
                } label: {
                    VStack {
                        HStack(spacing:22) {
                            
                            
                            WebImage(url: URL(string: message.profileUrl ?? ""))
                                .frame(width: 45,height: 45)
                                .padding(4)
                                .cornerRadius(45)
                                .overlay(RoundedRectangle(cornerRadius: 34).stroke(.black,lineWidth: 1))
                            
                            
                            VStack (alignment:.leading) {
                                Text(message.email ?? "")
                                    .font(.system(size: 18).bold())
                                
                                Text(message.message ?? "")
                                    .font(.system(size: 14)).foregroundColor(Color(.lightGray))
                                
                            }
                            
                            Spacer()
                       
                                
                         
                            
                            Text(formatDateFromFirestore(timestamp: message.timestemp!))
                        }
            
                        Divider()
                        
                    }.padding(.horizontal,15)
                }
                
            }.padding(.bottom,50)
          
            
        }
    }
    
    @State var messagesScreenNavigation = false
    
    
    func formatDateFromFirestore(timestamp: Timestamp) -> String{
        let date = timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // Your desired format
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    private var messagingButton : some View {
        Button{
            messagesScreenNavigation.toggle()
        } label: {
            HStack {
                
                
                Spacer()
                Text("+ New Messages")
                    .font(.system(size: 16,weight: .bold))
                Spacer()
                
            }.foregroundColor(.white)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 30)
            
        }.fullScreenCover(isPresented: $messagesScreenNavigation, onDismiss: nil, content: {
            SingleMessageView(didSelectNewUser: {
                user in
                print(user.email!)
                self.loginToSingleChatView.toggle()
                self.user = user
                self.vm.handleRecentMessagesLoaded()
            })
        })
    }
    
    @State var user : UserEntity?
}

#Preview {
    MessageView()
}
