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
    
    // New Post
    @Published var createPost = false
    @Published var isWriting = false
    
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
    
    func writePost(content: [PostContent], author: String, postTitle: String) {
        do {
            // Loading animation
            withAnimation {
                isWriting = true
            }
            
            // Storing to DB
            let post = Post(title: postTitle, author: author, postContent: content, date: Timestamp(date: Date()))
            
            let _ = try Firestore.firestore().collection("Blog").document().setData(from: post)
            
            withAnimation {
                // Adding to post
                posts?.append(post)
                isWriting = true
                // Closing post view
                createPost = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
