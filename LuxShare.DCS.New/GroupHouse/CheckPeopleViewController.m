//
//  CheckPeopleViewController.m
//  LuxShare.DCS.New
//
//  Created by MingMing on 16/8/25.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "CheckPeopleViewController.h"
#import "Header.h"
@interface CheckPeopleViewController ()<UITextFieldDelegate>
{
    UILabel *lab;
    UITextField *tfCode;
    NSMutableArray *peoArr;
    NSMutableDictionary*dic;
    UIView*bigV;
    
}

@end

@implementation CheckPeopleViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"isOkk" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self returnView]];
    [self creatNav];
    
    peoArr = [[NSMutableArray alloc]init];
    dic = [[NSMutableDictionary alloc]init];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceive) name:@"isOkk" object:nil];
    
}
-(UIView*)returnView{
    if (bigV) {
        return bigV;
    }else{
        
        bigV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT)];
        bigV.backgroundColor = [UIColor whiteColor];
        
        NSString *str = @"工号/姓名:";
        CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[UIFONT fontWithDevice:14]],NSFontAttributeName, nil]];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(6, 36, size.width, 40)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = str;
        lable.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:14]];
        [bigV addSubview:lable];
        
        tfCode = [[UITextField alloc]init];
        tfCode.tag = 100;
        tfCode.borderStyle = UITextBorderStyleRoundedRect;
        tfCode.delegate = self;
        tfCode.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:12]];
        tfCode.placeholder = @"请输入工号或者姓名";
        [bigV addSubview:tfCode];
        
        tfCode.sd_layout
        .leftSpaceToView(lable,5)
        .topEqualToView(lable)
        .rightSpaceToView(bigV,10)
        .heightIs(40);
        
        UIButton *buttonCheck = [[UIButton alloc]init];
        [buttonCheck setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1]];
        [buttonCheck setTitle:@"查询" forState:UIControlStateNormal];
        [buttonCheck addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonCheck setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonCheck.layer.cornerRadius = 10;
        [bigV addSubview:buttonCheck];
        
        
        buttonCheck.sd_layout
        .leftSpaceToView(bigV,20)
        .topSpaceToView(lable,40)
        .rightSpaceToView(bigV,20)
        .heightIs(40);
        return bigV;
    }
}
-(void)didReceive{
   [SVProgressHUD dismiss];
}

//添加导航部分
-(void)creatNav{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    bigView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:bigView];
    
    lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(bigView.frame.size.width/2-70, 20, 150, 44);
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:14]];
    lab.text = @"查询人员信息";
    lab.textAlignment = NSTextAlignmentCenter;
    [bigView addSubview:lab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(3, 30, 30, 30);
    [button setImage:[UIImage imageNamed:@"coverpage_animation"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:13]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:button];
    
   
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击按钮查询
-(void)buttonClick{
    
    
    [peoArr removeAllObjects];
    [dic removeAllObjects];
    [tfCode resignFirstResponder];
    
    //判断如果输入框没有输入就点击查询
    if (tfCode.text.length!= 0) {
        NSString *newString = [tfCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
         [SVProgressHUD showWithStatus:@"努力加载中..."];
        
        // 判断输入的字符串中是否含有特殊字符 进行处理
        NSString *str1 =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
        NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str1];
        if (![emailTest evaluateWithObject:newString]) {
            [KPromptBox showKPromptBoxWithMassage:@"请检查是否输入正确"];
             [SVProgressHUD dismiss];
            return;
        }
        
        //判断输入的第一个字符是字母还是汉字 如果是汉字的话进行编码
        NSString *newCode = nil;
        unichar c = [newString characterAtIndex:0];
        if (c >=0x4E00 && c <=0x9FFF)
        {
            newCode = [newString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else
        {
            newCode = newString;
        }
        
        //手动查询人员
        
        [HttpRequest getPersonInfo:newCode completeWithData:^(PeopleM *people) {
            if (people == nil) {
               [KPromptBox showKPromptBoxWithMassage:@" 您所查询的人员不存在"];
                return ;
            }
            [peoArr addObject:people];
            [HttpRequest getPersonImage:people.EmpCode completeWithData:^(UIImage *imageData) {
                [dic setObject:imageData forKey:people.EmpCode];
                if (peoArr.count == 1) {
                    SiglePeopleViewController *person = [[SiglePeopleViewController alloc]init];
                    person.people = people;
                    person.imgPic = imageData;
                     [SVProgressHUD dismiss];
                    [self presentViewController:person animated:YES completion:^{
                        tfCode.text = @"";
                        
                    }];
                    
                }else{
                    MorePeopleViewController*more = [[MorePeopleViewController alloc]init];
                    more.peopleArr = peoArr;
                    more.imagArr = dic;
                     [SVProgressHUD dismiss];
                    [self presentViewController:more animated:YES completion:^{
                        tfCode.text = @"";
                        
                    }];
                    
                }
                
            }];
            
        }];
        
        
    }else{
        KalertLogin(@"请先输入 在查询哦!");
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
// 返回上个页面
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
