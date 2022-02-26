import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var commit: () -> Void = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onCommit: commit)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .accentColor(.white)
        }
    }
}
