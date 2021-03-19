//
//  OnBoardingView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-08.
//

import SwiftUI

struct OnBoardingView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var currentUser:InstaUser
    @State var newUser:Bool
    var body: some View {
  
            ZStack {
                Image("Water35")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                TabView{
                   
                WelcomeView()
                    
                OnBoardAccountCreate().environment(\.managedObjectContext, managedObjectContext)
                }.tabViewStyle(PageTabViewStyle())
            }
        
       

        
        
    }
    
}

//struct OnBoardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingView(currentUser: .constant(InstaUser()), newUser: true)
//    }
//}
