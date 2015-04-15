//
//  TableViewCell.m
//  Public_Timeline
//
//  Created by Kundan Jadhav on 14/04/15.
//  Copyright (c) 2015 Kundan Jadhav. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
@synthesize User_name,ContentText,requiredCellHeight,UserImg,post_time;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(210.0f, CGFLOAT_MAX);
    CGSize requiredSize = [self.User_name sizeThatFits:maxSize];
    self.User_name.frame = CGRectMake(self.User_name.frame.origin.x, self.User_name.frame.origin.y, requiredSize.width, requiredSize.height);
    
//    requiredSize = [self.Subtitle sizeThatFits:maxSize];
//    self.Subtitle.frame = CGRectMake(self.Subtitle.frame.origin.x, self.Subtitle.frame.origin.y, requiredSize.width, requiredSize.height);
    
    requiredSize = [self.ContentText sizeThatFits:maxSize];
    self.ContentText.frame = CGRectMake(self.ContentText.frame.origin.x, self.ContentText.frame.origin.y, requiredSize.width, requiredSize.height);
    
    // Reposition labels to handle content height changes
    
//    CGRect subtitleFrame = self.Subtitle.frame;
//    subtitleFrame.origin.y = self.Title.frame.origin.y + self.Title.frame.size.height + 3.0f;
//    self.Subtitle.frame = subtitleFrame;
    
    CGRect contentTextFrame = self.ContentText.frame;
   // contentTextFrame.origin.y = self.Subtitle.frame.origin.y + self.Subtitle.frame.size.height + 7.0f;
    self.ContentText.frame = contentTextFrame;
    
    
    // Calculate cell height
    
    requiredCellHeight = 15.0f + 3.0f + 7.0f + 15.0f;
   // requiredCellHeight += self.Title.frame.size.height;
   // requiredCellHeight += self.Subtitle.frame.size.height;
    requiredCellHeight += self.ContentText.frame.size.height;
}
@end
