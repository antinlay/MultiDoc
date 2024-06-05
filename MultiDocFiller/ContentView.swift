//
//  ContentView.swift
//  MultiDocFiller
//
//  Created by Ляхевич Александр Олегович on 14.04.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import Vision
import _PhotosUI_SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showLiveTextView = false
    
    @State private var recognizedText = "Tap button to start scanning..."
    @State private var showingScanningView = false
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [LiveTextInteractionView]()

    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.gray.opacity(0.2))
                        
                        TextEditor(text: $recognizedText)
                            .padding()
                    }
                    .padding()
                }
            }
            .navigationTitle("Text Recognition")
            .onTapGesture {
                showingScanningView = true
            }

        }
        .sheet(isPresented: $showingScanningView, content: {
            ScanDocumentView(recognizedText: $recognizedText)
        })
        .onChange(of: inputImage) { _, _ in loadImage() }

        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<selectedImages.count, id: \.self) { i in
                        selectedImages[i]
                            .scaledToFit()
                    }
                }
            }
            .toolbar {
                PhotosPicker("Select images", selection: $selectedItems, matching: .images)
            }
            .onChange(of: selectedItems) {
                Task {
                    showLiveTextView = true
                    selectedImages.removeAll()

                    for item in selectedItems {
                        if let image = try? await item.loadTransferable(type: Image.self) {
                            selectedImages.append(LiveTextInteractionView(image: image))
                        }
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.pixellate()
        
        currentFilter.inputImage = beginImage
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
                
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }

}

#Preview {
    ContentView()
}
