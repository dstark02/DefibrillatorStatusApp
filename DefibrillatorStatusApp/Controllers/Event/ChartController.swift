//
//  ChartController.swift
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
    var chartLabel : ChartLabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var timeSlider: UISlider!
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        chartView.rightAxis.enabled = false
        //chartView.xAxis.enabled = false
        chartLabel = ChartLabel()
        chartView.dragEnabled = true
        guard let currentEvent = CurrentEventProvider.currentEvent else { return }
        let ecgPoints = DataParser.filterECG(event: currentEvent)
        CurrentEventProvider.duration = ecgPoints.count / Int(ChartConstants.ECGSampleRate)
        setChartData(ecgPoints: ecgPoints)
        timeSlider.maximumValue = Float(ecgPoints.count)
        timeSlider.minimumValue = 0
        timeSlider.value = 0
    }
    
    
    @IBAction func sliderInteraction(_ sender: UISlider) {
        chartView.moveViewToX(Double(timeSlider.value))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        var xPt = highlight.xPx
        let yPt = highlight.yPx
        //chartLabel.timeSlider.maximumValue = Float(CurrentEventProvider.duration!)
        
        
        chartLabel.timeLabel.text = "\(entry.x/ChartConstants.ECGSampleRate)"
        
        let actualWidth = xPt + 133
        
        if actualWidth > chartView.frame.width {
            xPt = 200
        }
        
        timeSlider.setValue(Float(entry.x), animated: true)
        
        chartLabel.center = CGPoint(x: xPt, y : chartLabel.center.y)
        chartLabel.isHidden = false
        self.view.addSubview(chartLabel)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartLabel.isHidden = true
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        chartLabel.isHidden = true
    }
    
//    func saveGraph() {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//    }
    
    
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
                self.chartView.frame.size.height -= 59
            }, completion: { finished in
                self.timeSlider.isHidden = false
            })
        } else {
            UIView.transition(with: chartView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.chartView.frame.size.height = self.view.frame.height
                self.timeSlider.isHidden = true
            }, completion: { finished in
            })
        }
    }    
    
}
