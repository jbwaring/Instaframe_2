//
//  HomeView.swift
//  Instaframe
//
//  Created by Mohsen lhaf on 2021-02-17.
//

import SwiftUI

struct HomeFeedView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showCard = false
    var fetchRequestPosts: FetchRequest<InstaframePost>
    var fetchRequestUser: FetchRequest<InstaUser>
    @State var currentUser:InstaUser
    @State var show:Bool = false
    @State var showFollowView:Bool = false
    @State var isCurrentUser:Bool
    @State var descriptionStateString:String
    @State var followStr = "Follow"
    init(username: String, currentuser: InstaUser){

        let userFollowList = currentuser.followingUsers?.components(separatedBy: "\n") ?? [""]

        var predicatesFollowing: [NSPredicate] =  []
        for username in userFollowList {
            predicatesFollowing.append(NSPredicate(format: "userID == %@", username))
        }
        predicatesFollowing.append(NSPredicate(format: "userID == %@", currentuser.userName ?? ""))
        let fetchRequestPredicate:NSPredicate  = NSCompoundPredicate(orPredicateWithSubpredicates: predicatesFollowing )

        fetchRequestPosts = FetchRequest<InstaframePost>(entity: InstaframePost.entity(), sortDescriptors: [], predicate:fetchRequestPredicate)
        fetchRequestUser = FetchRequest<InstaUser>(entity: InstaUser.entity(), sortDescriptors: [], predicate:NSPredicate(format: "userName == %@", username))

        _currentUser = .init(initialValue: currentuser)

        _descriptionStateString = .init(initialValue: currentuser.profileDescription ?? "")

        if ( currentuser.userName == username){
            _isCurrentUser = .init(initialValue: true)
        }else {
            _isCurrentUser = .init(initialValue: false)
        }

    }

    var body: some View {
        NavigationView{
            Form {
//                VStack {
//                    HStack (spacing: 20){
//                        Image(uiImage: UIImage(data: fetchRequestUser.wrappedValue.first?.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
//                            .resizable()
//
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(Circle())
//                            .frame(width: 100, height: 75, alignment: .leading)
//
//
//
//
//                    }
//
//                }
//                .padding()

                HStack {
                    Image(uiImage: UIImage(data: fetchRequestUser.wrappedValue.first?.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.nativeBounds.width+50, height: 100)

                }.padding(.init(top: -30, leading: -30, bottom: 0, trailing: -30))
                HStack{
                    VStack {
                        Text("\(fetchRequestUser.wrappedValue.first?.postCount ?? 0)")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Posts")
                    }
                    Spacer()
                    VStack {
                        Text("\(2)")
                            .fontWeight(.bold)
                        Text("Followers")
                    }
                    Spacer()

                    VStack {
                        Text("\(3)")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Following")
                    }
                }
                if isCurrentUser {
                    NavigationLink(destination: FollowedByView(currentUserName: currentUser.userName!, shownUser: fetchRequestUser.wrappedValue.first!).environment(\.managedObjectContext, managedObjectContext) ){
                        Text("Manage Feed")
                    }
                }else{
                    NavigationLink(destination: FollowedByView(currentUserName: currentUser.userName!, shownUser: fetchRequestUser.wrappedValue.first!).environment(\.managedObjectContext, managedObjectContext) ){
                        Text("See Feed")
                    }
                }

                ForEach(fetchRequestPosts.wrappedValue, id: \.self){post in

                    Section(header: Text("\(post.userID ?? "")"), footer: PostFooterView(post: post),  content: {
                                NavigationLink(destination:
                                                CardView(username: post.userID ?? "", postGiven: post, currentUserGiven: currentUser).environment(\.managedObjectContext, managedObjectContext)
                                    ){
                                    Image(uiImage: UIImage(data: post.image ?? Data())!)
                                        .resizable()
                                        .rotationEffect(.degrees(90))
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: UIScreen.main.bounds.width, maxHeight: 300, alignment: .center)
                                        .padding(.horizontal, -100)
                                }})

                }

            }.navigationTitle(fetchRequestUser.wrappedValue.first?.userName ?? "")
//            .navigationBarItems(leading:  HStack{
//                Image(uiImage: UIImage(data: fetchRequestUser.wrappedValue.first?.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
//                    .resizable()
//
//                    .aspectRatio(contentMode: .fill)
//                    .clipShape(Circle())
//                    .frame(width: 50, height: 50, alignment: .leading)
//
//
//
//
//            }, trailing: Text(fetchRequestUser.wrappedValue.first?.userName ?? ""))
            .onAppear(perform: isUserInitialyFollowing)
        }

    }
}


struct PostFooterView : View{
    @State var post:InstaframePost
    var body: some View {
        HStack{
            Image(systemName: "hand.thumbsup")
            if(post.likeCount>1){
                Text("\(post.likeCount) likes")
                    .font(.subheadline)
            }else{
                Text("\(post.likeCount) like")
                    .font(.subheadline)
            }

//            Button(action: {
//                    self.lovedCard.toggle()
//
//            }) {
//                Image(systemName: lovedCard ? "heart.fill" : "heart")
//                    .font(.system(size: 21))
//                    .foregroundColor(lovedCard ? Color.red : Color.black)
//            }
        }
    }
}




extension HomeFeedView {
    func  followUser(){
        var shownUserFollowedByArray = fetchRequestUser.wrappedValue.first?.followedByUsers?.components(separatedBy: "\n")

        var currentUserFollowingArray = currentUser.followingUsers?.components(separatedBy: "\n")

        if(shownUserFollowedByArray == nil){
            shownUserFollowedByArray = []
        }
        if(currentUserFollowingArray == nil){
            currentUserFollowingArray = []
        }


        if (shownUserFollowedByArray == nil){// we don't follow them let us follow them

            shownUserFollowedByArray?.append(currentUser.userName ?? "")
            currentUserFollowingArray?.append(fetchRequestUser.wrappedValue.first?.userName ?? "")

            // go back to string

            currentUser.followingUsers = currentUserFollowingArray!.joined(separator: "\n")
            fetchRequestUser.wrappedValue.first?.followedByUsers = shownUserFollowedByArray?.joined(separator: "\n")
            print(".join Result: \(String(describing: shownUserFollowedByArray?.joined(separator: "\n")))")
            print("result of currentUser.userName ??  : \(currentUser.userName ?? "")")
            saveItems()
            self.followStr = "Un-Follow"
            print("\(String(describing: currentUser.userName)) follows ==nil  \(String(describing: fetchRequestUser.wrappedValue.first?.userName))\nfollowedbyUser = \(fetchRequestUser.wrappedValue.first?.followedByUsers) AND followingUsers = \( currentUser.followingUsers)")
            return
        }

        if let index = currentUserFollowingArray?.firstIndex(where: { $0 == fetchRequestUser.wrappedValue.first?.userName ?? "" }) {
            // we follow them let's unfollow

            currentUserFollowingArray?.remove(at: index)
            if let index = shownUserFollowedByArray?.firstIndex(where: { $0 == currentUser.userName ?? "" }) {
                shownUserFollowedByArray?.remove(at: index)
            }

            //back to string
            currentUser.followingUsers = currentUserFollowingArray!.joined(separator: "\n")
            fetchRequestUser.wrappedValue.first?.followedByUsers = shownUserFollowedByArray?.joined(separator: "\n")
            saveItems()
            self.followStr = "Follow"
            print("\(String(describing: currentUser.userName)) UNfollows \(String(describing: fetchRequestUser.wrappedValue.first?.userName))")
            return

        }
        //we do not follow them:
        shownUserFollowedByArray?.append(currentUser.userName ?? "")
        currentUserFollowingArray?.append(fetchRequestUser.wrappedValue.first?.userName ?? "")
        // go back to string

        currentUser.followingUsers = currentUserFollowingArray!.joined(separator: "\n")
        fetchRequestUser.wrappedValue.first?.followedByUsers = shownUserFollowedByArray?.joined(separator: "\n")
        saveItems()
        self.followStr = "Un-Follow"
        print("\(String(describing: currentUser.userName)) follows \(String(describing: fetchRequestUser.wrappedValue.first?.userName))")
        return




    }


    func saveItems() {
        do {
            try managedObjectContext.save()
            print("saved Item")
        } catch {
            print(error)
        }
    }

    func isUserInitialyFollowing(){

        var followingArray = fetchRequestUser.wrappedValue.first?.followedByUsers?.components(separatedBy: "\n")
        if (followingArray == nil ) {followingArray = []}
        if let index = followingArray?.firstIndex(where: { $0 == currentUser.userName ?? "" }) {
            print("User is initialy followed.")
            self.followStr = "Un-Follow"
        }

    }
}

struct PostFeedView : View {

    var post : InstaframePost

    var body: some View{

        VStack{

            Image(uiImage: UIImage(data: post.image ?? Data())!)
                .resizable()
                .rotationEffect(.degrees(90))
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)


        }//.frame(minWidth: UIScreen.main.bounds.width+50, maxHeight: 100)

    }
}
