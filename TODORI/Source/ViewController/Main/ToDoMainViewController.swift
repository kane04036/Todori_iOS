//
//  TodoMainViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/29.
//

import UIKit
import SnapKit
import FSCalendar
import UserNotifications

struct Dots{
    var date: Date
    var color: String
}

class ToDoMainViewController : UIViewController {

    private var overlayViewController: MyPageViewController?
    var dimmingView: UIView = UIView()
    var bottomSheetVC: BottomSheetViewController?
    var calendarView: FSCalendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 330, height: 270))
    var segmentedControl: UISegmentedControl = UISegmentedControl()
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var topBarView: UIView = UIView()
    var hambuergerButton: UIButton = UIButton()
    var calendarImageView: UIImageView = UIImageView(image: UIImage(named: "calendar"))
    var dateLabel: UILabel = UILabel()
    var stackViewOfDateLabel:UIStackView = UIStackView()
    var dateFormatter = DateFormatter()
    var calendarBackgroundView: UIView = UIView()
    var headerView: UIView = UIView()
    private var weekdayLabel: UILabel = UILabel()
    var dayLabel: UILabel = UILabel()
    var floatingButton: UIImageView = UIImageView()
    var collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 151, height: 107), collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var grayLineNextDateLabel: UIView = UIView()
    var grayBackgroundView: UIView = UIView() //키보드레이아웃에 맞춘 테이블 뷰 밑에 빈 공간을 채우기 위한 뷰
    var grayFooterView: UIView = UIView() //키보드레이아웃에 맞춘 테이블 뷰 밑에 빈 공간을 채우기 위한 뷰
    var whiteBackgroundView: UIView = UIView() //캘린더뷰를 내렸을 때 비는 공간을 채우기 위한 뷰
    var clearViewOfFloatingButton: UIView = UIView()
    var clearViewForWritingTodo: UIView = UIView()
    var nothingExistingView: UIView = UIView()
    var nothingExistingLabel: UILabel = UILabel()
    var userButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "user"), for: .normal)
        return button
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
    
    var isCollectionViewShowing = false
    var floatingButton_y: CGFloat = 0
    var collectionView_y: CGFloat = 0
    private var nowSection: Int = 0
    private var nowRow: Int = 0
    
    //여기서부터

    let dateArray: [String] = ["123", "", "","","15","","6"]
    var dotsArray: [Dots] = []
    var dotArray:[String] = []
    //여기까지는 임의의 코드. + fscalender event 관련 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoArrayList = [redArray, yellowArray, greenArray, blueArray, pinkArray, purpleArray]
        getPriorityName()
        
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
        view.backgroundColor = UIColor.defaultColor
                
        //데이트 포멧터 설정
        dateFormatter.locale = Locale(identifier: "ko")
        
        //컬렉션 뷰 셀 등록
        collectionView.register(ColorCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "collectionViewCell")
        
        addComponent() //컴포넌트 및 뷰 추가
        addFunctionToComponent()
        setComponentAppearence() //컴포넌트 외형 설정
        setAutoLayout() //오토 레이아웃 설정
        searchTodo(date: calendarView.selectedDate!) //투두 조회
        
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: nil, title: "")
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let components = Calendar.current.dateComponents([.year, .month], from: self.calendarView.currentPage)
        self.setMonthOfDot(year: components.year!, month: components.month!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //각 컴포넌트에 동작 추가
    private func addFunctionToComponent(){
        segmentedControl.addTarget(self, action: #selector(tapSegmentedControl), for: .valueChanged)
        floatingButton.isUserInteractionEnabled = true
        floatingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFloatingButton)))
//        blackViewOfBottomSheet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBottomSheetBlackViewDismiss)))
        clearViewForWritingTodo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleWritingTodoClearViewDissmiss)))
        clearViewOfFloatingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFloatingButtonClearViewDismiss)))
        hambuergerButton.addTarget(self, action: #selector(tapHamburgerButton), for: .touchDown)
        userButton.addTarget(self, action: #selector(tapUserButton), for: .touchDown)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveEndEditGroupName), name: NSNotification.Name("endEditGroupName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveEndEditTodo), name: NSNotification.Name("EndEditTodo"), object: nil)

    }
    
    private func addComponent(){
        //기본 뷰에 세그먼티트 컨트롤, 햄버거바를 담을 뷰 추가
        self.view.addSubview(topBarView)
        
        //상위 뷰에 새그먼티트 컨트롤, 햄버거바 추가
        topBarView.addSubview(segmentedControl)
        topBarView.addSubview(hambuergerButton)
        topBarView.addSubview(userButton)
        
        //기본 뷰에 테이블뷰 추가
        self.view.addSubview(tableView)
        self.view.addSubview(grayBackgroundView)
        tableView.separatorStyle = .none
        
        //calendar background view에 컴포넌트 추가
        calendarBackgroundView.addSubview(calendarImageView)
        calendarBackgroundView.addSubview(dateLabel)
        calendarBackgroundView.addSubview(calendarView)
        
        //헤더뷰에 추가
        headerView.addSubview(calendarBackgroundView)
        headerView.addSubview(weekdayLabel)
        headerView.addSubview(dayLabel)
        headerView.addSubview(grayLineNextDateLabel)
        
        //tableview header view 지정
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = grayFooterView
        
        //floating button 추가
        tableView.addSubview(floatingButton)
        
        nothingExistingView.addSubview(nothingExistingLabel)
        tableView.addSubview(nothingExistingView)
    }
    
    //컴포넌트 외형 설정
    private func setComponentAppearence(){
        //segmented control segment 추가 및 초기 셋팅
        segmentedControl.insertSegment(withTitle: "월간", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "주간", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13, weight: .regular)]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)

        
        //햄버거 바 버튼 이미지 지정
        hambuergerButton.setImage(UIImage(named: "hamburger-button"), for: .normal)
        
        //캘린더 상단 날짜 라벨
        dateLabel.textColor = UIColor.textColor
        dateLabel.font.withSize(15)
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
        dateLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        //캘린더뷰 외형 설정
        calendarView.headerHeight = 0
        calendarView.select(calendarView.today)
        calendarView.firstWeekday = 2
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        calendarView.appearance.selectionColor = UIColor.selectionColor
        calendarView.appearance.todayColor = UIColor.todaySelectionColor
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.weekdayTextColor = UIColor.textColor
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .red
        calendarView.locale = Locale(identifier: "ko_KR")
        

        
        let calendarWidth: Int = Int(self.view.fs_width*0.9)
        let calendarHeight: Int = Int((self.view.fs_width * 0.9) * 0.8)
        let xCoordinateOfCalendarView: Int = Int((Int(self.view.fs_width) - calendarWidth)/2)
        let yCoordinateOfCalendarView: Int = Int(dateLabel.frame.origin.y + 55)
        
        calendarView.frame = CGRect(x: xCoordinateOfCalendarView, y: yCoordinateOfCalendarView, width: calendarWidth, height: calendarHeight)
        
        //캘린더 백그라운드 뷰 외형 설정
        calendarBackgroundView.backgroundColor = UIColor.defaultColor
        
        //테이블 뷰 외형 설정
        tableView.backgroundColor = UIColor.backgroundColor
        
        //테이블 뷰 헤더 뷰 설정
        calendarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.fs_width, height: calendarView.fs_height + 70)

        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: calendarBackgroundView.fs_height + 70)


        
        //calendar background view 하단 라운드 및 그림자 설정
        calendarBackgroundView.clipsToBounds = true
        calendarBackgroundView.layer.cornerRadius = 30
        calendarBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        calendarBackgroundView.layer.masksToBounds = false
        calendarBackgroundView.layer.shadowColor = UIColor.shadowColor?.cgColor
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
        floatingButton_y = self.view.fs_height*0.7
        floatingButton.frame = CGRect(x: self.view.fs_width*0.75, y:  floatingButton_y, width:self.view.fs_width * 0.16 , height: self.view.fs_width * 0.16)
        floatingButton.image = UIImage(named: "floating-button")
        floatingButton.layer.shadowColor = UIColor.shadowColor?.cgColor
        floatingButton.layer.shadowOpacity = 0.5
        floatingButton.layer.shadowRadius = 5.0
        floatingButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        //색깔 선택 view 외형 설정
        collectionView.clipsToBounds = true
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowColor = UIColor.shadowColor?.cgColor
        collectionView.layer.shadowOpacity = 0.4
        collectionView.layer.shadowRadius = 5.0
        collectionView.layer.shadowOffset = CGSize(width: -1, height: 3)
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor.defaultColor
        
        
        // 투두 없을 때 나오는 뷰 설정
        nothingExistingView.backgroundColor = .defaultColor
        nothingExistingView.clipsToBounds = true
        nothingExistingView.layer.cornerRadius = 10
        
        //투두 없을 때 나오는 뷰 내부 라벨
        nothingExistingLabel.text = "등록된 토도리스트가 없습니다."
        nothingExistingLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nothingExistingLabel.textColor = UIColor(red: 0.575, green: 0.561, blue: 0.561, alpha: 1) //라이트, 다크 동일
        
        grayLineNextDateLabel.backgroundColor = UIColor.lineColor
        
        grayBackgroundView.backgroundColor = UIColor.backgroundColor
        
        whiteBackgroundView.backgroundColor = .defaultColor
        
        grayFooterView.backgroundColor = UIColor.backgroundColor
        grayFooterView.fs_width = self.view.fs_width
        grayFooterView.fs_height = self.view.fs_height*0.3
        
        clearViewOfFloatingButton.backgroundColor = .clear
        
        clearViewForWritingTodo.backgroundColor = .clear
    }
    
    //bottom sheet, date picker view 제외 메인 투두 뷰 오토 레이아웃 설정
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
        
        userButton.snp.makeConstraints { make in
            make.width.height.equalTo(23)
            make.right.equalTo(hambuergerButton.snp.left).offset(-17)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.right.left.equalTo(self.view)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.top.equalTo(topBarView.snp.bottom)
        }
        
        grayBackgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(400)
            make.top.equalTo(tableView.snp.bottom)
        }
                
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.top.equalTo(calendarBackgroundView.snp.top).offset(16)
            make.left.equalTo(calendarBackgroundView.snp.left).offset(calendarView.frame.origin.x+14)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageView.snp.right).offset(5)
            make.centerY.equalTo(calendarImageView)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalTo(self.view).offset(20)
        }
        
        weekdayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel)
            make.left.equalTo(dayLabel.snp.right).offset(6)
        }
        
        grayLineNextDateLabel.snp.makeConstraints { make in
            make.left.equalTo(weekdayLabel.snp.right).offset(6)
            make.right.equalTo(self.view).offset(-21)
            make.height.equalTo(1)
            make.centerY.equalTo(dayLabel)
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
    
    //todo 작성 중 외부 클릭시 동작하는 함수
    @objc private func handleWritingTodoClearViewDissmiss(){
        tableView.endEditing(true)
        clearViewForWritingTodo.removeFromSuperview()
    }
    
    //floating button 클릭 후 외부 터치시 실행되는 함수 - 사라지는 애니메이션
    @objc private func handleFloatingButtonClearViewDismiss(){
        self.floatingButton.image = UIImage(named: "floating-button")
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.frame.origin.y = self.floatingButton.frame.origin.y - 10 - self.collectionView.fs_height + 20
            self.collectionView.alpha = 0
        }, completion: { finished in
            self.collectionView.removeFromSuperview()
            self.clearViewOfFloatingButton.removeFromSuperview()
        })
        isCollectionViewShowing = !isCollectionViewShowing
    }
    
    
    //segmented control 변경시 동작하는 함수 - 월간/주간 캘린더 변경
    @objc private func tapSegmentedControl(){
        if segmentedControl.selectedSegmentIndex == 0{
            self.calendarView.setScope(.month, animated: true)
        }else{
            self.calendarView.setScope(.week, animated: true)
        }
    }
    
    //floating button 터치시 동작하는 함수 - 보여지고 사라지는 애니메이션 적용
    @objc private func tapFloatingButton(){
        if isCollectionViewShowing{
            self.floatingButton.image = UIImage(named: "floating-button")
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionView.frame.origin.y = self.floatingButton.frame.origin.y - 10 - self.collectionView.fs_height + 20
                self.collectionView.alpha = 0
            }, completion: { finished in
                self.collectionView.removeFromSuperview()
                self.clearViewOfFloatingButton.removeFromSuperview()
            })
        }else {
            //컬렉션 뷰 추가 - 색깔 선택 뷰
            self.tableView.addSubview(clearViewOfFloatingButton)
            self.tableView.addSubview(collectionView)
            self.tableView.bringSubviewToFront(floatingButton)
            
            //컬렉션 뷰 위치 지정
            collectionView.frame.origin.x = floatingButton.frame.origin.x - (collectionView.fs_width-floatingButton.fs_width)
            collectionView.frame.origin.y = floatingButton.frame.origin.y - 10 - collectionView.fs_height + 15
            
            clearViewOfFloatingButton.snp.makeConstraints { make in
                make.left.right.top.bottom.equalTo(self.view)
            }

            collectionView.alpha = 0
            self.floatingButton.image = UIImage(named: "floating-button-touched")

            
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionView.frame.origin.y = self.floatingButton.frame.origin.y - 10 - self.collectionView.fs_height
                self.collectionView.alpha = 1
            }, completion: { finished in
            })
            
        }
        isCollectionViewShowing = !isCollectionViewShowing
        
    }
    
    //완료한 todo를 뒤로 보내는 함수 - done 기준 정렬
    private func todoSortByDone(section:Int){
        self.todoArrayList[section].sort { todo1, todo2 in
            return !todo1.done && todo2.done
        }
    }
    
    //id 기준 정렬 함수 - 역 최신순
    private func todoSortById(section:Int){
        self.todoArrayList[section].sort { todo1, todo2 in
            return todo1.id < todo2.id
        }
    }
    
    //마이 페이지 drawer 외부 터치시 실행 - 사라지는 애니메이션
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.overlayViewController?.view.frame = CGRect(x: self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.dimmingView.alpha = 0
        }) { (_) in
            self.overlayViewController?.removeFromParent()
            self.overlayViewController?.view.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
        }
    }
    
    //햄버거바 터치시 실행되는 동작 - 마이페이지 drawer 등장
    @objc private func tapHamburgerButton(){
        dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0
        view.addSubview(dimmingView)
        
        // 탭 제스처 생성
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    
        overlayViewController = MyPageViewController()
        overlayViewController?.view.frame = CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if let overlayViewController = overlayViewController {
            addChild(overlayViewController)
        }
        if let x = overlayViewController?.view {
            view.addSubview(x)
        }
        overlayViewController?.dimmingView = dimmingView
        
        UIView.animate(withDuration: 0.3) {
            self.overlayViewController?.view.frame = CGRect(x: 70, y: 0, width: self.view.frame.size.width - 70, height: self.view.frame.size.height)
            self.dimmingView.alpha = 0.5
        }
    }
    
    @objc private func tapUserButton(){
        let friendManagementVC = FriendManagementViewController()
        friendManagementVC.modalPresentationStyle = .fullScreen
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.pushViewController(friendManagementVC, animated: false)
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
    
    @objc private func didRecieveEndEditTodo(){
        print("receive")
        bottomSheetVC?.view.removeFromSuperview()
        bottomSheetVC?.removeFromParent()
    }
    
    //설정에서 그룹명을 바꾸면 notification center로 받아 서버에서 새로 그룹명을 받고 table reload
    @objc private func didRecieveEndEditGroupName(){
        getPriorityName()
        tableView.reloadData()
    }
    

}

extension ToDoMainViewController{
    //해당 날짜 투두 조회
    private func searchTodo(date:Date) {
        let dateArr = DateFormat.shared.getYearMonthDay(date: date)
        TodoService.shared.searchTodo(year: dateArr[0], month: dateArr[1], day: dateArr[2]) {(response) in
            switch(response){
            case .success(let resultData):
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
    
    //투두 삭제
    private func deleteTodo(todo: ToDo, section: Int, row: Int){
        TodoService.shared.deleteTodo(id: todo.id) { (resonse) in
            switch(resonse){
            case .success(let resultData):
                if let data = resultData as? ResponseData{
                    if data.resultCode == 200 {
                        self.todoArrayList[self.existingColorArray[section]].remove(at: row)
                        self.setExistArray()
                        self.tableView.reloadData()
                        let components = Calendar.current.dateComponents([.year, .month], from: self.calendarView.currentPage)
                        self.setMonthOfDot(year: components.year!, month: components.month!)
                        
                    }
                }
            case .failure(let message):
                print("failure", message)
            }
        }
    }
    
    //투두 미루기
    private func postponeTodo(todo: ToDo){
        TodoService.shared.postponeTodo(todo: todo) { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? TodoWriteResponseData{
                    if data.resultCode == 200 {
                        print("success")
                    }else{
                        print("fail")
                    }
                }
            case .failure(let message):
                print("failure", message)
            }
        }
    }
    
    //그룹명 조회
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
    
    //투두 존재하는 날 dot 찍기
    private func setMonthOfDot(year: Int, month: Int){
        TodoService.shared.getDayOfDot(year: year, month: month) { (response) in
            switch(response){
            case.success(let resultData):
                if let data = resultData as? DayDotResponseData{
                    if data.resultCode == 200 {
                        let dotStringArray = data.data.compactMap({String($0)})
                        self.dotsArray.removeAll()
                        for i in 0 ..< dotStringArray.count{
                            var date = Date()
                            var components = Calendar.current.dateComponents([.year, .month, .day], from: self.calendarView.currentPage)
                            components.day = i
                            self.dotsArray.append(Dots(date: Calendar.current.date(from: components)!, color: dotStringArray[i]))
                        }
                        self.calendarView.reloadData()
                        
                    }else{
                        print("get day 500")
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func setDayOfDot(date:Date){
        
    }
}


//table view delegate
extension ToDoMainViewController:UITableViewDelegate{
    
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
    
    //floating 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        floatingButton.frame = CGRect(x: floatingButton.frame.origin.x, y: floatingButton_y + offset, width: self.view.fs_width * 0.16, height: self.view.fs_width * 0.16)
        collectionView.frame = CGRect(x: collectionView.frame.origin.x, y: floatingButton_y + offset - 10 - self.collectionView.fs_height , width: collectionView.fs_width, height: collectionView.fs_height)
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = self.existingColorArray[indexPath.section]
        let row = indexPath.row
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.deleteTodo(todo: self.todoArrayList[section][row], section: indexPath.section, row: indexPath.row)
            self.deleteNotification(identifier: self.todoArrayList[self.existingColorArray[indexPath.section]][indexPath.row].id)
            success(true)
        }
        
        delete.backgroundColor = UIColor(red: 0.98, green: 0.32, blue: 0.32, alpha: 1)
        delete.title = nil
        delete.image = UIImage(named: "delete-trash")
        
        let postpone = UIContextualAction(style: .normal, title: "내일하기") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.postponeTodo(todo: self.todoArrayList[section][row])
            success(true)
        }
        
        postpone.backgroundColor = UIColor(red: 0.42, green: 0.72, blue: 1, alpha: 1)
        postpone.title = nil
        postpone.image = UIImage(named: "postpone")
        
        return UISwipeActionsConfiguration(actions: [delete, postpone])
    }
    
}



//table view datasource
extension ToDoMainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //현재 존재하는 그룹의 수 만큼 return
        return todoArrayList[existingColorArray[section]].count
    }
    
    //cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoTableViewCell()
        let todo = todoArrayList[existingColorArray[indexPath.section]][indexPath.row]
        cell.selectionStyle = .none
        cell.todo = todo
        cell.titleTextField.text = todo.title
        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.delegate = self
        cell.checkbox.image = todo.done ? Color.shared.getCheckBoxImage(colorNum: todo.color):UIImage(named: "checkbox")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    //cell이 선택되면 bottom sheet 등장 및 디자인 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomSheetVC = BottomSheetViewController()
        nowSection = existingColorArray[indexPath.section]
        nowRow =  indexPath.row
        bottomSheetVC?.todo = todoArrayList[nowSection][nowRow]
        bottomSheetVC?.delegate = self
        view.addSubview((bottomSheetVC?.view)!)
        addChild(bottomSheetVC!)
        
        (bottomSheetVC?.view)!.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
}

//calendar delegate, datasource
extension ToDoMainViewController: FSCalendarDelegate {
    //캘린더 페이지 변경시 하단 날짜 라벨 변경x
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let nowDate = calendarView.currentPage
        dateLabel.text = DateFormat.shared.getdateLabelString(date: nowDate)
        calendarView.select(nowDate)
        searchTodo(date: nowDate)
        dayLabel.text = DateFormat.shared.getDay(date: nowDate)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: nowDate)
        let components = Calendar.current.dateComponents([.year, .month], from: nowDate)
        self.setMonthOfDot(year: components.year!, month: components.month!)
        calendar.reloadData()
    }
    
    //날짜 선택시 평일, 주말 글씨 컬러 변경 및 날짜 라벨 변경
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        searchTodo(date: date)
        
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 {
            calendar.cell(for: date, at: monthPosition)?.titleLabel.textColor = .red
        }
        
        dayLabel.text = DateFormat.shared.getDay(date: date)
        weekdayLabel.text = DateFormat.shared.getWeekdayInKorean(date: date)
    }
    
    //월간, 주간 높이 변경
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        var colorArray: [UIColor] = []
        if let dots = dotsArray.first(where: { $0.date == date }) {
            if dots.color != "0"{
                for colorNum in Array(dots.color){
                    colorArray.append(Color.shared.getColor(colorNumString: colorNum))
                }
            }
        }
        return colorArray
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if DateFormat.shared.getWeekdayInKorean(date: date) == "일요일" {
            cell.titleLabel.textColor = UIColor.sundayDarkColor //이번달의 일요일 색깔
            if DateFormat.shared.getMonth(date: date) != DateFormat.shared.getMonth(date: calendar.currentPage){
                cell.titleLabel.textColor = UIColor.sundayLightColor //이번달이 아닌 일요일 색깔
            }
        }
    }
}

//캘린더 delegate, datasource
extension ToDoMainViewController:FSCalendarDelegateAppearance, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 {
            if Calendar.current.component(.month, from: calendar.currentPage) != Calendar.current.component(.month, from: date){
                return UIColor.sundayLightColor
            }
            return UIColor.sundayDarkColor
        }else if Calendar.current.component(.month, from: calendar.currentPage) != Calendar.current.component(.month, from: date){
            return UIColor.calendarNotThisMonthTextColor
        }
        return UIColor.textColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 {
            return .red
        }
        return .black
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let dots = dotsArray.first(where: { $0.date == date }) {
            return dots.color == "0" ? 0 : dots.color.count > 3 ? 3 : dots.color.count
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        var colorArray: [UIColor] = []
        if let dots = dotsArray.first(where: { $0.date == date }) {
            if dots.color != "0"{
                for colorNum in Array(dots.color){
                    colorArray.append(Color.shared.getColor(colorNumString: colorNum))
                }
            }
        }
        return colorArray
    }
}


//collection view delegate, datasource
extension ToDoMainViewController:UICollectionViewDelegate{
    //투두 작성을 위해 색깔 선택 뷰 에서 색깔 원을 선택했을 시 실행되는 동작
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = DateFormat.shared.getYearMonthDay(date: calendarView.selectedDate!) //year, month, day를 순서대로 배열로 반환하는 함수
        var index = 0
        
        //완료된 투두의 바로 위에 새로운 투두 추가. 완료된 투두가 없다면 맨 밑에 추가
        if let index_x = todoArrayList[indexPath.row].firstIndex(where: { todo in
            todo.done == true
        }){
            index = index_x
        }else {
            index = todoArrayList[indexPath.row].count
        }
        todoArrayList[indexPath.row].insert(ToDo(year: date[0] , month: date[1], day: date[2], title: "", done: false, isNew: true, writer: "", color: indexPath.row + 1, id: 0, time: "0000", description: ""), at: index)
        setExistArray()
        tableView.reloadData()
        
        //todo 작성 시에 뒤에 깔리는 투명한 뷰. 작성 도중에 셀이 눌리지 않고 다른 투두 완료가 불가하도록 만듦
        tableView.addSubview(clearViewForWritingTodo)
        clearViewForWritingTodo.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        //선택이 완료되었으면 선택 뷰가 없는 원래 상태로 되돌리기 위해 해당 함수 호출
        tapFloatingButton()
    }
    

    
    
}


extension ToDoMainViewController:UICollectionViewDataSource{
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
extension ToDoMainViewController:UICollectionViewDelegateFlowLayout{
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

//cell 내부에서 변경된 사항을 메인 페이지에 적용시키기 위한 프로토콜
extension ToDoMainViewController: TodoTableViewCellDelegate {
    
    func writeNothing(section: Int, row: Int) {
        todoArrayList[section].remove(at: row)
        setExistArray()
        tableView.reloadData()
    }
    
    func sendTodoData(section: Int, row: Int, todo: ToDo) {
        todoArrayList[todo.color-1][row] = todo
        todoSortById(section: section)
        todoSortByDone(section: section)
        let components = Calendar.current.dateComponents([.year, .month], from: calendarView.currentPage)
        setMonthOfDot(year: components.year!, month: components.month!)
        tableView.reloadData()
    }
    
    func editDone(section: Int, row: Int, todo: ToDo) {
        //파라미터의 section 대신 color(1~6)에서 1뺀 값으로 section에 접근
        todoArrayList[todo.color-1][row] = todo
        todoSortById(section: todo.color-1)
        todoSortByDone(section: todo.color-1)
        tableView.reloadData()
    }
}
//Bottom sheet 내부에서 변경된 사항을 메인 페이지에 적용시키기 위한 프로토콜
extension ToDoMainViewController: BottomSheetViewControllerDelegate{
    func sendTodoData(todo: ToDo) {
        todoArrayList[nowSection].remove(at: nowRow)
        
        let oldTodo = todoArrayList[nowSection][nowRow]
        if oldTodo.year == todo.year && oldTodo.month == todo.month && oldTodo.day == todo.day{
            todoArrayList[todo.color-1].append(todo)
            todoSortById(section: todo.color-1)
            todoSortByDone(section: todo.color-1)
        }
        setExistArray()
        tableView.reloadData()
    }
}


extension ToDoMainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == tableView || touch.view == tableView.tableHeaderView || touch.view == calendarBackgroundView || touch.view == tableView.tableFooterView
    }
    
}


