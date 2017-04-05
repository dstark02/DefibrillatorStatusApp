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
    
    var existingVisisbleX: Double = 0
    @IBOutlet weak var traceView: LineChartView!
    @IBOutlet weak var expand: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    var difference : CGFloat = 54.0
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traceView.delegate = self
        guard let currentEvent = CurrentEventProvider.currentEvent else { return }
        let (ecgPoints, markers) = DataParser.filter(event: currentEvent)
        CurrentEventProvider.duration = ecgPoints.count / Int(ChartConstants.ECGSampleRate)
        setChartData(ecgPoints: ecgPoints, markers: markers)
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
        traceView.moveViewToX(Double(timeSlider.value))
    }
    
    // MARK: Chart Delegate Methods
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
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
////            chartView.marker = nil
////        }
        timeSlider.setValue(Float(entry.x), animated: true)
        

//        
//        let position = traceView.getPosition(entry: entry, axis:  YAxis.AxisDependency.left)
//        timeSlider.setValue(Float(entry.x), animated: true)
//        chartLabel.frame.origin = CGPoint(x: position.x, y : 20)
//        chartLabel.isHidden = false
//        self.view.addSubview(chartLabel)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //chartLabel.isHidden = true
    }
    
    // MARK: Chart Setup
    
    func setChartData(ecgPoints: [UInt16], markers: [Marker]) {
        var chartValues = [ChartDataEntry]()
        for i in 0 ..< ecgPoints.count {
            chartValues.append(ChartDataEntry(x: Double(i), y: Double(ecgPoints[i])))
        }
        
        let ecgLine = LineChartDataSet(values: chartValues, label: "ECG Data")
        setupECGLine(ecgLine: ecgLine)
        
        
        
        
        let lineData = LineChartData(dataSet: ecgLine)
        setupTraceView(lineData: lineData, markers: markers, data: chartValues)
        
        if let event = CurrentEventProvider.currentEvent {
            traceView.chartDescription?.text = ("ECG trace from " + event.date)
            traceView.chartDescription?.font = .boldSystemFont(ofSize: 11)
            traceView.chartDescription?.textColor = Colour.HeartSineBlue
        }
    }
    
    // MARK: Setup Helpers
    
    func setupECGLine(ecgLine: LineChartDataSet) {
        ecgLine.setDrawHighlightIndicators(false)
        ecgLine.axisDependency = .left
        ecgLine.setColor(UIColor.black.withAlphaComponent(0.5))
        ecgLine.lineWidth = 2.0
        ecgLine.drawCirclesEnabled = false
        
    }
    
    func setupTraceView(lineData: LineChartData, markers: [Marker], data: [ChartDataEntry]) {
        let limitLine = ChartLimitLine(limit: ChartConstants.ECGBaseline)
        limitLine.lineWidth = 1.0
        traceView.leftAxis.addLimitLine(limitLine)
        traceView.xAxis.valueFormatter = XAxisFormatter()
        traceView.data = lineData
        let marker = BalloonMarker(color: Colour.HeartSineBlue, font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 20.0))
        marker.minimumSize = CGSize (width: 50, height: 50)
        traceView.marker = marker
        var highlights = [Highlight]()
       
        
        
        
        for marker in markers {
            
            highlights.append(Highlight(x: Double(marker.markerSample), y: Double(data[Int(marker.markerSample)].y), dataSetIndex: 0, label: Marker.markerDictionary[marker.markerCode]!))
        }
//        let monitorHighlight = Highlight(x: 391, y: 39477, dataSetIndex: 0)
//        highlights.append(monitorHighlight)
//        let shockHighlight = Highlight(x: 3089.0, y: 52982, dataSetIndex: 0)
//        highlights.append(shockHighlight)
//        let cprHighlight = Highlight(x: 3393.0, y: 42263, dataSetIndex: 0)
//        highlights.append(cprHighlight)
        traceView.highlightValues(highlights)
        traceView.setVisibleXRange(minXRange: 800, maxXRange: 800);
        traceView.drawBordersEnabled = false
        traceView.rightAxis.enabled = false
        traceView.dragEnabled = true
        traceView.highlightPerTapEnabled = false
        
    }
    
    func timeSliderSetup(dataPointsCount: Int) {
        timeSlider.maximumValue = Float(dataPointsCount)
        timeSlider.value = 0
        timeSlider.setThumbImage(#imageLiteral(resourceName: "Shock"), for: .normal)
    }
    
    func resizeChart() {
        if traceView.frame.size.height != view.frame.height {
            UIView.transition(with: traceView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.difference = self.view.frame.size.height - self.traceView.frame.height
                self.traceView.frame.size.height = self.view.frame.height
                self.toggleComponents(off: true)
            }, completion: { finished in
            })
        } else {
            
            UIView.transition(with: traceView, duration: 1.0, options: .curveEaseInOut, animations: {
                self.traceView.frame.size.height -= self.difference
            }, completion: { finished in
                self.toggleComponents(off: false)
            })
        }
    }
    
    func toggleComponents(off: Bool) {
        timeSlider.isHidden = off
    }
}
