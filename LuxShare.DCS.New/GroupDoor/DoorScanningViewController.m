//
//  DoorScanningViewController.m
//  LuxShare.DCS.New
//
//  Created by MingMing on 16/8/25.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "DoorScanningViewController.h"
#import "Header.h"
@interface DoorScanningViewController ()<ZBarReaderViewDelegate>
{
    ZBarCameraSimulator *cameraSim;
    NSString *data;
    UILabel*lab;
    NSMutableArray *peoArr;
    NSMutableDictionary*dic;
    
    
}
@end

@implementation DoorScanningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    kPublic;
    [self creatNav];
    [self setScanView];
    lab.text = _titleText;
    
    peoArr = [[NSMutableArray alloc]init];
    dic = [[NSMutableDictionary alloc]init];
    
 }

//添加导航部分
-(void)creatNav{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 20, self.view.frame.size.width, SCREENHEIGHT/10);
    bigView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:bigView];
    
    lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/10);
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:24]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.userInteractionEnabled = YES;
    [bigView addSubview:lab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, bigView.bounds.size.height/2, bigView.bounds.size.height);
    [button setImage:[UIImage imageNamed:@"coverpage_animation"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lab addSubview:button];
    
    UILabel *labText = [[UILabel alloc]init];
    labText.text = @"将条码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别";
    labText.textColor = [UIColor blackColor];
    labText.textAlignment = NSTextAlignmentLeft;
    labText.font = [UIFont systemFontOfSize:self.view.frame.size.width/34];
    [self.view addSubview:labText];
    
    labText.sd_layout
    .leftSpaceToView(self.view,10)
    .topSpaceToView(self.view,20+SCREENHEIGHT/10)
    .heightIs(30)
    .widthIs(SCREENWIDTH);
}
//二维码的扫描区域
- (void)setScanView
{
    ZBarReaderView *readerView = [[ZBarReaderView alloc]init];
    readerView.frame = CGRectMake(10, 50+SCREENHEIGHT/10, SCREENWIDTH-20, SCREENHEIGHT-60-SCREENHEIGHT/10);
    readerView.readerDelegate = self;
    [self.view addSubview:readerView];
    
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
    [readerView start];
    
    
}
//实现代理方法 进行读取二维码的内容
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    
    [peoArr removeAllObjects];
    [dic removeAllObjects];
    
    for(ZBarSymbol *sym in symbols) {
        
        NSString *code = sym.data;
        NSLog(@"---------%@",code);
        //在这解析 获取信息之后 将model传入下一个展示页面 判断进入那个页面
        if (code != nil) {
            
        if (_viewNumber == 10) { //查询人员页面
            if (code.length >7) {
                 [KPromptBox showKPromptBoxWithMassage:@"请扫描你的厂牌"];
            }else{
                
                [HttpRequest getPersonInfo:code completeWithData:^(PeopleM *people) {
                    if (people == nil) {
                        [SVProgressHUD dismiss];
                        return ;
                    }
                    [peoArr addObject:people];
                    [HttpRequest getPersonImage:people.EmpCode completeWithData:^(UIImage *imageData) {
                        if (imageData == nil) {
                            [SVProgressHUD dismiss];
                            return ;
                        }else{
                        [dic setObject:imageData forKey:people.EmpCode];
                        if (peoArr.count == 1) {
                            [SVProgressHUD dismiss];
                            
                            SiglePeopleViewController *person = [[SiglePeopleViewController alloc]init];
                            person.people = people;
                            person.imgPic = imageData;
                            [self presentViewController:person animated:YES completion:nil];
                          }
                        }
                    }];
                    
                }];

                
            
            }
        }else if (_viewNumber == 12){ //查询资产页面
            
            NSString *coded = [code substringFromIndex:5];
            NSMutableArray *t = [[NSMutableArray alloc]initWithCapacity:0];
            [HttpRequest getThingsInfo:coded completeWithData:^(ThingsModel *thing) {
                if (thing == nil) {
                    return ;
                }else{
                ThingViewController *things = [[ThingViewController alloc]init];
                 things.model = thing;
                [t addObject:thing];
                things.bigArr = t;
                
                [self presentViewController:things animated:YES completion:nil];
                }
            }];
            
        }else if (_viewNumber == 14){ //厂商进入页面
            NSDateFormatter *form = [[NSDateFormatter alloc]init];
            [form setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *date = [form stringFromDate:[NSDate date]];
            
            
            NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];
            
            
            [HttpRequest getPeopelInto:code code:[[NSUserDefaults standardUserDefaults] objectForKey:@"tfName"] Company:@"" completeWithData:^(ChangShang *chang) {
                
                
                NSDate *dat = [formatter dateFromString:chang.PlanOutTime];
                
                if ([[NSDate date]compare:dat] == NSOrderedDescending) {
                    KalertLogin(@"送货证已过期,如有需要请重新办理,谢谢您的配合");
                    return ;
                }else{
                    
                    GongYingShangViewController*changa = [[GongYingShangViewController alloc]init];
                    changa.changShang = chang;
                    changa.time = date;
                    [self.navigationController pushViewController:changa animated:YES];
                }
            }];
            
            
        }else{ //厂商离开页面
            
            NSDateFormatter *form = [[NSDateFormatter alloc]init];
            [form setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *date1 = [form stringFromDate:[NSDate date]];
            [HttpRequest getPeopelOut:code code:[[NSUserDefaults standardUserDefaults] objectForKey:@"tfName"] Company:@"" completeWithData:^(ChangShang *chang) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:chang.CallerCorpName message:[NSString stringWithFormat:@"姓名：%@  编号：%@     出厂时间：%@",chang.CallerName,chang.Id,date1] preferredStyle:UIAlertControllerStyleAlert];UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {return ;}];[alert addAction:sure];[self presentViewController:alert animated:YES completion:nil];
                
            }];
            
        }
    }else{
            
        }
        break;
    }
    
}

//回到主页面
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
