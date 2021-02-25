//
//  InstaframePost.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-06.
//

import CoreData
//
//class InstaframePost:NSManagedObject {
//
//    @NSManaged var userID:String
//    @NSManaged var likeCount:Int16
//    
//}

extension InstaframePost {
    
        static func getPostFetchRequest() -> NSFetchRequest<InstaframePost>{
            let request = NSFetchRequest<InstaframePost>()
            request.entity = InstaframePost.entity()
            request.sortDescriptors = [NSSortDescriptor(key: "userID", ascending: true)]
            return request
        }
    
}
