//
//  CreatePost.swift
//  BlogAppFirebase
//
//  Created by Danh Tu on 06/10/2021.
//

import SwiftUI

struct CreatePost: View {
    @EnvironmentObject var blogData: BlogViewModel
    
    // Post Properties
    @State private var postTitle = ""
    
    var body: some View {
        // Since I need Nav Buttons
        // So including NavBar
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    VStack(alignment: .leading) {
                        TextField("Post Title", text: $postTitle)
                            .font(.title2)
                        
                        Divider()
                    }
                }
                .padding()
            }
            // Changing Post Title Dynamic
            .navigationTitle(postTitle == "" ? "Post Title" : postTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        blogData.createPost.toggle()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        blogData.createPost.toggle()
                    }
                }
            }
        }
    }
}

