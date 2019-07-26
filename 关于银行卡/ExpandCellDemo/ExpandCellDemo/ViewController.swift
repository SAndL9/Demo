//
//  ViewController.swift
//  ExpandCellDemo
//



import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    let normalColor = UIColor.init(red: 0.90, green: 0.90, blue: 1.00, alpha: 1.00).cgColor;
    let selectedColor = UIColor.init(red:0.85, green:0.85, blue:1.00, alpha:1.00).cgColor
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPath : IndexPath?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "IVEListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath);
        if indexPath == selectedIndexPath {
            cell.layer.borderColor = selectedColor
        } else {
            cell.layer.borderColor = normalColor;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath);
        if selectedIndexPath == indexPath {
            cell?.layer.borderColor = normalColor;
            selectedIndexPath = nil;
        } else {
            if selectedIndexPath != nil {
                let selectedCell = collectionView.cellForItem(at: selectedIndexPath!)
                selectedCell?.layer.borderColor = normalColor
            }
            self.selectedIndexPath = indexPath;
            cell?.layer.borderColor = selectedColor
        }
        self.collectionView.performBatchUpdates({
            
        }) { (finished) in
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == selectedIndexPath {
            return CGSize.init(width: self.collectionView.frame.width - 40, height: 120);
        }
        return CGSize.init(width: self.collectionView.frame.width - 40, height: 70);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 20, bottom: 0, right: 20);
    }



}

