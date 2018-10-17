//
//  MOBACarViolationRequest.h
//  MobAPI
//
//  Created by Brilance on 2018/7/10.
//  Copyright © 2018年 mob. All rights reserved.
//

#import <MobAPI/MobAPI.h>

@interface MOBACarViolationRequest : MOBARequest

/**
 车辆违章查询请求信息 

 @param plateNumber 号牌号码
 @param plateType 号牌种类码，默认02 非必填
 @param engineNumber 发动机号后六位
 @param areaCode 地区码
 @return 请求对象
 */
+ (MOBACarViolationRequest *)queryCarViolationInfoByPlateNumber:(NSString *)plateNumber
                                                      plateType:(NSString *)plateType
                                                   engineNumber:(NSString *)engineNumber
                                                       areaCode:(NSString *)areaCode;


@end
