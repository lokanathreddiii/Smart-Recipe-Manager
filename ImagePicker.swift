//
//  ImagePicker.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {

    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ZStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                        Text("Select Image")
                            .font(.footnote)
                    }
                    .foregroundColor(.gray)
                }
            }
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .clipped()
        }
        .onChange(of: selectedItem) { _, newItem in
            if let newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}
