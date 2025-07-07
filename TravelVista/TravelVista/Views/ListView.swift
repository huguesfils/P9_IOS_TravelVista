import SwiftUI

struct ListView: View {
    let regions: [Region] = Service().load("Source.json")
    @State private var selectedCountry: Country? = nil
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(regions, id: \ .name) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.countries, id: \ .name) { country in
                            Button(action: {
                                selectedCountry = country
                                showDetail = true
                            }) {
                                CountryRow(country: country)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Liste de voyages")
            .navigationDestination(isPresented: $showDetail) {
                if let country = selectedCountry {
                    DetailViewControllerWrapper(country: country)
                }
            }
        }
    }
}

struct CountryRow: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: 16) {
            Image(country.pictureName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(country.name)
                    .font(.headline)
                    .foregroundStyle(.blue)
                Text(country.capital)
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }
            Spacer()
            HStack {
                Text("\(country.rate)")
                    .font(.subheadline)
                    .foregroundStyle(.black)
                
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)
                    
            }
            
        }
        .padding(.vertical, 4)
    }
}

struct DetailViewControllerWrapper: UIViewControllerRepresentable {
    let country: Country
    
    func makeUIViewController(context: Context) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.country = country
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        uiViewController.country = country
    }
}

#Preview {
    ListView()
}
