//
//  LiveTextInteractionView.swift
//  MultiDocFiller
//
//  Created by Janiece Eleonour on 03.06.2024.
//

import SwiftUI

struct LiveTextInteractionView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: Image
    
    var body: some View {
        NavigationView {
            LiveTextInteraction(image: image)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
                .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    LiveTextInteractionView(image: Image(.example))
}
