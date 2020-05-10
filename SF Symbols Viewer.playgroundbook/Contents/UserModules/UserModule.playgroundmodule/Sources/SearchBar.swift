import SwiftUI

public struct SearchBar {
    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }
}

extension SearchBar: UIViewRepresentable {
    public func makeCoordinator() -> Self.Coordinator {
        Self.Coordinator(text: self.$text)
    }

    public func makeUIView(context: Self.Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        return searchBar
    }

    public func updateUIView(_ uiView: UISearchBar, context: Self.Context) {
        uiView.text = self.text
    }
}

extension SearchBar {
    public final class Coordinator: NSObject {
        @Binding var text: String

        init(text: Binding<String>) {
            self._text = text
        }
    }
}

extension SearchBar.Coordinator: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.text = searchText
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
