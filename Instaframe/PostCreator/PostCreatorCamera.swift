//
//  PostCreatorCamera.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-14.
//

import SwiftUI

struct PostCreatorCamera: View {
    @StateObject var viewModel:ViewModel = ViewModel()
    @Binding var selectedImage:UIImage?


    var body: some View {


        ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            .onChange(of: viewModel.didSelect, perform: { didSelect in
                if(didSelect==true){
                    self.selectedImage = viewModel.selectedImage
                    print("image arrive in .onChange()")
                }
                viewModel.didSelect = false
            })
            .onAppear(perform: {
                viewModel.choosePhoto()
            })


        
    }
}
extension PostCreatorCamera {
    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var isPresentingImagePicker = false
        @Published var didSelect = false
        @Published var usingCamera = false
        private(set) var sourceType: ImagePicker.SourceType = .photoLibrary



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
            print("Selecting Image")
            didSelect = true
            selectedImage = image
            isPresentingImagePicker = false
            usingCamera = false
            
        }


    }
    
    

}
