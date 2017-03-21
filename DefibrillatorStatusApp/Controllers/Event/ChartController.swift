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
    
    var chartLabel: ChartLabel!
    var existingVisisbleX: Double = 0
    @IBOutlet weak var traceView: LineChartView!
    @IBOutlet weak var expand: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartLabel = ChartLabel()
        traceView.delegate = self
        guard let currentEvent = CurrentEventProvider.currentEvent else { return }
        let ecgPoints = DataParser.filterECG(event: currentEvent)
        CurrentEventProvider.duration = ecgPoints.count / Int(ChartConstants.ECGSampleRate)
        setChartData(ecgPoints: ecgPoints)
        timeSliderSetup(dataPointsCount: ecgPoints.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action Methods
    
    @IBAction func resizeTapped(_ sender: Any) {
        resizeChart()
    }
    
    @IBAction func sliderInteraction(_ sender: UISlider) {
        chartLabel.isHidden = true
        traceView.moveViewToX(Double(timeSlider.value))
    }
    
    // MARK: Chart Delegate Methods
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
        chartLabel.isHidden = true
        
        if existingVisisbleX == traceView.lowestVisibleX { return }
        
        if existingVisisbleX < traceView.lowestVisibleX {
            timeSlider.setValue(Float(traceView.highestVisibleX), animated: true)
        } else {
            timeSlider.setValue(Float(traceView.lowestVisibleX), animated: true)
        }
        
        existingVisisbleX = traceView.lowestVisibleX
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        toggleComponents(off: false)
        let time = entry.x/ChartConstants.ECGSampleRate
        
        if time > 12.0 && time < 12.8 {
            chartLabel.shockLabel.text = "SHOCK"
        } else {
            chartLabel.shockLabel.text = ""
        }
        
        let position = traceView.getPosition(entry: entry, axis:  YAxis.AxisDependency.left)
        timeSlider.setValue(Float(entry.x), animated: true)
        chartLabel.frame.origin = CGPoint(x: position.x, y : 20)
        chartLabel.isHidden = false
        self.view.addSubview(chartLabel)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartLabel.isHidden = true
    }
    
    // MARK: Chart Setup
    
    func setChartData(ecgPoints: [UInt16]) {
        var chartValues = [ChartDataEntry]()
        for i in 0 ..< ecgPoints.count {
            chartValues.append(ChartDataEntry(x: Double(i), y: Double(ecgPoints[i])))
        }
        
        let ecgLine: LineChartDataSet = LineChartDataSet(values: chartValues, label: "ECG Data")
        setupECGLine(ecgLine: ecgLine)
        
        let lineData = LineChartData(dataSet: ecgLine)
        setupTraceView(lineData: lineData)
        
        if let event = CurrentEventProvider.currentEvent {
            traceView.chartDescription?.text = ("ECG trace from " + event.date)
            traceView.chartDescription?.font = .boldSystemFont(ofSize: 11)
            traceView.chartDescription?.textColor = Colour.HeartSineBlue
        }
    }
    
    // MARK: Setup Helpers
    
    func setupECGLine(ecgLine: LineChartDataSet) {
        ecgLine.axisDependency = .left
        ecgLine.setColor(UIColor.black.withAlphaComponent(0.5))
        ecgLine.lineWidth = 2.0
        ecgLine.drawCirclesEnabled = false
    }
    
    func setupTraceView(lineData: LineChartData) {
        let limitLine = ChartLimitLine(limit: ChartConstants.ECGBaseline)
        limitLine.lineWidth = 1.0
        traceView.leftAxis.addLimitLine(limitLine)
        traceView.xAxis.valueFormatter = XAxisFormatter()
        traceView.data = lineData
        traceView.setVisibleXRange(minXRange: 1000, maxXRange: 1000);
        traceView.drawBordersEnabled = false
        traceView.rightAxis.enabled = false
        traceView.dragEnabled = true
    }
    
    func timeSliderSetup(dataPointsCount: Int) {
        timeSlider.maximumValue = Float(dataPointsCount)
        timeSlider.minimumValue = 0
        timeSlider.value = 0
        timeSlider.setThumbImage(#imageLiteral(resourceName: "Shock"), for: .normal)
    }
    
    func resizeChart() {
        if traceView.frame.size.height != view.frame.height {
            UIView.transition(with: traceView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.traceView.frame.size.height = self.view.frame.height
                self.toggleComponents(off: true)
            }, completion: { finished in
            })
        }
    }
    
    func toggleComponents(off: Bool) {
        timeSlider.isHidden = off
        expand.isHidden = off
    }
}
