//
//  ContentView.swift
//  chat_swift
//
//  Created by MA on 25/10/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    
    let didCompleteLoginProcess : () -> ()
    
    @State private var isLoginMode = false
    @State private var emailController = ""
    @State private var passwordController = ""
    @State private var loginStatus = "No Login Yet"
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    
    
    var body: some View {
        
            
        
        NavigationView {
            ScrollView {
               
                VStack {
                    
                    Picker(selection: $isLoginMode, label: Text("Picker Here")) {
                        
                        
                        Text("Login")
                            .tag(true)
                        
                        Text("Create Account")
                            .tag(false)
                        
                        
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    
                    if !isLoginMode {
                        Button{
                            
                            shouldShowImagePicker.toggle()
                            print(shouldShowImagePicker)
                            
                            
                        } label: {
                            
                            
                            
                            VStack {
                                
                                
                                if let image = self.image {
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100,height:100)
                                        .cornerRadius(64)
                                        
                                    
                                }else {
                                    Image(systemName: "person.fill").font(.system(size: 64))
                                        .foregroundColor(.black)
                                }
                                
                                
                            }.overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.black,lineWidth: 3)).contentMargins(10)
                            
                            
                           
                        }
                        
                    }
                    
                    Group {
                        
                        
                        TextField("Email",text: $emailController)
            
                            .keyboardType(.emailAddress)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                         
                        SecureField("Password",text: $passwordController)
                           
                    }.padding(12)
                        .background(Color.white)
                    
                
                    
                    Button {
                        
                        
                        handleAction()
                        
                        
                    } label : {
                        HStack {
                            
                            Spacer()
                            Text(isLoginMode ? "Log In" :"Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14,weight:.semibold))
                            Spacer()
                            
                        }.background(.blue)
                    }.padding()
                    
                
                    Text(loginStatus)
                    
                    
                }.padding()
                
            }.navigationTitle(isLoginMode ? "Log In": "Create Account")
                .background(Color(.init(white:0,alpha: 0.05)))
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    
                    
                    ImagePicker(image: $image)
                    
                }
                
        }

      
    }
    
    
    private func handleAction(){
        
        let repository = Repository()
        if (isLoginMode) {
            
            print("Submit Login 001")
            
            let response = repository.loginUser(email: emailController, password: passwordController) {
                errorMessage in
                loginStatus = errorMessage
            } onComplete: {
                didCompleteLoginProcess()
            }
            
            print(response)
            
        }else{
            
            
            if self.image == nil {
                
                loginStatus = "Select Avator Image"
                return
            }
            
            
            let response =  repository.createNewAccount(user: UserEntity(name: "test",email: emailController,password: passwordController,image: self.image)) {
                didCompleteLoginProcess()
            }
            
            
            loginStatus = response
            
            print("Submit create acccount 001",response)
            
        }
        
        
    }
    
}

#Preview {
    LoginView(didCompleteLoginProcess: {})
}
