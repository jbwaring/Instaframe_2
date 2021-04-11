//
//  TestHomeFeedView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-04-11.
//

import SwiftUI

struct TestHomeFeedView: View {
    var body: some View {
        NavigationView{
            Form{

               Image("Water35")
                .resizable()
                .aspectRatio(contentMode: .fit)
                Image("Water35")
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                Image("Water35")
                 .resizable()
                 .aspectRatio(contentMode: .fit)


        }.navigationTitle("jbwaring")
        }

    }
}

struct TestHomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        TestHomeFeedView()
    }
}
