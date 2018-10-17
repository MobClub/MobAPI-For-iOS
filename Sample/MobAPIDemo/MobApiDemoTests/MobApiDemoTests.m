//
//  MobApiDemoTests.m
//  MobApiDemoTests
//
//  Created by Brilance on 2018/6/6.
//  Copyright © 2018年 mob. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MobAPI/MobAPI.h>
#import <MOBFoundation/MOBFoundation.h>

@interface MobApiDemoTests : XCTestCase

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userEmail;

@end

@implementation MobApiDemoTests

//生成六位随机字符串
- (NSString *)six_randomString
{
    char data[6];
    for (int x=0;x < 6;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:6 encoding:NSUTF8StringEncoding];
    
    return randomStr;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark api查询接口
- (void)testApiQueryCall
{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    [MobAPI apiQueryWithResult:^(MOBAResponse *response) {
        
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 循环100次
- (void)testApiQueryCallThread
{
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i ++) {
            NSLog(@"%@",[NSThread currentThread]);
            
            [MobAPI apiQueryWithResult:^(MOBAResponse *response) {
                
                XCTAssertNil(response.error,@"error: %@",response.error);
                XCTAssertNotNil(response.responder);
                if(i == 99)
                    [expectation fulfill];
                
            }];
        }
    });
    
    [self waitForExpectationsWithTimeout:50 handler:nil];
}


#pragma mark 自定义请求接口
- (void)testCustomInterfaceCall
{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    [MobAPI sendRequestWithInterface:@"/v1/weather/query"
                               param:@{
                                       @"city":@"广州",
                                       @"province":@""
                                       }
                            onResult:^(MOBAResponse *response) {
                                
                                blockResponseObject = response.responder;
                                blockError = response.error;
                                [expectation fulfill];
                                
                            }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 循环100次
- (void)testCustomInterfaceCallThread
{
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i ++) {
            NSLog(@"%@",[NSThread currentThread]);
            
            [MobAPI sendRequestWithInterface:@"/v1/weather/query"
                                       param:@{
                                               @"city":@"广州",
                                               @"province":@""
                                               }
                                    onResult:^(MOBAResponse *response) {
                                        
                                        XCTAssertNil(response.error,@"error: %@",response.error);
                                        XCTAssertNotNil(response.responder);
                                        if(i == 99)
                                            [expectation fulfill];
                                        
                                    }];
            
            MOBARequest *request = [MOBAPhoneRequest addressRequestByPhone:@"013905892356"];
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                
            }];
            
        }
    });
    
    [self waitForExpectationsWithTimeout:50 handler:nil];
    
}


#pragma mark 手机号码查询
// 查询手机号码归属地
- (void)testPhoneAddress{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAPhoneRequest addressRequestByPhone:@"13905892356"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 循环100次
- (void)testPhoneAddressThread{
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i ++) {
            NSLog(@"%@",[NSThread currentThread]);
            
            MOBARequest *request = [MOBAPhoneRequest addressRequestByPhone:@"13905892356"];
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                XCTAssertNil(response.error,@"error: %@",response.error);
                XCTAssertNotNil(response.responder);
                if(i == 99)
                    [expectation fulfill];
            }];
        }
    });
    
    [self waitForExpectationsWithTimeout:50 handler:nil];
}

#pragma mark 菜谱查询
// 查询菜谱分类
- (void)testCategoryRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACookRequest categoryRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询菜谱信息
- (void)testSearchMenuRequestByCid{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACookRequest searchMenuRequestByCid:@"0010001058" name:@"养胃" page:0 size:0];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 获取菜谱详情信息
- (void)testInfoDetailRequestById{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACookRequest infoDetailRequestById:@"00100010580000040341"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 邮编查询
// 邮编查询
- (void)testGetPostcodeAddress{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAPostcodeRequest addressRequestByCode:@"102629"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 获取省市区域列表
- (void)testGetPCDList{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAPostcodeRequest pcdListRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询邮政编码
- (void)testSearchPostcode{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAPostcodeRequest searchRequestByPid:@"40" cid:@"4001" did:nil word:@"安康"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 天气查询
// 查询天气
- (void)testSearchWeather{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAWeatherRequest searchRequestByCity:@"通州" province:@"北京"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 获取城市列表
- (void)testGetCityList{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAWeatherRequest citiesRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 根据ip地址查询天气
- (void)testSearchWeatherByIP{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAWeatherRequest searchRequestByIP:@"222.73.199.3" province:nil];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 天气类型查询
- (void)testWeatchTypeQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAWeatherRequest weatherTypeRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 身份证信息查询
// 身份证信息查询
- (void)testIdcardQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAIdRequest idcardRequestByCardno:@"45102519800411512X"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询手机基站信息
- (void)testStationQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAStationRequest stationRequestBylac:@"34860" cell:@"62041" mcc:@"460" mnc:@"0"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 空气质量查询
- (void)testEnvironmentQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAEnvironmentRequest environmentRequestByCity:@"南京" province:@"江苏"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark ip信息查询
// ip信息查询
- (void)testIpQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAIpRequest addressRequestForIp:@"222.73.199.34"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark k-v查询
// k-v存储
- (void)testKvPutCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAKvRequest kvPutRequest:@"mobile" key:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// k-v查询
- (void)testKvGetCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAKvRequest kvPutRequest:@"mobile" key:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {
            MOBARequest *request = [MOBAKvRequest kvGetRequest:@"mobile" key:@"bW9iaWxl"];
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                blockResponseObject = response.responder;
                blockError = response.error;
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询用户表中所有数据
- (void)testKvGetAllDataQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAKvRequest kvGetAllDataRequestByTable:@"mobile" page:1 size:20];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 统计用户表中数据总数
- (void)testKvStatisticsDataCountQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAKvRequest kvStatisticsDataCountRequestByTable:@"mobile"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 删除数据表中的单条数据
- (void)testKvDeleteSigleDataQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAKvRequest kvDeleteSigleDataRequestyByTable:@"mobile" key:@"bW9iaWxl"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询用户的所有表
- (void)testKvGetAllTablesQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAKvRequest kvGetAllTablesRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 万年历查询
// 万年历查询
- (void)testCalendarQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACalendarRequest calendarRequestWithDate:@"2015-05-01"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 号码信息查询
// 手机号码查吉凶
- (void)testMobileLuckyQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAMobileLuckyRequest mobileLuckyRequestByMobile:@"18521525252"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 银行卡信息查询
// 银行卡信息查询
- (void)testBankCardQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBABankCardRequest bankCardRequestWithCard:@"6228482898203884775"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 老黄历查询
// 老黄历查询
- (void)testLaohuangliQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBALaohuangliRequest laohuangliRequestWithDate:@"2015-05-01"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 健康知识查询
// 健康知识查询
- (void)testHealthQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAHealthRequest healthRequestWithKeyword:@"手" page:nil size:nil];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 婚姻匹配查询
// 算婚姻
- (void)testMarriageQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAMarriageRequest marriageRequestWithManDate:@"1987-4-26" manHour:@"10" womanDate:@"1992-03-18" womanHour:@"11"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 历史上的今天查询
// 历史上的今天
- (void)testHistoryQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAHistoryRequest historyRequestWithDay:@"1231"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 周公解梦查询
// 周公解梦
- (void)testDreamQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBADreamRequest dreamRequestWithKeyword:@"鱼" page:@"1" size:@"30"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 成语查询
// 成语查询
- (void)testIdiomQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAIdiomRequest idiomRequestWithName:@"狐假虎威"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 新华字典查询
// 新华字典查询
- (void)testDictionaryQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBADictionaryRequest dictionaryRequestWithName:@"赵"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 算八字查询
// 八字算命
- (void)testHoroScopeQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAHoroScopeRequest horoScopeRequestWithDate:@"2016-01-19" hour:@"20"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 今日各省油价
// 今日各省油价查询
- (void)testProvinceoilQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAProvinceoilRequest provinceoilRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 彩票开奖信息
// 查询彩票开奖结果
- (void)testLotteryQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBALotteryRequest lotteryRequestByName:@"大乐透" period:@"16025"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 微信精选
// 微信精选分类查询
- (void)testWxArticleCategoryQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAWxArticleRequest wxArticleCategoryRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 微信精选列表查询
- (void)testWxArticleListQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAWxArticleRequest wxArticleListRequestByCID:@"1" page:5 size:20];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 电影票房
// 实时票房查询
- (void)testBoxofficeDayQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBABoxOfficeRequest boxofficeDayRequestByArea:@"CN"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 周票房查询
- (void)testBoxofficeWeekQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBABoxOfficeRequest boxofficeWeekRequestByArea:@"CN"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 周末票房查询
- (void)testBoxofficeWeekEndQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBABoxOfficeRequest boxofficeWeekEndRequestByArea:@"CN"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 黄金价格
// 期货黄金数据查询
- (void)testGoldFutureQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAGoldRequest goldFutureRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 现货黄金数据查询
- (void)testGoldSpotQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAGoldRequest goldSpotRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 全球货币汇率查询
// 人民币汇率数据查询
- (void)testExchangeRmbQuotQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAExchangeRequest exchangeRmbQuotRequestByBank:@"0"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 主要国家货币代码查询
- (void)testExchangeCurrencyQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAExchangeRequest exchangeCurrencyRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 根据货币代码查询汇率数据
- (void)testExchangeCodeQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAExchangeRequest exchangeCodeRequestByCode:@"CNYHKD"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 分页查询汇率实时数据
- (void)testExchangeQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAExchangeRequest exchangeByPage:1 size:50];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 全球股指查询
// 全球股指信息查询
- (void)testGlobalStockQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAGlobalStockRequest globalStockRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 全球股指明细查询
- (void)testGlobalStockDetailQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAGlobalStockRequest globalStockDetailRequestByCode:@"b_HSI" countryName:@"中国" continetType:@"asia"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        NSLog(@"%@,%@",response.error,response.responder);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 用户系统接口
// 用户注册
- (void)testUserRigisterRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 用户登录
- (void)testUserLoginRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功后登录
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                blockResponseObject = response.responder;
                blockError = response.error;
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 修改用户密码
- (void)testUserPasswordChangeRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功后修改密码
            MOBARequest *request = [MOBAUserCenterRequest userPasswordChangeRequestByUsername:self.userName oldPassword:@"123456" newPassword:@"654321" mode:@"1"];
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                blockResponseObject = response.responder;
                blockError = response.error;
                [expectation fulfill];
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 用户资料插入/更新
- (void)testUserProfilePutRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                //新用户登录成功
                if (!response.error)
                {
                    
                    NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    
                    NSString *token = dict[@"result"][@"token"];
                    NSString *uid = dict[@"result"][@"uid"];
                    
                    MOBARequest *request = [MOBAUserCenterRequest userProfilePutRequestByToken:token uid:uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
                    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                        blockResponseObject = response.responder;
                        blockError = response.error;
                        [expectation fulfill];
                    }];
                }
                
            }];
        }
    }];

    
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询用户资料
- (void)testUserProfileQueryRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                //新用户登录成功
                if (!response.error)
                {
                    NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSString *token = dict[@"result"][@"token"];
                    NSString *uid = dict[@"result"][@"uid"];
                    MOBARequest *request = [MOBAUserCenterRequest userProfilePutRequestByToken:token uid:uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
                    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                        //先插入数据再查询
                        if (!response.error) {
                            MOBARequest *request = [MOBAUserCenterRequest userProfileQueryRequestByUid:uid item:@"bW9iaWxl"];
                            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                                blockResponseObject = response.responder;
                                blockError = response.error;
                                [expectation fulfill];
                            }];
                        }
                    }];
                    
                }
                
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 删除用户资料项
- (void)testUserProfileDeleteRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                //新用户登录成功
                if (!response.error)
                {
                    NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSString *token = dict[@"result"][@"token"];
                    NSString *uid = dict[@"result"][@"uid"];
                    MOBARequest *request = [MOBAUserCenterRequest userProfilePutRequestByToken:token uid:uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
                    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                        //先插入数据再删除
                        if (!response.error) {
                            MOBARequest *request = [MOBAUserCenterRequest userProfileDeleteRequestByToken:token uid:uid item:@"bW9iaWxl"];
                            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                                blockResponseObject = response.responder;
                                blockError = response.error;
                                [expectation fulfill];
                            }];
                        }
                    }];
                    
                }
                
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 用户数据插入/更新
- (void)testUserDataPutRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                //新用户登录成功
                if (!response.error)
                {
                    
                    NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    
                    NSString *token = dict[@"result"][@"token"];
                    NSString *uid = dict[@"result"][@"uid"];
                    
                    MOBARequest *request = [MOBAUserCenterRequest userDataPutRequestByToken:token uid:uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
                    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                        blockResponseObject = response.responder;
                        blockError = response.error;
                        [expectation fulfill];
                    }];
                }
                
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 用户数据查询
- (void)testUserDataQueryRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                //新用户登录成功
                if (!response.error)
                {
                    NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSString *token = dict[@"result"][@"token"];
                    NSString *uid = dict[@"result"][@"uid"];
                    MOBARequest *request = [MOBAUserCenterRequest userDataPutRequestByToken:token uid:uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
                    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                        //先插入数据再查询
                        if (!response.error) {
                            MOBARequest *request = [MOBAUserCenterRequest userDataQueryRequestByToken:token uid:uid item:@"bW9iaWxl"];
                            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                                blockResponseObject = response.responder;
                                blockError = response.error;
                                [expectation fulfill];
                            }];
                        }
                    }];
                    
                }
                
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 用户数据删除项
- (void)testUserDataDeleteRequest{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    self.userName = [NSString stringWithFormat:@"mobTest_%@",[self six_randomString]];
    self.userEmail = [NSString stringWithFormat:@"%@@163.com",self.userName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userRigisterRequestByUsername:self.userName password:@"123456" email:self.userEmail];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        if (!response.error) {//新用户注册成功
            MOBARequest *request = [MOBAUserCenterRequest userLoginRequestByUsername:self.userName password:@"123456"];
            
            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                //新用户登录成功
                if (!response.error)
                {
                    NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSString *token = dict[@"result"][@"token"];
                    NSString *uid = dict[@"result"][@"uid"];
                    MOBARequest *request = [MOBAUserCenterRequest userDataPutRequestByToken:token uid:uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"];
                    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                        //先插入数据再删除
                        if (!response.error) {
                            MOBARequest *request = [MOBAUserCenterRequest userDataDeleteRequestByToken:token uid:uid item:@"bW9iaWxl"];
                            [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
                                blockResponseObject = response.responder;
                                blockError = response.error;
                                [expectation fulfill];
                            }];
                        }
                    }];
                    
                }
                
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 用户密码找回[获取随机码]
- (void)testUserPasswordRetrieveQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAUserCenterRequest userPasswordRetrieveRequestByUsername:@"mob_test"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 上海交易所白银数据
// 现货白银数据查询
- (void)testSilverSpotQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBASilverRequest silverSpotRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 期货白银数据
- (void)testSilverShfutureQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBASilverRequest silverShfutureRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 国内现货贵金属数据
// 国内交易所贵金属数据查询
- (void)testDomesticMetalQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBADomesticMetalRequest domesticSpotRequestByExchange:@"3"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 词库分词相关查询
// 词库分词相关查询
- (void)testWordAnalyzerCategoryQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAIKTokenRequest wordAnalyzerCategoryRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 根据不同的词库分词查询
- (void)testWordAnalyzerQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAIKTokenRequest wordAnalyzerRequestByType:@"common" text:@"6L-Z5piv5LiA5q615LyY576O6ICM5pyJ5peL5b6L55qE5LmQ5puy"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 火车票相关查询
// 车次查询
- (void)testTrainTicketsQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBATrainTicketsRequest trainTicketsQueryRequestByTrainno:@"G2"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 站站查询
- (void)testTrainTicketsByStationQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBATrainTicketsRequest trainTicketsQueryRequestByStationStart:@"北京" toEnd:@"上海"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 航班信息相关查询
// 查询所有城市机场三字码信息
- (void)testFlightCityQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAFlightRequest flightCityRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 根据航班号查询航班信息
- (void)testFlightNoQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAFlightRequest flightNoRequestByName:@"CZ8319"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 航线查询航班信息
- (void)testFlightLineQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAFlightRequest flightLineRequestByStart:@"上海" end:@"长沙"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 驾考题库相关查询
// 科目一题库列表查询
- (void)testSubjectOneListQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBATiKuRequest subjectOneListRequestByPage:1 size:10];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 科目四题库列表查询
- (void)testSubjectFourListQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBATiKuRequest subjectFourListRequestByPage:1 size:10];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 专项题库分类查询
- (void)testSpecialExamCategoryQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBATiKuRequest specialExamCategoryRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 专项练习题库查询
- (void)testSpecialPracticeExamQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBATiKuRequest specialPracticeExamRequestByPage:1 size:10 cid:@"207"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 汽车信息相关查询
// 查询所有汽车品牌
- (void)testCarBrandQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACarRequest carBrandRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 根据车系名称查询车型
- (void)testCarSeriesNameQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACarRequest carSeriesNameRequestByName:@"奥迪Q5"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询车型详细信息
- (void)testCarSeriesDetailQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACarRequest carSeriesDetailRequestByCid:@"1060133"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

#pragma mark 足球5大联赛信息相关查询
// 参数词典查询
- (void)testQueryParamQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAFootballLeagueRequest footballLeagueQueryParamRequest];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询某个轮次的比赛信息
- (void)testQueryMatchInfoQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAFootballLeagueRequest queryMatchInfoByLeagueTypeCn:@"德甲" season:@"2013" round:@"3"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

// 查询队伍的比赛信息
- (void)testQueryTeamMatchInfoQueryCall{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBAFootballLeagueRequest queryTeamMatchInfoByleagueTypeCn:@"德甲"
                                                                                 teamA:@"法兰克福"
                                                                                 teamB:@"沃尔夫斯堡"
                                                                                season:@"2015"
                                                                                 round:@"1"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
}

//车辆违章查询
- (void)testQueryCarViolationInfoCall
{
    __block id blockResponseObject = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    MOBARequest *request = [MOBACarViolationRequest queryCarViolationInfoByPlateNumber:@"苏FT218Y"
                                                                                         plateType:@"02"
                                                                                      engineNumber:@"M92654"
                                                                                          areaCode:@"ntg"];
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response) {
        blockResponseObject = response.responder;
        blockError = response.error;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssertNil(blockError,@"error: %@",blockError);
    XCTAssertNotNil(blockResponseObject);
    
}

@end
