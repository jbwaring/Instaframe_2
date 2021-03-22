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
    @State var currentUser:InstaUser

    init(currentUser: InstaUser) {
        _currentUser = .init(initialValue: currentUser)
        _followedUser = .init(initialValue: [currentUser])
    }
    var body: some View {
        NavigationView {

            Form{

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
                }
                }




                Section(header: Text("Following")){
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
                    }.onDelete(perform: removeFollower)

                }



            }.navigationBarTitle("Follow.")
        }
        .onAppear(perform: {
            findFollowList()
        })
    }

}


extension FollowedByView {

    func removeFollower(at offsets: IndexSet) {

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

    func findFollowList() {
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


    func saveItems() {
         do {
             try managedObjectContext.save()
             print("saved Item")
         } catch {
             print(error)
         }
     }
}
