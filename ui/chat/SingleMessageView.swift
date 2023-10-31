//
//  SingleMessageView.swift
//  chat_swift
//
//  Created by MA on 28/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI




struct SingleMessageView: View {
    
    
    let didSelectNewUser : (UserEntity) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var vm = MessageUserViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                ForEach (vm.users) {
                    user in
                    
                    Button {
                        presentationMode.wrappedValue.dismiss();
                        
                        didSelectNewUser(user)
                      
                        
                    } label: {
                        HStack {
                            WebImage(url: URL(string: user.imageUrl ?? "")).resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .overlay(RoundedRectangle(cornerRadius: 34).stroke(Color.black, lineWidth: 3.0))
                                .cornerRadius(45)
                        
                            VStack(alignment:.leading) {
                                Text("\(user.name ?? "")").font(.system(size: 18,weight: .bold))
                                Text("\(user.email ?? "")")
                            
                            }
                            Spacer()
                           
                        }.padding(.horizontal, 10).foregroundColor(Color(.label))
                    }
                    Divider().padding(.vertical,8).padding(.horizontal,8)
                   
                }
                
            }.navigationTitle(Text("Messages"))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        
                    }
                    
                }
            
        }
    
    }
}

#Preview {
    SingleMessageView(didSelectNewUser: {
        user in
    })
    //MessageView()
}
