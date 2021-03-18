//
//  ForgotPassword.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-03.
//

import SwiftUI
import FirebaseAuth
struct ForgotPassword: View {
    internal var didAppear: ((Self) -> Void)? // 1.
    @Environment(\.presentationMode) var presentationMode
    @State var email:String = ""
    @State var showError:Bool = false
    @State var errorString:String = ""
    var body: some View {
        VStack() {
            Text("Instaframe")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.top)
                .padding(.bottom)
            Text("Enter your email and if we find it in our database, you will receive an email with instructions on how to reset your password.")
                .multilineTextAlignment(.center)
                .padding(.trailing, 10)
                .padding(.leading, 10)

            Spacer()
            Field(fieldStr: $email, imgSystemName: "envelope", fieldNameStr: "Email")
                .padding(.bottom)

            Text(errorString)
                .foregroundColor(.red)
                .lineLimit(3)
                .padding(.trailing, 10)
                .padding(.leading, 10)
            Spacer()
            HStack(spacing: 25) {
                
                Button(action: {resetPassword()}) {
                    Text("Reset Password")
                        .font(.system(size: 21, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 45)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3490196078, green: 0.3960784314, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.9647058824, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 22.5))
                        .shadow(color: Color(.black).opacity(0.3), radius: 10, x: 0, y: 4)
                    
                }
            }
            .padding(.bottom, 20)
            
        }
        .frame(width: 345, height: 450)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color(.black).opacity(0.3), radius: 20, x: 0, y: 4)
        .onAppear { self.didAppear?(self) } // 2.
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}

extension ForgotPassword{
    
    func resetPassword(){
        
        if(!validateEmail(enteredEmail: email)){
            self.showError.toggle()
            errorString = "Email Format Invalid."
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if(error != nil){
                errorString = error?.localizedDescription ?? ""
                self.showError.toggle()
            }
            if(error == nil){
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
    func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
}
