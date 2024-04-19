//
//  LiveViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import UIKit
import HaishinKit
import AVFoundation
import Logboard

class LiveViewController: UIViewController {

    
    @IBOutlet weak var actionBtn: UIControl!
    @IBOutlet weak var hkView: MTHKView!
    let streamname = "stream1"
    
    let connection = RTMPConnection()
    var stream: RTMPStream!
    var isPublishing = false {
        didSet {
            if isPublishing {
                actionBtn.layer.cornerRadius = 8
            } else {
                actionBtn.layer.cornerRadius = 30
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateSession()
        setupHaishinKit()
        isPublishing = false
    }
    
    
    func activateSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func setupHaishinKit() {
        stream = RTMPStream(connection: connection)
        stream.attachAudio(AVCaptureDevice.default(for: .audio)) {err in
            print(err)
        }

        stream.attachCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)) {err in
                print(err)
        }
        
        hkView.attachStream(stream)
        stream.delegate = self

    }
    
    @IBAction func onActionPublish(_ sender: Any) {
        togglePublish(publish: !isPublishing)
    }
    
    func togglePublish(publish: Bool) {
        if publish {
           
            print("Publishing...")
            connection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            connection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            connection.connect("rtmp://192.168.1.100:1935")
          
        } else {
            print("Closing...")
            connection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            connection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            stream.close()
            connection.close()
           
        }
    }
    
    @objc
        private func rtmpErrorHandler(_ notification: Notification) {
            print(notification)
        
        }
    
    @objc
        private func rtmpStatusHandler(_ notification: Notification) {
            let e = Event.from(notification)
            guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
                print("Null")
                return
            }
    
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                stream.publish(streamname)
            case RTMPConnection.Code.connectFailed.rawValue:
                print("Connect Failed")
                break
            case RTMPConnection.Code.connectClosed.rawValue:
                print("Connect Closed")
                break
            default:
                print(code)
                break
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LiveViewController: IOStreamDelegate {
    func stream(_ stream: HaishinKit.IOStream, didOutput audio: AVAudioBuffer, when: AVAudioTime) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, didOutput video: CMSampleBuffer) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, sessionWasInterrupted session: AVCaptureSession, reason: AVCaptureSession.InterruptionReason?) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, sessionInterruptionEnded session: AVCaptureSession) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, videoErrorOccurred error: HaishinKit.IOVideoUnitError) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, audioErrorOccurred error: HaishinKit.IOAudioUnitError) {
        
    }
    
    func streamDidOpen(_ stream: HaishinKit.IOStream) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, willChangeReadyState state: HaishinKit.IOStream.ReadyState) {
        
    }
    
    func stream(_ stream: HaishinKit.IOStream, didChangeReadyState state: HaishinKit.IOStream.ReadyState) {
        DispatchQueue.main.async {
            print(state)
            switch state {
            case .publish:
                self.isPublishing = true
            case .open:
                self.isPublishing = false
            default:
                break
            }
        }
    }
    
    
}
