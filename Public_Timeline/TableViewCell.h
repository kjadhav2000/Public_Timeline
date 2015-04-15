//
//  TableViewCell.h
//  Public_Timeline
//
//  Created by Kundan Jadhav on 14/04/15.
//  Copyright (c) 2015 Kundan Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *User_name;
@property (nonatomic, strong) IBOutlet UILabel *ContentText;
@property (strong, nonatomic) IBOutlet UIImageView *UserImg;
@property (weak, nonatomic) IBOutlet UILabel *post_time;
@property (nonatomic) float requiredCellHeight;
   @property (nonatomic, assign)CGRect cellFrame;
@end
