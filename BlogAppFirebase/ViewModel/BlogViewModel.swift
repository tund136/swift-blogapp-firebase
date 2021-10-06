//
//  BlogViewModel.swift
//  BlogAppFirebase
//
//  Created by Danh Tu on 06/10/2021.
//

import SwiftUI

class BlogViewModel: ObservableObject {
    // Posts
    @Published var posts: [Post]?
}
