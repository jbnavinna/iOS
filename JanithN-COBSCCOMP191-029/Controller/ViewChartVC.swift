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
import Firebase
import FirebaseAuth
import FirebaseFirestore


class ViewChartVC: UIViewController{
    
   
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    static var lowCount=0
    static var midCount=0
    static var highCount=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get data from firebase on the count of infectious people from firestore to count
            let low="low possibility"
            let mid="mid possibility"
            let high="high possibility"
            
            
            
            let db = Firestore.firestore()
            
            db.collection("users").whereField("health", isEqualTo: low).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    ViewChartVC.lowCount = ViewChartVC.lowCount+querySnapshot!.count
                    print("lowcnt",querySnapshot!.count)

                    db.collection("users").whereField("health", isEqualTo: mid).getDocuments() { (querySnapshot, err) in
                      if let err = err {
                          print("Error getting documents: \(err)")
                      } else {
                        ViewChartVC.midCount = ViewChartVC.midCount+querySnapshot!.count
                        print("midcnt",querySnapshot!.count)
                        
                        db.collection("users").whereField("health", isEqualTo: high).getDocuments() { (querySnapshot, err) in
                          if let err = err {
                              print("Error getting documents: \(err)")
                          } else {
                            ViewChartVC.highCount = ViewChartVC.highCount+querySnapshot!.count
                            print("highcnt",querySnapshot!.count)
                            
                            //setup the survey chart
                            
                            let dataPoints = ["Low","High","Medium"]
                            

                            print("low",ViewChartVC.lowCount)
                            print("med",ViewChartVC.midCount)
                            print("high",ViewChartVC.highCount)


                            let count = [ViewChartVC.lowCount, ViewChartVC.highCount, ViewChartVC.midCount]
                            self.setChart(dataPoints: dataPoints, values: count)
                            
                            
                          }
                        }
                        
                        
                      }
                    }
                    
                    
                }
            }
            
            
        
   
    }
    func setChart(dataPoints: [String], values: [Int]) {
       var dataEntries: [PieChartDataEntry] = []

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
