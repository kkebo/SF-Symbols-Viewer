import Combine
import PlaygroundSupport
import SwiftUI

class ViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var symbols = Symbols.symbols
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scheduler: DispatchQueue = DispatchQueue(label: "ViewModel")) {
        self.$keyword
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
            .receive(on: DispatchQueue.main)
            .map { keyword in
                if keyword.count > 0 {
                    return Symbols.symbols.filter { $0.contains(keyword) }
                } else {
                    return Symbols.symbols
                }
            }
            .assign(to: \.symbols, on: self)
            .store(in: &self.cancellables)
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
