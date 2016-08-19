//
//  ViewController.swift
//  上传图片
//
//  Created by czbk on 16/8/19.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //显示图片的view
    private lazy var pictureView: WSLPictureView = {
        let picture = WSLPictureView()
        
        //背景色
        picture.backgroundColor = UIColor.grayColor()
        
        return picture
    }()
    
    
    //添加图片按钮
    private lazy var button: UIButton = {
        let button = UIButton()
        //添加事件
        button.addTarget(self, action: "clickAddPictureButton", forControlEvents: .TouchUpInside)
        
        //
        button.setTitle("添加图片", forState: .Normal)
        button.backgroundColor = UIColor.blackColor()

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        //添加控件
        view.addSubview(button)
        view.addSubview(pictureView)
        
        //设置约束
        button.frame = CGRect(x: 100, y: 50, width: 100, height: 30)
        
        pictureView.frame.size = CGSize(width: self.view.frame.size.width, height:  self.view.frame.size.width)
        pictureView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        
        
        //闭包
        pictureView.addPictureAction = { [weak self] in
            self!.clickAddPictureButton()
        }
    }

    //添加图片
    @objc private func clickAddPictureButton(){
        //获取图片和视频的接口
        let picture = UIImagePickerController()
        
        //设置代理
        picture.delegate = self
        
        //判断类型
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            //相机
            picture.sourceType = .Camera
        }else {
            //相册
            picture.sourceType = .PhotoLibrary
        }
        
        //判断摄像头是否可用
        if UIImagePickerController.isCameraDeviceAvailable(.Front) {
            print("前摄像头可用")
        }else if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            print("后摄像头可用")
        }else {
            print("没有摄像头")
        }
        
        //图片是否可以编辑
        picture.allowsEditing = true
        
        //打开相册
        presentViewController(picture, animated: true, completion: nil)
    }

}

//MARK: -UIImagePickerController的代理
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //1,把要上传的图片压缩
        let scaleImage = image.scaleImageWithScaleWith(200)
        
        //2,把图片添加到pictureView中
        pictureView.addImage(scaleImage)
        
        //3,选中图片后,dismis掉图册
        picker.dismissViewControllerAnimated(true, completion: nil) 
    }
    
    //点击相册中的返回,dismis掉相册
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}





























