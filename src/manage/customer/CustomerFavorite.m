//
//  CustomerFavorite.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "Utils.h"
#import "Access.h"
#import "ManageAccess.h"

#import "CustomerFavorite.h"
#import "CustomerFavoriteCell.h"

@interface CustomerFavorite()
{
    NSMutableArray *favorite;
}

@property (retain, nonatomic) IBOutlet UITableView *favoriteView;

@property (retain, nonatomic) IBOutlet UIButton *selectedAllButton;

@property (retain, nonatomic) IBOutlet UIButton *delectSelectedButton;

@end

@implementation CustomerFavorite

@synthesize favoriteView;

@synthesize selectedAllButton;

@synthesize delectSelectedButton;

//
static NSString *selectKey = @"select";

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [favoriteView setContentInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    
    [selectedAllButton addTarget:self action:@selector(selectAllTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [delectSelectedButton addTarget:self action:@selector(delectSelectedTouch:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setCustomer:(NSDictionary *)value
{
    [super setCustomer:value];
    
    id cid = [value objectForKey:@"id"];
    
    //
    selectedAllButton.enabled = NO;
    
    delectSelectedButton.enabled = NO;
    //
    
    [favorite release];
    
    favorite = [[ManageAccess getDefaultFavorite:cid] retain];
    
    for (NSMutableDictionary *dic in favorite)
    {
        [dic setValue:[NSNumber numberWithBool:NO] forKey:selectKey];
    }
    
    if (favorite) 
    {
        selectedAllButton.enabled = YES;
        
        delectSelectedButton.enabled = YES;
    }
    
    [favoriteView reloadData];
}

- (void)dealloc
{
    [favorite release];
    
    [favoriteView release];
    
    [selectedAllButton release];
    
    [delectSelectedButton release];
    
    [super dealloc];
}

//选择事件
-(void)cellActive:(CustomerFavoriteCell *)target
{
    NSIndexPath *path = [favoriteView indexPathForCell:target];
    
    if (path)
    {
        NSMutableDictionary *dic = [favorite objectAtIndex:path.row];
        
        [dic setValue:[NSNumber numberWithBool:target.active] forKey:selectKey];
    }
}
//全选
-(void)selectAllTouch:(UIButton*)sender
{
    [sender setSelected:!sender.selected];
    
    for (NSMutableDictionary *dic in favorite)
    {
        [dic setValue:[NSNumber numberWithBool:sender.selected] forKey:selectKey];
    }
    
    //
    NSArray *cells = [favoriteView visibleCells];
    
    for (CustomerFavoriteCell *cell in cells)
    {
        [cell setActive:sender.selected];
    }
}

//删除选择
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSMutableArray *fid = [NSMutableArray array];
        
        NSMutableArray *path = [NSMutableArray array];
        
        NSMutableArray *valid = [NSMutableArray array];
        
        for (int i=0;i<favorite.count;i++)
        {
            NSMutableDictionary *dic = [favorite objectAtIndex:i];
            
            if ([[dic objectForKey:selectKey] boolValue])
            {
                [fid addObject:[dic objectForKey:@"id"]];
                
                [path addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            else
            {
                [valid addObject:dic];
            }
        }
        
        if ([fid count] > 0)
        {
            [favorite removeAllObjects];
            
            [favorite addObjectsFromArray:valid];
            
            //
            [ManageAccess delProductFromFavoriteWithId:fid];
            
            [favoriteView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(void)delectSelectedTouch:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要删除选中的产品!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    [alert release];
}

//代理tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*id tmp = [favorite objectAtIndex:indexPath.row];
    
    if ([[tmp objectForKey:@"fromType"] intValue] == 1)
    {
        id room = [Access getRoom:[[tmp objectForKey:@"fromId"] intValue]];
        
        if (room)
        {
            NSMutableDictionary *curRoom = [room lastObject];
            
            [curRoom removeObjectForKey:@"files"];
            
            window.location = [MSRequest requestWithName:@"RoomViewController" search:curRoom];
        }
    }
    else 
    {*/
        NSMutableArray *temp = [NSMutableArray array];
        
        for (NSDictionary *dic in favorite)
        {
            [temp addObject:[dic objectForKey:@"productId"]];
        }
        
        id pro = [Access getProductInId:temp];
        
        if (pro)
        {
            window.location = [MSRequest requestWithName:@"ProductController" search:pro hash:[NSNumber numberWithInt:indexPath.row]];
        }
    //}
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favorite count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier"; 
    
    CustomerFavoriteCell *cell = (CustomerFavoriteCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [Utils loadNibNamed:@"CustomerFavoriteCell"];
        
        [cell setDelegate:self];
    }
    
    NSDictionary *dic = [favorite objectAtIndex:indexPath.row];
    
    [cell setActive:[[dic objectForKey:selectKey] boolValue]];
    
    [cell updata:dic];

    return cell;
}

@end
