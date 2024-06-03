//
//  LiveTextInteractionView.swift
//  MultiDocFiller
//
//  Created by Janiece Eleonour on 03.06.2024.
//

import SwiftUI

struct LiveTextInteractionView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            LiveTextInteraction(imageName: "1")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
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
    LiveTextInteractionView()
}
