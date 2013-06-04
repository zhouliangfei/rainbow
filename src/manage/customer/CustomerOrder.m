//
//  CustomerFavorite.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "ManageAccess.h"

#import "CustomerOrder.h"

@interface CustomerOrder()
{
    OrderDetailed *detailed;
    
    NSMutableArray *order;
}

@property (retain, nonatomic) IBOutlet UITableView *orderView;

@end

//
@implementation CustomerOrder

@synthesize orderView;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //
    orderView.layer.borderWidth = 1.0;
    
    orderView.layer.borderColor = [[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
    
    //
    CGRect rect = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    detailed = [[Utils loadNibNamed:@"CustomerOrderDetailed"] retain];
    
    [detailed setCellNibNamed:@"CustomerOrderCartCell"];
    
    [detailed setDelegate:self];

    [detailed setFrame:rect];
    
    [self addSubview:detailed];
    
    [self setContentSize:CGSizeMake(self.frame.size.width * 2, self.frame.size.height)];
}

-(void)setCustomer:(NSDictionary *)value
{
    [super setCustomer:value];

    [self backAndUpdataEvent];
}

-(void)setOrderId:(NSString *)orderId
{
    [super setOrderId:orderId];
    
    for (NSDictionary *dic in order)
    {
        if ([[dic objectForKey:@"id"] isEqualToString:orderId])
        {
            [detailed setOrder:dic];
            
            [self scrollRectToVisible:detailed.frame animated:NO];
            
            break;
        }
    }
}

- (void)dealloc
{
    [order release];
    
    [orderView release];
    
    [detailed release];
    
    [super dealloc];
}

//代理tableview
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [Utils loadNibNamed:@"CustomerOrderTitle"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [order count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier"; 
    
    OrderCell *cell = (OrderCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [Utils loadNibNamed:@"CustomerOrderCell"];
        
        [cell setDelegate:self];
    }
    
    //
    [cell updata:[order objectAtIndex:indexPath.row]];

    return cell;
}

-(void)detailedTouch:(id)target
{
    NSIndexPath *path = [orderView indexPathForCell:target];
    
    if (path)
    {
        [detailed setOrder:[order objectAtIndex:path.row]];
        
        [self scrollRectToVisible:detailed.frame animated:YES];
    }
}

-(void)backEvent
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self scrollRectToVisible:rect animated:YES];
}

-(void)backAndUpdataEvent
{
    if (order)
    {
        [order release];
        
        order = nil;
    }
    
    id sid = [self.customer objectForKey:@"id"];
    
    order = [[ManageAccess getCartWithCustomerId:sid] retain];
    
    [orderView reloadData];
    
    [self backEvent];
}

/*-(void)statusChange:(id)target
{
    
}*/

@end
