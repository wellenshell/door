//
//  VisitorViewController.m
//  Luxshare.DCS
//
//  Created by George Tsai on 16/7/14.
//  Copyright © 2016年 DCS. All rights reserved.
//

#import "VisitorViewController.h"
#import "Header.h"
#import "IQKeyboardManager.h"
@interface VisitorViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *gstArr;
    NSMutableArray *idsArr;
    NSMutableArray *itemsArr;
    UITableView*tab;
    NSMutableDictionary*thingDic;
    UIView *view;
}

@end

@implementation VisitorViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    thingDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //创建两个数组来装数据 作为下一个页面的数据请求参数
    idsArr = [[NSMutableArray alloc]initWithCapacity:0];
    itemsArr = [[NSMutableArray alloc]initWithCapacity:0];
    gstArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //获取访客的数据
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:@"tfName"];
    [HttpRequest getGuestInfo:code completeWithData:^(NSMutableArray *guestArr) {
    
        [gstArr addObjectsFromArray:guestArr];
        [tab reloadData];
        [SVProgressHUD dismiss];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];//[self hidden];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNav];
    [self creatVisitor];
    
    
    
    tab = [[UITableView alloc]init];
    tab.showsVerticalScrollIndicator = NO;
    tab.frame = CGRectMake(0, 20+SCREENHEIGHT/10+10, SCREENWIDTH,SCREENHEIGHT-30-SCREENHEIGHT/10-10-SCREENWIDTH/9);
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
   
    // 添加下拉刷新
    MJRefreshStateHeader *mj_header= [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    tab.mj_header = mj_header;
}
//刷新数据
-(void)headerRefresh{
    [SVProgressHUD showWithStatus:@"正在刷新。。。"];
    //获取访客的数据
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:@"tfName"];
    //开始刷新
    [tab.mj_header beginRefreshing];
   
    [HttpRequest getGuestInfo:code completeWithData:^(NSMutableArray *guestArr) {
        [gstArr removeAllObjects];
        [gstArr addObjectsFromArray:guestArr];
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
    lab.frame = CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT/10);
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:24]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.userInteractionEnabled=  YES;
    lab.text = @"等待进入的访客";
    [bigView addSubview:lab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, lab.bounds.size.height/2 , lab.bounds.size.height);
    [button setImage:[UIImage imageNamed:@"coverpage_animation"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [lab addSubview:button];

}
-(void)backBtnClick{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加访客
-(void)creatVisitor{
    
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
-(void)sureBtnClick{
    if (idsArr.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择要进入的访客" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
    //点击确定选择后 将两个数组存入本地 并跳转到扫描页面
        
    [idsArr writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ids.text"] atomically:YES];
    [itemsArr writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/items.text"] atomically:YES];
        
    CodeViewController *code = [[CodeViewController alloc]init];
    [self presentViewController:code animated:YES completion:nil];
        NSLog(@"-----%@---%@",idsArr,itemsArr);
    }
    
  
}
//列表的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return gstArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag = @"flag";
    VisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    cell.tfThings.text = @"";
    UILabel*time = [cell viewWithTag:1200];
    time.text = @"";
    [cell.btnSelect setImage:[UIImage imageNamed:@"noOk"] forState:UIControlStateNormal];

       if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"VisitorTableViewCell" owner:nil options:nil][0];
           cell.btnSelect.sd_layout
           .heightIs(SCREENWIDTH/10)
           .widthIs(SCREENWIDTH/10);
           
           cell.tfPerson.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:16]];
           cell.tfPerson.sd_layout
           .leftSpaceToView(cell.btnSelect,5).topEqualToView(cell.btnSelect).heightIs(SCREENWIDTH/10);
           
           cell.lab.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:17]];
           CGSize size = [cell.lab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[UIFONT fontWithDevice:17]],NSFontAttributeName, nil] ];
           cell.lab.sd_layout
           .heightIs(SCREENWIDTH/10)
           .widthIs(size.width+3)
           .topSpaceToView(cell.btnSelect,5);
           
           
           
           cell.tfThings.sd_layout
           .topSpaceToView(cell.btnSelect,5)
           .heightIs(SCREENWIDTH/10)
           .leftSpaceToView(cell.lab,0)
           .widthIs(SCREENWIDTH-size.width-3-20);
           cell.tfThings.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:17]];
           cell.tfThings.returnKeyType = UIReturnKeyDefault;
           
           cell.time.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:17]];
          
           UILabel*labTime = [[UILabel alloc]init];
           labTime.text = @"登记时间";
           labTime.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:17]];
           CGSize size1 = [labTime.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[UIFONT fontWithDevice:17]],NSFontAttributeName, nil] ];
           [cell addSubview:labTime];
           labTime.sd_layout.bottomSpaceToView(cell,20)
           .leftSpaceToView(cell,10)
           .heightIs(SCREENWIDTH/10)
           .widthIs(size1.width+5);
           
           UILabel*time = [[UILabel alloc]init];
           time.tag = 1200;
           time.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:17]];
           [cell addSubview:time];
           time.sd_layout
           .leftSpaceToView(labTime,10)
           .bottomSpaceToView(cell,20)
           .heightIs(SCREENWIDTH/10)
           .rightEqualToView(cell);
           
          cell.backgroundColor = [UIColor whiteColor];
           cell.tfThings.delegate = self;
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tfChange:) name:UITextFieldTextDidChangeNotification object:nil];

    }

    cell.btnSelect.tag = indexPath.row+1;
    [cell.btnSelect addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    GuestModel *model = [gstArr objectAtIndex:indexPath.row];
    cell.tfPerson.text = [NSString stringWithFormat:@"%@－%@",model.GuestCompany,model.GuestName];
   
    UILabel*time1 = [cell viewWithTag:1200];
    time1.text = [model.CheckTime  substringWithRange:NSMakeRange(0, model.CheckTime.length-3)];

    if (thingDic.count !=0) {
        cell.tfThings.text = [thingDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    
    
    if ([idsArr containsObject:model.guestId]) {
        [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"favmanage_checkbutton_checked"] forState:UIControlStateNormal];
    }else{
       [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"favmanage_checkbutton"] forState:UIControlStateNormal];
    }
    return cell;
    
}
//设置cell单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH/10*3+40;
}
-(void)btnClick:(UIButton*)button{
   VisitorTableViewCell *cell = (VisitorTableViewCell*)[[button superview]superview];
    NSIndexPath *pa = [tab indexPathForCell:cell];
    GuestModel *model = [gstArr objectAtIndex:pa.row];
    UITextField *tfItems = (UITextField*)[cell viewWithTag:20];
    if (cell.btnSelect.selected == YES) {
        cell.btnSelect.selected = NO;
        [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"favmanage_checkbutton"] forState:UIControlStateNormal];
        [idsArr removeObject:model.guestId];
        [itemsArr removeObject:tfItems.text];
        
    }else{
        
        cell.btnSelect.selected = YES;
        [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"favmanage_checkbutton_checked"] forState:UIControlStateNormal];
        [idsArr addObject:model.guestId];
        [itemsArr addObject:tfItems.text];
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    VisitorTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GuestModel *model = [gstArr objectAtIndex:indexPath.row];
    UITextField *tfItems = (UITextField*)[cell viewWithTag:20];
        if (cell.btnSelect.selected == YES) {
        cell.btnSelect.selected = NO;
        [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"favmanage_checkbutton"] forState:UIControlStateNormal];
        [idsArr removeObject:model.guestId];
        [itemsArr removeObject:tfItems.text];
        
    }else{
        
        cell.btnSelect.selected = YES;
        [cell.btnSelect setBackgroundImage:[UIImage imageNamed:@"favmanage_checkbutton_checked"] forState:UIControlStateNormal];
        [idsArr addObject:model.guestId];
        [itemsArr addObject:tfItems.text];
        
    }
}
//接受输入框改变通知 获取内容
-(void)tfChange:(NSNotification*)notify{
    
        UITextField *tf = notify.object;
           VisitorTableViewCell *cell = (VisitorTableViewCell*)tf.superview.superview;
        NSIndexPath *path = [tab indexPathForCell:cell];
        GuestModel *model = [gstArr objectAtIndex:path.row];
        if ([idsArr containsObject:model.guestId]) {
            for (int i = 0; i<idsArr.count; i++) {
                NSString *guestId = [idsArr objectAtIndex:i];
                if ([guestId integerValue] == [model.guestId integerValue]) {
                    [itemsArr removeObjectAtIndex:i];
                    [itemsArr insertObject:tf.text atIndex:i];
                }
            }
        
    }
    
    
    
   
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    VisitorTableViewCell*cell =  (VisitorTableViewCell*)[[textField superview]superview];
    NSIndexPath*path = [tab indexPathForCell:cell];
    cell.tfThings.text = textField.text;
    
        [thingDic setObject:cell.tfThings.text forKey:[NSString stringWithFormat:@"%ld",path.row]];
        [tab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];

    [textField resignFirstResponder];

     return YES;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
