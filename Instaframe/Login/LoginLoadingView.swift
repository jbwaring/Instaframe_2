//
//  LoginLoadingView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-07.
//
import SwiftUI
import FirebaseAuth

let autoOnboard = false //Once Onboarding is setup set to false !


struct LoginLoadingView:View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var goHome:Bool = false
    @State var comeOnBoard:Bool = false
    @State var requestCount:Int = 0
    @State var newUser:Bool = false
    @FetchRequest(fetchRequest: InstaUser.fetchAllUsers())  var userList: FetchedResults<InstaUser>
    @State var userUUID:String
    @State var currentUser:InstaUser = InstaUser()
    var body: some View{
        
        VStack {
            LottieView(filename: "9561-loading-unicorn")
                .frame(width: 200, height: 200)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(color: Color(.black).opacity(0.3), radius: 20, x: 0, y: 4)
                .onAppear(perform: {
                    FindUser()
                })
            
        }.multiModal{  //Thanks davdroman this is so useful!
            
            $0.fullScreenCover(isPresented: $goHome, content: {
                Home(currentUser: $currentUser).environment(\.managedObjectContext, managedObjectContext)
            })
            $0.fullScreenCover(isPresented: $comeOnBoard, content: {
                OnBoardingView(currentUser: $currentUser, newUser: newUser).environment(\.managedObjectContext, managedObjectContext)
            })
            
        }
        
        
        
    }
}

struct LoginLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoginLoadingView(userUUID: "41GGSuWgdaNT2QQ7ajki2PVX8qo1")
    }
}

extension LoginLoadingView {
    
    func FindUser(){
        
        self.requestCount += 1
        var found:Bool = false
        print(userList.count)
        for user in userList {
            print("\(String(describing: user.userID))")
            if user.userID == userUUID {
                print("FOUND THEM")
                found = true
                currentUser = user

                print("Inside currentUser \(String(describing: currentUser.userID))")
                if(autoOnboard){
                    currentUser.onBoard = true
                }
                if(currentUser.onBoard == true){
                    self.goHome = true
                }else{
                    self.comeOnBoard = true
                }
            }
        }
        if(found == false && requestCount < 15){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                FindUser()
            }
        }
        if(found == false && requestCount == 15){
            print("Let's create the user!")
            self.newUser = true
            self.comeOnBoard = true
        }
    }
}

