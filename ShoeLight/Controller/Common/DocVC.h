//
//  DocController.h
//  ShoeLight
//
//  Created by even on 16/3/20.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface DocVC : QLPreviewController <QLPreviewControllerDataSource>

@property (copy, nonatomic) NSString *fileName;

@end
