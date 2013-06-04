//
//  popTableViewController.m
//  rainbow
//
//  Created by 360 e on 13-2-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "popTableViewController.h"
#import "RoomController.h"


@interface popTableViewController ()

@end

@implementation popTableViewController


@synthesize myTableView;
@synthesize selectStr;
@synthesize myArray;
@synthesize popoverController;
@synthesize oceanaViewController;
@synthesize active;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myTableView = [[UITableView alloc] init];
    
    [myTableView setDelegate:self];
    
    [myTableView setDataSource:self];
    
    [self.view addSubview:myTableView];
    
 
}

-(void)setContentSizeForViewInPopover:(CGSize)contentSizeForViewInPopover
{
    [super setContentSizeForViewInPopover:contentSizeForViewInPopover];
    
    myTableView.frame = CGRectMake(0, 0, contentSizeForViewInPopover.width, contentSizeForViewInPopover.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

 //指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
 
 //指定每个分区中有多少行，默认为1
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
         return [myArray count];
}
 //绘制Cell
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
     
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
     
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease]; 
    }
     
    cell.textLabel.text =[myArray objectAtIndex:indexPath.row];
     
    if(oceanaViewController.touchID==0)
    {
        if (indexPath.row==active)
        {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
     
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    
    selectStr =[[NSString alloc] initWithFormat:@"%@",[myArray objectAtIndex:indexPath.row]];
    
    [oceanaViewController killPopoversOnSight];
//    
    [oceanaViewController textGetValue:selectStr]; //CustomerDetailVC中的一个方法
    
    [selectStr release];
}


@end
