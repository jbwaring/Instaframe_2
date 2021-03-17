//
//  CardView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-01-20.
//

import SwiftUI

struct CardView: View {
    @State var preview:Bool = false
    @State var lovedCard:Bool = false
    @State var post:InstaframePost
    @State var shareImage : [UIImage] = []
    func shareSheet() {
            let data = shareImage.first ?? UIImage()
            let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: post.image ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 240, height: 310, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            VStack {
                
                    
                Spacer()
                HStack{
                    Image("sampleimage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 2)
                    Text(post.userID ?? "nil")
                    Spacer()
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 15)
                HStack {
                    if !preview {
                        Button(action: {self.lovedCard.toggle()}) {
                            Image(systemName: lovedCard ? "heart.fill" : "heart")
                                .font(.system(size: 21))
                                .foregroundColor(lovedCard ? Color.red : Color.black)
                        }
                    } else {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 21))
                            .foregroundColor(Color.black.opacity(0.5))
                        
                    }
                    
                    Spacer()
                    if !preview {
                        Button(action: {
                            // Add Message View
                        }) {
                            Image(systemName: "message")
                                .font(.system(size: 21))
                                .foregroundColor(.black)
                            
                        }
                    } else {
                        Image(systemName: "message")
                            .font(.system(size: 21))
                            .foregroundColor(Color.black.opacity(0.5))
                        
                    }
                    
                    Spacer()
                    
                    if !preview {
                        Button(action: {
                            shareImage.removeAll()
                            shareImage.append(UIImage())

                            shareSheet()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 21))
                                .foregroundColor(.black)
                        }
                    } else {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 21))
                            .foregroundColor(Color.black.opacity(0.5))
                        }
//                    .sheet(isPresented: $showingSheet, content: {
//                        ShareSheet(items: shareItems)
//                    })
                    
                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            
        }
        .frame(width: 240, height: 420)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 2)
        
    }
}


