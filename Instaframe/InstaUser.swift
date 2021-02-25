//
//  InstaUser.swift
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

extension InstaUser {
    
    static func fetchAllUsers() -> NSFetchRequest<InstaUser>{
            let request = NSFetchRequest<InstaUser>()
            request.entity = InstaUser.entity()
            request.sortDescriptors = [NSSortDescriptor(key: "userID", ascending: true)]
            return request
        }
    static func fetchUserWithUUID(userUUID:String) -> NSFetchRequest<InstaUser>{
        
        let request = NSFetchRequest<InstaUser>()
        request.entity = InstaUser.entity()
        request.predicate = NSPredicate(format: "userID == %@", userUUID)
        request.sortDescriptors = [NSSortDescriptor(key: "userID", ascending: true)]
        return request
        
    }
    
}
