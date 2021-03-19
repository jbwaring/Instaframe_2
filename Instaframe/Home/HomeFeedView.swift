//
//  HomeView.swift
//  Instaframe
//
//  Created by Mohsen lhaf on 2021-02-17.
//

import SwiftUI

struct HomeView: View {
    @State var showCard = false
    
    var body: some View {
        VStack {
            
            HStack (spacing: 20){
                Image("ProfilePic")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 75, alignment: .leading)
                
                VStack {
                    Text("6")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("Posts")
                    }
                
                VStack {
                    Text("1200")
                        .fontWeight(.bold)
                    Text("Followers")
                    }
                
                VStack {
                    Text("650")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("Following")
                    }
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            HStack {
                VStack (alignment : .leading){
                    Text("Andrew")
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("Engineering student at Concorida 🇨🇦")
                        
                    Text("Football fan ⚽")
                }
                .padding()
            
                Spacer()
            }
      
            Button(action:{}, label: {
               Text("Follow")
                .padding()
                .frame(width: 350, height: 40)
                .foregroundColor(.black)
                .background(Color.white)
                .border(Color.black, width: 3)
                
                .cornerRadius(10)
                    })
                   
            VStack{
                HStack (spacing: 20) {
                Image("Image 1")
                    .resizable()
                    .frame(width: 150, height: 130)
                    
                Image("Image 2")
                    .resizable()
                    .frame(width: 150, height: 130)
                }
                .onTapGesture {self.showCard.toggle()}
            
                HStack (spacing: 20) {
                    Image("Group2")
                    .resizable()
                    .frame(width: 150, height: 130)
                    Image("Group1")
                    .resizable()
                    .frame(width: 150, height: 130)
            }
            
                HStack (spacing: 20) {
                    Image("SmilingPic")
                    .resizable()
                    .frame(width: 150, height: 130)
                    Image("StadiumPic")
                    .resizable()
                    .frame(width: 150, height: 130)
            }
                
            }
            .padding()
        
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
