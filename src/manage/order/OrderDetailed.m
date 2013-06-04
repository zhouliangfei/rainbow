//
//  CustomerFavorite.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "ManageAccess.h"
#import "OrderCartCell.h"
#import "OrderDetailed.h"
#import "PrintView.h"

@interface OrderDetailed()
{
    NSMutableArray *cart;
    
    NSMutableDictionary *printData;
}

@property (retain, nonatomic) IBOutlet UITextView *noteView;

@property (retain, nonatomic) IBOutlet UITableView *cartView;

@property (retain, nonatomic) IBOutlet UIButton *backButton;
//
@property (retain, nonatomic) IBOutlet UILabel *codeView;

@property (retain, nonatomic) IBOutlet UILabel *dateView;

@property (retain, nonatomic) IBOutlet UILabel *nameView;

@property (retain, nonatomic) IBOutlet UILabel *addressView;

@property (retain, nonatomic) IBOutlet UILabel *priceView;

@property (retain, nonatomic) IBOutlet UIButton *delOrder;

@property (retain, nonatomic) IBOutlet UIButton *printBtn;

@end

//
@implementation OrderDetailed

@synthesize codeView;

@synthesize dateView;

@synthesize nameView;

@synthesize addressView;

@synthesize priceView;
@synthesize delOrder;
@synthesize printBtn;

@synthesize delegate;

@synthesize noteView;
@synthesize cartView;

@synthesize backButton;

@synthesize cellNibNamed;

@synthesize order;

static NSString *selectKey = @"select";

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setCellNibNamed:@"OrderCartCell"];

    [backButton addTarget:self action:@selector(backTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [printBtn addTarget:self action:@selector(printTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    noteView.contentInset = UIEdgeInsetsZero;
}

-(void)backTouch:(UIButton*)sender
{
    [delegate backEvent];
}

-(void)setOrder:(NSDictionary *)value
{
    [order release];
    
    order = [value retain];
    
    //
    codeView.text = [self getString:[value objectForKey:@"code"]];
    
    dateView.text = [self getString:[value objectForKey:@"createDate"]];
    
    nameView.text = [self getString:[value objectForKey:@"name"]];
    
    addressView.text = [self getString:[value objectForKey:@"address"]];
    
    priceView.text = [self getString:[value objectForKey:@"total"]];
    
    noteView.text = [self getString:[value objectForKey:@"note"]];
    
    [delOrder setHidden:([[value objectForKey:@"status"] intValue]!=0)];
    
    [delOrder addTarget:self action:@selector(delTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [printBtn addTarget:self action:@selector(printTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [cart release];
    
    cart = [[ManageAccess getGoodsWithCartId:[value objectForKey:@"id"]] retain];
    
    for (NSMutableDictionary *dic in cart)
    {
        [dic setValue:[NSNumber numberWithBool:NO] forKey:selectKey];
    }
    
    [cartView reloadData];
    
    //。。。。。。。。。。。。。。。。。。。打印
    printData = [[NSMutableDictionary dictionaryWithDictionary:value] retain];
    
    int row = ceilf((float)[cart count] / 3.0);
    
    NSMutableArray *rows = [NSMutableArray array];
    
    for (int i=0; i<row; i++) 
    {
        NSMutableArray *cols = [NSMutableArray array];
        
        for (int j=0; j<3; j++)
        {
            int index = i * 3 + j;
            
            if (index < [cart count])
            {
                NSMutableDictionary *good = [NSMutableDictionary dictionaryWithDictionary:[cart objectAtIndex:index]];
                
                if (j<2)
                {
                    [good setObject:[NSNumber numberWithBool:YES] forKey:@"drawLine"];
                }
                else 
                {
                    [good setObject:[NSNumber numberWithBool:NO] forKey:@"drawLine"];
                }
                //
                id photo = [Utils getPathWithFile:[good objectForKey:@"photo"]];
                
                [good setObject:[NSString stringWithFormat:@"file://%@",photo] forKey:@"photo"];
                //
                id specPhoto = [Utils getPathWithFile:[good objectForKey:@"specPhoto"]];
                
                [good setObject:[NSString stringWithFormat:@"file://%@",specPhoto] forKey:@"specPhoto"];
                //
                [cols addObject:good];
            }
        }
        
        //
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        
        [row setObject:cols forKey:@"cols"];
        
        [rows addObject:row];
    }
    
    [printData setObject:rows forKey:@"rows"];
}

-(void)printTouch:(UIButton*)sender
{
    if (printData)
    {
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        
        if  (controller) 
        {
            PrintView *printView = [[PrintView alloc] initWithFrame:CGRectMake(0, 0, 595, 842)];
            
            id data = [printView loadTemplateWithData:[Utils getPathWithSource:@"print.html"] order:printData];            
            //
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            
            printInfo.outputType = UIPrintInfoOutputGeneral;
            
            printInfo.orientation = UIPrintInfoOrientationPortrait;
            
            controller.printInfo = printInfo;
            
            controller.showsPageRange = YES;
            
            controller.printingItem = data;
            
            UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) 
            {
                if(completed && error)
                {
                    NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
                }
            };
            
            [controller presentFromRect:sender.frame inView:self animated:YES completionHandler:completionHandler];
            
            [printView release];
        }
    }
}

-(NSString*)getFloat:(id)value
{
    if (value==nil || value==NULL || value==[NSNull null])
    {
        return @"0.0";
    }
    
    return [NSString stringWithFormat:@"%0.2f",[value floatValue]];
}

-(NSString*)getString:(id)value
{
    if (value==nil || value==NULL || value==[NSNull null])
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@",value];
}


- (void)dealloc
{
    [cart release];
    
    [cartView release];
    
    [backButton release];
    
    [codeView release];
    
    [dateView release];
    
    [nameView release];
    
    [addressView release];
    
    [priceView release];
    
    [cellNibNamed release];
    
    [printBtn release];
    
    [printData release];
    
    [delOrder release];
    [noteView release];
    [super dealloc];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        id oid = [order objectForKey:@"id"];
        
        [ManageAccess delOrderWithId:oid];
        
        [delegate backAndUpdataEvent];
    }
}

-(void)delTouch:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要删除当前订单!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    [alert release];
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
        cell = [Utils loadNibNamed:cellNibNamed];
        
        [cell setDelegate:self];
    }
    
    NSDictionary *dic = [cart objectAtIndex:indexPath.row];
    
    [cell setActive:[[dic objectForKey:selectKey] boolValue]];
    
    [cell updata:dic];
    
    return cell;
}

-(void)statusChange:(id)target
{
    
}
@end
