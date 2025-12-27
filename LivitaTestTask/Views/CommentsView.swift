//(c) Copyright PopAppFactory 2023

import SwiftUI

struct CommentsView: View {
  let postId: Int
  @StateObject private var viewModel: CommentsViewModel
  @Environment(\.dismiss) private var dismiss

  init(postId: Int) {
    self.postId = postId
    _viewModel = StateObject(wrappedValue: CommentsViewModel(postId: postId))
  }

  var body: some View {
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
              await viewModel.loadComments()
            }
          }
          .buttonStyle(.borderedProminent)
        }
      } else {
        VStack(spacing: 0) {
          HStack {
            Button(action: {
              dismiss()
            }) {
              Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
            }
            .padding(.leading, 16)

            Spacer()
          }
          .padding(.vertical, 16)
          .background(Color.black)
          .overlay(
            Text("Comments (\(viewModel.comments.count))")
              .font(.title2)
              .fontWeight(.semibold)
              .foregroundColor(.white),
            alignment: .center
          )

          List {
            ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { index, comment in
              CommentRowView(comment: comment, isLast: index == viewModel.comments.count - 1)
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
    .navigationBarHidden(true)
    .task {
      await viewModel.loadComments()
    }
  }
}

struct CommentRowView: View {
  let comment: Comment
  let isLast: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading, spacing: 8) {
        Text(comment.email)
          .font(.headline)
          .foregroundColor(.white)
          .lineLimit(1)

        Text(comment.body)
          .font(.subheadline)
          .foregroundColor(.gray)
          .lineLimit(2)
          .padding(.bottom, 8)
      }

      if !isLast {
        Rectangle()
          .fill(Color.gray.opacity(0.4))
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
  NavigationStack {
    CommentsView(postId: 1)
  }
}
