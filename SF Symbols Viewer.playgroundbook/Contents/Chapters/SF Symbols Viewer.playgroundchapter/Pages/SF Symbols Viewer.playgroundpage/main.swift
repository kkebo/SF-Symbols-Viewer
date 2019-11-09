import Combine
import PlaygroundSupport
import SwiftUI

class ViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var fontSize = 60.0
    @Published var fontWeight = Font.Weight.regular
    @Published var textFormatIsVisible = false
    @Published var symbols = Symbols.symbols
    
    let fontWeights = [
        Font.Weight.ultraLight,
        .thin,
        .light,
        .regular,
        .medium,
        .semibold,
        .bold,
        .heavy,
        .black,
    ]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scheduler: DispatchQueue = DispatchQueue(label: "ViewModel")) {
        self.$keyword
            .dropFirst()
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
                        Picker("Font Weights", selection: self.$viewModel.fontWeight) {
                            ForEach(self.viewModel.fontWeights, id: \.self) { weight in
                                Image(systemName: "textformat")
                                    .font(.system(size: 10, weight: weight))
                                    .tag(weight)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
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
                                .font(.system(size: CGFloat(self.viewModel.fontSize), weight: self.viewModel.fontWeight))
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
