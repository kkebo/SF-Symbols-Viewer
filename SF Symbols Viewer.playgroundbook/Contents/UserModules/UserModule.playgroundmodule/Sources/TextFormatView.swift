import SwiftUI

public struct TextFormatView {
    @Binding var fontSize: Double
    @Binding var fontWeight: Font.Weight
    @Binding var renderingMode: Image.TemplateRenderingMode

    public init(
        fontSize: Binding<Double>,
        fontWeight: Binding<Font.Weight>,
        renderingMode: Binding<Image.TemplateRenderingMode>
    ) {
        self._fontSize = fontSize
        self._fontWeight = fontWeight
        self._renderingMode = renderingMode
    }
}

extension TextFormatView: View {
    public var body: some View {
        VStack {
            Picker("Font Weights", selection: self.$fontWeight) {
                ForEach(Font.Weight.allCases, id: \.self) { weight in
                    Image(systemName: "textformat")
                        .font(.system(size: 10, weight: weight))
                        .tag(weight)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack {
                Image(systemName: "textformat")
                    .font(.system(size: 10))
                Slider(value: self.$fontSize, in: 0...120)
                Image(systemName: "textformat")
                    .font(.system(size: 20))
            }
            Picker("Rendering Mode", selection: self.$renderingMode) {
                ForEach(Image.TemplateRenderingMode.allCases, id: \.self) { mode in
                    Text(mode.description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
