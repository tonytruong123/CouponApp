//
//  LoginView.swift
//  CouponApp
//
//  Created by Hoa Truong on 1/10/23.
//

import SwiftUI
import PhotosUI

struct LoginView: View {
    // MARK: user Details
    @State var emailID: String = ""
    @State var password: String = ""
    // MARK: View Properties
    @State var createAccount: Bool = false
    var body: some View {
        VStack(spacing: 10){
            Text("Lets sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome Back, \nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Email", text:$emailID)
                    .textContentType(.emailAddress)
                    .border(_width: 1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                SecureField("Password", text:$password)
                    .textContentType(.emailAddress)
                    .border(_width: 1, .gray.opacity(0.5))
                
                Button("Reset password?", action: {})
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button {
                    
                } label: {
                    //MARK: Login Button
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top, 10)
            }
            
            // Mark: reigster button
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now") {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        // MARK: register view via sheets
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
    }
}

// Mark: Register View
struct RegisterView: View{
    // Mark: user details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    // MARK: View properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    var body: some View{
        VStack(spacing: 10){
            Text("Lets Register \nAccount")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Hello user, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            // Mark: For Smaller Size Optimization
            ViewThatFits{
                ScrollView(.vertical, showsIndicators: false){
                    HelperView()
                }
                HelperView()
            }
            
            // Mark: reigster button
            HStack{
                Text("Already Have An Account")
                    .foregroundColor(.gray)
                
                Button("Login Now") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            // Mark: extracting UIImage from PhotoItem
            if let newValue{
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        // Mark: UI must be updated on main thread
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    }catch{}
                }
            }
        }
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                     Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image("fall-leaves")
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top,25)

            
            TextField("Username", text:$userName)
                .textContentType(.emailAddress)
                .border(_width: 1, .gray.opacity(0.5))
                            
            TextField("Email", text:$emailID)
                .textContentType(.emailAddress)
                .border(_width: 1, .gray.opacity(0.5))
            
            SecureField("Password", text:$password)
                .textContentType(.emailAddress)
                .border(_width: 1, .gray.opacity(0.5))
            
            TextField("About you", text:$userBio,axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(_width: 1, .gray.opacity(0.5))
            
            TextField("Bio Link (Optional)", text:$userBioLink)
                .textContentType(.emailAddress)
                .border(_width: 1, .gray.opacity(0.5))
            
            Button {
                
            } label: {
                //MARK: Login Button
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .padding(.top, 10)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: View Extensions For UI Building

extension View{
    func hAlign(_ alignment: Alignment)-> some View {
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)-> some View {
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    
    //Mark: custom border view with padding
    func border(_width: CGFloat,_ color: Color)->some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: _width)
            }
    }
    
    //Mark: custom fill view with padding
    func fillView(_ color: Color)->some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}
