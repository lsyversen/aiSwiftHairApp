//
//  CameraViewModel.swift
//  hairapp
//
//  Created by Liam Syversen on 9/4/24.
//

import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var previewLayer = AVCaptureVideoPreviewLayer()
    @Published var isTaken = false

    private var output = AVCapturePhotoOutput()
    private var deviceInput: AVCaptureDeviceInput?
    private var photoCompletionHandler: ((UIImage?) -> Void)? // Completion handler as a property

    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                }
            }
        default:
            break
        }
    }

    func setupCaptureSession() {
        session.beginConfiguration()

        // Use optional binding to safely unwrap the device
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Error: No front camera found")
            return
        }

        // Only wrap the AVCaptureDeviceInput in a do-catch since it throws
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
                deviceInput = input
            } else {
                print("Error: Couldn't add input to the session")
            }
        } catch {
            print("Error creating device input: \(error.localizedDescription)")
            return
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            print("Error: Couldn't add output to the session")
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill

        session.commitConfiguration()
        session.startRunning()
    }

    func takePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCompletionHandler = completion // Store the completion handler
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
        self.isTaken = true
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            photoCompletionHandler?(nil)
            return
        }

        let image = UIImage(data: imageData)
        DispatchQueue.main.async {
            self.photoCompletionHandler?(image)
        }
    }
}

