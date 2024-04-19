import AVFoundation
import UIKit


public class CameraSource {
    
    let videoOutput = AVCaptureVideoDataOutput();
    private let previewLayer = AVCaptureVideoPreviewLayer()
    var session: AVCaptureSession?
    private var dimensions: (Int32, Int32) = (0 , 0)
    let backgroundVideoQueue = DispatchQueue.global(qos: .background)
    private var running = false
//    public var delegate: CameraSourceDelegate?
    var currentCameraPosition: AVCaptureDevice.Position?
    
    public init(position: AVCaptureDevice.Position, preset: AVCaptureSession.Preset = .hd1920x1080) {
       
        /// setup session
        /// calculates the dimensions
        session = setupCaptureSession(position: position, preset: preset)

        DispatchQueue.global().async {
            /// Set the session to output video frames
            self.session?.startRunning()
        }
    }
    
    public func switchCamera() {
//        self.delegate?._CameraSource(switchStarted: true)
   
        session?.beginConfiguration()
        // Remove existing input
        if let currentInput = session?.inputs.first as? AVCaptureInput {
            session?.removeInput(currentInput)
        }
        
        // Toggle camera position
        let position: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
        self.currentCameraPosition = position
        // Set up new video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            print("Failed to get AVCaptureDevice for video input.")
            return
        }
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if session?.canAddInput(videoInput) ?? false {
                session?.addInput(videoInput)
            } else {
                print("Failed to add video input to session.")
            }
        } catch {
            print("Error creating AVCaptureDeviceInput: \(error.localizedDescription)")
        }
        session?.commitConfiguration()
     
//        self.delegate?._CameraSource(switchEnded: true)
    }
    
    private func addCamera(session: AVCaptureSession, position: AVCaptureDevice.Position) -> AVCaptureDeviceInput? {
        self.currentCameraPosition = position
        do {
            /// Check if the device has a camera
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera ,for: .video, position: position) else {
                print("Camera not available")
                return nil
            }
            /// Create input from the camera
            let input = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            return input
        } catch {
            print(error)
        }
        return nil
    }
    
    private func setupCaptureSession(position: AVCaptureDevice.Position, preset: AVCaptureSession.Preset) -> AVCaptureSession? {
        do {
            // Create a session and add the input
            let session = AVCaptureSession()
            /// add camera to session input
            let cameraInput = addCamera(session: session, position: position)
            guard let camera = cameraInput?.device else {
                return nil
            }
            /// add videooutput as session output
            videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32),]
            if session.canAddOutput(videoOutput) {
                session.sessionPreset = preset
                session.addOutput(videoOutput)
                
            }
            
            /// set framerate 30
            do {
                try camera.lockForConfiguration()
                let desiredFrameRate = CMTimeMake(value: 1, timescale: 30)
                camera.activeVideoMinFrameDuration = desiredFrameRate
                camera.activeVideoMaxFrameDuration = desiredFrameRate
                camera.unlockForConfiguration()
                
            } catch {
                print("Error accessing video device: \(error)")
            }
            /// just print the current resoultion
            let activeFormat = camera.activeFormat.formatDescription
            let dimensions = CMVideoFormatDescriptionGetDimensions(activeFormat)
            let width = dimensions.width
            let height = dimensions.height
            print("Resolution: \(width) x \(height)")
            self.dimensions = (width , height)
            
            return session
        } catch {
            print("Error setting up AVCaptureDeviceInput: \(error)")
        }
    }
    
    public func getDimensions() -> (Int, Int) {
        return (Int(self.dimensions.0), Int(self.dimensions.1))
    }
    
    public func startPreview(previewView: UIView?) {
        /// Set the preview layer to display the camera feed
        if let view = previewView {
            DispatchQueue.main.async {
                self.previewLayer.session = self.session
                self.previewLayer.videoGravity = .resizeAspectFill
                /// Add the preview layer to your view's layer
                view.layer.insertSublayer(self.previewLayer, at: 0)
                /// Optional: Adjust the frame of the preview layer
                self.previewLayer.frame = view.layer.bounds
            }
        }
    }
    
    public func start() {
        self.running = true
    }
    
    public func stop() {
        self.running = false
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    /// check if torch is on or off
    public var isTorchOn: Bool {
        if let device = AVCaptureDevice.default(for: .video) {
            return device.hasTorch && device.isTorchActive
        }
        return false
    }
    
    /// Toggle torch
    public func toggleTorch(level: Float = 1.0) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.isTorchActive {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: level)
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Error toggling torch: \(error.localizedDescription)")
        }
    }
}
