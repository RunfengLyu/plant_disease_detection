//
//  RecordView.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 30.09.22.
//

import SwiftUI
import UIKit
import AVFoundation

class RecordSurfaceController: UIViewController {
    var delegate: AVCapturePhotoCaptureDelegate!
    
    var captureSession: AVCaptureSession!
    var output: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet var captureView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else { fatalError() }
        let input = try! AVCaptureDeviceInput(device: backCamera)
        output = AVCapturePhotoOutput()
        
        if captureSession.canAddInput(input) && captureSession.canAddOutput(output) {
            captureSession.addInput(input)
            captureSession.addOutput(output)
        } else {
            fatalError()
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        captureView.layer.addSublayer(videoPreviewLayer)
        
        // Add layer
        // let coverView = UIView(frame: captureView.frame)
        // coverView.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
        // captureView.addSubview(coverView)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.captureView.frame
        }
    }
    
    @IBAction func takePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        output.capturePhoto(with: settings, delegate: self.delegate)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
}

struct RecordView: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> some RecordSurfaceController {
        let controller = Bundle.main.loadNibNamed("RecorderView", owner: self)!.first as! RecordSurfaceController
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }
}

class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
    
    @Binding var image: UIImage?
    
    init(image: Binding<UIImage?>) {
        self._image = image
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: data) else { return }
        self.image = crop(image)
    }
    
    func crop(_ image: UIImage) -> UIImage {
        let size = image.size
        
        let x = size.width / 2.0 - 500.0
        let y = size.height / 2.0 - 500.0
        
        let cropRect = CGRect(x: y, y: x, width: 1000, height: 1000).integral
        let cgImg = image.cgImage!
        let croppedCG = cgImg.cropping(to: cropRect)!
        return UIImage(
            cgImage: croppedCG,
            scale: image.imageRendererFormat.scale,
            orientation: image.imageOrientation
        )
    }
}
