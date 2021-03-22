//
//  SettingsView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-07.
//

import SwiftUI
let preview = true
struct SettingsView: View {
    @State var showCameraView:Bool = false
    @StateObject var viewModel:ViewModel = ViewModel()
    @Binding var currentUser:InstaUser

    var actionSheetAvatar: ActionSheet {
          ActionSheet(title: Text("Change Avatar"), message: nil, buttons: [
              .default(Text("Choose from Camera Roll."), action: {
                viewModel.choosePhoto()
              }),
              .default(Text("Take a picture."), action: {
                viewModel.takePhoto()
              }),
              .cancel()
          ])
      }
    var body: some View {


            List {
                HStack {
                    ZStack {
//                        Image("sampleimage")
                        Image(uiImage: UIImage(data: currentUser.avatar!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                            .background(Color.white)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        Button(action: {self.showCameraView.toggle()}) {
                            Image(systemName: "pencil.circle")
                                .renderingMode(.original)
                                .font(.system(size: 25, weight: .bold))
                                .frame(width: 35)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color(.black).opacity(0.2), radius: 10, x: 0, y: 4)
                                .offset(x: 45, y: 58)


                        }


                    }
                    .frame(height: 150)
                    Text("@\(currentUser.userName!)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.leading)
                    }
                    //Text(currentUser.userName)

                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(Color(.blue).opacity(0.43))
                        .frame(width: 30, height: 80, alignment: .center)
                    Text("Change Email")
                }
                HStack{
                    Image(systemName: "key")
                        .foregroundColor(Color(.blue).opacity(0.43))
                        .frame(width: 30, height: 80, alignment: .center)
                    Text("Change Password")
                }
                }
                .padding(.vertical, 20)


             .actionSheet(isPresented: $showCameraView, content: {
            self.actionSheetAvatar

        })
        .sheet(isPresented: $viewModel.isPresentingImagePicker, onDismiss: {updateUser()}, content: {
            ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
        })

        }
    }


//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView( currentUser: .constant(InstaUser()))
//    }
//}

extension SettingsView {

 func updateUser() {
    self.showCameraView = false
    if (viewModel.selectedImage?.pngData() != nil){
    self.currentUser.avatar =  viewModel.selectedImage?.pngData()
    }
 }

}



struct ImagePicker: UIViewControllerRepresentable {
typealias UIViewControllerType = UIImagePickerController
typealias SourceType = UIImagePickerController.SourceType
let sourceType: SourceType
let completionHandler: (UIImage?) -> Void
func makeUIViewController(context: Context) -> UIImagePickerController {
let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.sourceType = sourceType
return viewController
    }
func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
func makeCoordinator() -> Coordinator {
return Coordinator(completionHandler: completionHandler)
    }
final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
let completionHandler: (UIImage?) -> Void
init(completionHandler: @escaping (UIImage?) -> Void) {
self.completionHandler = completionHandler
        }
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
let image: UIImage? = {
if let image = info[.editedImage] as? UIImage {
return image
                }
return info[.originalImage] as? UIImage
            }()
completionHandler(image)
        }
func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
completionHandler(nil)
        }
    }
}
extension SettingsView {

    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        @Published var usingCamera = false
        private(set) var sourceType: ImagePicker.SourceType = .camera




        func choosePhoto() {

            sourceType = .photoLibrary
            isPresentingImagePicker = true
        }

        func takePhoto() {
            sourceType = .camera
            usingCamera = true
            isPresentingImagePicker = true
        }

        func didSelectImage(_ image: UIImage?) {
            selectedImage = image
            isPresentingImagePicker = false
            usingCamera = false


        }


    }



}
