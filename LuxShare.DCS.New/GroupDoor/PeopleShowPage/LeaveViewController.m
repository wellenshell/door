//
//  LeaveViewController.m
//  Luxshare.DCS
//
//  Created by MingMing on 16/7/19.
//  Copyright © 2016年 DCS. All rights reserved.
//

#import "LeaveViewController.h"
#import "Header.h"
@interface LeaveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
     UITableView *tab;
    NSMutableArray *infoArr,*sureArr,*idsArr;
    UIView *view;
}
@end

@implementation LeaveViewController
-(void)viewWillAppear:(BOOL)animated{
    sureArr = [[NSMutableArray alloc]initWithCapacity:0];
    idsArr = [[NSMutableArray alloc]initWithCapacity:0];

     [SVProgressHUD showWithStatus:@"努力加载中..."];
     infoArr = [[NSMutableArray alloc]init];
    [HttpRequest getManufacturerInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"tfName"] completeWithData:^(NSMutableArray *ar) {
        [infoArr addObjectsFromArray:ar];
        [tab reloadData];
         [SVProgressHUD dismiss];
    }];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNav];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 10+SCREENHEIGHT/10+20, SCREENWIDTH, SCREENHEIGHT-20-SCREENHEIGHT/10-20-SCREENWIDTH/10)];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    // 添加下拉刷新
    MJRefreshStateHeader *mj_header= [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    tab.mj_header = mj_header;
  }
//刷新数据
-(void)headerRefresh{
    [SVProgressHUD showWithStatus:@"正在刷新。。。"];
    //开始刷新
    [tab.mj_header beginRefreshing];
    
    [HttpRequest getManufacturerInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"tfName"] completeWithData:^(NSMutableArray *ar) {
        
        [infoArr removeAllObjects];
        [infoArr addObjectsFromArray:ar];
        [tab reloadData];
        [SVProgressHUD dismiss];
    }];
      //结束刷新
    [tab.mj_header endRefreshing];
    
    
}

//添加导航条
-(void)creatNav{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT/10);
    bigView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:bigView];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/10);
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:24]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.userInteractionEnabled = YES;
    lab.text = @"等待离开的访客";
    [bigView addSubview:lab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, lab.bounds.size.height/2, lab.bounds.size.height);
    [button setImage:[UIImage imageNamed:@"coverpage_animation"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:button];
    
    UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSure.layer.cornerRadius = 5;
    [buttonSure setTitle:@"确认选择" forState:UIControlStateNormal];
    buttonSure.titleLabel.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:20]];
    [buttonSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonSure.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [buttonSure addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSure];
    
    buttonSure.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(SCREENWIDTH/10)
    .bottomSpaceToView(self.view,10);
}
-(void)backBtnClick{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sureBtnClick{
    if (idsArr.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择要离开的访客" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
      
 
    SureCodeViewController*sure = [[SureCodeViewController alloc]init];
    sure.idsArrr = idsArr;
    [self presentViewController:sure animated:YES completion:nil];
}
}


// 动态设置有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArr.count;
    
}
//给表添加数据
-(DidGuestTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag = @"flagg";
    DidGuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (!cell) {
        cell = [[DidGuestTableViewCell alloc]initWithCell];
         cell.labName.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
         cell.labItems.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
    }
    GuestModel *model = [infoArr objectAtIndex:indexPath.row];
    cell.labCompanyName.text = [NSString stringWithFormat:@"公司名字:%@",model.GuestCompany];
    cell.labName.text = [NSString stringWithFormat:@"访客名字:%@",model.GuestName];
    cell.labItems.text = [NSString stringWithFormat:@"携带物品:%@",model.GuestItem];
    cell.labReceptionName.text = [NSString stringWithFormat:@"接待人:%@",model.ReceptionName];
    
    cell.labReceptionName.sd_layout
    .leftSpaceToView(cell,10)
    .topSpaceToView(cell.labItems,SCREENWIDTH*0.01)
    .widthIs([cell getString:cell.labReceptionName.text].width+5)
    .heightIs(30);
    
    cell.labTime.text = [NSString stringWithFormat:@"时间:%@",[model.CheckTime substringWithRange:NSMakeRange(0, model.CheckTime.length-3)]];
   
    if ([idsArr containsObject:model.guestId]) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
         cell.backgroundColor = [UIColor colorWithRed:175.0/255.0 green:189.0/255.0 blue:211.0/255.0 alpha:0.5];
    }else{
         cell.accessoryType = UITableViewCellAccessoryNone;
         cell.backgroundColor = [UIColor whiteColor];
    }
  
    return cell;
    
}
// 进行人物的勾选 判断选中没有
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DidGuestTableViewCell*cell = (DidGuestTableViewCell*)[tab cellForRowAtIndexPath:indexPath];
    GuestModel *model = [infoArr objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark ) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        [sureArr removeObject:model.GuestName];
        [idsArr removeObject:model.guestId];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor colorWithRed:175.0/255.0 green:189.0/255.0 blue:211.0/255.0 alpha:0.5];
        [sureArr addObject:model.GuestName];
        [idsArr addObject:model.guestId];
       
    }
    
   
}
// 设置单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UIScreen mainScreen].bounds.size.width <= 414) {
        return 140;
    }else{
         return 180;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
