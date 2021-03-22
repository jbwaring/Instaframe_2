//
//  CardView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-01-20.
//

import SwiftUI

struct CardView: View {
    @State var preview:Bool = false
    @State var lovedCard:Bool
    @State var post:InstaframePost
    @State var currentUser:InstaUser
    @State var showUserHome:Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequestPosts: FetchRequest<InstaUser>
    @State var shareImage : [UIImage] = []
    func shareSheet() {
            let data = shareImage.first ?? UIImage()
            let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }

    init(username:String, postGiven:InstaframePost, currentUserGiven: InstaUser) {
        fetchRequestPosts = FetchRequest<InstaUser>(entity: InstaUser.entity(), sortDescriptors: [], predicate:NSPredicate(format: "userName == %@", username))
        _post = .init(initialValue: postGiven)
        _currentUser = .init(initialValue: currentUserGiven)
        _lovedCard = .init(initialValue: false)
    }
    var body: some View {


        VStack {
            Image(uiImage: UIImage(data: post.image ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                .resizable()
                .rotationEffect(.degrees(90))
                .aspectRatio(contentMode: .fill)
                .frame(width: 240, height: 310, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            VStack {



                HStack{
                    Image(uiImage: UIImage(data: fetchRequestPosts.wrappedValue.first?.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 2)
                    Text(post.userID ?? "nil")
                    Button(action: {
                        self.showUserHome.toggle()

                    }) {
                        Image(systemName: "eye")
                            .font(.system(size: 21))
                            .foregroundColor(Color.blue)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 15)

                HStack {
                    Text("\(post.likeCount) likes.")

                }
                HStack {
                    if !preview {
                        Button(action: {
                                self.lovedCard.toggle()
                                tapLikeButton()

                        }) {
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
        .frame(width: 240, height: 600)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 2)
        .onAppear(perform: {
            isPostInitialyLiked()
        })
        .sheet(isPresented: $showUserHome, content: {
            HomeFeedView(username: post.userID ?? "", currentuser: currentUser).environment(\.managedObjectContext, managedObjectContext)
        })

    }
}

extension CardView {

   func tapLikeButton() {

    if self.lovedCard == true {
        print("Adding Like")
        post.likeCount = post.likeCount+1;
        var postLikeUsers = post.likeUsers?.components(separatedBy: "\n")
        postLikeUsers?.append(currentUser.userName ?? "")
        post.likeUsers = postLikeUsers?.joined(separator: "\n")
        print("postLikeUsers: \(String(describing: postLikeUsers))")
        print("post.likeUsers: \(post.likeUsers ?? "")")

    }
    if self.lovedCard == false {
        print("Removing Like")
        var postLikeUsers = post.likeUsers?.components(separatedBy: "\n")

        if let index = postLikeUsers?.firstIndex(where: { $0 == currentUser.userName ?? "" }) {
            postLikeUsers?.remove(at: index)
        }
        post.likeUsers = postLikeUsers?.joined(separator: "\n")
        print("postLikeUsers: \(String(describing: postLikeUsers))")
        print("post.likeUsers: \(post.likeUsers ?? "")")
        post.likeCount = post.likeCount-1;
    }
    saveItems()

    }


   func saveItems() {
        do {
            try managedObjectContext.save()
            print("saved Item")
        } catch {
            print(error)
        }
    }

    func isPostInitialyLiked(){
        var postLikeUsers = post.likeUsers?.components(separatedBy: "\n")
        if let index = postLikeUsers?.firstIndex(where: { $0 == currentUser.userName ?? "" }) {
            //Current User has liked this post.
            self.lovedCard = true
        }

    }

}

