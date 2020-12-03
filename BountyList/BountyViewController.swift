//
//  BountyViewController.swift
//  BountyList
//
//  Created by 김상원 on 2020/10/23.
//  Copyright © 2020 com.sangs. All rights reserved.
//

import UIKit

// TableView로 진행할 경우 UITableViewDataSource, UITableViewDelegate
class BountyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    // -------------------------------------------------------------------------------------
    // CollectionView
    // UICollectionViewDataSource
    // 몇개를 보여줄지, 셀은 어떻게 표현할지 구현
    // 몇 개를 보여줄지!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numofBountyInfoList
    }
    
    // 셀을 어떻게 표현할지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }
        
        let bountyInfo = viewModel.bountyInfo(at: indexPath.item)
        cell.update(info: bountyInfo)
        return cell
    }
    
    // UICollectionViewDelegate
    // 셀이 클릭되었을때 어떻게 하는지
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
    
    // UICollectionViewFlowLayout
    // 셀 사이즈를 계산 (각 디바이스마다 화면에 대한 크기가 다르기 때문에 다양한 디바이스에서 일반적인 디자인을 보여주기 위해)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10 // 가로에서 cell과 cell 사이의 거리
        let textAreaHeight: CGFloat = 65 // textLabel이 차지하는 높이
        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
        let height: CGFloat = width * 10/7 + textAreaHeight //셀 하나의 높이
        
        return CGSize(width: width, height: height)
    }
    
    // -------------------------------------------------------------------------------------
    
    
    // -------------------------------------------------------------------------------------
    // MVVM 요소 찾아서 바꾸기
    // Model
    // -- nameList, bountyList를 BountyInfo 오브젝트로 만들자
    
    // View
    // -- ListCell --> ListCell에 필요한 정보를 ViewModel한테서 받아오자
    // ListCell은 ViewModel로 부터 받은 정보로 View 업데이트 하기
    
    // ViewModel
    // -- BountyViewModel을 만들고, View Layer에서 필요한 메소드 만들기
    // -- Model을 가지고 있기 BountyInfo 들을 가지고 있기
    // -------------------------------------------------------------------------------------
    
    let viewModel = BountyViewModel()
    
    // 세그웨이를 수행하기 직전에 준비하는 메소드
    // ViewController에 있는 함수라서 override로 표현 (상속 받았으므로)
    // DetailViewController에게 데이터를 넘겨줌
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // showDetail 세그웨이를 수행할 때
        if segue.identifier == "showDetail" {
            // 세그웨이의 도착지가 DetailViewController
            let vc = segue.destination as? DetailViewController
            
            if let index = sender as? Int {
                let bountyInfo = viewModel.bountyInfo(at: index)
                vc?.viewModel.update(model: bountyInfo)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    // UITableViewDataSource에 관련된 코드
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return bountyList.count
//        // ViewModel에서 먼저 접근하고 반환해주는 형식으로 진행
//        return viewModel.numofBountyInfoList
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // casting, 리스트 셀로 캐스팅해가지고 캐스팅한 결과가 있는 경우에는 밑으로 코드를 수행, 그렇지 않은 경우에는 else문으로 들어감
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
//            return UITableViewCell()
//        }
//        let bountyInfo = viewModel.bountyInfo(at: indexPath.row)
//        cell.update(info: bountyInfo)
//        return cell
//
//    }
    
    // UITableViewDelegate에 관련된 코드
//    // Cell이 클릭됐을 때 수행
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("--> \(indexPath.row)")
//
//        // 세그웨이 수행
//        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
//    }
    
}

// CUSTOM CELL 만들기 (UITableViewCell를 상속해서 만듬)
class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    func update(info: BountyInfo) {
        imgView.image = info.image
        nameLabel.text = info.name
        bountyLabel.text = String(info.bounty)
    }
}

// CollectionViewCell에 대한 Custom Cell
class GridCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    func update(info: BountyInfo) {
        imgView.image = info.image
        nameLabel.text = info.name
        bountyLabel.text = String(info.bounty)
    }
}

// Model 만들기
struct BountyInfo {
    let name: String
    let bounty: Int
    var image: UIImage? {
        return UIImage(named: "\((name).lowercased()).jpg")
    }
    
    // 이니셜 라이즈
    init(name: String, bounty: Int) {
        self.name = name
        self.bounty = bounty
    }
}

// ViewModel 만들기
// Model을 가지고 있어야 함
// ViewModel을 통해서만 Model을 Access

class BountyViewModel {
    let bountyInfoList: [BountyInfo] = [
        BountyInfo(name: "BROOK", bounty: 33000000),
        BountyInfo(name: "CHOPPER", bounty: 50),
        BountyInfo(name: "FRANKY", bounty: 44000000),
        BountyInfo(name: "LUFFY", bounty: 300000000),
        BountyInfo(name: "NAMI", bounty: 16000000),
        BountyInfo(name: "ROBIN", bounty: 80000000),
        BountyInfo(name: "SANJI", bounty: 77000000),
        BountyInfo(name: "ZORO", bounty: 120000000)
    ]
    
    var sortedList: [BountyInfo] {
        let sortedList = bountyInfoList.sorted { prev, next in
            return prev.bounty > next.bounty
        }
        
        return sortedList
    }
    
    var numofBountyInfoList: Int {
        return bountyInfoList.count
    }
    
    func bountyInfo(at index: Int) -> BountyInfo {
        return sortedList[index]
    }
    
    
}

