//
//  TodoMainViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/19.
//

import Foundation
import SnapKit
import FSCalendar

class TodoMainViewController : UIViewController{
    
    var calendarView:FSCalendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 330, height: 270))
    var segmentedControl:UISegmentedControl = UISegmentedControl()
    var tableView:UITableView = UITableView()
    var topBarView:UIView = UIView()
    var hambuergerButton:UIButton = UIButton()
    var calendarImageView:UIImageView = UIImageView(image: UIImage(named: "calendar"))
    var dateLabel:UILabel = UILabel()
    var stackViewOfDateLabel:UIStackView = UIStackView()
    var dateFormatter = DateFormatter()
    var calendarBackgroundView:UIView = UIView()
    var headerView:UIView = UIView()
    var weekdayLabel:UILabel = UILabel()
    var dayLabel:UILabel = UILabel()
    var floatingButton:UIImageView = UIImageView()
    var collectionView:UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 151, height: 107), collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var bottomSheetView:UIView = UIView()
    
    var redArray:[Todo] = []
    var yellowArray:[Todo] = []
    var greenArray:[Todo] = []
    var blueArray:[Todo] = []
    var pinkArray:[Todo] = []
    var purpleArray:[Todo] = []
    var todoArrayList:[[Todo]] = []
    
    var isCollectionViewShowing = false
    var floatingButton_y:CGFloat = 0
    var collectionView_y:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test code
        let userDefaults = UserDefaults.standard
        userDefaults.set("c2f648d8faa70aae0e0eb74086bf907c61aeaf02", forKey: "token")
        
        todoArrayList = [redArray, yellowArray, greenArray, blueArray, pinkArray, purpleArray]
        
        //투두 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        
        //색깔 선택 컬렉션 뷰 설정
        collectionView.delegate = self
        collectionView.dataSource = self
        //캘린더 설정
        calendarView.delegate = self
        calendarView.dataSource = self
        
        //기본 뷰 색상 설정
        view.backgroundColor = .white
        
        //데이트 포멧터 설정
        dateFormatter.locale = Locale(identifier: "ko")
        
        //컬렉션 뷰 셀 등록
        collectionView.register(ColorCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "collectionViewCell")
        
        
        addComponent() //컴포넌트 및 뷰 추가
        addFunctionToComponent()
        setAutoLayout() //오토 레이아웃 설정
        setComponentAppearence() //컴포넌트 외형 설정
        searchTodo(date: calendarView.selectedDate!) //투두 조회
    }
    
    private func addFunctionToComponent(){
        segmentedControl.addTarget(self, action: #selector(tapSegmentedControl), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFloatingButton))
        floatingButton.isUserInteractionEnabled = true
        floatingButton.addGestureRecognizer(tapGesture)
//        floatingButton.addTarget(self, action: #selector(tapFloatingButton), for: .touchUpInside)
    }
    
    private func addComponent(){
        //기본 뷰에 세그먼티트 컨트롤, 햄버거바를 담을 뷰 추가
        self.view.addSubview(topBarView)
        
        //상위 뷰에 새그먼티트 컨트롤, 햄버거바 추가
        topBarView.addSubview(segmentedControl)
        topBarView.addSubview(hambuergerButton)
        
        //기본 뷰에 테이블뷰 추가
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        
        //calendar background view에 컴포넌트 추가
        calendarBackgroundView.addSubview(calendarImageView)
        calendarBackgroundView.addSubview(dateLabel)
        calendarBackgroundView.addSubview(calendarView)
        
        //헤더뷰에 추가
        headerView.addSubview(calendarBackgroundView)
        headerView.addSubview(weekdayLabel)
        headerView.addSubview(dayLabel)
        
        //tableview header view 지정
        tableView.tableHeaderView = headerView
        
        //floating button 추가
        tableView.addSubview(floatingButton)
    }
    
    private func setComponentAppearence(){
        //segmented control segment 추가 및 초기 셋팅
        segmentedControl.insertSegment(withTitle: "월간", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "주간", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        
        //햄버거 바 버튼 이미지 지정
        hambuergerButton.setImage(UIImage(named: "hamburger-button"), for: .normal)
        
        //캘린더 상단 날짜 라벨
        dateLabel.textColor = UIColor.black
        dateLabel.font.withSize(15)
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
        dateLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        //캘린더뷰 외형 설정
        calendarView.headerHeight = 0
        calendarView.select(calendarView.today)
        calendarView.firstWeekday = 2
        calendarView.appearance.titleWeekendColor = UIColor(red: 1, green: 0.654, blue: 0.654, alpha: 1)
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        calendarView.appearance.selectionColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        calendarView.appearance.todayColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        calendarView.appearance.titleTodayColor = UIColor(red: 0.246, green: 0.246, blue: 0.246, alpha: 1)
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.weekdayTextColor = .black
        
        //캘린더 백그라운드 뷰 외형 설정
        calendarBackgroundView.backgroundColor = .white
        
        //테이블 뷰 외형 설정
        tableView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        
        //테이블 뷰 헤더 뷰 설정
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
        calendarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.fs_width, height: 340)
        
        //calendar background view 하단 라운드 및 그림자 설정
        calendarBackgroundView.clipsToBounds = true
        calendarBackgroundView.layer.cornerRadius = 30
        calendarBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        calendarBackgroundView.layer.masksToBounds = false
        calendarBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        calendarBackgroundView.layer.shadowOpacity = 0.2
        calendarBackgroundView.layer.shadowRadius = 5
        calendarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        //날짜 라벨
        dayLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        weekdayLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: calendarView.selectedDate!)
        dayLabel.text = DateFormat.shared.getDay(date: calendarView.selectedDate!)
        weekdayLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        
        //Floating Button 외형 설정
        floatingButton_y = self.view.fs_height*(7/10)
        floatingButton.frame = CGRect(x: self.view.fs_width*(7/10), y:  floatingButton_y,width:76 , height: 76)
        floatingButton.image = UIImage(named: "floating-button")
        floatingButton.layer.shadowColor = UIColor.lightGray.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 5.0
        floatingButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        //색깔 선택 view 외형 설정
        collectionView.clipsToBounds = true
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOpacity = 0.4
        collectionView.layer.shadowRadius = 5.0
        collectionView.layer.shadowOffset = CGSize(width: -1, height: 3)
        collectionView.layer.cornerRadius = 15
        
    }
    
    private func setAutoLayout(){
        topBarView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(138)
            make.right.equalTo(-138)
        }
        
        hambuergerButton.snp.makeConstraints { make in
            make.width.height.equalTo(29)
            make.rightMargin.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.right.left.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.top.equalTo(topBarView.snp.bottom)
        }
        
        //캘린더 뷰 설정
        calendarView.frame = CGRect(x: (self.view.fs_width - calendarView.fs_width)/2, y: dateLabel.frame.origin.y + 60, width: 330, height: 270)
        
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.top.equalTo(calendarBackgroundView.snp.top).offset(16)
            make.left.equalTo(calendarBackgroundView.snp.left).offset(calendarView.frame.origin.x)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageView.snp.right).offset(5)
            make.centerY.equalTo(calendarImageView)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(headerView)
            make.left.equalTo(headerView).offset(20)
        }
        weekdayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel)
            make.left.equalTo(dayLabel.snp.right).offset(6)
        }
    }
    
    @objc func tapSegmentedControl(){
        if segmentedControl.selectedSegmentIndex == 0{
            self.calendarView.setScope(.month, animated: true)
        }else{
            self.calendarView.setScope(.week, animated: true)
        }
    }
    
    @objc func tapFloatingButton(){
        if isCollectionViewShowing{
            collectionView.removeFromSuperview()
        }else {
            //컬렉션 뷰 추가
            tableView.addSubview(collectionView)
            
            //컬렉션 뷰 위치 지정
            collectionView.frame.origin.x = floatingButton.frame.origin.x - (collectionView.fs_width-floatingButton.fs_width)
            collectionView.frame.origin.y = floatingButton.frame.origin.y - 10 - collectionView.fs_height
            collectionView_y = collectionView.frame.origin.y
        }
        isCollectionViewShowing = !isCollectionViewShowing
        print(isCollectionViewShowing)

    }
    

    
    private func searchTodo(date:Date){
        let dateArr = DateFormat.shared.getYearMonthDay(date: date)
        TodoAPIConstant.shared.searchTodo(year: dateArr[0], month: dateArr[1], day: dateArr[2]) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? TodoSearchResponseData{
                    if data.resultCode == 200 {
                        self.todoArrayList[0].removeAll()
                        self.todoArrayList[1].removeAll()
                        self.todoArrayList[2].removeAll()
                        self.todoArrayList[3].removeAll()
                        self.todoArrayList[4].removeAll()
                        self.todoArrayList[5].removeAll()

                        for i in data.data{
                            self.todoArrayList[i.color - 1].append(Todo(year: String(i.year), month: String(i.month), day: String(i.day), title: i.title, done: i.done, isNew: false, writer: i.writer, color: i.color, id: i.id, description: i.description))
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
    
    @objc private func editEndTodo(){
        print("edit")
    }
    
    //table view 터치하면 키보드 내려가기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.tableView.endEditing(true)
    }
    
}

//table view delegate, datasource
extension TodoMainViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view:UIView = UIView()
        var colorRoundView:UIView = UIView()
        var titleLabel:UILabel = UILabel()
        
        view.addSubview(colorRoundView)
        view.addSubview(titleLabel)
        
        colorRoundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(9)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorRoundView)
            make.left.equalTo(colorRoundView.snp.right).offset(5)
        }
        
        colorRoundView.clipsToBounds = true
        colorRoundView.layer.cornerRadius = 4.5
        colorRoundView.backgroundColor = Color.shared.UIColorArray[section]
        
        titleLabel.text = "section title"
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .black
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        floatingButton.frame = CGRect(x: floatingButton.frame.origin.x, y: floatingButton_y + offset, width: 76, height: 76)
        collectionView.frame = CGRect(x: collectionView.frame.origin.x, y: collectionView_y + offset, width: collectionView.fs_width, height: collectionView.fs_height)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                TodoAPIConstant.shared.deleteTodo(id: todoArrayList[indexPath.section][indexPath.row].id) { (response) in
                    switch (response){
                    case .success(let resultData):
                        if let data = resultData as? ResponseData{
                            if data.resultCode == 200 {
                                self.todoArrayList[indexPath.section].remove(at: indexPath.row)
                                tableView.reloadData()
                            }
                        }
                    case .requestErr(let message):
                        print("requestErr", message)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                    case .decodeErr:
                        print("decodeErr")
                    }
                }
            }
        }
    
    
}
extension TodoMainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArrayList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodoTableViewCell()
        var titleTextField = UITextField()
        var checkbox = UIButton()
        
        cell.cellBackgroundView.addSubview(titleTextField)
        cell.cellBackgroundView.addSubview(checkbox)
        
        checkbox.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
        }
        titleTextField.snp.makeConstraints { make in
            make.left.equalTo(checkbox.snp.right).offset(7)
            make.centerY.equalToSuperview()
        }
        
        titleTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        checkbox.setImage(UIImage(named: "checkbox"), for: .normal)
        
        titleTextField.addTarget(self, action: #selector(editEndTodo), for: .valueChanged)

        titleTextField.text = todoArrayList[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        49
    }
}

//calendar delegate, datasource
extension TodoMainViewController:FSCalendarDelegate{
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        searchTodo(date: date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarBackgroundView.fs_height = calendarBackgroundView.fs_height - (calendarView.fs_height - bounds.height)
        tableView.tableHeaderView?.fs_height = tableView.tableHeaderView!.fs_height - (calendarView.fs_height - bounds.height)
        calendarView.fs_height = bounds.height
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.tableView.reloadData()
        }
    }
    
}
extension TodoMainViewController:FSCalendarDataSource{

}

//collection view delegate, datasource
extension TodoMainViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = DateFormat.shared.getYearMonthDay(date: calendarView.selectedDate!)
        todoArrayList[indexPath.row].insert(Todo(year: date[0] , month: date[1], day: date[2], title: "", done: false, isNew: true, writer: "", color: indexPath.row + 1, id: 0, description: ""), at: 0)
        tableView.reloadData()
        collectionView.removeFromSuperview()
        isCollectionViewShowing = false
    }
}
extension TodoMainViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! ColorCollectionViewCell
        
        view.backgroundColor = Color.shared.UIColorArray[indexPath.row]
        view.clipsToBounds = true
        view.layer.cornerRadius = view.fs_width/2
        return view
    }
}

//collection view layout delegate
extension TodoMainViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 25, height: 25)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
        return inset
    }
}
