//
//  WelcomeView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-08.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        
        ZStack {
            
//            Image("Water35")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea(.all)
            VStack {
                Text("Instaframe")
                    .foregroundColor(.white)
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                Spacer();
            }.padding(.top, 100)
            Text("Welcome!\nLet's get you onboard.")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            HStack {
                Text("Swipe to Start")
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .foregroundColor(.white)
                Image(systemName: "arrow.right.square")
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .medium, design: .default))
                
            }
            .frame(width: 250, height: 50)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            .shadow(color: Color(.black).opacity(0.2), radius: 20, x: 0, y: 5   )
            .padding(.top, 200)
            
            
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
