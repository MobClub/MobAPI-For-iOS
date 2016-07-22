//
//  MOBAUserCenter.h
//  MobAPI
//
//  Created by ShengQiangLiu on 16/5/3.
//  Copyright © 2016年 mob. All rights reserved.
//

#import <MobAPI/MobAPI.h>

/**
 *  用户系统相关请求
 *
 *  @author ShengQiangLiu
 */
@interface MOBAUserCenter : MOBARequest

/**
 *  用户注册
 *
 *  @param username 用户名（一个key只能存在唯一username），必填项，不允许为nil
 *  @param password 用户密码（建议加密），必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userRigisterRequestByUsername:(NSString *)username password:(NSString *)password;

/**
 *  用户登录
 *
 *  @param username 用户名，必填项，不允许为nil
 *  @param password 用户密码，必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userLoginRequestByUsername:(NSString *)username password:(NSString *)password;

/**
 *  修改用户密码
 *
 *  @param username 用户名，必填项，不允许为nil
 *  @param oldPwd   旧密码，必填项，不允许为nil
 *  @param newPwd   新密码，必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userPasswordChangeRequestByUsername:(NSString *)username
                                               oldPassword:(NSString *)oldPwd
                                               newPassword:(NSString *)newPwd;

/**
 *  用户资料插入/更新
 *
 *  @param token 用户登录时生成的token，必填项，不允许为nil
 *  @param uid   用户id，必填项，不允许为nil
 *  @param item  用户资料项(长度length不超过1024)，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *  @param value 用户资料项对应的值()用户资料项(长度length不超过1024)，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userProfilePutRequestByToken:(NSString *)token
                                                uid:(NSString *)uid
                                               item:(NSString *)item
                                              value:(NSString *)value;

/**
 *  查询用户资料
 *
 *  @param uid  用户id，用户注册时生成，必填项，不允许为nil
 *  @param item 用户资料项（如果为空，则返回用户资料所有数据），标准base64编码，且为URLSafe模式。
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userProfileQueryRequestByUid:(NSString *)uid item:(NSString *)item;

/**
 *  删除用户资料项
 *
 *  @param token 用户登录时生成，必填项，不允许为nil
 *  @param uid   用户id，必填项，不允许为nil
 *  @param item  用户资料项，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userProfileDeleteRequestByToken:(NSString *)token
                                                   uid:(NSString *)uid
                                                  item:(NSString *)item;

/**
 *  用户数据插入/更新
 *
 *  @param token 用户登录时生成的token，必填项，不允许为nil
 *  @param uid   用户id，必填项，不允许为nil
 *  @param item  用户数据项(长度length不超过1024)，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *  @param value 用户数据项对应的值(长度length不超过1024)，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userDataPutRequestByToken:(NSString *)token
                                             uid:(NSString *)uid
                                            item:(NSString *)item
                                           value:(NSString *)value;

/**
 *  用户数据查询
 *
 *  @param token 用户登录时生成的token，必填项，不允许为nil
 *  @param uid   用户id，必填项，不允许为nil
 *  @param item  用户数据项，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userDataQueryRequestByToken:(NSString *)token
                                               uid:(NSString *)uid
                                              item:(NSString *)item;

/**
 *  用户数据删除项
 *
 *  @param token 用户登录时生成的token，必填项，不允许为nil
 *  @param uid   用户id，必填项，不允许为nil
 *  @param item  用户数据项，标准base64编码，且为URLSafe模式。必填项，不允许为nil
 *
 *  @return 请求对象
 */
+ (MOBAUserCenter *) userDataDeleteRequestByToken:(NSString *)token
                                                uid:(NSString *)uid
                                               item:(NSString *)item;

@end
