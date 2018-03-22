//
//  VPViewController.h
//  VPCodeObfuscationDemo
//
//  Created by Axe on 2018/3/21.
//  Copyright © 2018年 Axe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPViewController : UIViewController

@property (copy, nonatomic) NSString *vp_title;
@property (copy, nonatomic) NSString *logoImageName; ///< The logo image name

- (void)testFunctionWithParam1:(NSString*)param10 param2:(BOOL)param20 param3:(void (^)(NSString *value))param30;

- (void)testFunction:(NSString*)testFunction;

@end
