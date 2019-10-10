import SwiftUI
import PlaygroundSupport

class ViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var symbols = Symbols.symbols
    
    init(scheduler: DispatchQueue = DispatchQueue(label: "ViewModel")) {
        _ = self.$keyword
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
            .sink { keyword in
                if keyword.count > 0 {
                    self.symbols = Symbols.symbols
                        .filter { $0.contains(keyword) }
                } else {
                    self.symbols = Symbols.symbols
                }
            }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SearchBar(text: self.$viewModel.keyword)
            List {
                ForEach(viewModel.symbols, id: \.self) { name in
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: name)
                                .font(.system(size: 60))
                                .padding()
                            HStack {
                                Text(name)
                                Button(action: {
                                    UIPasteboard.general.string = name
                                }) {
                                    Image(systemName: "doc.on.clipboard")
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView(viewModel: ViewModel()))
