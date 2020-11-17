import SwiftUI

public struct TextFormatView {
    @Binding var fontSize: Double
    @Binding var fontWeight: Font.Weight
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

    public init(
        fontSize: Binding<Double>,
        fontWeight: Binding<Font.Weight>
    ) {
        self._fontSize = fontSize
        self._fontWeight = fontWeight
    }
}

extension TextFormatView: View {
    public var body: some View {
        VStack {
            Picker("Font Weights", selection: self.$fontWeight) {
                ForEach(self.fontWeights, id: \.self) { weight in
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
        }
    }
}
