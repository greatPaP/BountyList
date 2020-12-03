//
//  DetailViewController.swift
//  BountyList
//
//  Created by 김상원 on 2020/10/23.
//  Copyright © 2020 com.sangs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    @IBOutlet weak var nameLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var bountyLabelCenterX: NSLayoutConstraint!
    
    // DetailViewController에서 사용할 변수 선언
    // BountyViewController에서 name과 bounty를 받아와야 함
    
    let viewModel = DetailViewModel()
    
    // 해당 함수는 메모리에 뷰가 올라온 상태도 아직 띄어진 상태가 아님
    // 그래서 메모리에 올라온 상태에서 updateUI()를 먼저 실행해서 해당 화면의 데이터를 넣고 화면을 띄워줌
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // 애니메이션을 준비하는 메소드
        prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 애니메이션을 진행하는 메소드
        showAnimation()
    }
    
    private func prepareAnimation() {
        // constant를 이용한 Animation에서 사용
//        nameLabelCenterX.constant = view.bounds.width
//        bountyLabelCenterX.constant = view.bounds.width
        
        
        // View의 속성을 이용한 Animation에서 사용
        // transform : 변형을 가한다
        // CGAffineTransform : 위치의 변형
        // scaledBy : 사이즈 변형
        // rotated : 180도 돌리기
        // 우측에 사라진 상태에서 3배씩 커진 뒤 180도 돌아간 상태
        nameLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        bountyLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        
        // 투명도가 0으로 시작
        nameLabel.alpha = 0
        bountyLabel.alpha = 0
    }

    private func showAnimation() {
        
        // constant를 이용한 Animation에서 사용
    //        nameLabelCenterX.constant = 0
    //        bountyLabelCenterX.constant = 0
    //
    //        // 스프링 옵션이 들어감
    //        UIView.animate(withDuration: 0.5,
    //                       delay: 0.2,
    //                       usingSpringWithDamping: 0.6,
    //                       initialSpringVelocity: 2,
    //                       options: .allowUserInteraction,
    //                       animations: {
    //                        self.view.layoutIfNeeded()
    //        },
    //                       completion: nil)
    //
    //        UIView.transition(with: imgView,
    //                          duration: 0.3,
    //                          options: .transitionFlipFromLeft,
    //                          animations: nil,
    //                          completion: nil)
        
        // View의 속성을 이용한 Animation에서 사용
        // Animation 적용 (Animation API를 이용)
        // Label 스프링 옵션
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            // CGAffineTransform.identity : 변형을 적용하기 전의 상태로 돌려주는 것
            self.nameLabel.transform = CGAffineTransform.identity
            self.bountyLabel.transform = CGAffineTransform.identity
            // 투명도를 되돌리자
            self.nameLabel.alpha = 1
            self.bountyLabel.alpha = 1
        }, completion: nil)
        
        // imgView에 대한 애니메이션
        UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    func updateUI() {
        if let bountyInfo = viewModel.bountyInfo {
            imgView.image = bountyInfo.image
            nameLabel.text = bountyInfo.name
            bountyLabel.text = String(bountyInfo.bounty)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// ViewModel
class DetailViewModel {
    var bountyInfo: BountyInfo?
    
    func update(model: BountyInfo?) {
        bountyInfo = model
    }
}
