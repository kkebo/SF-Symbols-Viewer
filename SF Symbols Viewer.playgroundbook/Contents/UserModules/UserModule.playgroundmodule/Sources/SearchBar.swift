import SwiftUI

public struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(text: self.$text)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    public func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = self.text
    }
}

extension SearchBar {
    public class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
        }
        
        public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
}
