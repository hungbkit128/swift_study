//
//  ERPChartVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/5/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import Charts

class ERPChartVC: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    
    var num1:Int = 0
    var num2:Int = 1
    var num3:Int = 3
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!;
    }
    
    init(num1:Int, num2:Int, num3:Int)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.num1 = num1
        self.num2 = num2
        self.num3 = num3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        barChartUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func barChartUpdate () {
        //future home of bar chart code
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(num1))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(num2))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(num3))
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3], label: "Widgets Type")
        dataSet.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.chartDescription?.text = "Number of Widgets by Type"
        
        barChart.notifyDataSetChanged()
    }
}
