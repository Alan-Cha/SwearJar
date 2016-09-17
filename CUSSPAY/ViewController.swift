//
//  ViewController.swift
//  CUSSPAY
//
//  Created by Hope Jin on 9/17/16.
//  Copyright © 2016 BigRedHacks#3. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(value: 1),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            let audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL, settings: recordSettings)
            audioRecorder.prepareToRecord()
        }
        catch {
            
        }
    }

    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL as NSURL?
    }
    @IBAction func mainButton(_ sender: UIButton) {
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record
            } catch{
                
            }
        }
        else if audioRecorder.recording {
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setActive(false)
            } catch {
                
        }
    }
    
        
}
