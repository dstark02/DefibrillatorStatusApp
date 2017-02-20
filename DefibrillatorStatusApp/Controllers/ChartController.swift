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
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var eventInfo: UIScrollView!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var numberOfShocks: UILabel!
    
    var selectedEvent : Event?
    var hideButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.isHidden = hideButton
        chartView.delegate = self
        chartView.rightAxis.enabled = false
        //chartView.xAxis.enabled = false
    
        chartView.dragEnabled = true
        if let currentEvent = selectedEvent {
            setChartData(event: currentEvent)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func resizeTapped(_ sender: Any) {
        resizeChart()
    }
    
    
    func setChartData(event: Event) {
        
        var ecgPoints = DataParser.filterECG(event: event)
        
        // 1 - creating an array of data entries
        var yVals : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< ecgPoints.count {
            yVals.append(ChartDataEntry(x: Double(i), y: Double(ecgPoints[i])))
        }
        
        eventDuration.text = String(ecgPoints.count / Int(ChartConstants.ECGSampleRate)) + " seconds"
        
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals, label: "ECG Data")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.black.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.lineWidth = 2.0
        set1.drawCirclesEnabled = false
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let lineData: LineChartData = LineChartData(dataSets: dataSets)
        lineData.setValueTextColor(UIColor.white)
        
        
        let limitLine = ChartLimitLine(limit: ChartConstants.ECGBaseline)
        limitLine.lineWidth = 1.0
        chartView.leftAxis.addLimitLine(limitLine)
        
        chartView.xAxis.valueFormatter = XAxisFormatter()
        //5 - finally set our data
        chartView.data = lineData
        chartView.setVisibleXRange(minXRange: 1000, maxXRange: 1000);
        chartView.drawBordersEnabled = false
    }
    
    
    func resizeChart() {
        
        if chartView.frame.size.height == view.frame.height {
            UIView.transition(with: chartView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.chartView.frame.size.height -= 159
            }, completion: { finished in
                self.eventInfo.isHidden = false
            })
        } else {
            UIView.transition(with: chartView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.chartView.frame.size.height = self.view.frame.height
                self.eventInfo.isHidden = true
            }, completion: { finished in
            })
        }
    }
    
}
