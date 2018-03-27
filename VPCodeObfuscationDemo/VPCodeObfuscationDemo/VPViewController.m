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

	self.view.backgroundColor = [UIColor redColor];

	UILabel *label = [UILabel new];
	label.text = @"触摸屏幕任意地方返回";
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.frame = self.view.bounds;
	[self.view addSubview:label];

	[self introduce];
	[self testFunction1:@"Zero" params1:@"One" params2:@[@1, @2]];
	[self testFunction2:@"Three" params4:@"Four"];
}

- (void)testFunction1:(NSString *)params0
			  params1:(NSString *)params1
			  params2:(NSArray *)params2 {
	NSLog(@"params0 = %@, params1 = %@, params2 = %@", params0, params1, params2);
}

- (void)testFunction2:(NSString *)params3 params4:(NSString *)params4 {
	NSLog(@"%s{params3 = %@, params4 = %@}", __FUNCTION__, params3, params4);
}


- (void)introduce {
	NSLog(@"跟第三方库中的方法名相同，不参与混淆 %s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];

	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
