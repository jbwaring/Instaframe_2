//
//  OnBoardAccountCreate.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-08.
//

import SwiftUI
import FirebaseAuth
import CoreData
struct OnBoardAccountCreate: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: InstaUser.fetchAllUsers())  var userList: FetchedResults<InstaUser>
    @State var username:String = ""
    @State var showAlert:Bool = false
    @State var errorDescription:String = ""
    @StateObject var viewModel:ViewModel = ViewModel()
    @State var showCameraView:Bool = false
    @State var currentUser:InstaUser = InstaUser()
    @State var selectedProfilePic:UIImage?
    @State var choosePicString:String = "Please choose your profile picture."
    @State var onBoardingFinished:Bool = false
    var actionSheetAvatar: ActionSheet {
        ActionSheet(title: Text("Change Avatar"), message: nil, buttons: [
            .default(Text("Choose from Camera Roll."), action: {
                viewModel.choosePhoto()
            }),
            .default(Text("Take a picture."), action: {
                viewModel.takePhoto()
            }),
            .cancel()
        ])
    }
    var body: some View {
        ZStack {
//            Image("Water35")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea(.all)
            VStack() {
                Text("Instaframe")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.top)
                    .padding(.bottom)
                Text("Let's create your profile.")
                
                Spacer()
                Field(fieldStr: $username, imgSystemName: "person", fieldNameStr: "Choose your username")
                    .padding(.bottom)
                Text(choosePicString)
                ZStack {
                    //
                    Image(uiImage: selectedProfilePic ?? UIImage(named: "sample_avatar")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .background(Color.white)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    Button(action: {self.showCameraView.toggle()}) {
                        Image(systemName: "pencil.circle")
                            .renderingMode(.original)
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 35)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color(.black).opacity(0.2), radius: 10, x: 0, y: 4)
                            .offset(x: 45, y: 58)
                        
                        
                    }
                    
                    
                }
                .frame(height: 150)
                
                HStack{
                    Text(userUniqueCheckString())
                    userUniqueCheckColor()
                        .frame(width: 15, height: 15)
                        .clipShape(Circle())
                        .shadow(color: Color(.black).opacity(0.2), radius: 10, x: 0, y: 4)
                }
                
                
                Spacer()
                HStack(spacing: 25) {
                    
                    Button(action: {createAccount()}) {
                        Text("Next")
                            .font(.system(size: 21, weight: .bold, design: .rounded))
                            .foregroundColor(showAccountCreateButton() ? Color(.white) : Color(.white).opacity(0.1))
                            .frame(width: 200, height: 45)
                            .background(LinearGradient(gradient: Gradient(colors: [showAccountCreateButton() ? Color(#colorLiteral(red: 0.3490196078, green: 0.3960784314, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.3490196078, green: 0.3960784314, blue: 1, alpha: 1)).opacity(0.1) , showAccountCreateButton() ? Color(#colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.9647058824, alpha: 1)) : Color(#colorLiteral(red: 0.5098039216, green: 0.3725490196, blue: 0.9647058824, alpha: 1)).opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 22.5))
                            .shadow(color: Color(.black).opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    .actionSheet(isPresented: $showCameraView, content: {
                        self.actionSheetAvatar
                        
                    })
                }
                .padding(.bottom, 20)
                
                
            }
            .frame(width: 345, height: 615)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.9764705882, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: Color(.black).opacity(0.3), radius: 20, x: 0, y: 4)
            .multiModal{
                $0.alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Account Creation Failed."), message: Text(errorDescription), dismissButton: .default(Text("OK")))
                })
            
                $0.sheet(isPresented: $viewModel.isPresentingImagePicker, onDismiss: {updateProfilePic()}, content: {
                    ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
                })
            }
            if onBoardingFinished {
                LoginLoadingView(userUUID: Auth.auth().currentUser!.uid)
            }
        }
        
        
    }
}


struct OnBoardAccountCreate_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardAccountCreate()
    }
}

extension OnBoardAccountCreate {
    
    func updateProfilePic() {
        self.selectedProfilePic = viewModel.selectedImage
        self.choosePicString = "You can still modify the picture before proceeding."
    }
 
    func checkUserUnique() -> Bool {
        for user in userList {
            if(user.userName == username){
                return false
            }
        }
        return true
    }
    
    func showAccountCreateButton() -> Bool {
        var answer = false
        if(userUniqueCheckColor()==Color(.green) && selectedProfilePic != nil){ //Best compare statement ever. If colors looks good let's execute LOL.
            answer = true
        }
        return answer
    }
    func userUniqueCheckString() -> String{
        if(!checkUserUnique() && username != ""){
            return "This username is already taken."
        }
        if(username.count < 6){
            return "Username should be\n at least 6 characters"
        }
        if(username == ""){
            return ""
        }
        
        return "This username is available."
        
    }
    func userUniqueCheckColor() -> Color {
        if(!checkUserUnique() || username.count < 6){
            return Color(.red)
        }
        
        return Color(.green)
    }
    func createAccount() {
        if(!showAccountCreateButton()){
            return // Do nothing, the button is not shown
        }
        
        // The button was shown: Create the user's Profile.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newUser = InstaUser(context: context)
        newUser.userName = username
        newUser.avatar = selectedProfilePic!.pngData()
        newUser.userID = Auth.auth().currentUser!.uid
        newUser.onBoard = true
        do {
            try context.save()
            print("saved newUser and newUser is Onboard! Welcome to Instaframe \(newUser.userName ?? "NotSet!")")
            self.onBoardingFinished = true
            
            
        } catch {
            print(error)
            fatalError()
        }
        
    }
    
    
    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        @Published var usingCamera = false
        private(set) var sourceType: ImagePicker.SourceType = .camera
        
        
        
        
        func choosePhoto() {
            
            sourceType = .photoLibrary
            isPresentingImagePicker = true
        }
        
        func takePhoto() {
            sourceType = .camera
            usingCamera = true
            isPresentingImagePicker = true
        }
        
        func didSelectImage(_ image: UIImage?) {
            selectedImage = image
            isPresentingImagePicker = false
            usingCamera = false
            
            
        }
        
        
    }
    
    
    
    
}
