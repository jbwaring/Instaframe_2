//
//  PostCreatorCamera.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-14.
//

import SwiftUI

struct PostCreatorCamera: View {
    @State var showCameraView:Bool = false
    @StateObject var viewModel:ViewModel = ViewModel()
    @Binding var selectedImage:UIImage?
    var body: some View {
       
            
            ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
                .onChange(of: viewModel.didSelect, perform: { didSelect in
                    if(didSelect==true){
                        self.selectedImage = viewModel.selectedImage
                    }
                    viewModel.didSelect = false
                })
                
                
        
    }
}

struct PostCreatorCamera_Previews: PreviewProvider {
    static var previews: some View {
        PostCreatorCamera(selectedImage: .constant(UIImage()))
    }
}
extension PostCreatorCamera {
    func testfunc() {
        
    }
    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        @Published var didSelect = false
        @Published var usingCamera = false
      //  private(set) var sourceType: ImagePicker.SourceType = .camera
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
            didSelect = true
            selectedImage = image
            isPresentingImagePicker = false
            usingCamera = false
            
        }


    }
    
    

}
