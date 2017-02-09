//
//  DoorCheckViewController.m
//  LuxShare.DCS.New
//
//  Created by MingMing on 16/8/25.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "DoorCheckViewController.h"
#import "Header.h"
@interface DoorCheckViewController ()  <UITextFieldDelegate>
{
    UILabel *lab;
    UIImage*image;
    UIView*view;
    NSMutableArray *peoArr;
    NSMutableDictionary*dic;
   
   
}

@end

@implementation DoorCheckViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kPublic;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNav];
    lab.text = _titleText;
     peoArr = [[NSMutableArray alloc]init];
     dic = [[NSMutableDictionary alloc]init];
}

-(void)show{
    if (view) {
        view.hidden = NO;
        [self.view addSubview:view];
    }else{
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 20+SCREENHEIGHT/10, SCREENWIDTH, SCREENHEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.3;
        [self.view addSubview:view];
        
    }
    [view bringSubviewToFront:self.view];
}
-(void)hidden{
    view.hidden = YES;
}

//添加导航部分
-(void)creatNav{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT/10);
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
    button.frame = CGRectMake(0, 0, lab.bounds.size.height/2, lab.bounds.size.height);
    [button setImage:[UIImage imageNamed:@"coverpage_animation"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lab addSubview:button];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(6,SCREENHEIGHT/10+20+50, SCREENWIDTH/6, SCREENHEIGHT/10)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:20]];
    [self.view addSubview:lable];
    
    UITextField *tfCode = [[UITextField alloc]init];
    tfCode.tag = 100;
    tfCode.delegate = self;
    tfCode.borderStyle = UITextBorderStyleRoundedRect;
    tfCode.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:20]];
    [self.view addSubview:tfCode];
    
    tfCode.sd_layout
    .leftSpaceToView(lable,5)
    .topSpaceToView(self.view,50+SCREENHEIGHT/10+20)
    .rightSpaceToView(self.view,10)
    .heightIs(SCREENHEIGHT/10);
    
    UIButton *buttonCheck = [[UIButton alloc]init];
    [buttonCheck setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1]];
    [buttonCheck setTitle:@"查询" forState:UIControlStateNormal];
    [buttonCheck addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonCheck setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonCheck.titleLabel.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:20]];
    buttonCheck.layer.cornerRadius = 10;
    [self.view addSubview:buttonCheck];
    
    
    buttonCheck.sd_layout
    .leftSpaceToView(self.view,20)
    .topSpaceToView(lable,100)
    .rightSpaceToView(self.view,20)
    .heightIs(SCREENHEIGHT/11);
    
    
    
    UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSure.layer.cornerRadius = 10;
    [buttonSure setTitle:@"确认选择" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonSure.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:209.0/255.0 blue:44.0/255.0 alpha:1];
    [buttonSure addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSure];
    
    buttonSure.sd_layout
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .heightIs(30)
    .bottomSpaceToView(self.view,10);
    
    //判断进入的是哪个页面
    if (_number == 11) { //进入的是查询人员
        buttonSure.hidden = YES;
        
        buttonCheck.hidden = NO;
        lable.hidden = NO;
        tfCode.hidden = NO;
        lable.text = @"工 号:";
        lable.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:20]];
        tfCode.placeholder = @"请输入工号";
    }else if (_number == 13){ //进入的是查询资产
        buttonSure.hidden = YES;
        buttonCheck.hidden = NO;
        lable.hidden = NO;
        tfCode.hidden = NO;
        lable.text = @"编 号:";
        lable.numberOfLines = 0;
        lable.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:20]];
        tfCode.placeholder = @"请输入资产编号";

    }else{
        
        buttonCheck.hidden = YES;
        lable.hidden = YES;
        tfCode.hidden = YES;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)sureBtnClick{
    
}


//判断进入的是哪个页面
-(void)buttonClick{
    [peoArr removeAllObjects];
    [dic removeAllObjects];
   
    DoorCheckViewController*door = self;
    
    UITextField *tfCode = (UITextField*)[self.view viewWithTag:100];
    [tfCode resignFirstResponder];
    
    if (tfCode.text.length != 0) {
        NSString *newString = [tfCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // 判断输入的字符串中是否含有特殊字符 进行处理
        NSString *str1 =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
        NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str1];
        if (![emailTest evaluateWithObject:newString]) {
            [KPromptBox showKPromptBoxWithMassage:@"请检查是否输入正确"];
            [SVProgressHUD dismiss];
            return;
        }
       
        [SVProgressHUD showWithStatus:@"正在查询..."];
        [self show];
        if (_number == 11) { //手动查询人员
            
            [HttpRequest getPersonInfo:newString completeWithData:^(PeopleM *people) {
                if (people == nil) {
                    [SVProgressHUD dismiss];
                    [door hidden];
                    return ;
                }
                [peoArr addObject:people];
                [HttpRequest getPersonImage:people.EmpCode completeWithData:^(UIImage *imageData) {
                    if (imageData == nil) {
                        [SVProgressHUD dismiss];
                        [door hidden];
                        return ;
                    }else{
                    [dic setObject:imageData forKey:people.EmpCode];
                    if (peoArr.count == 1) {
                        
                        [SVProgressHUD dismiss];
                        [door hidden];
                        SiglePeopleViewController *person = [[SiglePeopleViewController alloc]init];
                        person.people = people;
                        person.imgPic = imageData;
                        [self presentViewController:person animated:YES completion:nil];
                    }
                 }
                }];
                
            }];
        }else if(_number == 13){ //手动查询资产
           
            NSMutableArray *thArr = [[NSMutableArray alloc]initWithCapacity:0];
            [HttpRequest getThingsInfo:newString completeWithData:^(ThingsModel *thing) {
                [SVProgressHUD dismiss];
                [door hidden];
                if (thing == nil) {
                    return ;
                }
               
                [thArr addObject:thing];
                ThingViewController *things = [[ThingViewController alloc]init];
                things.model = thing;
                things.bigArr = thArr;
                
                [self presentViewController:things animated:YES completion:^{
                    tfCode.text = @"";
                    
                }];
                
            }];
            
        }else{
            
        }
    }else{
        KalertLogin(@"请先输入 在查询哦!");
    }
    
}

// 判断进来的时候是从哪进来的 出去的时候以什么方式出去
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
