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

    // MARK: Properties
    
    @IBOutlet weak var chartView: LineChartView!
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        chartView.rightAxis.enabled = false
        //chartView.xAxis.enabled = false
    
        chartView.dragEnabled = true
        if let currentEvent = CurrentEventProvider.currentEvent {
            let ecgPoints = DataParser.filterECG(event: currentEvent)
            CurrentEventProvider.duration = ecgPoints.count / Int(ChartConstants.ECGSampleRate)
            setChartData(ecgPoints: ecgPoints)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action Methods
    
    @IBAction func resizeTapped(_ sender: Any) {
        resizeChart()
    }
    
    // MARK: Chart Methods
    
    func setChartData(ecgPoints: [UInt16]) {
        
        var yVals : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< ecgPoints.count {
            yVals.append(ChartDataEntry(x: Double(i), y: Double(ecgPoints[i])))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals, label: "ECG Data")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.black.withAlphaComponent(0.5)) // line's opacity is 50%
        set1.lineWidth = 2.0
        set1.drawCirclesEnabled = false
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let lineData: LineChartData = LineChartData(dataSets: dataSets)
        lineData.setValueTextColor(UIColor.white)
        
        
        let limitLine = ChartLimitLine(limit: ChartConstants.ECGBaseline)
        limitLine.lineWidth = 1.0
        chartView.leftAxis.addLimitLine(limitLine)
        
        chartView.xAxis.valueFormatter = XAxisFormatter()
        chartView.data = lineData
        chartView.setVisibleXRange(minXRange: 1000, maxXRange: 1000);
        chartView.drawBordersEnabled = false
    }
    
    func resizeChart() {
        
        if chartView.frame.size.height == view.frame.height {
            UIView.transition(with: chartView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.chartView.frame.size.height -= 159
            }, completion: { finished in
            })
        } else {
            UIView.transition(with: chartView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.chartView.frame.size.height = self.view.frame.height
            }, completion: { finished in
            })
        }
    }    
    
}
