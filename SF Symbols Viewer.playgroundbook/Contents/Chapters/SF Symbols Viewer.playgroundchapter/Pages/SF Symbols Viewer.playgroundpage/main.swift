import PlaygroundSupport
import SwiftUI

class ViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var fontSize = 60.0
    @Published var fontWeight = Font.Weight.regular
    @Published var textFormatIsVisible = false
    
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
            List(
                Symbols.symbols
                    .filter { self.viewModel.keyword.isEmpty ? true : $0.contains(self.viewModel.keyword) },
                id: \.self
            ) { name in
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
            .id(UUID())
            Spacer()
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView(viewModel: ViewModel()))
