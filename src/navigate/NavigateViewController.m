//
//  popTableViewController.m
//  rainbow
//
//  Created by 360 e on 13-2-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NavigateViewController.h"
#import "RoomController.h"

@interface NavigateViewController ()
{
    UITableView *tableView;
}

@end

@implementation NavigateViewController

@synthesize onClose;

@synthesize single;

@synthesize data;

-(id)initWithSource:(NSArray*)value title:(NSString*)title button:(BOOL)button
{
    UIViewController *rootCtrl = [[UIViewController alloc] init];
    
    if (nil == title && NO == button)
    {
        self = [super initWithContentViewController:rootCtrl];
    }
    else 
    {
        UINavigationController *navigateCtrl = [[UINavigationController alloc] initWithRootViewController:rootCtrl];
        
        if (title)
        {
            rootCtrl.title = [NSString stringWithFormat:@"%@", title];
        }
        
        if (button)
        {
            UIBarButtonItem *lefBtn = [[[UIBarButtonItem alloc] initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(allTouch:)] autorelease];
            
            UIBarButtonItem *rigBtn = [[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(okTouch:)] autorelease];
            
            rootCtrl.navigationItem.leftBarButtonItem = lefBtn;
            
            rootCtrl.navigationItem.rightBarButtonItem = rigBtn;
        }
        
        self = [super initWithContentViewController:navigateCtrl];
        
        [navigateCtrl release];
    }

    if (self)
    {
        single = YES;
        
        data = [value retain];
        
        //
        tableView = [[UITableView alloc] init];
        
        [tableView setDelegate:self];
        
        [tableView setDataSource:self];

        [rootCtrl.view addSubview:tableView];
        
        [self setDelegate:self];
    }

    [rootCtrl release];
    
    return self;
}

-(void)dealloc
{
    [onClose release];
    
    [tableView release];
    
    [data release];

    [super dealloc];
}

-(void)setPopoverContentSize:(CGSize)popoverContentSize
{
    CGSize size = popoverContentSize;
    
    size.height = [data count] * tableView.rowHeight;
    
    tableView.frame = CGRectMake(0, 0, size.width, size.height);
    
    //
    if ([self.contentViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)self.contentViewController;

        size.height += nav.navigationBar.frame.size.height - 8.f;
    }
    
    [super setPopoverContentSize:size];
}

-(void)clearSelectWith:(NSArray*)value
{
    for (NSDictionary *dic in value)
    {
        if ([dic objectForKey:@"select"])
        {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"select"];
        }
        
        if ([dic objectForKey:@"value"])
        {
            [self clearSelectWith:[dic objectForKey:@"value"]];
        }
    }
}

-(void)allTouch:(id)sender
{
    [self clearSelectWith:data];
    
    if (onClose)
    {
        onClose(self);
    }
}

-(void)okTouch:(id)sender
{
    if (onClose)
    {
        onClose(self);
    }
}

-(void)setSingle:(BOOL)value
{
    single = value;
    
    tableView.allowsMultipleSelection = !value;
}

//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

-(UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
     
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
     
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease]; 
    }
    
    //
    id cur = [[data objectAtIndex:indexPath.row] objectForKey:@"select"];
    
    if (cur && [cur boolValue])
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    //
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [self setLableWithCell:cell atData:[data objectAtIndex:indexPath.row]];

    return cell;
}

-(void)setLableWithCell:(UITableViewCell*)cell atData:(id)atdata 
{
    NSString *lab = nil;
    
    for (id all in [atdata objectForKey:@"value"])
    {
        id sel = [all valueForKey:@"select"];
        
        if (sel && [sel boolValue])
        {
            if (nil == lab)
            {
                lab = [NSString stringWithFormat:@"%@",[all objectForKey:@"name"]];
            }
            else 
            {
                lab = [NSString stringWithFormat:@"%@,%@",lab,[all objectForKey:@"name"]];
            }
        }
    }
    
    if (lab) 
    {
        cell.textLabel.text = lab;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[atdata objectForKey:@"name"]];
    }
}

-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    id temp = [data objectAtIndex:indexPath.row];
    
    id value = [temp objectForKey:@"value"];
    
    if (value)
    {
        for (NSMutableDictionary *dic in data)
        {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"select"];
        }
        
        [temp setValue:[NSNumber numberWithBool:YES] forKey:@"select"];
        
        //有子项
        CGRect rect = [cell convertRect:cell.bounds toView:tableView];
        
        NavigateViewController *sub = [[NavigateViewController alloc] initWithSource:value title:[temp objectForKey:@"name"] button:NO];
        
        [sub setPopoverContentSize:self.popoverContentSize];
        
        sub.single = [[temp objectForKey:@"single"] boolValue];
        
        sub.onClose = ^(id target)
        {
            [self setLableWithCell:cell atData:temp];
            
            [sub dismissPopoverAnimated:YES];
        };
        
        [sub presentPopoverFromRect:rect inView:tableView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        [sub release];
    }
    else
    {
        if (single)
        {
            for (NSMutableDictionary *dic in data)
            {
                [dic setValue:[NSNumber numberWithBool:NO] forKey:@"select"];
            }
            
            [temp setValue:[NSNumber numberWithBool:YES] forKey:@"select"];
            
            onClose(self);
        }
        else 
        {
            if ([[temp objectForKey:@"select"] boolValue])
            {
                [temp setValue:[NSNumber numberWithBool:NO] forKey:@"select"];
            }
            else 
            {
                [temp setValue:[NSNumber numberWithBool:YES] forKey:@"select"];
            }
        }
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (onClose)
    {
        onClose(self);
    }
}

@end
