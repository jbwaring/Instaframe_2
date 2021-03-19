//
//  LoginView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-01-28.
//

import SwiftUI
import Firebase
import Combine
struct LoginView: View {
    internal var didAppear: ((Self) -> Void)? // 1.
    internal let inspection = Inspection<Self>() // 1.
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var flag: Bool = false
    @State var alertMessage:String = "Something went wrong."
    @State var isLoading:Bool = false
    @State var isSuccessful:Bool = false
    @State var isFocused:Bool = false
    @State var showAlert:Bool = false
    @State var email:String = ""
    @State var password:String = ""
    @State var showingSignUp:Bool = false
    @State var showingResetPassword:Bool = false
    
    func Login(){
        //ADD HIDE KEYBOARD!
        self.isFocused = true
       // self.showAlert = true
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            self.isLoading = true
            
            if error != nil {
                self.alertMessage = error?.localizedDescription ?? ""
                self.showAlert = true
                self.isLoading = false
            } else {
                self.isSuccessful = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.isSuccessful = true
                    self.email = ""
                    self.password = ""
                    print("Current User ID:\(String(describing: Auth.auth().currentUser?.uid))")
                }
                
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                 
                Image("Water35")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                VStack {
                    Text("Instaframe")
                        .foregroundColor(.white)
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                    Spacer();
                }.padding(.top, 100)
                VStack(spacing: 25) {
                    
                    VStack {
                        VStack(spacing: 50) {
                            
                            LoginMainFields(email: $email, password: $password)
                            
                            
                            
                            
                            HStack(spacing: 25) {
                                
                                Button(action: {Login()}) {
                                    Text("Login")
                                        .font(.system(size: 21, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(width: 125, height: 45)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3490196078, green: 0.3960784314, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.9647058824, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                        .clipShape(RoundedRectangle(cornerRadius: 22.5))
                                        .shadow(color: Color(.black).opacity(0.3), radius: 10, x: 0, y: 4)
                                    
                                }

                            }
                            
                        }
                        .frame(width: 345, height: 315)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(color: Color(.black).opacity(0.3), radius: 20, x: 0, y: 4)
                    }
                    Button(action: {self.showingSignUp.toggle()}) {
                        Text("Don’t have an account yet? Create one now.")
                            .foregroundColor(Color(#colorLiteral(red: 0.2039215686, green: 0, blue: 1, alpha: 0.52)))
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(width: 260, height: 30)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color(.black).opacity(0.15), radius: 20, x: 0, y: 4)
                    }
                    
                    
                    Button(action: {self.showingResetPassword.toggle()}) {
                        Text("Forgot your password?")
                            .foregroundColor(Color(#colorLiteral(red: 0.2039215686, green: 0, blue: 1, alpha: 0.52)))
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(width: 140, height: 30)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color(.black).opacity(0.15), radius: 20, x: 0, y: 4)
                    }
                }
                
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Authentication Failed."), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .multiModal{  //Thanks davdroman this is so useful!
                
                $0.sheet(isPresented: $showingSignUp, content: {
                    SignUpView()
              
                  })
                $0.sheet(isPresented: $showingResetPassword, content: {
                    ForgotPassword()
              
                  })
            }
            .statusBar(hidden: true)
            .onAppear { self.didAppear?(self) } // 2.
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) } // 2.
            if isLoading {
                LoginLoadingView(userUUID: Auth.auth().currentUser!.uid)
            }
            
            
        }
        
        
        

        
        
    }
    
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}




struct LoginMainFields: View {
    @Binding var email:String
    @Binding var password:String
    var body: some View {
        ZStack {
            Path() { path in
                path.move(to: CGPoint(x: 0, y: 100))
                path.addLine(to: CGPoint(x: 400, y: 100))
            }
            .stroke(Color(#colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)).opacity(0.8), lineWidth: 1.2)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(Color(.blue).opacity(0.43))
                        .frame(width: 30, height: 80, alignment: .bottom)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .frame(width: 260, height: 80, alignment: .bottom)
                }
                .padding(.leading, 15)
                .padding(.bottom, 20)
                
                HStack {
                    Image(systemName: "key")
                        .foregroundColor(Color(.blue).opacity(0.43))
                        .frame(width: 30, height: 80, alignment: .top)
                    SecureField("Password", text: $password)
                        .frame(width: 260, height: 80, alignment: .top)
                }
                .padding(.leading, 15)
                .padding(.top, 20)
                
                
            }
            .padding(.leading, 20)
            
        }
        .frame(width: 280, height: 125)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style:.continuous))
    }
}

struct LoginWindowBackgroundView: View {
    var body: some View {
        ZStack {
            
            
            VStack(spacing: 20) {
//                LoginCarouselView(reversed: .constant(true))
//                LoginCarouselView(reversed: .constant(false))
//                LoginCarouselView(reversed: .constant(true))
            }
            Text("Instafame")
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .offset(y: -250)
                .shadow(color: Color(.black).opacity(0.83), radius: 20, x: 0, y: 3)
            
        }
    }
}

internal final class Inspection<LoginView> where LoginView: View {

    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (LoginView) -> Void]()

    func visit(_ view: LoginView, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
