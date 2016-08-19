//
//  UIImage+Extension.swift
//  上传图片
//
//  Created by czbk on 16/8/19.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
    图片的压缩
    
    - parameter scaleWidth: 压缩的比例宽度
    */
    func scaleImageWithScaleWith(scaleWidth: CGFloat) -> UIImage {
        //1,计算压缩后的高度
        let scaleHeight = scaleWidth / self.size.width * self.size.height
        
        //2,压缩后的图片大小
        let imageSize = CGSize(width: scaleWidth, height: scaleHeight)
        
        //MARK: -绘制图片
        //3,开启图片上下文
        UIGraphicsBeginImageContext(imageSize)
        
        //4,绘制图片
        self.drawInRect(CGRect(origin: CGPointZero, size: imageSize))
        
        //5,获取图片上下文中的图片
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //6,关闭图片上下文
        UIGraphicsEndImageContext()
        
        return scaleImage
    }

}
