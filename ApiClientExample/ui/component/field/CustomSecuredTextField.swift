import Foundation
import SwiftUI

struct CustomSecuredTextField: View {
    var placeholder: Text
    @Binding var text: String
    var commit: () -> Void = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text, onCommit: commit)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .accentColor(.white)
        }
    }
}
