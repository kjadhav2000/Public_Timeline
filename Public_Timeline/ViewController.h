//
//  ViewController.h
//  Public_Timeline
//
//  Created by Kundan Jadhav on 14/04/15.
//  Copyright (c) 2015 Kundan Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UITableView *Timeline_tableView;
@property (strong) TableViewCell *cellPrototype;
@property (strong,nonatomic)NSMutableArray *arr;
@property(nonatomic,strong)NSMutableArray* postData;
@property(nonatomic,strong)NSMutableArray* UserName;
@property(nonatomic,strong)NSMutableArray* PostContent;
@property(nonatomic,strong)NSMutableArray* avatar;
@property(nonatomic,strong)NSMutableArray* post_time;





@end

