//
//  Customer.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ChineseCharacters.h"
#import "ManageAccess.h"
#import "Utils.h"

#import "Customer.h"
#import "CustomerTitle.h"
#import "CustomerInterface.h"
#import "CustomerIntroduction.h"

@interface Customer()
{
    CustomerInterface *content;
    
    NSMutableDictionary *customers;
}

@property (retain, nonatomic) IBOutlet UIView *indexView;

@property (retain, nonatomic) IBOutlet UITableView *customerView;

//
@property (retain, nonatomic) IBOutlet UIButton *introductionButton;

@property (retain, nonatomic) IBOutlet UIButton *favoriteButton;

@property (retain, nonatomic) IBOutlet UIButton *cartButton;

@property (retain, nonatomic) IBOutlet UIButton *orderButton;

@property (retain, nonatomic) IBOutlet UITextField *seachView;

@end

//
@implementation Customer

@synthesize customerId;

@synthesize orderId;

@synthesize tabbedId;

//
@synthesize indexView;

@synthesize customerView;

@synthesize introductionButton;

@synthesize favoriteButton;

@synthesize cartButton;

@synthesize orderButton;

@synthesize seachView;

//
static NSString *indSelected = @"manage_index.png";

static uint top   = 45;

static uint left  = 201;

//
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addObserver:self forKeyPath:@"customerId" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"tabbedId" options:NSKeyValueObservingOptionNew context:nil];
    
    //
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manage_iconinput.png"]];
    
    [icon setContentMode:UIViewContentModeCenter];
    
    [icon setFrame:CGRectInset(icon.frame, -5, 0)];
    
    [seachView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [seachView setLeftView:icon];
    
    [seachView setDelegate:self];
    
    [icon release];
    
    //
    customerView.layer.borderWidth = 1.0;
    
    customerView.layer.borderColor = [[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
    
    //
    customers = [[NSMutableDictionary dictionary] retain];
    
    [self orderOn:[ManageAccess getCustomer:nil] data:&customers];
    
    [introductionButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [favoriteButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cartButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeIndexView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([[customers allKeys] count] > 0)
    {
        if ([keyPath isEqualToString:@"customerId"])
        {
            NSIndexPath *first = [self getIndexPathWithCustomerId:customerId];
            
            [customerView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
        if ([keyPath isEqualToString:@"tabbedId"])
        {
            switch (tabbedId) 
            {
                case 1:
                    [self onTouch:favoriteButton];
                    break;
                case 2:
                    [self onTouch:cartButton];
                    break;
                case 3:
                    [self onTouch:orderButton];
                    break;
                default:
                    [self onTouch:introductionButton];
                    break;
            } 
        }
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"customerId"];
    
    [self removeObserver:self forKeyPath:@"tabbedId"];
    
    [orderId release];
    
    [customerId release];
    
    [content release];
    
    [customers release];
    
    [indexView release];
    
    [customerView release];
    
    [introductionButton release];
    
    [favoriteButton release];
    
    [cartButton release];
    
    [orderButton release];
    
    [seachView release];
    
    [super dealloc];
}

//取选中
-(NSIndexPath*)getIndexPathWithCustomerId:(NSString*)value
{
    if (value) 
    {
        NSArray *key = [customers allKeys];
        
        for (uint i=0;i<key.count;i++)
        {
            NSArray *val = [customers objectForKey:[key objectAtIndex:i]];
            
            for (uint j=0;j<val.count;j++)
            {
                id cus = [val objectAtIndex:j];
                
                if ([[cus objectForKey:@"id"] isEqualToString:value])
                {
                    return [NSIndexPath indexPathForRow:j inSection:i];
                }
            }
        }
    }
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(void)orderOn:(NSArray*)value data:(NSMutableDictionary**)data
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
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    
    //
    [*data removeAllObjects];
    
    for (NSString *key in order)
    {
        [*data setValue:[temp objectForKey:key] forKey:key];
    }
}

-(void)onTouch:(UIButton*)sender
{
    introductionButton.selected = NO;
    
    favoriteButton.selected = NO;
    
    cartButton.selected = NO;
    
    orderButton.selected = NO;
    
    //
    if (content)
    {
        [content removeFromSuperview];
        
        [content release];
        
        content = nil;
    }
    
    if (sender == favoriteButton)
    {
        favoriteButton.selected = YES;
        //
        content = [[Utils loadNibNamed:@"CustomerFavorite"] retain];
    }
    else if (sender == cartButton)
    {
        cartButton.selected = YES;
        
        content = [[Utils loadNibNamed:@"CustomerCart"] retain];
    }
    else if (sender == orderButton)
    {
        orderButton.selected = YES;
        
        content = [[Utils loadNibNamed:@"CustomerOrder"] retain];
    }
    else 
    {
        introductionButton.selected = YES;
        
        content = [[Utils loadNibNamed:@"CustomerIntroduction"] retain];
    }
    
    if (content)
    {
        NSIndexPath *indexPath = [[customerView indexPathsForSelectedRows] lastObject];
        
        [self tableView:customerView didSelectRowAtIndexPath:indexPath];
        
        //
        [content setFrame:CGRectOffset(content.frame, left, top)];
        
        [self addSubview:content];
    }
}

//索引
-(void)makeIndexView
{
    for (id view in [indexView subviews])
    {
        [view removeFromSuperview];
    }
    
    //
    NSArray *key = [customers allKeys];
    
    CGFloat val = 23 * [[customers allKeys] count];
    
    CGFloat gap = (indexView.bounds.size.height - val) / ([key count] - 1);
    
    CGFloat top = 0;
    
    for (int i=0; i<[[customers allKeys] count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(indexTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageNamed:indSelected] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [btn setTitle:[key objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setFrame:CGRectMake(3, top, 26, 23)];
        
        [indexView addSubview:btn];
        
        top += 23 + gap;
        
        if (i==0)
        {
            [self indexTouch:btn];
        }
    }
}

-(void)indexTouch:(UIButton*)sender
{
    for (UIButton *btn in indexView.subviews)
    {
        [btn setSelected:(btn == sender)];
    }
    
    NSInteger section = [indexView.subviews indexOfObject:sender];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    [customerView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        [self orderOn:temp data:&customers];
        
        [self makeIndexView];
        
        [customerView reloadData];
        
        NSIndexPath *first = [self getIndexPathWithCustomerId:customerId];
        
        [customerView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

//代理tableview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomerTitle *title = [Utils loadNibNamed:@"CustomerTitle"];
    
    title.titleView.text = [[customers allKeys] objectAtIndex:section];
    
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [[customers allKeys] objectAtIndex:indexPath.section];
    
    content.customer = [[customers objectForKey:key] objectAtIndex:indexPath.row];
    
    if (orderId)
    {
        content.orderId = orderId;
        
        [orderId release];
        
        orderId = nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
    return [[customers allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [[customers allKeys] objectAtIndex:section];
    
    return [[customers objectForKey:key] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customerTableIdentifier = @"customerTableIdentifier"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:customerTableIdentifier] autorelease];
        //
        UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
        
        [background setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0]];
        
        [cell setSelectedBackgroundView:background];
        //
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        
        [cell.textLabel setHighlightedTextColor:[UIColor redColor]];
        
        [background release];
    }
    
    //新数据
    id key = [[customers allKeys] objectAtIndex:indexPath.section];
    
    id val = [[customers objectForKey:key] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [val  objectForKey:@"name"];
    
    return cell;
}

@end

