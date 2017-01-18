//
//  DataController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 13/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class ChartController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        chartView.delegate = self
        chartView.gridBackgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        setChartData()
    }
    
    func setChartData() {
        
        var ecgPoints = DataParser.filterECG(data: getECGPointsFromDatabase())
        var seconds = [String]()
        
        // 1 - creating an array of data entries
        var yVals : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< ecgPoints.count {
            seconds.append(String(i))
            yVals.append(ChartDataEntry(x: Double(i), y: Double(ecgPoints[i])))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals, label: "First Data Set")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.black.withAlphaComponent(0.5)) // our line's opacity is 50%
        // our circle will be dark red
        set1.lineWidth = 2.0
        set1.drawCirclesEnabled = false
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let lineData: LineChartData = LineChartData(dataSets: dataSets)
        lineData.setValueTextColor(UIColor.white)
        
        //5 - finally set our data
        chartView.data = lineData
    }
    
    func getECGPointsFromDatabase() -> Results<ECG> {
        do {
            let realm = try Realm()
            return realm.objects(ECG.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    

    

}
