//
//  CustomerFavorite.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "ManageAccess.h"

#import "CustomerCart.h"
#import "OrderCartCell.h"
#import "CustomerNoteAlert.h"

@interface CustomerCart()
{
    NSMutableArray *cart;
}

@property (retain, nonatomic) IBOutlet UITableView *cartView;

@property (retain, nonatomic) IBOutlet UIButton *selectedAllButton;

@property (retain, nonatomic) IBOutlet UIButton *sandboxButton;

@property (retain, nonatomic) IBOutlet UIButton *saveButton;

@property (retain, nonatomic) IBOutlet UIButton *delSelectButton;

@property (retain, nonatomic) IBOutlet UIButton *noteButton;

@end

//
@implementation CustomerCart

@synthesize cartView;

@synthesize selectedAllButton;

@synthesize sandboxButton;

@synthesize saveButton;
@synthesize delSelectButton;
@synthesize noteButton;

//
static NSString *selectKey = @"select";

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [cartView setContentInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    
    [saveButton addTarget:self action:@selector(saveTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [sandboxButton addTarget:self action:@selector(sandboxTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectedAllButton addTarget:self action:@selector(selectAllTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [delSelectButton addTarget:self action:@selector(delSelectTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [noteButton addTarget:self action:@selector(noteTouch:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setCustomer:(NSDictionary *)value
{
    [super setCustomer:value];
    
    id cid = [value objectForKey:@"id"];
    
    //
    saveButton.enabled = NO;
    
    sandboxButton.enabled = NO;
    
    selectedAllButton.enabled = NO;
    
    delSelectButton.enabled = NO;
    
    noteButton.enabled = NO;
    
    //
    [cart release];
    
    id cur = [ManageAccess getDefaultCart:cid];
    
    if (cur)
    {
        cart = [[ManageAccess getGoodsWithCartId:[cur objectForKey:@"id"]] retain];
        
        for (NSMutableDictionary *dic in cart)
        {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:selectKey];
        }
        
        if (cart)
        {
            saveButton.enabled = YES;
            
            sandboxButton.enabled = YES;
            
            selectedAllButton.enabled = YES;
            
            delSelectButton.enabled = YES;
            
            noteButton.enabled = YES;
        }
    }

    [cartView reloadData];
}

- (void)dealloc
{
    [cart release];
    
    [cartView release];
    
    [selectedAllButton release];
    
    [sandboxButton release];
    
    [saveButton release];
    
    [delSelectButton release];
    [noteButton release];
    [super dealloc];
}

-(void)saveTouch:(UIButton*)sender
{
    if ([cart count] > 0)
    {
        NSMutableArray *sel = [NSMutableArray array];
        
        for (NSDictionary *dic in cart) 
        {
            [sel addObject:[dic objectForKey:@"id"]];
        }
        
        //
        id sid = [self.customer objectForKey:@"id"];
        
        id cur = [ManageAccess getDefaultCart:sid];

        NSDictionary *search = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.customer objectForKey:@"id"],@"customerId",
                                [cur objectForKey:@"id"],@"orderId",
                                [NSNumber numberWithInt:3],@"tabbedId",nil];
        
        [ManageAccess saveOrder:[cur objectForKey:@"id"]];
        
        [window.location replace:[MSRequest requestWithName:@"ManageController" search:search]];
    }
}

-(void)noteTouch:(UIButton*)sender
{
    id sid = [self.customer objectForKey:@"id"];
    
    id cur = [ManageAccess getDefaultCart:sid];
    
    MSWindow *win = [window open:[MSRequest requestWithName:@"CustomerNoteAlert" search:[cur objectForKey:@"note"]]];
    
    win.onclose=^(id target){
        
        CustomerNoteAlert *alert = (CustomerNoteAlert*)win.rootViewController;
        
        if(alert.data && ![alert.data isEqualToString:@""])
        {
            [ManageAccess setOrderNoteWithId:[cur objectForKey:@"id"] note:alert.data];
        }
    };
}

-(void)sandboxTouch:(UIButton*)sender
{
    NSString *ids = nil;
    
    for (NSDictionary *dic in cart) 
    {
        if ([[dic objectForKey:selectKey] boolValue])
        {
            if (ids == nil)
            {
                ids = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
            }
            else 
            {
                ids = [ids stringByAppendingFormat:@",%@",[dic objectForKey:@"productId"]];
            }
        }
    }
    
    if (ids)
    {
        window.location = [MSRequest requestWithName:@"SandboxController" search:ids];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择产品!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        [alert release];
    }
}
//代理
-(void)amountChange:(id)target amount:(NSInteger)amount
{
    NSIndexPath *path = [cartView indexPathForCell:target];
    
    if (path)
    {
        NSMutableDictionary *dic = [cart objectAtIndex:path.row];

        [dic setValue:[NSNumber numberWithInt:amount] forKey:@"amount"];
        
        [ManageAccess modOrderGoodsWithId:[dic objectForKey:@"id"] amount:[dic objectForKey:@"amount"]];
    }
}

-(void)statusChange:(id)target
{
    NSIndexPath *path = [cartView indexPathForCell:target];
    
    if (path)
    {
        OrderCartCell *cell = target;
        
        NSMutableDictionary *dic = [cart objectAtIndex:path.row];
        
        [dic setValue:[NSNumber numberWithBool:cell.active] forKey:selectKey];
    }
}

//全选
-(void)selectAllTouch:(UIButton*)sender
{
    [sender setSelected:!sender.selected];
    
    for (NSMutableDictionary *dic in cart)
    {
        [dic setValue:[NSNumber numberWithBool:sender.selected] forKey:selectKey];
    }
    
    //
    NSArray *cells = [cartView visibleCells];
    
    for (OrderCartCell *cell in cells)
    {
        [cell setActive:sender.selected];
    }
}

-(void)delSelectTouch:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要删除选中的产品!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    [alert release];
}

//删除选择
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSMutableArray *fid = [NSMutableArray array];
        
        NSMutableArray *path = [NSMutableArray array];
        
        NSMutableArray *valid = [NSMutableArray array];
        
        for (int i=0;i<cart.count;i++)
        {
            NSMutableDictionary *dic = [cart objectAtIndex:i];
            
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
            [cart removeAllObjects];
            
            [cart addObjectsFromArray:valid];
            
            //
            id sid = [self.customer objectForKey:@"id"];
            
            id cur = [ManageAccess getDefaultCart:sid];
            
            [ManageAccess delGoodsInOrder:[cur objectForKey:@"id"] goodsId:fid];
            
            [cartView deleteRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationFade];
            
            //
            BOOL enabled = cart.count > 0;
            
            saveButton.enabled = enabled;
            
            sandboxButton.enabled = enabled;
            
            selectedAllButton.enabled = enabled;
            
            delSelectButton.enabled = enabled;
        }
    }
}

//代理tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cart count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier"; 
    
    OrderCartCell *cell = (OrderCartCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [Utils loadNibNamed:@"CustomerCartCell"];
        
        [cell setDelegate:self];
    }
    
    NSDictionary *dic = [cart objectAtIndex:indexPath.row];
    
    [cell setActive:[[dic objectForKey:selectKey] boolValue]];
    
    [cell updata:dic]; 

    return cell;
}

@end
