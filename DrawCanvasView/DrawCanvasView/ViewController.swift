//
//  ViewController.swift
//  DrawCanvasView
//
//  Created by Hưng Trần on 1/25/19.
//  Copyright © 2019 Hưng Trần. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    override func draw(_ rect: CGRect) {
        
        // custom draw
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // here my line
//        let startPoint = CGPoint(x: 0, y: 0)
//        let endPoint = CGPoint(x: 100, y: 100)
//        context.move(to: startPoint)
//        context.addLine(to: endPoint)
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.round)
        
        lines.forEach{ (line) in
            for (index, pointItem) in line.enumerated() {
                if index == 0 {
                    context.move(to: pointItem)
                } else {
                    context.addLine(to: pointItem)
                }
            }
        }
        
        
        context.strokePath()
    }
    
    //var line = [CGPoint]()
    var lines = [[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    // track the figer as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else {
            return
        }
        print(point)
        
        //line.append(point)
        
        //var lastLine = lines.last
        //lastLine?.append(point)
        
        guard var lastLine = lines.popLast() else {
            return
        }
        lastLine.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
}

class ViewController: UIViewController {
    
    let canvas = Canvas()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }


}

