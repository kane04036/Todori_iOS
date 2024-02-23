//
//  BottomSheetViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/08/07.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController{
    var todo: ToDo?
    var delegate: BottomSheetViewControllerDelegate?
    var bottomSheetView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.defaultColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        return view
    }()
    var colorBarViewInBottomsheet: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4.5
        view.backgroundColor = .gray //임의
        return view
    }()
    var titleTextFieldInBottomSheet: UITextField = {
        var textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textfield.textColor = UIColor.textColor
        textfield.placeholder = "토도리스트 입력"
        return textfield
    }()
    var dateLabelInBottomSheet: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    var descriptionBackgroundView: UIView = UIView()
    var descriptionTextView: UITextView = {
        var textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 14, weight: .light)
        textview.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textview.clipsToBounds = true
        textview.layer.cornerRadius = 10
        textview.textColor = UIColor.textColor
        textview.backgroundColor = UIColor.descriptionBackground
        textview.textContainer.lineBreakMode = .byCharWrapping
        return textview
    }()
    
    var blackViewOfBottomSheet: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    var blackViewOfDatePicker: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        //        view.frame = view.frame
        //화면 꽉 차게 설정하기
        return view
    }()
    var blackViewOfDrawer: UIView = UIView()
    var clockImageView: UIImageView = UIImageView(image: UIImage(named: "clock"))
    var timeLiterallyLabel: UILabel = {
        var label = UILabel()
        label.text = "시간"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .textColor
        return label
    }()
    var timeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textColor
        label.isUserInteractionEnabled = true
        return label
    }()
    var datePickerBackgroundView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = .defaultColor
        return view
    }()
    var datePicker: UIDatePicker = {
        var datepicker = UIDatePicker()
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.datePickerMode = .time
        datepicker.locale = Locale(identifier: "ko_KR")
        return datepicker
    }()
    var deleteButtonInDatePicker: UIButton = {
        var button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    var redCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 1
        button.setImage(UIImage(named: "red-circle"), for: .normal)
        return button
    }()
    var yellowCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 2
        button.setImage(UIImage(named: "yellow-circle"), for: .normal)
        return button
    }()
    var greenCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 3
        button.setImage(UIImage(named: "green-circle"), for: .normal)
        return button
    }()
    var blueCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 4
        button.setImage(UIImage(named: "blue-circle"), for: .normal)
        return button
    }()
    var pinkCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 5
        button.setImage(UIImage(named: "pink-circle"), for: .normal)
        return button
    }()
    var purpleCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 6
        button.setImage(UIImage(named: "purple-circle"), for: .normal)
        return button
    }()
    
    var circleButtonArray: [UIButton] = []
    
    var colorCircleButtonStackView: UIStackView = {
        var stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        return stackview
    }()
    var grayLineInBottomSheet: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        return view
    }()
    let textviewPlaceholder: String = "+ 메모하고 싶은 내용이 있나요?"
    
    var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    var finishButton: UIButton = {
        var button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    var calendarBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    var calendarView: UIDatePicker = {
        var calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        return calendar
    }()
    
    var blackViewOfCalendarView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    var bottomSheetHeightConstraint: ConstraintMakerEditable?
    var datePickerBackgroundViewHeightConstraint: ConstraintMakerEditable?
    var descriptionTextViewHeightConstraint: ConstraintMakerEditable?
    var calendarBackgroundViewHeightConstraint: ConstraintMakerEditable?
    var bottomSheetHeight: CGFloat = 0
    var nowHour: String = "99"
    var nowMin: String = "99"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        
        circleButtonArray = [redCircleButton, yellowCircleButton, greenCircleButton, blueCircleButton, pinkCircleButton, purpleCircleButton]
        
        addFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if let todo = todo{
            //bottom sheet 내부 컬러바 색상 설정
            colorBarViewInBottomsheet.backgroundColor = Color.shared.UIColorArray[todo.color-1]
            //날짜 라벨 텍스트 색상 설정
            
            let components = DateComponents(year: Int(todo.year), month: Int(todo.month), day: Int(todo.day))
            if let date = Calendar.current.date(from: components){
                let date = DateFormat.shared.getYearMonthDayDictionary(date: date)
                dateLabelInBottomSheet.text = "\(date["month"]!)월 \(date["day"]!)일 \(date["weekday"]!)"
            }
            dateLabelInBottomSheet.textColor = Color.shared.UIColorArray[todo.color-1]
            //title text field에 해당 title로 설정
            titleTextFieldInBottomSheet.text = todo.title
            
            //메모가 있을때, 없을 때 설정
            if todo.description.count > 0{
                descriptionTextView.text = todo.description
                descriptionTextView.textColor = .black
                
                let size = CGSize(width: descriptionTextView.bounds.width, height: .infinity)
                let newSize = descriptionTextView.sizeThatFits(size)
                guard let lineHeight = descriptionTextView.font?.lineHeight else {return}
                if newSize.height/lineHeight < 6 {
                    descriptionTextView.snp.makeConstraints({ make in
                        descriptionTextViewHeightConstraint = make.height.equalTo(newSize.height)
                    })
                    descriptionTextView.invalidateIntrinsicContentSize()
                    view.updateConstraints()
                    view.layoutIfNeeded()
                }else{
                    descriptionTextView.snp.makeConstraints { make in
                        descriptionTextViewHeightConstraint = make.height.equalTo(24 + lineHeight * 4)
                    }
                    
                    descriptionTextView.invalidateIntrinsicContentSize()
                    view.layoutIfNeeded()
                }
                
            }else{
                descriptionTextView.text = textviewPlaceholder
                descriptionTextView.textColor = .gray
                
                descriptionTextView.snp.makeConstraints { make in
                    guard let lineHeight = descriptionTextView.font?.lineHeight else {
                        //메모 텍스트뷰의 줄 높이를 구하는 것을 실패하면 적절한 수치로 설정
                        descriptionTextViewHeightConstraint = make.height.equalTo(41)
                        return
                    }
                    descriptionTextViewHeightConstraint = make.height.equalTo((lineHeight)+24)
                }
            }
            
            //설정된 시간이 있을 때, 없을 때 설정
            let time = todo.time
            nowHour = String(time.prefix(2))
            nowMin = String(time.suffix(2))
            
            if time == "9999"{
                timeLabel.text = "미지정"
                timeLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
            }else{
                if let time = Int(time){
                    if time >= 1200 {
                        timeLabel.text = "오후 \(nowHour):\(nowMin)"
                    }else {
                        timeLabel.text = "오전 \(nowHour):\(nowMin)"
                    }
                }
                timeLabel.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
            }
            //현재 투두의 id, section, row, color 저장 - bottom sheet 외부 클릭시 변경 사항을 저장하기 위함
            //            nowId = todo.id
            //            nowSection = existingColorArray[indexPath.section]
            //            nowRow = indexPath.row
            //            nowColor = todo.color
            
            setCircleButtonImage()
            switch(todo.color){
            case 1: redCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
            case 2: yellowCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
            case 3: greenCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
            case 4: blueCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
            case 5: pinkCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
            case 6: purpleCircleButton.setImage(Color.shared.getSeletedCircleImage(colorNum: todo.color), for: .normal)
            default: break
            }
        }
        
        setUI()
    }
    
    func addFunction(){
        timeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel)))
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        blackViewOfBottomSheet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBottomSheetBlackViewDismiss)))
        deleteButtonInDatePicker.addTarget(self, action: #selector(tapDeleteButton), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchDown)
        finishButton.addTarget(self, action: #selector(tapFinishButton), for: .touchDown)
        circleButtonArray.forEach({$0.addTarget(self, action: #selector(tapColorCircleButton(_:)), for: .touchDown)})
        dateLabelInBottomSheet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDateLabel)))
    }
    
    func setUI(){
        self.view.addSubview(blackViewOfBottomSheet)
        self.view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubViews([colorBarViewInBottomsheet, titleTextFieldInBottomSheet,
                                     dateLabelInBottomSheet, descriptionTextView, clockImageView,
                                     timeLiterallyLabel, timeLabel, grayLineInBottomSheet,
                                     colorCircleButtonStackView])
        
        
        colorCircleButtonStackView.addArrangedSubviews(circleButtonArray)

        blackViewOfBottomSheet.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            bottomSheetHeightConstraint = make.height.equalTo(0)
        }
        
        dateLabelInBottomSheet.snp.makeConstraints { make in
            make.top.equalTo(colorBarViewInBottomsheet.snp.top)
            make.left.equalTo(colorBarViewInBottomsheet.snp.right).offset(8)
        }
        
        titleTextFieldInBottomSheet.snp.makeConstraints { make in
            make.left.equalTo(dateLabelInBottomSheet)
            make.top.equalTo(dateLabelInBottomSheet.snp.bottom).offset(3)
            make.right.equalToSuperview().offset(-25)
        }
        
        colorBarViewInBottomsheet.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(9)
            make.bottom.equalTo(titleTextFieldInBottomSheet)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldInBottomSheet.snp.bottom).offset(16)
            make.centerX.equalTo(self.view)
            make.right.equalTo(self.view).offset(-25)
            make.left.equalTo(self.view).offset(25)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalTo(descriptionTextView)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(22)
        }
        
        timeLiterallyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(clockImageView.snp.right).offset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(timeLiterallyLabel.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        grayLineInBottomSheet.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(timeLiterallyLabel.snp.bottom).offset(26)
            make.height.equalTo(1)
        }
        
        redCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        yellowCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        greenCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        blueCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        pinkCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        purpleCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        colorCircleButtonStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-42)
            make.left.equalToSuperview().offset(42)
            make.top.equalTo(grayLineInBottomSheet).offset(13)
        }
        titleTextFieldInBottomSheet.becomeFirstResponder()
    }

    
    private func setDatePickerViewUI(){
        self.view.addSubViews([blackViewOfDatePicker, datePickerBackgroundView])
        datePickerBackgroundView.addSubViews([datePicker, cancelButton, finishButton, deleteButtonInDatePicker])
        
        blackViewOfDatePicker.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        datePickerBackgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            if datePickerBackgroundViewHeightConstraint == nil {
                datePickerBackgroundViewHeightConstraint = make.height.equalTo(0)
            }else{
                self.datePickerBackgroundViewHeightConstraint?.constraint.update(offset: 0)
            }
        }
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.datePickerBackgroundViewHeightConstraint?.constraint.update(offset: 380)
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.updateConstraints()
        }
        
        finishButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(25)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.right.equalTo(finishButton.snp.left).offset(-32)
            make.centerY.equalTo(finishButton)
        }
        
        datePicker.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        deleteButtonInDatePicker.snp.makeConstraints { make in
            make.centerY.equalTo(finishButton)
            make.left.equalToSuperview().offset(25)
        }
    }
    
    private func setCalendarViewUI(){
        print("setCalendarViewUI")
        calendarBackgroundView.addSubViews([calendarView, finishButton, cancelButton])
        self.view.addSubViews([blackViewOfCalendarView, calendarBackgroundView])
        
        blackViewOfCalendarView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        calendarBackgroundView.snp.makeConstraints { make in
            make.width.bottom.equalToSuperview()
            
            if calendarBackgroundViewHeightConstraint == nil{
                calendarBackgroundViewHeightConstraint = make.height.equalTo(0)
            }else{
                calendarBackgroundViewHeightConstraint?.constraint.update(offset: 0)
            }
        }
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.calendarBackgroundViewHeightConstraint?.constraint.update(offset: 380)
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.updateConstraints()
        }
        
        finishButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(25)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.right.equalTo(finishButton.snp.left).offset(-32)
            make.centerY.equalTo(finishButton)
        }

        calendarView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(finishButton.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func tapColorCircleButton(_ sender: UIButton){
        redCircleButton.setImage(UIImage(named: "red-circle"), for: .normal)
        yellowCircleButton.setImage(UIImage(named: "yellow-circle"), for: .normal)
        greenCircleButton.setImage(UIImage(named: "green-circle"), for: .normal)
        blueCircleButton.setImage(UIImage(named: "blue-circle"), for: .normal)
        pinkCircleButton.setImage(UIImage(named: "pink-circle"), for: .normal)
        purpleCircleButton.setImage(UIImage(named: "purple-circle"), for: .normal)
        
        todo?.color = sender.tag
        let color = sender.tag
        sender.setImage(Color.shared.getSeletedCircleImage(colorNum: color), for: .normal)
        colorBarViewInBottomsheet.backgroundColor = Color.shared.getColor(colorNum: color)
        dateLabelInBottomSheet.textColor = Color.shared.getColor(colorNum: color)
    }
    
    @objc private func handleBottomSheetBlackViewDismiss(){
        NotificationCenter.default.post(name: NSNotification.Name("EndEditTodo"), object: nil, userInfo: nil)
        print("tap")
        todo?.description = descriptionTextView.text.replacingOccurrences(of: textviewPlaceholder, with: "")
        todo?.title = titleTextFieldInBottomSheet.text!
        todo?.time = nowHour+nowMin
        
        if let requestTodo = todo {
            editTodo(todo: requestTodo)
        }
        //        NotificationCenter.default.post(name: NSNotification.Name("EndEditTodo"), object: nil, userInfo: nil)
        
        
        //        editTodo(title: titleTextFieldInBottomSheet.text ?? "", description: description, colorNum: nowColor, time: nowHour+nowMin, id: nowId)
        //        modifyNotification(at: datePicker.date, identifier: nowId)
        //        self.blackViewOfBottomSheet.removeFromSuperview()
        //        self.bottomSheetView.removeFromSuperview()
        
    }
    
    @objc private func tapTimeLabel(){
        self.view.endEditing(true)

        setDatePickerViewUI()
        
        //설정된 시간이 있을 때만 삭제 버튼이 보이도록함
        if nowHour == "99" && nowMin == "99"{
            deleteButtonInDatePicker.isHidden = true
        } else {
            deleteButtonInDatePicker.isHidden = false
        }
    }
    
    @objc private func tapDeleteButton(){
        nowHour = "99"
        nowMin = "99"
        timeLabel.text =  "미지정"
        timeLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
//        deleteNotification(identifier: todo?.id)
        blackViewOfDatePicker.removeFromSuperview()
        datePickerBackgroundView.removeFromSuperview()
        titleTextFieldInBottomSheet.becomeFirstResponder()
    }
    
    private func deleteNotification(identifier: Int){
        // 푸시 알림 요청 식별자
        let notificationIdentifier = String(identifier)
        
        // 기존 예약된 알림 요청 가져오기
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let notificationRequest = requests.first { $0.identifier == notificationIdentifier }
            
            // 기존 알림 요청 삭제
            if let request = notificationRequest {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                print("remove notification")
            }
        }
    }
    
    @objc private func tapDateLabel(){
        print("tap date label")
        self.view.endEditing(true)
        setCalendarViewUI()
    }
    
    private func modifyNotification(at date: Date, identifier: Int){
        // 푸시 알림 요청 식별자
//        let notificationIdentifier = String(todo?.id)
        let title = titleTextFieldInBottomSheet.text ?? "TODORI 미리 알림"
        
        // 기존 예약된 알림 요청 가져오기
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            if let notificationRequest = requests.first(where: { $0.identifier == notificationIdentifier }) {
//                let updatedContent = UNMutableNotificationContent()
//                updatedContent.title = "오늘의 토도리"
//                updatedContent.body = title
//
//                let calendar = Calendar.current
//                var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//                //                let yearMonthDay = DateFormat.shared.getYearMonthDay(date: self.calendarView.selectedDate!)
//
//                //                components.year = Int(yearMonthDay[0])
//                //                components.month = Int(yearMonthDay[1])
//                //                components.day = Int(yearMonthDay[2])
//
//                let updatedTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//
//                let updatedRequest = UNNotificationRequest(identifier: notificationRequest.identifier, content: updatedContent, trigger: updatedTrigger)
//                UNUserNotificationCenter.current().add(updatedRequest) { error in
//                    if let error = error {
//                        print("Failed to update notification: \(error.localizedDescription)")
//                    } else {
//                        print("Notification updated successfully.")
//                    }
//                }
//            } else {
//                print("absence")
//                //                self.setNotification(at: date, identifier: identifier, title: title)
//            }
//        }
    }
    
    private func setNotification(at date: Date, identifier: Int, title:String) {
//        let notificationIdentifier = String(todo?.id)
        
        let content = UNMutableNotificationContent()
        content.title = "오늘의 토도리"
        content.body = title
        content.sound = UNNotificationSound.default
        
        // 알림을 예약할 날짜와 시간을 구성합니다.
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        //        let yearMonthDay = DateFormat.shared.getYearMonthDay(date: calendarView.selectedDate!)
        
        //        components.year = Int(yearMonthDay[0])
        //        components.month = Int(yearMonthDay[1])
        //        components.day = Int(yearMonthDay[2])
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // 알림 요청을 생성합니다.
//        let request = UNNotificationRequest(identifier: String(todo?.id), content: content, trigger: trigger)
        
        // 알림을 예약합니다.
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("푸시 알림 예약 실패: \(error.localizedDescription)")
//            } else {
//                print("푸시 알림 예약 성공")
//            }
//        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let updownSpace: CGFloat = 24
            let size = CGSize(width: descriptionTextView.bounds.width, height: .infinity)
            let newSize = descriptionTextView.sizeThatFits(size)
            guard let lineHeight = descriptionTextView.font?.lineHeight else {return}
            if newSize.height/lineHeight < 6 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.bottomSheetHeightConstraint?.constraint.update(offset: 270 + keyboardHeight + newSize.height - (lineHeight+updownSpace))
                    self.bottomSheetHeight = 270 + keyboardHeight
                    self.view.layoutIfNeeded()
                })
                self.view.updateConstraints()
            }else{
                UIView.animate(withDuration: 0.25, animations: {
                    self.bottomSheetHeightConstraint?.constraint.update(offset: 270 + keyboardHeight + (24 + lineHeight * 4) - (lineHeight+updownSpace))
                    self.bottomSheetHeight = 270 + keyboardHeight
                    self.view.layoutIfNeeded()
                })
                self.view.updateConstraints()
            }
            
        }
    }
    
    @objc private func tapCancelButton(){
        if datePickerBackgroundView.superview == self.view{
            blackViewOfDatePicker.removeFromSuperview()
            datePickerBackgroundView.removeFromSuperview()
        }
        if calendarBackgroundView.superview == self.view{
            blackViewOfCalendarView.removeFromSuperview()
            calendarBackgroundView.removeFromSuperview()
        }
        
        titleTextFieldInBottomSheet.becomeFirstResponder()

    }
    
    @objc private func tapFinishButton(){
        print("tap finish")
        if datePickerBackgroundView.superview == self.view{
            if nowHour == "99" && nowMin == "99"{
                //            setNotification(at: datePicker.date, identifier: todo?.id, title: titleTextFieldInBottomSheet.text ?? "TODORI 미리 알림")
            }else {
                //            modifyNotification(at: datePicker.date, identifier: todo?.id)
            }
            nowHour = DateFormat.shared.getHour(date: datePicker.date)
            nowMin = DateFormat.shared.getMinute(date: datePicker.date)
            timeLabel.text =  "\(nowHour):\(nowMin)"
            timeLabel.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
            
            
            blackViewOfDatePicker.removeFromSuperview()
            datePickerBackgroundView.removeFromSuperview()
        }
        
        if calendarBackgroundView.superview == self.view{
            let date = DateFormat.shared.getYearMonthDayDictionary(date: calendarView.date)
            todo?.year = date["year"]!
            todo?.month = date["month"]!
            todo?.day = date["day"]!
            
            dateLabelInBottomSheet.text = "\(date["month"]!)월 \(date["day"]!)일 \(date["weekday"]!)"
            
//            let components = DateComponents(year: Int(date["year"]!), month: Int(date["month"]!), day: Int(date["day"]!))
//            print("log2")
//
//            if let date = Calendar.current.date(from: components){
//                print("log3")
//                let weekday = DateFormat.shared.getWeekdayInKorean(date: date)
//                dateLabelInBottomSheet.text = "\(components.month)월 \(components.day)일 \(weekday)"
//            }
            
            blackViewOfCalendarView.removeFromSuperview()
            calendarBackgroundView.removeFromSuperview()
        }
        
        titleTextFieldInBottomSheet.becomeFirstResponder()
    }
    
    private func setCircleButtonImage(){
        redCircleButton.setImage(UIImage(named: "red-circle"), for: .normal)
        yellowCircleButton.setImage(UIImage(named: "yellow-circle"), for: .normal)
        greenCircleButton.setImage(UIImage(named: "green-circle"), for: .normal)
        blueCircleButton.setImage(UIImage(named: "blue-circle"), for: .normal)
        pinkCircleButton.setImage(UIImage(named: "pink-circle"), for: .normal)
        purpleCircleButton.setImage(UIImage(named: "purple-circle"), for: .normal)
        
    }
    
//    private func editTodo(title: String, description: String, colorNum: Int, time: String, id: Int){
//        TodoService.shared.editTodo(title: title, description: description, colorNum: colorNum, time: time,id: id) { (response) in
//            switch(response){
//            case .success(let resultData):
//                if let data = resultData as? TodoEditResponseData{
//                    if data.resultCode == 200 {
//                        if let resultTodo = self.todo {
//                            self.delegate?.sendTodoData(todo: resultTodo)
//                        }
//                    }
//                }
//            case .failure(let meassage):
//                print("failure", meassage)
//
//            }
//        }
//    }
    
    private func editTodo(todo:ToDo){
        TodoService.shared.editTodo(todo: todo) { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? TodoEditResponseData{
                    if data.resultCode == 200 {
                        if let resultTodo = self.todo {
                            print("success")
                        }
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
    }
}
extension BottomSheetViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        //text view의 placeholder 구현
        if textView.text == textviewPlaceholder{
            textView.text = ""
            textView.textColor = .textColor
            textView.sizeToFit()
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.textColor = .gray
            textView.text = textviewPlaceholder
            textView.sizeToFit()
        }
    }
    
    //텍스트 뷰 동적 높이 조절
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let newSize = textView.sizeThatFits(size)
        guard let lineHeight = textView.font?.lineHeight else {return}
        if newSize.height/lineHeight < 6 {
            self.descriptionTextViewHeightConstraint?.constraint.update(offset: newSize.height)
            self.bottomSheetHeightConstraint?.constraint.update(offset: self.bottomSheetHeight + newSize.height - (lineHeight+24))
            textView.invalidateIntrinsicContentSize()
            view.layoutIfNeeded()
        }
    }
}

extension UIView{
    func addSubViews(_ views: [UIView]){
        _ = views.map { self.addSubview($0) }
        
    }
}

extension UIStackView{
    func addArrangedSubviews(_ views: [UIView]){
        _ = views.map { self.addArrangedSubview($0) }
    }
}

protocol BottomSheetViewControllerDelegate: AnyObject{
    func sendTodoData(todo:ToDo)
}

