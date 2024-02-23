//
//  TestCalendarViewController.swift
//  TODORI
//
//  Created by 제이콥 on 2/16/24.
//

import UIKit
import FSCalendar

class TestCalendarViewController: UIViewController {
    var calendarView: FSCalendar = {
        var calendarView = FSCalendar()
        calendarView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        calendarView.headerHeight = 0
        calendarView.select(calendarView.today)
        calendarView.firstWeekday = 2
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        calendarView.appearance.selectionColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        calendarView.appearance.todayColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        calendarView.appearance.titleTodayColor = UIColor(red: 0.246, green: 0.246, blue: 0.246, alpha: 1)
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.weekdayTextColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .red
        calendarView.locale = Locale(identifier: "ko_KR")
        return calendarView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(calendarView)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
