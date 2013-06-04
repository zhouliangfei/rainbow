//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "ManageAccess.h"
#import "ChineseCharacters.h"
#import <QuartzCore/QuartzCore.h>

#import "CustomerSelect.h"
#import "CustomerTitle.h"

@interface CustomerSelect ()
{
    NSMutableDictionary *customer;
    IBOutlet UITableView *cusTableView;
}

@property (retain, nonatomic) IBOutlet UITextField *seachView;
@property (retain, nonatomic) IBOutlet UIButton *customerAddBtn;

@end

//
@implementation CustomerSelect
@synthesize addEvent;
@synthesize closeEvent;
@synthesize seachView;
@synthesize customerAddBtn;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    cusTableView.layer.borderColor = [[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
    
    cusTableView.layer.borderWidth = 1.0;
    
    //
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manage_iconinput.png"]];
    
    [icon setContentMode:UIViewContentModeCenter];
    
    [icon setFrame:CGRectInset(icon.frame, -8, 0)];
    
    [seachView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [seachView setLeftView:icon];
    
    [seachView setDelegate:self];
    
    [icon release];
    
    //
    [customerAddBtn addTarget:self action:@selector(customerAddTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    customer = [[NSMutableDictionary dictionary] retain];
    
    id temp = [ManageAccess getCustomer:nil];
    
    if (temp)
    {
        [self orderOn:temp];
    }
}

- (void)dealloc 
{
    [addEvent release];
    [closeEvent release];
    [customer release];
    [seachView release];
    [customerAddBtn release];
    [cusTableView release];
    [super dealloc];
}

-(void)customerCancel:(UIButton*)sender
{
    if (closeEvent)
    {
        closeEvent(self);
    }
}

-(void)customerAddTouch:(UIButton*)sender
{
    if (addEvent)
    {
        addEvent(self);
    }
}

-(void)orderOn:(NSArray*)value
{
    //分类
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    
    for (NSDictionary *cus in value) 
    {
        id name = [cus objectForKey:@"name"];
        
        if (name != [NSNull null] && ![name isEqualToString:@""])
        {
            char cn = firstLetter([name characterAtIndex:0]);
            
            NSString *letter = [[NSString stringWithFormat:@"%c",cn] lowercaseString];
            
            if (nil == [temp objectForKey:letter])
            {
                [temp setValue:[NSMutableArray arrayWithObject:cus] forKey:letter];
            }
            else
            {
                [[temp objectForKey:letter] addObject:cus];
            }
        }
    }
    
    //排序
    NSArray *keys = [temp allKeys];
    
    NSArray *order = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //
    [customer removeAllObjects];
    
    for (NSString *key in order)
    {
        [customer setValue:[temp objectForKey:key] forKey:key];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    id key = nil;
    
    if (textField.text.length > 0)
    {
        key = textField.text;
    }
    
    //
    id temp = [ManageAccess getCustomer:textField.text];
    
    if (temp)
    {
        [self orderOn:temp];
        
        [cusTableView reloadData];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

//表格代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomerTitle *title = [Utils loadNibNamed:@"CustomerTitle"];
    
    title.titleView.text = [[customer allKeys] objectAtIndex:section];
    
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [customer allKeys];
}

/*-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return [[customer allKeys] objectAtIndex:section];
 }*/

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return true;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
    return [[customer allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [[customer allKeys] objectAtIndex:section];
    
    return [[customer objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    static NSString *customerTableIdentifier = @"customerTableIdentifier"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:customerTableIdentifier] autorelease];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    id key = [[customer allKeys] objectAtIndex:indexPath.section];
    
    id val = [[customer objectForKey:key] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [val objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        id key = [[customer allKeys] objectAtIndex:indexPath.section];
        
        id val = [[customer objectForKey:key] objectAtIndex:indexPath.row];
        
        id cid = [[ManageAccess getCurrentCustomer] objectForKey:@"id"];
        
        if (![cid isEqualToString:[val objectForKey:@"id"]])
        {
            [ManageAccess delCustomerWithId:[val objectForKey:@"id"]];
            
            //
            [[customer objectForKey:key] removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //
            if ([[customer objectForKey:key] count] == 0)
            {
                [customer removeObjectForKey:key];
                
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [[customer allKeys] objectAtIndex:indexPath.section];
    
    id val = [[customer objectForKey:key] objectAtIndex:indexPath.row];
    
    NSDictionary *curCustomer = [ManageAccess getCustomerWithId:[val objectForKey:@"id"]];
    
    if (curCustomer)
    {
        [self customerCancel:nil];
    }
}

@end
