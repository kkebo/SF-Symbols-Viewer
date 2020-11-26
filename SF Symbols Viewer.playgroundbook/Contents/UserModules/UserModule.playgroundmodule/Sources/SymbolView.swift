import SwiftUI

public struct SymbolView {
    let name: String
    @Binding var fontSize: Double
    @Binding var fontWeight: Font.Weight
    @Binding var renderingMode: Image.TemplateRenderingMode

    public init(
        name: String,
        fontSize: Binding<Double>,
        fontWeight: Binding<Font.Weight>,
        renderingMode: Binding<Image.TemplateRenderingMode>
    ) {
        self.name = name
        self._fontSize = fontSize
        self._fontWeight = fontWeight
        self._renderingMode = renderingMode
    }

    func copy() {
        UIPasteboard.general.string = self.name
    }
}

extension SymbolView: View {
    public var body: some View {
        VStack {
            Image(systemName: self.name)
                .renderingMode(self.renderingMode)
                .font(
                    .system(
                        size: CGFloat(self.fontSize),
                        weight: self.fontWeight
                    )
                )
                .padding()
            HStack {
                Text(self.name)
                Button(action: self.copy) {
                    Image(systemName: "doc.on.clipboard")
                }
            }
        }
    }
}
