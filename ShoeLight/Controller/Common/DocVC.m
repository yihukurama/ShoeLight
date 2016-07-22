//
//  DocController.m
//  ShoeLight
//
//  Created by even on 16/3/20.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "DocVC.h"
#import "macro.h"

@implementation DocVC

- (void)loadView {
    self.dataSource = self;
    [super loadView];
}




- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [[NSBundle mainBundle]URLForResource:self.fileName withExtension:nil];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

@end
