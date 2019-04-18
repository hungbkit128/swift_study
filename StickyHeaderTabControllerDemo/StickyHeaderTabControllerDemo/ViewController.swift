//
//  ViewController.swift
//  StickyHeaderTabControllerDemo
//
//  Created by Tran Van Hung on 11/15/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let string = "what is your name? my name is hung"
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        //utterance.voice = AVSpeechSynthesisVoice(language: "vi-VN")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
}

