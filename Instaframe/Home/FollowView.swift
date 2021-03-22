//
//  FollowView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-03-22.
//

import SwiftUI

struct FollowedByView: View {
    @FetchRequest(fetchRequest: InstaUser.fetchAllUsers())  var userList: FetchedResults<InstaUser>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var followedUser: [InstaUser]
    @State var followingUser: [InstaUser]
    @State var currentUser:InstaUser
    @State var shownUser:InstaUser
    @State var canEdit:Bool = false
    init(currentUser: InstaUser, shownUser: InstaUser) {
        _currentUser = .init(initialValue: currentUser)
        _shownUser  = .init(initialValue: shownUser)
        _followedUser = .init(initialValue: [currentUser])
        _followingUser = .init(initialValue: [currentUser])

    }
    var body: some View {
        NavigationView {

            Form{
                Text(canEdit ? "Tip: You remove followers or followings by swiping right to left on the user you would like to remove." : "Tip: To edit this, connect to the account \(currentUser.userName ?? "").")
                    .font(.subheadline)
                Section(header: Text("Followers")){
                ForEach(followedUser, id: \.self) { user in
                    HStack{
                        Image(uiImage: UIImage(data: user.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 2)
                        Text(user.userName ?? "nil")
                    }
                    .frame(height: 70)
                    .buttonStyle(PlainButtonStyle())
                    //Deleting task
                }.onDelete(perform: removeFollowedBy)
                }




                Section(header: Text("Following")){
                    ForEach(followingUser, id: \.self) { user in
                        HStack{
                            Image(uiImage: UIImage(data: user.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 2)
                            Text(user.userName ?? "nil")
                        }
                        .frame(height: 70)
                        .buttonStyle(PlainButtonStyle())
                        //Deleting task
                    }.onDelete(perform: removeFollowing)

                }



            }.navigationBarTitle("Follow.")
        }
        .onAppear(perform: {
            findFollowedByList()
            findFollowingList()
//            if(currentUser.){
//                self.canEdit = true
//            }
        })
    }

}


extension FollowedByView {

    func removeFollowedBy(at offsets: IndexSet) {

        var userNameToRemove = ""
        for index in offsets {
            userNameToRemove = followedUser[index].userName ?? ""
            followedUser.remove(at: index)
        }
        var postLikeUsers = currentUser.followedByUsers?.components(separatedBy: "\n")
        if let index = postLikeUsers?.firstIndex(where: { $0 == userNameToRemove }) {
            postLikeUsers?.remove(at: index)
        }
        currentUser.followedByUsers = postLikeUsers?.joined(separator: "\n")
        saveItems()

    }
    func removeFollowing(at offsets: IndexSet) {

        var userNameToRemove = ""
        for index in offsets {
            userNameToRemove = followingUser[index].userName ?? ""
            followingUser.remove(at: index)
        }
        var postLikeUsers = currentUser.followingUsers?.components(separatedBy: "\n")
        if let index = postLikeUsers?.firstIndex(where: { $0 == userNameToRemove }) {
            postLikeUsers?.remove(at: index)
        }
        currentUser.followingUsers = postLikeUsers?.joined(separator: "\n")
        saveItems()

    }


    func findFollowedByList() {
        print("Finding List of Followers and Following.")
        var followlist = currentUser.followedByUsers?.components(separatedBy: "\n")
        followedUser.removeAll()
        for findName in followlist! {
            for user in userList {
                //find corresponding user:
                if(user.userName == findName){
                    followedUser.append(user)
                }
            }
        }
    }
    func findFollowingList() {
        print("Finding List of Followers and Following.")
        var followlist = currentUser.followingUsers?.components(separatedBy: "\n")
        followingUser.removeAll()
        for findName in followlist! {
            for user in userList {
                //find corresponding user:
                if(user.userName == findName){
                    followingUser.append(user)
                }
            }
        }
    }

    func saveItems() {
         do {
             try managedObjectContext.save()
             print("saved Item")
         } catch {
             print(error)
         }
     }
}
