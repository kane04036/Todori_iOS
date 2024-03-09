//
//  FriendToDoViewController.swift
//  TODORI
//
//  Created by 제이콥 on 11/17/23.
//

import UIKit
import FSCalendar

class FriendToDoViewController: UIViewController {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        return tableView
    }()
    var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
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
    var calendarBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.backgroundColor = .white
        return view
    }()
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        imageView.layer.cornerRadius = imageView.fs_width/2
        return imageView
    }()
    var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    var friendInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
    var calendarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "월간", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "주간", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10, weight: .bold)]
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10, weight: .regular)]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        return segmentedControl
    }()
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let imageView = UIImageView(image: UIImage(named: "calendar"))
        imageView.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
        stackView.addArrangedSubview(imageView)
        return stackView
    }()
    var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        return label
    }()
    private var weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }()
    var grayLineNextDateLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.846, green: 0.846, blue: 0.846, alpha: 1)
        return view
    }()
    var dayLabelStackView: UIStackView = {
        var stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 6
        return stackview
    }()
    var navigationBar = UINavigationBar()
    
    var nothingExistingView: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    var nothingExistingLabel: UILabel = {
       let label = UILabel()
        label.text = "등록된 토도리스트가 없습니다."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.575, green: 0.561, blue: 0.561, alpha: 1) //라이트, 다크 동일
        return label
    }()
    
    var redArray: [ToDo] = []
    var yellowArray: [ToDo] = []
    var greenArray: [ToDo] = []
    var blueArray: [ToDo] = []
    var pinkArray: [ToDo] = []
    var purpleArray: [ToDo] = []
    var todoArrayList: [[ToDo]] = []
    var titleOfSectionArray: [String] = ["","","","","",""]
    var existingColorArray: [Int] = []
    
    
    var headerView = UIView()
    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoArrayList = [redArray, yellowArray, greenArray, blueArray, pinkArray, purpleArray]
        getPriorityName()
        setUI()
        initView()
    }
    
    private func initView(){
        tableView.delegate = self
        tableView.dataSource = self
        calendarView.delegate = self
        calendarView.dataSource = self
        
        segmentedControl.addTarget(self, action: #selector(tapSegmentedControl), for: .valueChanged)

        
        guard let friend = friend else {print("no frirend");return}
        if let image = profileImageView.image {
            profileImageView.image = image
        }else {
            profileImageView.image = UIImage(named: "profile-image")
        }
        nicknameLabel.text = friend.nickname
        
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
                
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: calendarView.selectedDate!)
        dayLabel.text = DateFormat.shared.getDay(date: calendarView.selectedDate!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTodo(date: Date())
    }
    
    
    private func setUI(){
        self.view.backgroundColor = .white
        
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(tapBackButton), title: "",showSeparator: false)
        
        navigationBar = navigationController!.navigationBar
        self.view.addSubview(navigationBar)
        friendInfoStackView.addArrangedSubviews([profileImageView, nicknameLabel])
        dateStackView.addArrangedSubview(dateLabel)
        dayLabelStackView.addArrangedSubviews([dayLabel, weekdayLabel])
        
        calendarBackgroundView.addSubViews([calendarView, friendInfoStackView, moreButton, dateStackView, segmentedControl])
        headerView.addSubViews([calendarBackgroundView, dayLabelStackView, grayLineNextDateLabel])
        
        nothingExistingView.addSubview(nothingExistingLabel)
        tableView.addSubview(nothingExistingView)
        
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
    
        }
        
        friendInfoStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(37)
            make.top.equalToSuperview().offset(14)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(33)
        }
        
        moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.centerY.equalTo(friendInfoStackView)
            make.right.equalToSuperview().offset(-39)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(36)
            make.top.equalTo(friendInfoStackView.snp.bottom).offset(30)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-33)
            make.centerY.equalTo(dateStackView)
            make.width.equalTo(80)
        }
        
        
        let calendarWidth: Int = Int(self.view.fs_width * 0.9)
        let calendarHeight: Int = Int((self.view.fs_width * 0.9) * 0.8)
        let leadingPaddingOfCalendarView: Int = Int((Int(self.view.fs_width) - calendarWidth)/2)
        calendarView.frame = CGRect(x: leadingPaddingOfCalendarView, y: 120, width: calendarWidth, height: calendarHeight)

        calendarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.fs_width, height: calendarView.fs_height + 135)

        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: calendarBackgroundView.fs_height + 70)
        tableView.tableHeaderView = headerView
        
        dayLabelStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        grayLineNextDateLabel.snp.makeConstraints { make in
            make.left.equalTo(dayLabelStackView.snp.right).offset(6)
            make.right.equalTo(self.view).offset(-21)
            make.centerY.equalTo(dayLabelStackView)
            make.height.equalTo(1)
        }
        
        nothingExistingView.snp.makeConstraints { make in
            make.height.equalTo(43)
            make.width.equalTo(self.view.fs_width-42)
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.tableHeaderView!.snp.bottom)
        }
        
        nothingExistingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
        }
        
    }

    @objc private func tapBackButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //segmented control 변경시 동작하는 함수 - 월간/주간 캘린더 변경
    @objc private func tapSegmentedControl(){
        if segmentedControl.selectedSegmentIndex == 0{
            self.calendarView.setScope(.month, animated: true)
        }else{
            self.calendarView.setScope(.week, animated: true)
        }
    }
}
extension FriendToDoViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {        
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 {
            calendar.cell(for: date, at: monthPosition)?.titleLabel.textColor = .red
        }
        
        dayLabel.text = DateFormat.shared.getDay(date: date)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: date)
        searchTodo(date: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendar.currentPage)
        calendarView.select(calendar.currentPage)
        searchTodo(date: calendar.currentPage)
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if DateFormat.shared.getWeekdayInKorean(date: date) == "일요일" {
            cell.titleLabel.textColor = UIColor(red: 248/255, green: 107/255, blue: 107/255, alpha: 1) //진한 붉은색
            if DateFormat.shared.getMonth(date: date) != DateFormat.shared.getMonth(date: calendar.currentPage){
                cell.titleLabel.textColor = UIColor(red: 242/255, green: 197/255, blue: 197/255, alpha: 1)//연한 붉은색(전달 혹은 다음달)
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        let diff = calendarView.fs_height - bounds.height
        
        calendarBackgroundView.fs_height = calendarBackgroundView.fs_height - diff
        tableView.tableHeaderView?.fs_height = tableView.tableHeaderView!.fs_height - diff
        calendarView.fs_height = bounds.height
        self.view.layoutIfNeeded()
        
        //하단 라벨들과 월,주간 변경 애니메이션 시간이 맞지 않아 약간의 딜레이를 줌
        if diff > 0 {
            //월간->주간
            Timer.scheduledTimer(withTimeInterval: 0.07 , repeats: false) { timer in
                self.tableView.reloadData()
            }
        }else {
            //주간->월간
            Timer.scheduledTimer(withTimeInterval: 0.03 , repeats: false) { timer in
                self.tableView.reloadData()
            }
        }
    }
}
extension FriendToDoViewController{
    struct TodoColor{
        let gary = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
    }
    
    private func todoSortByDone(section:Int){
        self.todoArrayList[section].sort { todo1, todo2 in
            return !todo1.done && todo2.done
        }
    }
    
    //현재 존재하는 todo의 color을 따로 existingColorArray에 추가 및 투두 없음을 알리는 뷰 hidden 설정
    private func setExistArray(){
        existingColorArray.removeAll()
        
        //1. 색깔별로 나눠져있는 배열을 하나씩 돌면서 투두가 있는지 확인
        for i in 0 ..< 6 {
            if todoArrayList[i].count > 0 {
                existingColorArray.append(i)
            }
        }
        
        if existingColorArray.isEmpty{
            nothingExistingView.isHidden = false
        }else{
            nothingExistingView.isHidden = true
        }
    }
    
    private func searchTodo(date: Date) {
        let dateArr = DateFormat.shared.getYearMonthDayDictionary(date: date)
        FriendService.shared.searchTodo(friend: friend ?? Friend(email: "", nickname: ""), date: dateArr) { (response) in
            switch(response){
            case .success(let resultData):
                print("good friend")
                if let data = resultData as? TodoSearchResponseData{
                    if data.resultCode == 200 {
                        self.todoArrayList[0].removeAll()
                        self.todoArrayList[1].removeAll()
                        self.todoArrayList[2].removeAll()
                        self.todoArrayList[3].removeAll()
                        self.todoArrayList[4].removeAll()
                        self.todoArrayList[5].removeAll()
                        self.existingColorArray.removeAll()
                        
                        for i in data.data{
                            self.todoArrayList[i.color - 1].append(ToDo(year: String(i.year), month: String(i.month), day: String(i.day), title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, time: i.time, description: i.description))
                            print(i.title)
                        }
                        
                        for i in 0 ..< 6{
                            self.todoSortByDone(section: i)
                        }
                        self.setExistArray()
                        self.tableView.reloadData()
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
    }
    
    private func getPriorityName(){
        TodoService.shared.getPriorityName { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    if data.resultCode == 200 {
                        self.titleOfSectionArray[0] = data.data._1
                        self.titleOfSectionArray[1] = data.data._2
                        self.titleOfSectionArray[2] = data.data._3
                        self.titleOfSectionArray[3] = data.data._4
                        self.titleOfSectionArray[4] = data.data._5
                        self.titleOfSectionArray[5] = data.data._6
                    }
                }
            case .failure(let meassage):
                print("failure", meassage)
                
            }
        }
    }
}
extension FriendToDoViewController: UITableViewDelegate, UITableViewDataSource{
    //각 섹션 디자인 및 오토 레이아웃 적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView()
        let colorRoundView:UIView = UIView()
        let titleLabel:UILabel = UILabel()
        
        view.addSubview(colorRoundView)
        view.addSubview(titleLabel)
        
        colorRoundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(9)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorRoundView)
            make.left.equalTo(colorRoundView.snp.right).offset(5)
        }
        
        colorRoundView.clipsToBounds = true
        colorRoundView.layer.cornerRadius = 4.5
        colorRoundView.backgroundColor = Color.shared.UIColorArray[existingColorArray[section]]
        
        titleLabel.text = titleOfSectionArray[existingColorArray[section]]
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor.textColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return existingColorArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //현재 존재하는 그룹의 수 만큼 return
        return todoArrayList[existingColorArray[section]].count
    }
    
    //cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FriendTodoTableViewCell()
        let todo = todoArrayList[existingColorArray[indexPath.section]][indexPath.row]
        cell.selectionStyle = .none
        cell.todo = todo
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
}
