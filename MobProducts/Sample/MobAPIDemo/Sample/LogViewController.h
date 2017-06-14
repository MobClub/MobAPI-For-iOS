//
//  LogViewController.h
//  Sample
//
//  Created by liyc on 15/11/10.
//  Copyright © 2015年 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController

/**
 *  设置日志
 *
 *  @param content 日志内容
 */
- (void)setLog:(NSString *)content;

@property (nonatomic, strong) NSString *naviTitle;

@end
