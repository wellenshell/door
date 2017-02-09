//
//  SmellModel.m
//  LuxShare.DCS.New
//
//  Created by MingMing on 16/9/21.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "SmellModel.h"

@implementation SmellModel
+(SmellModel*)getSmellModel:(NSDictionary*)dicData{
    SmellModel *model = [[SmellModel alloc]init];
  
    
    
    
    if ([[dicData objectForKey:@"Id"] isKindOfClass:[NSNull class]]) {
        model.idd = 0;
    }else{
         model.idd = [[dicData objectForKey:@"Id"] integerValue];
    }
    if ([[dicData objectForKey:@"DemandTime"] isKindOfClass:[NSNull class]]) {
        model.DemandTime = @"null";
    }else{
        NSString *time = [dicData objectForKey:@"DemandTime"];
         model.DemandTime = [time substringWithRange:NSMakeRange(0, time.length-3)];
    }
    if ([[dicData objectForKey:@"DemandQuantity"] isKindOfClass:[NSNull class]]) {
        model.DemandQuantity = 0;
    }else{
        model.DemandQuantity = [[dicData objectForKey:@"DemandQuantity"] integerValue];
    }
  
    if ([[dicData objectForKey:@"Status"] isKindOfClass:[NSNull class]]) {
        model.Status = 0;
    }else{
        model.Status = [[dicData objectForKey:@"Status"] integerValue];
    }
    
    if ([[dicData objectForKey:@"ActualQuantity"] isKindOfClass:[NSNull class]]) {
        model.ActualQuantity = 0;
    }else{
        model.ActualQuantity = [[dicData objectForKey:@"ActualQuantity"] integerValue];
    }
    
    if ([[dicData objectForKey:@"GetOrderTime"] isKindOfClass:[NSNull class]]) {
        model.GetOrderTime = @"null";
    }else{
        NSString *time = [dicData objectForKey:@"GetOrderTime"];
        model.GetOrderTime = [time substringWithRange:NSMakeRange(0, time.length-3)];
    }
    if ([[dicData objectForKey:@"Line"] isKindOfClass:[NSNull class]]) {
        model.Line = @"null";
    }else{
        model.Line = [dicData objectForKey:@"Line"];
    }
    if ([[dicData objectForKey:@"MaterialCode"] isKindOfClass:[NSNull class]]) {
        model.MaterialCode = @"null";
    }else{
        model.MaterialCode = [dicData objectForKey:@"MaterialCode"];
    }
    if ([[dicData objectForKey:@"MaterialName"] isKindOfClass:[NSNull class]]) {
        model.MaterialName = @"null";
    }else{
        model.MaterialName = [dicData objectForKey:@"MaterialName"];
    }
    if ([[dicData objectForKey:@"ProfitceterCode"] isKindOfClass:[NSNull class]]) {
        model.ProfitceterCode = @"null";
    }else{
        model.ProfitceterCode = [dicData objectForKey:@"ProfitceterCode"];
    }
  
    
    if ([[dicData objectForKey:@"StockTime"] isKindOfClass:[NSNull class]]) {
        model.StockTime = @"null";
    }else{
        NSString *time = [dicData objectForKey:@"StockTime"];
        model.StockTime = [time substringWithRange:NSMakeRange(0, time.length-3)];

    }
    if ([[dicData objectForKey:@"SignForTime"] isKindOfClass:[NSNull class]]) {
        model.SignForTime = @"null";
    }else{
        model.SignForTime = [dicData objectForKey:@"SignForTime"];
    }
    if ([[dicData objectForKey:@"ApplyTime"] isKindOfClass:[NSNull class]]) {
        model.ApplyTime = @"null";
    }else{
        model.ApplyTime = [dicData objectForKey:@"ApplyTime"];
    }
    
    if ([[dicData objectForKey:@"WorkOrderCode"] isKindOfClass:[NSNull class]]) {
        model.WorkOrderCode = @"null";
    }else{
        model.WorkOrderCode = [dicData objectForKey:@"WorkOrderCode"];
    }
    if ([[dicData objectForKey:@"Background"] isKindOfClass:[NSNull class]]) {
        model.Background = @"null";
    }else{
        model.Background = [[dicData objectForKey:@"Background"] substringFromIndex:1];
    }
    if ([[dicData objectForKey:@"StockEmpName"] isKindOfClass:[NSNull class]]) {
        model.StockEmpName = @"null";
    }else{
        model.StockEmpName = [dicData objectForKey:@"StockEmpName"] ;
    }
      return model;
}
@end
