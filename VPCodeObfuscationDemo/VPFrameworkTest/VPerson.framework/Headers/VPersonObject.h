//
//  VPersonObject.h
//  VPerson
//
//  Created by Axe on 2018/3/27.
//  Copyright © 2018年 Axe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VPersonObject : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic, nullable) NSString *sex;
@property (strong, nonatomic, nullable) NSNumber *age;

- (instancetype)initWithName:(NSString *)name age:(nullable NSNumber *)age sex:(nullable NSString *)sex;
+ (instancetype)personWithName:(NSString *)name age:(nullable NSNumber *)age sex:(nullable NSString *)sex;

- (void)introduce;

@end

NS_ASSUME_NONNULL_END
