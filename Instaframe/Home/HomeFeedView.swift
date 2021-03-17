import SwiftUI

struct TestImages : Identifiable {
    let id = UUID()
    let str:String
}

let images = [TestImages(str: "Water35"), TestImages(str: "Water35"), TestImages(str: "Water35"), TestImages(str: "Water35")]


struct HomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: InstaframePost.getPostFetchRequest())  var postList: FetchedResults<InstaframePost>
    @FetchRequest(fetchRequest: InstaUser.fetchUserWithUUID(userUUID: "uLnI3AK5HueybPWqRThqQ2VL6m33"))  var shownUser: FetchedResults<InstaUser>
    @State var showCard = false
    @State var testAndrew = "Andrew"
    var body: some View {
        ScrollView {
            
            HStack (spacing: 20){
                Image("Water35")
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
                    if(shownUser.first != nil){
                        Text(shownUser.first!.userName!)
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text(shownUser.first!.description)
                    }
                    
                    
                        
                    Text("Football fan ⚽")
                }
                .padding()
            
                Spacer()
            }
      
            Button(action:{}, label: {
               Text("Follow")
                .padding()
                .frame(width: 100, height: 40)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color(.black).opacity(0.2), radius: 10, x: 0, y: -5)
                
                    })
                   
            VStack{
                ForEach(postList){ post in
                    ImageFeedView(showCard: $showCard, post: post)
                    
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

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct ImageFeedView: View {
    @Binding var showCard:Bool
    @State var post:InstaframePost
    var body: some View {
        Image(uiImage: UIImage(data: post.image ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
            .resizable()
            .frame(width: UIScreen.screenWidth-10, height: UIScreen.screenWidth-10)
            .clipShape(RoundedRectangle(cornerRadius: UIScreen.screenWidth/20, style: .continuous))
            .onTapGesture {
                self.showCard.toggle()
            }
    }
}
