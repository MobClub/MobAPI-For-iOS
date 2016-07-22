//
//  ViewController.m
//  MOBApiCloudDemo
//
//  Created by liyc on 15/11/10.
//  Copyright © 2015年 mob. All rights reserved.
//

#import "ViewController.h"
#import "LogViewController.h"

#import <MobAPI/MobAPI.h>
#import <MOBFoundation/MOBFoundation.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *apiTableView;
@property (nonatomic, strong) NSString *selectedTitle;

/**
 *  section 显示的 Api 分类标题
 */
@property (nonatomic, strong) NSArray *sectionTitlesArray;
/**
 *  cell 显示的 Api 分类接口标题
 */
@property (nonatomic, strong) NSArray *cellTitlesArray;

/**
 *  用户系统接口，登录之后使用的 token
 */
@property (nonatomic, strong) NSString *token;

/**
 *  用户系统接口，登录之后使用的 uid
 */
@property (nonatomic, strong) NSString *uid;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews
{
    if ([MOBFDevice versionCompare:@"7.0"] >= 0)
    {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"MobApi 示例";
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    versionLabel.textColor = [UIColor redColor];
    versionLabel.font = [UIFont systemFontOfSize:15.0f];
    
    // 获取 MobApi 版本号
    versionLabel.text = [MobAPI getMobApiVersion];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:versionLabel];
    
    // 获取在 TableView 上展示的数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MobApiCategory" ofType:@"plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.sectionTitlesArray = [[plistDict objectForKey:@"ApiCategory"] objectForKey:@"SectionTitlesArray"];
    self.cellTitlesArray = [[plistDict objectForKey:@"ApiCategory"] objectForKey:@"CellTitlesArray"];
    
    self.apiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49) style:UITableViewStyleGrouped];
    [self.apiTableView setDelegate:self];
    [self.apiTableView setDataSource:self];
    [self.view addSubview:self.apiTableView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.apiTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Private
- (void)waitLoading:(BOOL)flag
{
    static UIView *loadingView = nil;
    if (!loadingView)
    {
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView sizeToFit];
        indicatorView.frame = CGRectMake((loadingView.frame.size.width - indicatorView.frame.size.width) / 2, (loadingView.frame.size.height - indicatorView.frame.size.height) / 2, indicatorView.frame.size.width, indicatorView.frame.size.height);
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        [indicatorView startAnimating];
        [loadingView addSubview:indicatorView];
        
        [self.view addSubview:loadingView];
    }
    
    loadingView.hidden = !flag;
}

- (void)showLog:(NSString *)log
{
    [self waitLoading:NO];
    
    LogViewController *vc = [[LogViewController alloc] init];
    vc.naviTitle = self.selectedTitle;
    [vc setLog:log];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  Api 返回信息处理
 *
 *  @param response
 */
- (void)resultWithResponse:(MOBAResponse *)response
{
    NSString *logContent = nil;
    if (response.error)
    {
        logContent = [NSString stringWithFormat:@"request error!\n%@", response.error];
        NSLog(@"%@", logContent);
    }
    else
    {
        if ([response.responder isKindOfClass:[NSString class]])
        {
            logContent = response.responder;
        }
        else
        {
            logContent = [NSString stringWithFormat:@"request success!\n%@", [MOBFJson jsonStringFromObject:response.responder]];
        }
        NSLog(@"%@", logContent);
    }
    
    [self showLog:logContent];
}

#pragma mark - UITableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitlesArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitlesArray[section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount = [self.cellTitlesArray[section] count];
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierStr = @"apiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    // 设置每个 section下面对应cell 的标题
    cell.textLabel.text = self.cellTitlesArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedTitle = self.cellTitlesArray[indexPath.section][indexPath.row];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [self apiQueryCall];
            }else if (indexPath.row == 1)
            {
                [self customInterfaceCall];
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                [self queryPhoneNumberOwnership];
            }
            break;
        }
        case 2:
        {
            if (indexPath.row == 0) {
                [self getCookCategoryList];
            }else if(indexPath.row == 1){
                [self searchCookInfo];
            }else if(indexPath.row == 2)
            {
                [self getCookDetailInfo];
            }
            break;
        }
        case 3:
        {
            if (indexPath.row == 0) {
                [self getPostcodeAddress];
            }else if(indexPath.row == 1){
                [self getPCDList];
            }else if(indexPath.row == 2)
            {
                [self searchPostcode];
            }
            break;
        }
        case 4:
        {
            if (indexPath.row == 0)
            {
                [self searchWeather];
            }else if(indexPath.row == 1)
            {
                [self getCityList];
            }else if(indexPath.row == 2)
            {
                [self searchWeatherByIP];
            }
            break;
        }
        case 5:
        {
            if (indexPath.row == 0)
            {
                [self idcardQueryCall];
            }
            break;
        }
        case 6:
        {
            if (indexPath.row == 0)
            {
                [self stationQueryCall];
            }
            break;
        }
        case 7:
        {
            if (indexPath.row == 0)
            {
                [self environmentQueryCall];
            }
            break;
        }
        case 8:
        {
            if (indexPath.row == 0)
            {
                [self ipQueryCall];
            }
            break;
        }
        case 9:
        {
            if (indexPath.row == 0)
            {
                [self kvPutCall];
            }else if (indexPath.row == 1)
            {
                [self kvGetCall];
            }
            break;
        }
        case 10:
            [self calendarQueryCall];
            break;
        case 11:
            [self mobileLuckyQueryCall];
            break;
        case 12:
            [self bankCardQueryCall];
            break;
        case 13:
            [self laohuangliQueryCall];
            break;
        case 14:
            [self healthQueryCall];
            break;
        case 15:
            [self marriageQueryCall];
            break;
        case 16:
            [self historyQueryCall];
            break;
        case 17:
            [self dreamQueryCall];
            break;
        case 18:
            [self idiomQueryCall];
            break;
        case 19:
            [self dictionaryQueryCall];
            break;
        case 20:
            [self horoScopeQueryCall];
            break;
        case 21:
            [self provinceoilQueryCall];
            break;
        case 22:
            [self lotteryQueryCall];
            break;
        case 23:
            
            if (indexPath.row == 0)
            {
                [self wxarticleCategoryQueryCall];
            }else if (indexPath.row == 1)
            {
                [self wxarticleListQueryCall];
            }
            break;
            
        case 24:
            if (indexPath.row == 0)
            {
                [self boxofficeDayQueryCall];
            }else if (indexPath.row == 1)
            {
                [self boxofficeWeekQueryCall];
            }
            else
            {
                [self boxofficeWeekEndQueryCall];
            }
            break;
        case 25:
            if (indexPath.row == 0)
            {
                [self goldFutureQueryCall];
            }else if (indexPath.row == 1)
            {
                [self goldSpotQueryCall];
            }
            break;
        case 26:
            if (indexPath.row == 0)
            {
                [self exchangeRmbQuotQueryCall];
            }else if (indexPath.row == 1)
            {
                [self exchangeCurrencyQueryCall];
            }
            else if (indexPath.row == 2)
            {
                [self exchangeCodeQueryCall];
            }else
            {
                [self exchangeQueryCall];
            }
            break;
        case 27: // 全球股指查询
            if (indexPath.row == 0) {
                [self globalStockQueryCall];
            }
            else
            {
                [self globalStockDetailQueryCall];
            }
            break;
        case 28:// 用户系统相关请求
            if (indexPath.row == 0)
            {
                [self userRigisterRequest];
            }
            else if (indexPath.row == 1)
            {
                [self userLoginRequest];
            }
            else if (indexPath.row == 2)
            {
                [self userPasswordChangeRequest];
            }
            else if (indexPath.row == 3)
            {
                [self userProfilePutRequest];
            }
            else if (indexPath.row == 4)
            {
                [self userProfileQueryRequest];
            }
            else if (indexPath.row == 5)
            {
                [self userProfileDeleteRequest];
            }
            else if (indexPath.row == 6)
            {
                [self userDataPutRequest];
            }
            else if (indexPath.row == 7)
            {
                [self userDataQueryRequest];
            }
            else if (indexPath.row == 8)
            {
                [self userDataDeleteRequest];
            }
            break;
        case 29: // 上海交易所白银数据相关请求
            if (indexPath.row == 0) {
                [self silverSpotQueryCall];
            }
            else if (indexPath.row == 1)
            {
                [self silverShfutureQueryCall];
            }
            break;
        case 30: // 国内现货贵金属数据
            if (indexPath.row == 0) {
                [self domesticMetalQueryCall];
            }
            break;
            
        case 31: // 词库分词相关查询
            if (indexPath.row == 0) {
                [self wordAnalyzerCategoryQueryCall];
            }
            else if (indexPath.row == 1)
            {
                [self wordAnalyzerQueryCall];
            }
            break;
            
        case 32: // 火车票相关查询
            if (indexPath.row == 0) {
                [self trainTicketsQueryCall];
            }
            else if (indexPath.row == 1)
            {
                [self trainTicketsByStationQueryCall];
            }
            break;
            
        case 33: //航班信息相关查询
            if (indexPath.row == 0) {
                [self flightCityQueryCall];
            }
            else if (indexPath.row == 1)
            {
                [self flightNoQueryCall];
            }
            else if (indexPath.row == 2)
            {
                [self flightLineQueryCall];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -  MobApi 接口调用示例
#pragma mark api 查询接口
- (void)apiQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI apiQueryWithResult:^(MOBAResponse *response) {
        
        [self resultWithResponse:response];
        
    }];
}


#pragma mark 自定义请求接口
- (void)customInterfaceCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequestWithInterface:@"/v1/weather/query"
                               param:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"广州", @"city",
                                      @"", @"province",
                                      nil]
                            onResult:^(MOBAResponse *response) {
                                
                                [self resultWithResponse:response];
                                
                            }];
}


#pragma mark 查询手机号码归属地
- (void)queryPhoneNumberOwnership
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAPhoneRequest addressRequestByPhone:@"13333333333"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 获取菜谱分类
- (void)getCookCategoryList
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBACookRequest categoryRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
                   
               }];
}


#pragma mark 查询菜谱信息
- (void)searchCookInfo
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBACookRequest searchMenuRequestByCid:nil name:nil page:0 size:0]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 查询菜谱详情信息
- (void)getCookDetailInfo
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBACookRequest infoDetailRequestById:@"00100010560000040337"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
                   
               }];
}


#pragma mark 获取邮编所属地址
- (void)getPostcodeAddress
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAPostcodeRequest addressRequestByCode:@"102629"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
                   
               }];
}


#pragma mark 获取省市区域列表

- (void)getPCDList
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAPostcodeRequest pcdListRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 查询邮政编码

- (void)searchPostcode
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAPostcodeRequest searchRequestByPid:@"40" cid:@"4001" did:nil word:@"安康"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 查询天气

- (void)searchWeather
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAWeatherRequest searchRequestByCity:@"通州" province:@"北京"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 获取城市列表，该接口返回数据供查询天气时使用。

- (void)getCityList
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAWeatherRequest citiesRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 根据ip地址查询天气

- (void)searchWeatherByIP
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAWeatherRequest searchRequestByIP:@"222.73.199.3" province:nil]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 身份证信息查询接口

- (void)idcardQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAIdRequest idcardRequestByCardno:@"45102519800411512X"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 查询手机基站信息

- (void)stationQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAStationRequest stationRequestBylac:@"34860" cell:@"62041" mcc:@"460" mnc:@"0"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 空气质量查询

- (void)environmentQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAEnvironmentRequest environmentRequestByCity:@"通州" province:@"北京"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark ip库查询

- (void)ipQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAIpRequest addressRequestForIp:@"222.73.199.34"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark k-v存储

- (void)kvPutCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAKvRequest kvPutRequest:@"mobile" key:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}



#pragma mark k-v查询调用

- (void)kvGetCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAKvRequest kvGetRequest:@"mobile" key:@"bW9iaWxl"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 万年历查询

- (void)calendarQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBACalendarRequest calendarRequestWithDate:@"2015-05-01"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 手机号码查吉凶

- (void)mobileLuckyQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAMobileLuckyRequest mobileLuckyRequestByMobile:@"18521525252"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 银行卡信息查询

- (void)bankCardQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBABankCardRequest bankCardRequestWithCard:@"6228482898203884775"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 老黄历查询

- (void)laohuangliQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBALaohuangliRequest laohuangliRequestWithDate:@"2015-05-01"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 健康知识查询

- (void)healthQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAHealthRequest healthRequestWithKeyword:@"手" page:nil size:nil]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 算婚姻

- (void)marriageQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAMarriageRequest marriageRequestWithManDate:@"1987-4-26" manHour:@"10" womanDate:@"1992-03-18" womanHour:@"11"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 历史上的今天

- (void)historyQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAHistoryRequest historyRequestWithDay:@"1231"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 周公解梦

- (void)dreamQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBADreamRequest dreamRequestWithKeyword:@"鱼" page:nil size:nil]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 成语查询

- (void)idiomQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAIdiomRequest idiomRequestWithName:@"狐假虎威"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark  新华字典查询

- (void)dictionaryQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBADictionaryRequest dictionaryRequestWithName:@"赵"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 八字算命

- (void)horoScopeQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAHoroScopeRequest horoScopeRequestWithDate:@"2016-01-19" hour:@"20"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 今日各省油价查询

- (void)provinceoilQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAProvinceoilRequest provinceoilRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
    
}


#pragma mark 查询彩票开奖结果

- (void)lotteryQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBALotteryRequest lotteryRequestByName:@"大乐透" period:@"16025"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 微信精选分类查询

- (void)wxarticleCategoryQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAWxArticleRequest wxarticleCategoryRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
    
}


#pragma mark 微信精选列表查询

- (void)wxarticleListQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAWxArticleRequest wxarticleListRequestByCID:@"1" page:5 size:20]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
    
}


#pragma mark 实时票房查询

- (void)boxofficeDayQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBABoxOfficeRequest boxofficeDayRequestByArea:@"CN"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 周票房查询

- (void)boxofficeWeekQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBABoxOfficeRequest boxofficeWeekRequestByArea:@"CN"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 周末票房查询

- (void)boxofficeWeekEndQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBABoxOfficeRequest boxofficeWeekEndRequestByArea:@"CN"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 期货黄金数据查询

- (void)goldFutureQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAGoldRequest goldFutureRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 现货黄金数据查询

- (void)goldSpotQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAGoldRequest goldSpotRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 人民币汇率数据查询

- (void)exchangeRmbQuotQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAExchangeRequest exchangeRmbQuotRequestByBank:@"0"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 主要国家货币代码查询

- (void)exchangeCurrencyQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAExchangeRequest exchangeCurrencyRequest]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 根据货币代码查询汇率数据

- (void)exchangeCodeQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAExchangeRequest exchangeCodeRequestByCode:@"CNYHKD"]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}


#pragma mark 分页查询汇率实时数据

- (void)exchangeQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAExchangeRequest exchangeByPage:1 size:50]
               onResult:^(MOBAResponse *response) {
                   
                   [self resultWithResponse:response];
                   
               }];
}

#pragma mark 全球股指信息查询
- (void)globalStockQueryCall
{
    [self waitLoading:YES];
    
    [MobAPI sendRequest:[MOBAGlobalStockRequest globalStockRequest] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
    
}

#pragma mark 全球股指明细查询
- (void)globalStockDetailQueryCall
{
    [MobAPI sendRequest:[MOBAGlobalStockRequest globalStockDetailRequestByCode:@"b_HSI" countryName:@"中国" continetType:@"asia"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
    
}

#pragma mark 用户注册
- (void)userRigisterRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userRigisterRequestByUsername:@"mob_test" password:@"123456"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 用户登录
- (void)userLoginRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userLoginRequestByUsername:@"mob_test" password:@"123456"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
                   
                   if (!response.error)
                   {
                       
                       NSData *data = [MOBFJson jsonDataFromObject:response.responder];
                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                       /**
                        *  获取登录之后的 token
                        */
                       self.token = [dict objectForKey:@"token"];
                       /**
                        *  获取登录之后的 uid
                        */
                       self.uid = [dict objectForKey:@"uid"];
                   }
                   
               }];
}

#pragma mark 修改用户密码
- (void)userPasswordChangeRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userPasswordChangeRequestByUsername:@"mob_test" oldPassword:@"654321" newPassword:@"123456"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 用户资料插入/更新
- (void)userProfilePutRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userProfilePutRequestByToken:self.token uid:self.uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 查询用户资料
- (void)userProfileQueryRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userProfileQueryRequestByUid:self.uid item:@"bW9iaWxl"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 删除用户资料项
- (void)userProfileDeleteRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userProfileDeleteRequestByToken:self.token uid:self.uid item:@"bW9iaWxl"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 用户数据插入/更新
- (void)userDataPutRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userDataPutRequestByToken:self.token uid:self.uid item:@"bW9iaWxl" value:@"e21vYmlsZTE6IjE0NzgyODY3MjM4In0"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 用户数据查询
- (void)userDataQueryRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userDataQueryRequestByToken:self.token uid:self.uid item:@"bW9iaWxl"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
}

#pragma mark 用户数据删除项
- (void)userDataDeleteRequest
{
    [MobAPI sendRequest:[MOBAUserCenter userDataDeleteRequestByToken:self.token uid:self.uid item:@"bW9iaWxl"]
               onResult:^(MOBAResponse *response) {
                   [self resultWithResponse:response];
               }];
    
}

#pragma mark 现货白银数据查询
- (void)silverSpotQueryCall
{
    [MobAPI sendRequest:[MOBASilverRequest silverSpotRequest] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

#pragma mark 期货白银数据
- (void)silverShfutureQueryCall
{
    [MobAPI sendRequest:[MOBASilverRequest silverShfutureRequest] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

#pragma mark 国内交易所贵金属数据
- (void)domesticMetalQueryCall
{
    [MobAPI sendRequest:[MOBADomesticMetalRequest domesticSpotRequestByExchange:@"3"] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

#pragma mark 词库分词相关查询
- (void)wordAnalyzerCategoryQueryCall
{
    [MobAPI sendRequest:[MOBAIKTokenRequest wordAnalyzerCategoryRequest] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

- (void)wordAnalyzerQueryCall
{
    [MobAPI sendRequest:[MOBAIKTokenRequest wordAnalyzerRequestByType:@"common" text:@"6L-Z5piv5LiA5q615LyY576O6ICM5pyJ5peL5b6L55qE5LmQ5puy"] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

#pragma mark 火车票相关查询
- (void)trainTicketsQueryCall
{
    [MobAPI sendRequest:[MOBATrainTicketsRequest trainTicketsQueryRequestByTrainno:@"G2"] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

- (void)trainTicketsByStationQueryCall
{
    [MobAPI sendRequest:[MOBATrainTicketsRequest trainTicketsQueryRequestByStationStart:@"北京" toEnd:@"上海"] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

#pragma mark 航班信息相关查询
- (void)flightCityQueryCall
{
    [MobAPI sendRequest:[MOBAFlightRequest flightCityRequest] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

- (void)flightNoQueryCall
{
    [MobAPI sendRequest:[MOBAFlightRequest flightNoRequestByName:@"CZ8319"] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}

- (void)flightLineQueryCall
{
    [MobAPI sendRequest:[MOBAFlightRequest flightLineRequestByStart:@"上海" end:@"长沙"] onResult:^(MOBAResponse *response) {
        [self resultWithResponse:response];
    }];
}


@end
