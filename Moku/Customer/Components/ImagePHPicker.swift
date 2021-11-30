//
//  ImagePHPicker.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 01/11/21.
//

import SwiftUI
import PhotosUI

struct ImagePHPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 0
        return config
    }()
    
    @Binding var pickerResult: [UIImage]
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    /// PHPickerViewControllerDelegate => Coordinator
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: ImagePHPicker
        init(_ parent: ImagePHPicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let newImage = newImage as? UIImage {
                                DispatchQueue.main.async {
                                    self.parent.pickerResult.append(newImage)
                                }
                            }
                        }
                    }
                } else {
                    print("Loaded Assest is not a Image")
                }
            }
            // dissmiss the picker
            parent.isPresented = false
        }
    }
}
