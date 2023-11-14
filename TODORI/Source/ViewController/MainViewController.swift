//
//  MainViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/04/18.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setTitle("감자!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃을 코드로 설정할 것임을 명시
        
        // 버튼의 탭 액션 설정
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 뷰에 버튼 추가
        view.addSubview(button)
        
        // 버튼의 가로 중앙, 세로 중앙, 너비, 높이 제약 조건 설정
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let label = UILabel()
        label.text = "FUCK"
        label.textAlignment = .center
        label.backgroundColor = .purple
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.bottom.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @objc func buttonTapped() {
        print("Button tapped!")
        
//        self.dismiss(animated: true, completion: nil)
        
            // 첫 번째 뷰 컨트롤러에서 두 번째 뷰 컨트롤러로 전환
            let secondViewController = ViewController()
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        
    }

}
