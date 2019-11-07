import Combine
import PlaygroundSupport
import SwiftUI

class ViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var fontSize = 60.0
    @Published var textFormatIsVisible = false
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
            HStack {
                SearchBar(text: self.$viewModel.keyword)
                Button(action: {
                    self.viewModel.textFormatIsVisible = true
                }) {
                    Image(systemName: "textformat.size")
                }
                .padding([.trailing])
                .popover(isPresented: self.$viewModel.textFormatIsVisible) {
                    VStack {
                        Text("\(self.viewModel.fontSize)")
                        HStack {
                            Image(systemName: "textformat")
                                .font(.system(size: 10))
                            Slider(value: self.$viewModel.fontSize, in: 0...120)
                            Image(systemName: "textformat")
                                .font(.system(size: 20))
                        }
                    }
                    .padding()
                }
            }
            List {
                ForEach(self.viewModel.symbols, id: \.self) { name in
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: name)
                                .font(.system(size: CGFloat(self.viewModel.fontSize)))
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
                    .padding()
                }
            }
        }
    }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView(viewModel: ViewModel()))
