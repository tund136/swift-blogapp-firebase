//
//  Post.swift
//  BlogAppFirebase
//
//  Created by Danh Tu on 06/10/2021.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

// Post Model
struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var author: String
    var postContent: [PostContent]
    var date: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case postContent
        case date
    }
}

// Post Content Model
struct PostContent: Identifiable, Codable {
    var id = UUID().uuidString
    var value: String
    var type: PostType
    
    enum CodingKeys: String, CodingKey {
        // Since firestore keyname is key
        case type = "key"
        case value
    }
}

// Content Type
// Ex: Header, Paragraph, etc.
enum PostType: String, CaseIterable, Codable {
    case Header = "Header"
    case SubHeading = "SubHeading"
    case Paragraph = "Paragraph"
    case Image = "Image"
}
