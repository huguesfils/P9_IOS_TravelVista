import SwiftUI

struct TitleView: View {
    let countryName: String
    let capitalName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(countryName)
                .font(.title3)
                .foregroundStyle(.blue)
            Text(capitalName)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    TitleView(countryName: "Nepal", capitalName: "Kathmandu")
}
