// This code defines a struct called "ImagePicker" that conforms to the "UIViewControllerRepresentable" protocol in SwiftUI.

import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    
    // A binding to a UIImage optional variable named "image".
    @Binding var image: UIImage?

    // Create a private instance of "UIImagePickerController" named "controller".
    private let controller = UIImagePickerController()

    // A function that creates and returns a "Coordinator" instance to coordinate communication between the view and the view controller.
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // A class named "Coordinator" that conforms to the "UIImagePickerControllerDelegate" and "UINavigationControllerDelegate" protocols.
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // A reference to the "ImagePicker" instance that created this "Coordinator" instance.
        let parent: ImagePicker
        
        // An initializer that sets the "parent" variable to the "ImagePicker" instance that created this "Coordinator" instance.
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // A function that is called when the user selects an image in the image picker controller.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Sets the "image" variable in the "parent" instance to the selected image.
            parent.image = info[.originalImage] as? UIImage
            // Dismisses the image picker controller.
            picker.dismiss(animated: true)
        }
        
        // A function that is called when the user cancels the image picker controller.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Dismisses the image picker controller.
            picker.dismiss(animated: true)
        }
    }

    // A function that creates and returns a "UIViewController" instance that wraps the "controller" instance.
    func makeUIViewController(context: Context) -> some UIViewController {
        // Sets the delegate of the "controller" instance to the "Coordinator" instance created by "makeCoordinator()".
        controller.delegate = context.coordinator
        return controller
    }

    // An empty function that is called when the view controller is updated.
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }

    
}
