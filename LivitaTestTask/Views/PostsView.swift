//(c) Copyright PopAppFactory 2023


import SwiftUI

struct PostsView: View {
  @StateObject private var viewModel = PostsViewModel()

  var body: some View {
    NavigationStack {
      ZStack {
        Color.black.ignoresSafeArea()

        if viewModel.isLoading {
          ProgressView()
            .tint(.white)
        } else if let errorMessage = viewModel.errorMessage {
          VStack {
            Text("Error: \(errorMessage)")
              .foregroundColor(.red)
              .padding()
            Button("Retry") {
              Task {
                await viewModel.loadData()
              }
            }
            .buttonStyle(.borderedProminent)
          }
        } else {
          VStack(spacing: 0) {
            Text(viewModel.userName)
              .font(.title2)
              .fontWeight(.semibold)
              .foregroundColor(.white)
              .padding(.vertical, 16)

            List {
              ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                NavigationLink(destination: CommentsView(postId: post.id)) {
                  PostRowView(post: post, isLast: index == viewModel.posts.count - 1)
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSeparator(.visible)
                .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 8, trailing: 0))
              }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.gray.opacity(0.4))
            .padding(.bottom, 24)

          }
          .ignoresSafeArea(edges: .bottom)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .task {
        await viewModel.loadData()
      }
    }
  }
}

struct PostRowView: View {
  let post: Post
  let isLast: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading, spacing: 8) {
        Text(post.title)
          .font(.headline)
          .foregroundColor(.white)
          .lineLimit(1)

        Text(post.body)
          .font(.subheadline)
          .foregroundColor(.gray)
          .lineLimit(2)
          .padding(.bottom, 8)
      }

      if !isLast {
        Rectangle()
          .fill(Color.gray.opacity(0.3))
          .frame(height: 2)
          .shadow(color: .black, radius: 2, x: 0, y: 2)
          .padding(.top, 8)
          .padding(.trailing, -20)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  PostsView()
}


