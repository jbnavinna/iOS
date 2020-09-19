//
//  ViewChartVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import Charts


class ViewChartVC: UIViewController{
    
   
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataPoints = ["Low","High","Medium"]

           let count = [10, 4, 6]
        setChart(dataPoints: dataPoints, values: count)
   
    }
    func setChart(dataPoints: [String], values: [Int]) {
       var dataEntries: [PieChartDataEntry] = []

//          let dataPoints = ["Mar","Apr","May"]

          for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: Double(Int(values[i])), label: dataPoints[i])
              dataEntries.append(dataEntry)
          }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = [UIColor(red: 47/255, green: 164/255, blue: 59/255, alpha: 1.0),UIColor.red,UIColor.orange]
          let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
          pieChartView.data = pieChartData
          pieChartView.centerText = "Current Cases Possibility"
          pieChartView.chartDescription?.text = ""
          pieChartView.usePercentValuesEnabled = true
          pieChartView.legend.horizontalAlignment = .center
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
