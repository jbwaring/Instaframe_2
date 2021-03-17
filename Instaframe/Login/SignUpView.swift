//
//  SignUpView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-01.
//

import SwiftUI 
import FirebaseAuth

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email:String = ""
    @State var password:String = ""
    @State var password2:String = ""
    @State var username:String = ""
    @State var showAlert:Bool = false
    @State var errorDescription:String = ""
    
    var body: some View {
        VStack() {

            Text("Instaframe")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.top)
                .padding(.bottom)
            Text("Fill this form to create a new account.")

            Spacer()
            Field(fieldStr: $username, imgSystemName: "person", fieldNameStr: "Username")
                .padding(.bottom)
            Field(fieldStr: $email, imgSystemName: "envelope", fieldNameStr: "Email")
                .padding(.bottom)
            SecureTextField(fieldStr: $password, imgSystemName: "key", fieldNameStr: "Password")
                .padding(.bottom)
            SecureTextField(fieldStr: $password2, imgSystemName: "key", fieldNameStr: "Confirm Password")
            
            HStack{
                Text(passwordMatchCheck())
                PasswordMatchCheckColor()
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .shadow(color: Color(.black).opacity(0.2), radius: 10, x: 0, y: 4)
            }
            
            
            Spacer()
            HStack(spacing: 25) {
                
                Button(action: {createAccount()}) {
                    Text("Create Account")
                        .font(.system(size: 21, weight: .bold, design: .rounded))
                        .foregroundColor(showAccountCreateButton() ? Color(.white) : Color(.white).opacity(0.1))
                        .frame(width: 200, height: 45)
                        .background(LinearGradient(gradient: Gradient(colors: [showAccountCreateButton() ? Color(#colorLiteral(red: 0.3490196078, green: 0.3960784314, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.3490196078, green: 0.3960784314, blue: 1, alpha: 1)).opacity(0.1) , showAccountCreateButton() ? Color(#colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.9647058824, alpha: 1)) : Color(#colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.9647058824, alpha: 1)).opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 22.5))
                        .shadow(color: Color(.black).opacity(0.3), radius: 10, x: 0, y: 4)
                }
            }
            .padding(.bottom, 20)
            
        }
        .frame(width: 345, height: 615)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color(.black).opacity(0.3), radius: 20, x: 0, y: 4)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Account Creation Failed."), message: Text(errorDescription), dismissButton: .default(Text("OK")))
        })
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct Field: View {
    @Binding var fieldStr:String
    @State var imgSystemName:String
    @State var fieldNameStr:String
    var body: some View {
        HStack {
            Image(systemName: imgSystemName)
                .foregroundColor(Color(.blue).opacity(0.43))
                .frame(width: 30, height: 80)
            TextField(fieldNameStr, text: $fieldStr)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(width: 260, height: 80)
            
            
            
        }
        .padding(.leading, 40)
        .frame(width: 280, height: 62.5)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style:.continuous))
    }
}
struct SecureTextField: View {
    @Binding var fieldStr:String
    @State var imgSystemName:String
    @State var fieldNameStr:String
    var body: some View {
        HStack {
            Image(systemName: imgSystemName)
                .foregroundColor(Color(.blue).opacity(0.43))
                .frame(width: 30, height: 80)
            SecureField(fieldNameStr, text: $fieldStr)
                .textContentType(.oneTimeCode)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(width: 260, height: 80)
            
            
            
            
        }
        .padding(.leading, 40)
        .frame(width: 280, height: 62.5)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style:.continuous))
    }
}

extension SignUpView {
    func passwordMatchCheck() -> String {
        var str = "Password do not match."
        if(password==password2){
            str = "Password match."
        }
        if(password=="" && password2==""){
            str = ""
        }
        return str
    }
    func passwordMatchCheckBool() -> Bool {
        var str = false
        if(password==password2){
            str = true
        }
        if(password=="" && password2==""){
            str = false
        }
        return str
    }
    func PasswordMatchCheckColor() -> Color{
        var color = Color(.red)
        if(password==password2){
            color = Color(.green)
        }
        if(password=="" && password2==""){
            color = Color(.green).opacity(0)
        }
        return color
        
    }
    func checkUserUnique() -> Bool {
//        if(email != ""){   FOR NOW EMAIL IS NOT CHECKED !
//        Auth.auth().fetchSignInMethods(forEmail: email) { (array, error) in
//            print(error?.localizedDescription ?? "ERROR in checkUserUnique")
//            print(array)
//            }
//        }
        return true
    }
    
    func showAccountCreateButton() -> Bool {
        var answer = true
        if(!passwordMatchCheckBool() || !checkUserUnique()){
            answer = false
        }
        return answer
    }
    
    func createAccount() {
        if(!showAccountCreateButton()){
            return // Do nothing, the button is not shown
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if(error != nil){
                errorDescription = error?.localizedDescription ?? ""
                self.showAlert.toggle()
                self.password = ""
                self.password2 = ""
                }
            if(error == nil){
                
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }


        // The button was shown: Create the user's account.
    }
}
