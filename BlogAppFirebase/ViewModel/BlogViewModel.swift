//
//  BlogViewModel.swift
//  BlogAppFirebase
//
//  Created by Danh Tu on 06/10/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class BlogViewModel: ObservableObject {
    // Posts
    @Published var posts: [Post]?
    
    // Errors
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    // Async Await Method
    func fetchPosts() async {
        do {
            let db = Firestore.firestore().collection("Blog")
            
            let posts = try await db.getDocuments()
            
            // Converting my Model
            self.posts = posts.documents.compactMap({ post in
                return try? post.data(as: Post.self)
            })
        } catch {
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deletePost(post: Post) {
        guard let _ = posts
        else {
            return
        }
        
        let index = posts?.firstIndex(where: { currentPost in
            return currentPost.id == post.id
        }) ?? 0
        
        withAnimation {
            posts?.remove(at: index)
        }
    }
}
