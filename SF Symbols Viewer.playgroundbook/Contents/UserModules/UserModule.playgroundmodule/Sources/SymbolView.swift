import SwiftUI

public struct SymbolView {
    let name: String
    @Binding var fontSize: Double
    @Binding var fontWeight: Font.Weight
    @Binding var renderingMode: Image.TemplateRenderingMode
    @Binding var color: Color

    public init(
        name: String,
        fontSize: Binding<Double>,
        fontWeight: Binding<Font.Weight>,
        renderingMode: Binding<Image.TemplateRenderingMode>,
        color: Binding<Color>
    ) {
        self.name = name
        self._fontSize = fontSize
        self._fontWeight = fontWeight
        self._renderingMode = renderingMode
        self._color = color
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
                .foregroundColor(self.color)
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
