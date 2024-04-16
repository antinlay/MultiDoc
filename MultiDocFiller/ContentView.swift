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

struct ContentView: View {
    @State private var blurAmount = 0.0
    @State private var backgroundColor = Color.gray
    @State private var showConfirmation = false
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var recognizedText = "Tap button to start scanning..."
    @State private var showingScanningView = false
    var body: some View {
        //        Form {
        //            VStack {
        //                image?
        //                    .resizable()
        //                    .scaledToFit()
        //                Button("Load image") {
        //                    showingImagePicker = true
        //                }
        //            }
        //            .sheet(isPresented: $showingImagePicker, content: {
        //                ImagePicker(image: $inputImage)
        //            })
        //
        //        }
        //        .onChange(of: inputImage) { _, _ in loadImage() }
        
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.gray.opacity(0.2))
                        
                        Text(recognizedText)
                            .padding()
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack {
                    Button(action: { self.showingImagePicker = true
                    }, label: {
                        Text("Scaning from images")
                    })
                    .padding()
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color.blue))
                    
                    Spacer()
                    
                    Button(action: {
                        self.showingScanningView = true
                    }, label: {
                        Text("Start Scanning")
                    })
                    .padding()
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color.blue))
                }
                .padding()
            }
            .navigationTitle("Text Recognition")
        }
        .sheet(isPresented: $showingScanningView, content: {
            ScanDocumentView(recognizedText: self.$recognizedText)
        })
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $inputImage)
        })
        .onChange(of: inputImage) { _, _ in loadImage() }
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
