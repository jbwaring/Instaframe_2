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
    @State var verticalOffset:CGFloat = 0.0
    @State var show:Bool = false
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var showFollowView:Bool = false
    @State var isCurrentUser:Bool
    init(username: String, currentuser: InstaUser){
        fetchRequestPosts = FetchRequest<InstaframePost>(entity: InstaframePost.entity(), sortDescriptors: [], predicate:NSPredicate(format: "userID == %@", username))
        fetchRequestUser = FetchRequest<InstaUser>(entity: InstaUser.entity(), sortDescriptors: [], predicate:NSPredicate(format: "userName == %@", username))

        _currentUser = .init(initialValue: currentuser)
        currentuser.profileDescription = "Multi Line\nProfile Description."
        if ( currentuser.userName == username){
            _isCurrentUser = .init(initialValue: true)
        }else {
            _isCurrentUser = .init(initialValue: false)
        }

    }

    var body: some View {

        ZStack(alignment: .top, content: {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    GeometryReader{g in

                        VStack {
                            HStack (spacing: 20){
                                Image(uiImage: UIImage(data: fetchRequestUser.wrappedValue.first?.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                                    .resizable()

                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 75, alignment: .leading)

                                VStack {
                                    Text("\(fetchRequestUser.wrappedValue.first?.postCount ?? 0)")
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Text("Posts")
                                }

                                VStack {
                                    Text("\(2)")
                                        .fontWeight(.bold)
                                    Text("Followers")
                                }

                                VStack {
                                    Text("\(3)")
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Text("Following")
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 20)



                            HStack {
                                VStack (alignment : .leading){
                                    Text(fetchRequestUser.wrappedValue.first?.userName ?? "")
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Text(fetchRequestUser.wrappedValue.first?.profileDescription ?? "")
                                        .font(.subheadline)


                                }
                                .padding()

                                Spacer()
                            }.padding(.leading,20)
                            //
                            if isCurrentUser {
                                Button(action:{self.showFollowView.toggle()}, label: {
                                    Text("My Followers")
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        .frame(width: 200, height: 40)

                                        .shadow(color: Color(.black).opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -5)

                                })
                            } else {
                                HStack {
                                    Button(action:{self.showFollowView.toggle()}, label: {
                                        Text("Followers")
                                            .padding()
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                            .frame(width: 200, height: 40)

                                            .shadow(color: Color(.black).opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -5)

                                    })
                                    Button(action:{self.showFollowView.toggle()}, label: {
                                        Text("Follow")
                                            .padding()
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                            .frame(width: 200, height: 40)

                                            .shadow(color: Color(.black).opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -5)

                                    })
                                }

                            }




                        }
                        .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                        .frame(height: g.frame(in: .global).minY > 0 ? UIScreen.main.bounds.height / 2.2 + g.frame(in: .global).minY  : UIScreen.main.bounds.height / 2.2)
                        .onReceive(self.time) { (_) in

                            let y = g.frame(in: .global).minY

                            if -y > (UIScreen.main.bounds.height / 2.2) - 50{

                                withAnimation{

                                    self.show = true
                                }
                            }
                            else{

                                withAnimation{

                                    self.show = false
                                }
                            }

                        }

                    }
                    .frame(height: UIScreen.main.bounds.height / 2.2)

                    VStack{



                        VStack(spacing: 20){

                            ForEach(fetchRequestPosts.wrappedValue, id: \.self){post in

                                PostFeedView(post: post)
                            }


                        }

                    }


                    Spacer()
                }
            })

            if self.show{

                HeaderViewHomeFeed(currentUser: currentUser)
            }
        })
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showFollowView) {
            FollowedByView(currentUser: currentUser).environment(\.managedObjectContext, managedObjectContext)
        }
    }

}

struct PostFeedView : View {

    var post : InstaframePost

    var body: some View{

        HStack(alignment: .top, spacing: 0){

            Image(uiImage: UIImage(data: post.image ?? Data())!)
                .resizable()
                .rotationEffect(.degrees(90))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment:  .center)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))


            Spacer(minLength: 0)
        }
    }
}
struct HeaderViewHomeFeed : View {
    @State var currentUser:InstaUser

    var body: some View{

        HStack{
            VStack(alignment: .leading, spacing: 12) {

                HStack(alignment: .top){

                    Image(uiImage: UIImage(data: currentUser.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                        .resizable()

                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 30, height: 30, alignment: .leading)


                    Text(currentUser.userName ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                }

                Text("\(3) Followers.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 20)

            Spacer(minLength: 0)
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top == 0 ? 15 : (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 5)
        .padding(.horizontal)
        .padding(.bottom)
        .background(CustomBlurredBackground())
    }
}

struct CustomBlurredBackground : UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}
