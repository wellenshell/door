//
//  SureCodeViewController.m
//  Luxshare.DCS
//
//  Created by MingMing on 16/7/19.
//  Copyright © 2016年 DCS. All rights reserved.
//

#import "SureCodeViewController.h"
#import "Header.h"
@interface SureCodeViewController ()<ZBarReaderViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    ZBarCameraSimulator *cameraSim;
    NSString *data;
    UITableView *tab;
    NSMutableArray *infoArr;
    NSMutableArray *sm;
    
}
@end

@implementation SureCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kPublic;
    [self creatNav];
    [self setScanView];
    
    sm = [[NSMutableArray alloc]initWithCapacity:0];
    infoArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self creatViewShow];
  
   
}
//添加导航部分
-(void)creatNav{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT/10);
    bigView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:bigView];
    
    UILabel* lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/10);
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:24]];
    lab.text = @"送离人员扫描";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.userInteractionEnabled= YES;
    [bigView addSubview:lab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, lab.bounds.size.height/2, lab.bounds.size.height);
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
    .widthIs(self.view.frame.size.width);
}
//二维码的扫描区域
- (void)setScanView
{
    ZBarReaderView *readerView = [[ZBarReaderView alloc]init];
    readerView.frame = CGRectMake(10, 50+SCREENHEIGHT/10, SCREENWIDTH-20, SCREENHEIGHT-50-SCREENHEIGHT/10-10);
    readerView.readerDelegate = self;
    [self.view addSubview:readerView];
    
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
    
    [readerView start];
    
    
}
-(void)backBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//实现代理方法 进行读取二维码的内容
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    
    for(ZBarSymbol *sym in symbols) {
        //如果扫描出来东西 就进行提示并跳转到展示页面
        if (sym.data != nil) {
            [infoArr removeAllObjects];
            [HttpRequest getleaveInfo:sym.data ids:_idsArrr completeWithData:^(NSMutableArray *ar) {
                
                [infoArr addObjectsFromArray:ar];
                [tab reloadData];
                [UIView animateWithDuration:1 animations:^{
                    tab.frame = CGRectMake(20,SCREENHEIGHT/5, tab.frame.size.width, 250);
                }];

            }];
            
        }
        
        break;
    }
    
}



-(void)creatViewShow{
    tab = [[UITableView alloc]init];
    tab.layer.cornerRadius = 10;
    tab.frame = CGRectMake(20,self.view.frame.size.height , self.view.frame.size.width-40, 0);
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    lab.text = @"离厂人员";
    lab.backgroundColor = [UIColor lightGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:20];
    
    return lab;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag = @"v";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:flag];
    
    
    UILabel*lab1 = (UILabel*)[cell viewWithTag:100];
    UILabel*lab2 = (UILabel*)[cell viewWithTag:200];
    lab1.text = @"";
    lab2.text = @"";
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:flag];
        
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.bounds.size.width, 40)];
        lab.tag = 100;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont boldSystemFontOfSize:20];
        [cell addSubview:lab];
        
        
        UILabel*lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, cell.bounds.size.width, 40)];
        lab1.tag = 200;
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.font = [UIFont boldSystemFontOfSize:20];
        [cell addSubview:lab1];
    }
    GuestModel *model = infoArr[indexPath.row];
    
    UILabel*lab3 = (UILabel*)[cell viewWithTag:100];
    UILabel*lab4 = (UILabel*)[cell viewWithTag:200];
    lab3.text =[NSString stringWithFormat:@" 公司:  %@",model.GuestCompany] ;
    lab4.text = [NSString stringWithFormat:@" 姓名:  %@", model.GuestName];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
