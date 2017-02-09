//
//  GongYingShangViewController.m
//  Luxshare.DCS
//
//  Created by MingMing on 16/8/10.
//  Copyright © 2016年 DCS. All rights reserved.
//

#import "GongYingShangViewController.h"

@interface GongYingShangViewController ()
{
    NSMutableArray *rightArr;
}
@end

@implementation GongYingShangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kPublic;
    [self creatNav];
    rightArr = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",_changShang.Id],_changShang.CallerName, _changShang.CallerCorpName, _changShang.PlanOutTime,_time,nil];
    [self creatInfoView];

}
//添加导航条
-(void)creatNav{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 20,SCREENWIDTH, SCREENHEIGHT/10);
    bigView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:bigView];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/10);
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:24]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.userInteractionEnabled = YES;
    lab.text = @"供应商信息";
    [bigView addSubview:lab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, lab.bounds.size.height/2, lab.bounds.size.height);
    [button setImage:[UIImage imageNamed:@"coverpage_animation"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lab addSubview:button];
    
   }
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatInfoView{
    NSArray *leftArr = [[NSArray alloc]initWithObjects:@"客户编号:",@"客户姓名:", @"客户公司名称:", @"送货证有效期:", @"系统扫描时间:",  nil];
   
    for (int i = 0; i<5; i++) {
        CGSize size = [leftArr[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[UIFONT fontWithDevice:17]],NSFontAttributeName, nil]];

        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.text = leftArr[i];
        labLeft.font = [UIFont boldSystemFontOfSize:[UIFONT fontWithDevice:17]];
        [self.view addSubview:labLeft];
        labLeft.sd_layout
        .leftSpaceToView(self.view,20)
        .widthIs(size.width+5)
        .heightIs(35)
        .topSpaceToView(self.view,SCREENHEIGHT/10+50+(i%5)*(70+SCREENHEIGHT/10-60));
        
        
        UILabel *labRight = [[UILabel alloc]init];
        labRight.numberOfLines = 0;
        labRight.text = rightArr[i];
        labRight.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:17]];
        [self.view addSubview:labRight];
        labRight.sd_layout
        .leftEqualToView(labLeft)
        .widthIs(self.view.frame.size.width-10)
        .autoHeightRatio(0)
        .topSpaceToView(labLeft,0);

        
    }
}
















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
