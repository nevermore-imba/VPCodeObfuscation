//
//  VPViewController.m
//  VPCodeObfuscationDemo
//
//  Created by Axe on 2018/3/21.
//  Copyright © 2018年 Axe. All rights reserved.
//

#import "VPViewController.h"

@interface VPViewController ()

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	self.vp_title = nil;
	_logoImageName = @"logo.png";
}

- (void)setVp_title:(NSString *)vp_title {
	if (!vp_title) {
		vp_title = @"null";
	}
	NSLog(@"vp_title = %@", vp_title);
}

- (void)testFunctionWithParam1:(NSString*)param10 param2:(BOOL)param20 param3:(void (^)(NSString *value))param30 {
	
}

- (void)testFunction:(NSString*)testFunction {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
