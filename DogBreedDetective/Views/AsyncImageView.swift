import SwiftUI

struct AsyncImageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    ProgressView()
                        .scaleEffect(1.5)
                )
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
