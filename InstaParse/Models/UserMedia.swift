//
//  UserMedia.swift
//  InstaParse
//
//  Created by Amay Singhal on 2/11/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import Foundation
import Parse

class UserMedia: NSObject {

    // MARK: Constants
    static let ObjectName = "UserMedia"
    struct Fields {
        static let OjbectId = "objectId"
        static let Media = "media"
        static let LikesCount = "likesCount"
        static let CommentsCount = "commentsCount"
        static let Caption = "caption"
        static let MediaAuthor = "author"
        static let CreatedAt = "createdAt"
    }
    
    // MARK: Properties
    private var mediaObject: PFObject


    var likesCount: Int {
        if let count = mediaObject[Fields.LikesCount] as? Int {
            return count
        }
        return 0
    }

    var username: String? {
        return (mediaObject[Fields.MediaAuthor] as? PFUser)?.username ?? nil
    }

    var dateCreated: NSDate? {
        return mediaObject.createdAt
    }
    
    
    func setMediaOnImageView(imageView: UIImageView) {
        if let mediaFile = mediaObject[Fields.Media] as? PFFile {
            mediaFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    imageView.image = UIImage(data: data)
                }
            })
        }
    }

    init(userMediaObj: PFObject) {
        mediaObject = userMediaObj
    }

    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image, let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
        return nil
    }

    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        let media = PFObject(className: UserMedia.ObjectName)
        media[Fields.Media] = getPFFileFromImage(image)
        media[Fields.Caption] = caption
        media[Fields.LikesCount] = 0
        media[Fields.CommentsCount] = 0
        media[Fields.MediaAuthor] = PFUser.currentUser()
        media.saveInBackgroundWithBlock(completion)
    }

    class func fetchRecentMedia(limit: Int = 20, withCompletition completion: (success: Bool, media: [UserMedia]?, error: NSError?)->()) {
        let query = PFQuery(className: UserMedia.ObjectName)
        query.orderByDescending(Fields.CreatedAt)
        query.includeKey(Fields.MediaAuthor)
        query.limit = limit

        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                var gramsArray = [UserMedia]()
                for record in media {
                    gramsArray.append(UserMedia(userMediaObj: record))
                }
                completion(success: true, media: gramsArray, error: nil)
            } else {
                completion(success: false, media: nil, error: error)
            }
        }
    }
}