//
//  Home.swift
//  BlogAppFirebase
//
//  Created by Danh Tu on 06/10/2021.
//

import SwiftUI

struct Home: View {
    @StateObject private var blogData = BlogViewModel()
    
    // Color based on ColorScheme
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack {
            if let posts = blogData.posts {
                // No Post
                if posts.isEmpty {
                    (
                        Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                        +
                        Text("Start Writing Blog")
                    )
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                } else {
                    List(posts) { post in
                        // Card View
                        CardView(post: post)
                        // Swipe to delete
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive, action: {
                                    blogData.deletePost(post: post)
                                }, label: {
                                    Image(systemName: "trash")
                                })
                            }
                    }
                    .listStyle(.insetGrouped)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("My Blog")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            // FAB Button
            Button(action: {
                blogData.createPost.toggle()
            }, label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(scheme == .dark ? Color.black : Color.white)
                    .padding()
                    .background(.primary, in: Circle())
            })
                .padding()
                .foregroundStyle(.primary)
            , alignment: .bottomTrailing
        )
        // Fetching Blog Posts
        .task {
            await blogData.fetchPosts()
        }
        .fullScreenCover(isPresented: $blogData.createPost) {
            // Create Post View
            CreatePost()
                .environmentObject(blogData)
        }
        .alert(blogData.alertMsg, isPresented: $blogData.showAlert) {
            
        }
    }
    
    @ViewBuilder
    func CardView(post: Post) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(post.title)
                .fontWeight(.bold)
            
            Text("Written by: \(post.author)")
                .font(.callout)
                .foregroundColor(.gray)
            
            let postDate = post.date.dateValue().formatted(date: .numeric, time: .shortened)
            Text("Written by: \(postDate)")
                .font(.callout)
                .foregroundColor(.gray)
        }
    }
}

