import SwiftUI

extension Font.Weight: CaseIterable {
    public static var allCases: [Self] {
        [
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
}

extension Image.TemplateRenderingMode: CaseIterable {
    public static var allCases: [Self] {
        [.original, .template]
    }
}

extension Image.TemplateRenderingMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .original: return "Original"
        case .template: return "Template"
        }
    }
}
