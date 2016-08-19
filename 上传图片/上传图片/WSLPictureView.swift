//
//  WSLPictureView.swift
//  上传图片
//
//  Created by czbk on 16/8/19.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

//标识
private let pictureCellID = "pictureCellID"

//图片view
class WSLPictureView: UICollectionView {
    //添加图片的闭包
    var addPictureAction: (()->())?
    
    //图片数组
    lazy var images: [UIImage] = [UIImage]()

     //init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        //
        let flowLayout = UICollectionViewFlowLayout()
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        //设置界面
        setupUI()
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //外界添加图片的方法
    func addImage(image: UIImage) {
        //判断 > 9张后
        if images.count > 9 {
            return
        }
        
        //添加图片
        images.append(image)
        
        //刷新数据
        self.reloadData()
    }
    
    //设置界面
    private func setupUI(){
        //注册cell
        registerClass(WSLPictureCell.self, forCellWithReuseIdentifier: pictureCellID)
        
        //设置代理
        dataSource = self
        delegate = self
    }
    
    //布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //
        let itemMargin: CGFloat = 5     //间距
        let itemWidth = (frame.size.width - 2 * itemMargin) / 3 //宽(固定3列)
        
        //获取布局
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        //设置大小
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        //水平垂直间距
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.minimumLineSpacing = itemMargin
    }

}

//MARK: -数据源方法
extension WSLPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //判断当是0 或9 的时候,不显示添加
        if images.count == 0 || images.count == 9 {
            return images.count
        }else{
            return images.count + 1
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureCellID, forIndexPath: indexPath) as! WSLPictureCell
        
        //判断,当是最后一个的时候,
        if indexPath.item == images.count {
            cell.image = nil
        }else {
            //传递数据
            cell.image = images[indexPath.item]
            
            //删除按钮的闭包
            cell.selectDeleteButton = {[weak self] in
                //删除指定的图片
                self?.images.removeAtIndex(indexPath.item)
                
                //刷新数据
                self?.reloadData()
            }
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //判断是最后一个cell
        if indexPath.item == images.count {
            super.deselectItemAtIndexPath(indexPath, animated: true)
            
            //执行闭包,去调用添加图片的方法
            addPictureAction?()
        }
    }
}

//MARK: -自定义cell
class WSLPictureCell: UICollectionViewCell {
    //删除按钮的闭包
    var selectDeleteButton: (() -> ())?
    
    //图片
    private lazy var imageView: UIImageView = UIImageView()
    
    //删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        //添加点击事件
        button.addTarget(self, action: "deleteButtonAction", forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        
        button.sizeToFit()
        
        return button
    }()
    
    //frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置界面
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置界面
    private func setupUI() {
        //添加控件
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        //设置约束
        imageView.frame = contentView.frame
        
        addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .Right, relatedBy: .Equal, toItem: imageView, attribute: .Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Top, multiplier: 1, constant: 0))
    }
    
    //数据赋值
    var image: UIImage? {
        didSet {
            //为空显示添加
            if image == nil {
                //添加图片
                imageView.image = UIImage(named: "compose_pic_add")
                
                //高亮图片
                imageView.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
                
                //添加,不需要删除按钮
                deleteButton.hidden = true
            }else {
                //设置图片
                imageView.image = image
                
                //显示删除按钮
                deleteButton.hidden = false
                
                //不需要高亮
                imageView.highlightedImage = nil
            }
        }
    }
    
    
    //删除按钮的事件
    @objc private func deleteButtonAction() {
        //执行闭包
        selectDeleteButton?()
    }
    
    
    
}
