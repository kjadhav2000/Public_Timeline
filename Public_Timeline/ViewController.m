//
//  ViewController.m
//  Public_Timeline
//
//  Created by Kundan Jadhav on 14/04/15.
//  Copyright (c) 2015 Kundan Jadhav. All rights reserved.
//
#define PublicTimelineURL  [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"]

#import "ViewController.h"
#import "TableViewCell.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize cellPrototype,arr,Timeline_tableView,postData,PostContent,UserName,avatar,post_time;
- (void)viewDidLoad {
    [super viewDidLoad];
    static NSString *CellIdentifier = @"MyCell";
    self.cellPrototype = [self.Timeline_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    postData=[[NSMutableArray alloc]init];         //store data
    PostContent=[[NSMutableArray alloc]init];      //Post content data
    UserName=[[NSMutableArray alloc]init];         //Username of all posters
    avatar=[[NSMutableArray alloc]init];           //Image URL of all posters
    post_time=[[NSMutableArray alloc]init];        //Post time string
    [self fetchPostDataAPI];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [Timeline_tableView addSubview:refreshControl];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [UserName removeAllObjects];
   // [postData removeAllObjects];
    [PostContent removeAllObjects];
    [avatar removeAllObjects];
    [post_time removeAllObjects];
    [self fetchPostDataAPI];
    [refreshControl endRefreshing];

}

-(void)fetchPostDataAPI;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:PublicTimelineURL];
        if (data) {
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        }
        else
        {
            // NSLog(@" error data is nil");
            [self performSelectorInBackground:@selector(Alert) withObject:nil];
        }
    });
}

- (void)fetchedData:(NSData *)responseData
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    postData = [json valueForKey:@"data"];
    if (postData) {
        
        for (NSMutableDictionary *Dict in postData) {
            NSMutableDictionary *UserInfo=[Dict valueForKey:@"user"];
            [UserName addObject:[UserInfo valueForKey:@"username"]];
            [PostContent addObject:[Dict valueForKey:@"text"]];
            NSMutableDictionary* avatarImage = [UserInfo valueForKey:@"avatar_image"];
            [avatar addObject:[avatarImage valueForKey:@"url"]];
            [post_time addObject:[Dict objectForKey:@"created_at"]];
        }
        [Timeline_tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return UserName.count;
}
- (NSString *)NameTextForRow:(int)row {
    return [self.UserName objectAtIndex:row];
}

- (NSString *)ContentTextForRow:(int)row {
    return [@"–" stringByAppendingString:[self.PostContent objectAtIndex:row]];
}
- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {
    return [text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        self.cellPrototype.ContentText.text = [PostContent objectAtIndex:indexPath.row];
        [self.cellPrototype layoutSubviews];
        CGFloat quotationLabelHeight = [self sizeOfLabel:self.cellPrototype.User_name withText:[self NameTextForRow:indexPath.row]].height;
        CGFloat attributionLabelHeight = [self sizeOfLabel:self.cellPrototype.ContentText withText:[self ContentTextForRow:indexPath.row]].height;
        CGFloat padding = self.cellPrototype.ContentText.frame.origin.y;
        CGFloat combinedHeight = padding + quotationLabelHeight + padding/5 + attributionLabelHeight;
        return MAX(combinedHeight, 30);
    }
    
    @catch (NSException *e)
    {
        NSLog(@"Exception: %@", e);
        return 20.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
    }
    if([UserName count] > 0 && [UserName count] > indexPath.row){  // to check null value
        
      NSString*  shrObj=[UserName objectAtIndex:indexPath.row];
        cell.User_name.text = shrObj;

    }
    if([PostContent count] > 0 && [PostContent count]> indexPath.row){// to check null value
        
        NSString*  shrObj=[PostContent objectAtIndex:indexPath.row];
        cell.ContentText.text = shrObj;
    }
    if([post_time count] > 0 && [post_time count]> indexPath.row){// to check null value
        
        NSString*  timeObj=[post_time objectAtIndex:indexPath.row];
        NSString *timeStr,*finalTime;
        timeStr= [timeObj stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        finalTime= [timeStr stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
        cell.post_time.text = finalTime;
    }
    NSString*  avatarStr;
    if([avatar count] > 0 && [avatar count]> indexPath.row){
       avatarStr =[avatar objectAtIndex:indexPath.row];
    }
    else{
        avatarStr = @"NA";
    }

    cell.tag = indexPath.row;
        cell.imageView.image = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);

    dispatch_async(queue, ^(void) {

    NSData* imageData1;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:avatarStr]) {
        
        imageData1 = [[NSUserDefaults standardUserDefaults] objectForKey:avatarStr];
        NSLog(@"found");// image already cached
    }
    else{
        imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatarStr]];
        [[NSUserDefaults standardUserDefaults] setObject:imageData1 forKey:avatarStr];
        NSLog(@"not found"); // image cached here
    }
    UIImage* image = [[UIImage alloc] initWithData:imageData1];
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{   // load images async
            if (cell.tag == indexPath.row) {
                cell.UserImg.image = image;
                [cell setNeedsLayout];
            }
        });
    }
        
});
    cell.UserImg.layer.cornerRadius = 28.0;
    cell.UserImg.layer.masksToBounds = YES;
    cell.UserImg.clipsToBounds = YES;
    cell.UserImg.layer.borderColor = [UIColor blackColor].CGColor;
    cell.UserImg.layer.borderWidth = 1.0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
