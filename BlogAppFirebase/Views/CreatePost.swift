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
    
    // Keyboard Focus State for TextViews
    @FocusState var showKeyboard: Bool
    
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
                        VStack {
                            // Image URL
                            if content.type == .Image {
                                if content.showImage && content.value != "" {
                                    WebImage(url: content.value)
                                    // If tap change URL
                                        .onTapGesture {
                                            withAnimation {
                                                content.showImage = false
                                            }
                                        }
                                } else {
                                    // TextField for URL
                                    VStack {
                                        TextField("Image URL", text: $content.value, onCommit:  {
                                            withAnimation {
                                                content.showImage = true
                                            }
                                            // To show image when pressed return
                                        })
                                        
                                        Divider()
                                    }
                                    .padding(.leading, 5)
                                }
                            } else {
                                // Custom Text Editor from UIKit
                                TextView(text: $content.value, height: $content.height, fontSize: getFontSize(type: content.type))
                                    .focused($showKeyboard)
                                // Approx Height based on Font for First Display
                                    .frame(height: content.height == 0 ? getFontSize(type: content.type) * 2 : content.height)
                                    .background(
                                        Text(content.type.rawValue)
                                            .font(.system(size: getFontSize(type: content.type)))
                                            .foregroundColor(.gray)
                                            .opacity(content.value == "" ? 0.7 : 0)
                                            .padding(.leading, 5)
                                        
                                        , alignment: .leading
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        // Swipe to delete
                        .gesture(DragGesture().onEnded({ value in
                            if -value.translation.width < (UIScreen.main.bounds.width / 2.5) && !content.showDeleteAlert {
                                // Showing alert
                                content.showDeleteAlert = true
                            }
                        }))
                        .alert("Sure to delete this content?", isPresented: $content.showDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                // Deleting content
                                let index = postContent.firstIndex { currentPost in
                                    return currentPost.id == content.id
                                } ?? 0
                                
                                withAnimation {
                                    postContent.remove(at: index)
                                }
                            }
                        }
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
                    if !showKeyboard {
                        Button("Cancel") {
                            blogData.createPost.toggle()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showKeyboard {
                        Button("Done") {
                            // Closing Keyboard
                            showKeyboard.toggle()
                        }
                    } else {
                        Button("Post") {
                            
                        }
                        .disabled(authorName == "" || postTitle == "")
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

// Async Image
struct WebImage: View {
    
    var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                    .cornerRadius(15)
            } else {
                if let _ = phase.error {
                    Text("Failed to load image.")
                } else {
                    ProgressView()
                }
            }
        }
        .frame(height: 250)
    }
}
