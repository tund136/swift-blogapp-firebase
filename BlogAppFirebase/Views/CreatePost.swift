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
    @State private var authorName = ""
    @State private var postContent: [PostContent] = []
    
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
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Author:")
                            .font(.caption.bold())
                        
                        TextField("iJustine", text: $authorName)
                        
                        Divider()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    
                    // Iterating Post Content
                    ForEach($postContent) { $content in
                        // Custom Text Editor from UIKit
                        TextView(text: $content.value, height: $content.height, fontSize: getFontSize(type: content.type))
                    }
                    
                    // Menu Button to insert Post Content
                    Menu(content: {
                        // Iterating Cases
                        ForEach(PostType.allCases, id: \.rawValue) { type in
                            Button(type.rawValue) {
                                // Appending New PostContent
                                withAnimation {
                                    postContent.append(PostContent(value: "", type: type))
                                }
                            }
                        }
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.primary)
                    })
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
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

// Dynamic Height
func getFontSize(type: PostType) -> CGFloat {
    switch type {
    case .Header:
        return 24
    case .SubHeading:
        return 22
    case .Paragraph:
        return 18
    case .Image:
        return 18
    }
}
