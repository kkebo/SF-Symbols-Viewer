import PlaygroundSupport
import SwiftUI

struct ContentView {
    @State var keyword = ""
    @State var fontSize = 60.0
    @State var fontWeight = Font.Weight.regular
    @State var renderingMode = Image.TemplateRenderingMode.template
    @State var color = Color.white
    @State var textFormatIsVisible = false
    @State var searchIsVisible = false

    var columns: [GridItem] {
        [self.fontSize * 2].lazy
            .map { max($0, 120) }
            .map { CGFloat($0) }
            .map { .init(.adaptive(minimum: $0)) }
    }

    var symbols: [String] {
        Symbols.symbols
            .filter { self.keyword.isEmpty ? true : $0.contains(self.keyword) }
    }

    func toggleTextFormat() {
        withAnimation {
            self.textFormatIsVisible.toggle()
        }
    }

    func toggleSearchBar() {
        self.keyword.removeAll()
        withAnimation {
            self.searchIsVisible.toggle()
        }
    }
}

extension ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                if self.searchIsVisible {
                    SearchBar(text: self.$keyword)
                }
                if self.textFormatIsVisible {
                    TextFormatView(
                        fontSize: self.$fontSize,
                        fontWeight: self.$fontWeight,
                        renderingMode: self.$renderingMode,
                        color: self.$color
                    )
                    .padding()
                }
                ScrollView {
                    LazyVGrid(columns: self.columns) {
                        ForEach(self.symbols, id: \.self) { name in
                            SymbolView(
                                name: name,
                                fontSize: self.$fontSize,
                                fontWeight: self.$fontWeight,
                                renderingMode: self.$renderingMode,
                                color: self.$color
                            )
                            .padding()
                        }
                        .id(UUID())
                    }
                }
            }
            .navigationTitle("\(self.symbols.count) symbols")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: self.toggleSearchBar) {
                        Image(
                            systemName: self.searchIsVisible
                                ? "magnifyingglass.circle.fill"
                                : "magnifyingglass.circle"
                        )
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: self.toggleTextFormat) {
                        // TODO: Toggle icon
                        Image(systemName: "textformat")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

PlaygroundPage.current.setLiveView(ContentView())
