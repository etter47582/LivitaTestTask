//(c) Copyright PopAppFactory 2023


import SwiftUI

struct UsersView: View {
  @StateObject private var viewModel = UsersViewModel()
  @Environment(\.dismiss) private var dismiss
  let onUserSelected: (User) -> Void
  
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea(.all)
      
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
              await viewModel.loadUsers()
            }
          }
          .buttonStyle(.borderedProminent)
        }
      } else {
        VStack(spacing: 0) {
          // Custom navigation bar
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
          .padding(.top, 8)
          .padding(.bottom, 16)
          .background(Color.black)
          .overlay(
            Text("Users")
              .font(.title2)
              .fontWeight(.semibold)
              .foregroundColor(.white),
            alignment: .center
          )
          
          // Users list
          List {
            ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
              Button(action: {
                onUserSelected(user)
                dismiss()
              }) {
                UserRowView(user: user, isLast: index == viewModel.users.count - 1)
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
    .navigationBarHidden(true)
    .task {
      await viewModel.loadUsers()
    }
  }
}

struct UserRowView: View {
    let user: User
    let isLast: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(user.name) (\(user.username))")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(.bottom, 8)
            }
            
            // Custom separator with shadow (hidden for last item)
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
        UsersView { user in
            print("Selected user: \(user.name)")
        }
    }
}

