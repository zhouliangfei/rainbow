//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "NavigateView.h"
#import "UIShutterView.h"
#import "SandboxController.h"
#import "SandboxTitleView.h"
#import "SandboxProductView.h"

#import "Access.h"
#import "ManageAccess.h"
#import "PlanView2.h"
//
#import "StructData.h"

#define BUTTON_NAME     101

@interface SandboxController ()
{
    int shutterRow;
    
    NSString *productId;
    
    NSArray *products;
    
    PlanView2 *PlanView;
    
    //
    NSString *filePath;
    
    UITextField *keyFocus;
    
    UIScrollView *sandBoxView;
}
//
@property (retain, nonatomic) IBOutlet UIView *keyboardView;
@property (retain, nonatomic) IBOutlet UIButton *key1;
@property (retain, nonatomic) IBOutlet UIButton *key2;
@property (retain, nonatomic) IBOutlet UIButton *key3;
@property (retain, nonatomic) IBOutlet UIButton *key4;
@property (retain, nonatomic) IBOutlet UIButton *key5;
@property (retain, nonatomic) IBOutlet UIButton *key6;
@property (retain, nonatomic) IBOutlet UIButton *key7;
@property (retain, nonatomic) IBOutlet UIButton *key8;
@property (retain, nonatomic) IBOutlet UIButton *key9;
@property (retain, nonatomic) IBOutlet UIButton *key0;
@property (retain, nonatomic) IBOutlet UIButton *keyDot;
@property (retain, nonatomic) IBOutlet UIButton *keyCancel;

//
@property (retain, nonatomic) IBOutlet UIScrollView *roomView;
@property (retain, nonatomic) IBOutlet UIButton *room1;
@property (retain, nonatomic) IBOutlet UIButton *room2;
@property (retain, nonatomic) IBOutlet UIButton *room3;
@property (retain, nonatomic) IBOutlet UIButton *room4;
@property (retain, nonatomic) IBOutlet UIButton *room5;
@property (retain, nonatomic) IBOutlet UIButton *room6;
@property (retain, nonatomic) IBOutlet UIButton *room7;
@property (retain, nonatomic) IBOutlet UIButton *room8;
@property (retain, nonatomic) IBOutlet UIButton *room9;

//
@property (retain, nonatomic) IBOutlet UIShutterView *shutterView;
//
@property (retain, nonatomic) IBOutlet UIButton *singleButton;
@property (retain, nonatomic) IBOutlet UIButton *packageButton;
@property (retain, nonatomic) IBOutlet UIButton *caseButton;

@property (retain, nonatomic) IBOutlet UIButton *newfileBtn;
@property (retain, nonatomic) IBOutlet UIButton *zoomInBtn;
@property (retain, nonatomic) IBOutlet UIButton *zoomOutBtn;
@property (retain, nonatomic) IBOutlet UIButton *saveBtn;
@property (retain, nonatomic) IBOutlet UIButton *rulerBtn;
//
@property (retain, nonatomic) IBOutlet UITextField *lengthView;
@property (retain, nonatomic) IBOutlet UITextField *widthView;
//
@property (retain, nonatomic) IBOutlet UIControl *switchView;
@property (retain, nonatomic) IBOutlet UIImageView *switchDot;
@property (retain, nonatomic) IBOutlet UIImageView *switchBackground;

@end

//
@implementation SandboxController
@synthesize switchView;
@synthesize switchBackground;
@synthesize switchDot;
@synthesize saveBtn;
@synthesize rulerBtn;
@synthesize lengthView;
@synthesize widthView;
//
@synthesize singleButton;
@synthesize packageButton;
@synthesize caseButton;
@synthesize newfileBtn;
@synthesize zoomInBtn;
@synthesize zoomOutBtn;
//
@synthesize keyboardView;
@synthesize key1;
@synthesize key2;
@synthesize key3;
@synthesize key4;
@synthesize key5;
@synthesize key6;
@synthesize key7;
@synthesize key8;
@synthesize key9;
@synthesize key0;
@synthesize keyDot;
@synthesize keyCancel;
//
@synthesize roomView;
@synthesize room1;
@synthesize room2;
@synthesize room3;
@synthesize room4;
@synthesize room5;
@synthesize room6;
@synthesize room7;
@synthesize room8;
@synthesize room9;
//
@synthesize shutterView;


-(PlanView2*)makePlanView
{
    PlanView2 *Plan = [[PlanView2 alloc] initWithFrame:CGRectMake(2, 2, 643, 643)];
    
    [Plan setParent:self];
    
    [Plan setLeftMargin:0];
    
    [Plan setTopMargin:0];
    
    [Plan setLineWidth:10];
    
    [Plan setHandleEvent:YES];
    
    [Plan setShowGrid:YES];
    
    [Plan showWallSize:YES];

    return [Plan autorelease];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    }
    
    return self;
}

- (void)viewDidLoad
{
    if (window.location.search)
    {
        productId = [window.location.search retain];
    }
    else 
    {
        return;
    }
    //菜单
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    menu.title.text = @"户型模拟";
    
    [self.view addSubview:menu];
    
    //
    sandBoxView = [[UIScrollView alloc] initWithFrame:CGRectMake(42, 72, 647, 647)];
    [sandBoxView setDelegate:self];
    [sandBoxView setMinimumZoomScale:1.0];
    [sandBoxView setMaximumZoomScale:3.0];
    [sandBoxView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [sandBoxView.layer setBorderWidth:2.f];
    [sandBoxView setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:sandBoxView belowSubview:keyboardView];
    
    //
    [roomView setContentSize:CGSizeMake(680, 44)];
    [room1 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room2 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room3 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room4 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room5 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room6 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room7 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room8 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    [room9 addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    //
    [key0 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key1 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key2 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key3 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key4 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key5 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key6 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key7 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key8 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [key9 addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [keyDot addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    [keyCancel addTarget:self action:@selector(keyTouch:) forControlEvents:UIControlEventTouchUpInside];
    //
    [singleButton addTarget:self action:@selector(tabedTouch:) forControlEvents:UIControlEventTouchUpInside];
    [packageButton addTarget:self action:@selector(tabedTouch:) forControlEvents:UIControlEventTouchUpInside];
    [caseButton addTarget:self action:@selector(tabedTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self tabedTouch:singleButton];
    //
    [newfileBtn addTarget:self action:@selector(newfileTouch:) forControlEvents:UIControlEventTouchUpInside];
    [zoomInBtn addTarget:self action:@selector(zoomInTouch:) forControlEvents:UIControlEventTouchUpInside];
    [zoomOutBtn addTarget:self action:@selector(zoomOutTouch:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn addTarget:self action:@selector(saveTouch:) forControlEvents:UIControlEventTouchUpInside];
    [rulerBtn addTarget:self action:@selector(rulerTouch:) forControlEvents:UIControlEventTouchUpInside];
    [switchView addTarget:self action:@selector(lockTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [self roomTouch:room1];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    filePath = nil;
    sandBoxView = nil;
    [self setShutterView:nil];
    [self setSingleButton:nil];
    [self setPackageButton:nil];
    [self setCaseButton:nil];
    [self setSaveBtn:nil];
    [self setRulerBtn:nil];
    [self setKeyboardView:nil];
    [self setRoomView:nil];
    [self setLengthView:nil];
    [self setWidthView:nil];
    [self setKey1:nil];
    [self setKey2:nil];
    [self setKey3:nil];
    [self setKey4:nil];
    [self setKey5:nil];
    [self setKey6:nil];
    [self setKey7:nil];
    [self setKey8:nil];
    [self setKey9:nil];
    [self setKey0:nil];
    [self setKeyDot:nil];
    [self setKeyCancel:nil];
    [self setRoom1:nil];
    [self setRoom2:nil];
    [self setRoom3:nil];
    [self setRoom4:nil];
    [self setRoom5:nil];
    [self setRoom6:nil];
    [self setRoom7:nil];
    [self setRoom8:nil];
    [self setRoom9:nil];
    [self setSwitchView:nil];
    [self setSwitchBackground:nil];
    [self setNewfileBtn:nil];
    [self setZoomInBtn:nil];
    [self setZoomOutBtn:nil];
    [self setSwitchDot:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [filePath release];
    [sandBoxView release];
    [products release];
    [shutterView release];
    [singleButton release];
    [packageButton release];
    [caseButton release];
    [saveBtn release];
    [rulerBtn release];
    [keyboardView release];
    [roomView release];
    [lengthView release];
    [widthView release];
    [key1 release];
    [key2 release];
    [key3 release];
    [key4 release];
    [key5 release];
    [key6 release];
    [key7 release];
    [key8 release];
    [key9 release];
    [key0 release];
    [keyDot release];
    [keyCancel release];
    [room1 release];
    [room2 release];
    [room3 release];
    [room4 release];
    [room5 release];
    [room6 release];
    [room7 release];
    [room8 release];
    [room9 release];
    [switchView release];
    [switchBackground release];
    [newfileBtn release];
    [zoomInBtn release];
    [zoomOutBtn release];
    [switchDot release];
    [super dealloc];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1.0)
    {
        [PlanView setCenter:CGPointMake(scrollView.bounds.size.width * 0.5, scrollView.bounds.size.height * 0.5)];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return PlanView;
}

- (void)roomTouch:(UIButton*)sender
{
    if (NO == sender.selected)
    {
        for (UIButton *btn in roomView.subviews)
        {
            if ([btn isKindOfClass:[UIButton class]]) 
            {
                btn.selected = (btn == sender);
            }
        }
        
        [filePath release];
        
        if (sender == room1)
        {
            filePath = [[Utils getPathWithSource:@"scratch1.txt"] retain];
            goto finishRoom;
        }
        if (sender == room2)
        {
            filePath = [[Utils getPathWithSource:@"scratch2.txt"] retain];
            goto finishRoom;
        }
        if (sender == room3)
        {
            filePath = [[Utils getPathWithSource:@"scratch3.txt"] retain];
            goto finishRoom;
        }
        if (sender == room4)
        {
            filePath = [[Utils getPathWithSource:@"scratch4.txt"] retain];
            goto finishRoom;
        }
        if (sender == room5)
        {
            filePath = [[Utils getPathWithSource:@"scratch5.txt"] retain];
            goto finishRoom;
        }
        if (sender == room6)
        {
            filePath = [[Utils getPathWithSource:@"scratch6.txt"] retain];
            goto finishRoom;
        }
        if (sender == room7)
        {
            filePath = [[Utils getPathWithSource:@"scratch7.txt"] retain];
            goto finishRoom;
        }
        if (sender == room8)
        {
            filePath = [[Utils getPathWithSource:@"scratch8.txt"] retain];
            goto finishRoom;
        }
        if (sender == room9)
        {
            filePath = [[Utils getPathWithSource:@"scratch9.txt"] retain];
            goto finishRoom;
        }
        
    finishRoom:
        
        if (filePath)
        {
            [self planViewLoadFile:filePath savePath:nil name:nil];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if(touch.view==keyboardView)
    {
        [UIView beginAnimations:nil context:nil];
        
        [keyboardView setAlpha:0.0];
        
        [UIView commitAnimations];
        //
        if (PlanView)
        {
            float tw = fmax(1.0,fmin(10.f, widthView.text.floatValue));
            
            float th = fmax(1.0,fmin(10.f, lengthView.text.floatValue));
            //
            [PlanView getData].roomWidth = tw;
            
            [PlanView getData].roomHeight = th;
            
            [PlanView roomSizeChanged];
        }
    }
}

-(void)keyTouch:(UIButton *)sender
{
    if (sender == keyCancel)
    {
        if (keyFocus.text.length > 0)
        {
            keyFocus.text = [keyFocus.text substringToIndex:keyFocus.text.length-1];
        }
    }
    else 
    {
        NSString *val = nil;
        
        if (sender == key0)
        {
            val = @"0";
            goto finishKey;
        }
        if (sender == key1)
        {
            val = @"1";
            goto finishKey;
        }
        if (sender == key2)
        {
            val = @"2";
            goto finishKey;
        }
        if (sender == key3)
        {
            val = @"3";
            goto finishKey;
        }
        if (sender == key4)
        {
            val = @"4";
            goto finishKey;
        }
        if (sender == key5)
        {
            val = @"5";
            goto finishKey;
        }
        if (sender == key6)
        {
            val = @"6";
            goto finishKey;
        }
        if (sender == key7)
        {
            val = @"7";
            goto finishKey;
        }
        if (sender == key8)
        {
            val = @"8";
            goto finishKey;
        }
        if (sender == key9)
        {
            val = @"9";
            goto finishKey;
        }
        if (sender == keyDot)
        {
            val = @".";
            goto finishKey;
        }
        
    finishKey:
        keyFocus.text = [keyFocus.text stringByAppendingString:val];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    
    [keyboardView setAlpha:1.0];
    
    [UIView commitAnimations];

    keyFocus = textField;
    
    keyFocus.text = @"";
    
    return NO;
}

-(void)saveTouch:(UIButton*)sender
{
    if (PlanView.name)
    {
        //保存数据
        if ([ManageAccess getCurrentCustomer])
        {
            [PlanView savePlan];
            
            PlanData *dat = [PlanView getData];
            //
            id sid = [[ManageAccess getCurrentSales] objectForKey:@"id"];
            
            id cid = [[ManageAccess getCurrentCustomer] objectForKey:@"id"];
            
            [Access saveSandBoxWithCustomerId:cid salesId:sid path:dat.filePath name:PlanView.name];
        }
        else
        {
            MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
            
            alert.onclose = ^(id target)
            {
                [self saveTouch:sender];
            };
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"设置文件名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [alert setTag:BUTTON_NAME];
        
        [alert show];
        
        [alert release];
    }
}

-(void)newfileTouch:(UIButton*)sender
{
    if (filePath)
    {
        [self planViewLoadFile:filePath savePath:nil name:nil];
    }
}

-(void)lockTouch:(UIControl*)sender
{
    PlanView.lock = !PlanView.lock;
    
    sender.selected = PlanView.lock;
    
    //
    [UIView beginAnimations:nil context:nil];
    
    if (sender.selected)
    {
        switchDot.frame = CGRectMake(45, 0, 25, 25);
        
        switchBackground.image = [UIImage imageNamed:@"box_off.png"];
    }
    else 
    {
        switchDot.frame = CGRectMake(68, 0, 25, 25);
        
        switchBackground.image = [UIImage imageNamed:@"box_on.png"];
    }
    
    [UIView commitAnimations];
}

-(void)rulerTouch:(UIButton*)sender
{
    PlanView.ruler = !PlanView.ruler;
    
    sender.selected = PlanView.ruler;
}

-(void)zoomInTouch:(UIButton*)sender
{
    if (sandBoxView.zoomScale > sandBoxView.minimumZoomScale)
    {
        [sandBoxView setZoomScale:sandBoxView.zoomScale-1 animated:YES];
    }
}

-(void)zoomOutTouch:(UIButton*)sender
{
    if (sandBoxView.zoomScale < sandBoxView.maximumZoomScale)
    {
        [sandBoxView setZoomScale:sandBoxView.zoomScale+1 animated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            if (alertView.tag==BUTTON_NAME)
            {
                NSString *value = [alertView textFieldAtIndex:0].text;
                
                if (value.length > 0)
                {
                    PlanView.name = value;
                    
                    [self saveTouch:nil];
                }
            }
    }
}

-(void)planViewLoadFile:(NSString*)files savePath:(NSString*)savePath name:(NSString*)name
{
    PlanData *dataPlan = [[[PlanData alloc] init] autorelease];
    
    [dataPlan setBoolClosePath:YES];
    
    [dataPlan load:files];
    
    [dataPlan setFilePath:savePath];
    
    //删除上一个
    if (PlanView)
    {
        [PlanView removeObserver:self forKeyPath:@"roomWidth"];
        
        [PlanView removeObserver:self forKeyPath:@"roomHeight"];
        
        [PlanView removeObserver:self forKeyPath:@"ruler"];
        
        [PlanView removeFromSuperview];
        
        [PlanView release];
    }
    
    //生成新的
    PlanView = [[self makePlanView] retain];
    
    [PlanView addObserver:self forKeyPath:@"ruler" options:NSKeyValueObservingOptionNew context:nil];
    
    [PlanView addObserver:self forKeyPath:@"roomWidth" options:NSKeyValueObservingOptionNew context:nil];
    
    [PlanView addObserver:self forKeyPath:@"roomHeight" options:NSKeyValueObservingOptionNew context:nil];
    
    [PlanView setData:dataPlan];
    
    [PlanView setName:name];
    
    [PlanView setFocusObject:nil]; 
    
    [PlanView setRuler:rulerBtn.selected];
    
    [PlanView setLock:switchView.selected];
    
    [sandBoxView addSubview:PlanView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"ruler"])
    {
        BOOL focus = ([[change objectForKey:@"new"] boolValue]);
        
        [rulerBtn setSelected:focus];
    }
    
    if ([keyPath isEqualToString:@"roomWidth"])
    {
        widthView.text = [NSString stringWithFormat:@"%0.2f",[PlanView getData].roomWidth];
    }
    
    if ([keyPath isEqualToString:@"roomHeight"])
    {
        lengthView.text = [NSString stringWithFormat:@"%0.2f",[PlanView getData].roomHeight];
    }
}


-(void)tabedTouch:(UIButton*)sender
{
    singleButton.selected  = NO;
    
    packageButton.selected = NO;
    
    caseButton.selected    = NO;
    
    //
    if (products) 
    {
        [products release];
        
        products = nil;
    }
    
    //
    if (sender == singleButton) 
    {
        singleButton.selected = YES;
        
        products = [[Access getSandBoxGoodsWithProductId:productId] retain];
    }
    else if(sender == packageButton)
    {
        packageButton.selected = YES;
        
        products = [[Access getSandBoxGoodsPackageWithProductId:productId] retain];
    }
    else 
    {
        caseButton.selected = YES;
        
        //保存数据
        if ([ManageAccess getCurrentCustomer])
        {
            id sid = [[ManageAccess getCurrentSales] objectForKey:@"id"];
            
            id cid = [[ManageAccess getCurrentCustomer] objectForKey:@"id"];
            
            products = [[Access openSandBoxWithCustomerId:cid salesId:sid] retain];
        }
        else
        {
            MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
            
            alert.onclose = ^(id target)
            {
                [self tabedTouch:sender];
            };
            
            return;
        }
    }

    [shutterView reloadData];
}

-(void)cellTouch:(UIControl*)sender
{
    [PlanView addObjWithId:sender.tag];
}

//shutter代理
-(void)shutterCellWithPackage:(UIShutterViewCell*)cell row:(NSInteger)row
{
    if (caseButton.selected) 
    {
        id package = [products objectAtIndex:row];
        
        //标题
        SandboxTitleView *view = [Utils loadNibNamed:@"SandboxTitleView"];
        
        [view setUserInteractionEnabled:NO];

        [view.titleView setText:[package objectForKey:@"name"]];
        
        [cell setTitleView:view];
        
        //
        NSArray *goods = [package objectForKey:@"goods"];
        
        uint top = 0;
        
        for (uint i=0; i<goods.count; i++)
        {
            id good = [goods objectAtIndex:i];
            
            SandboxProductView *temp = [Utils loadNibNamed:@"SandboxProductView"];
            
            //画线
            if (i > 0) 
            {
                UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sandbox_lineH.png"]];
                
                [line setFrame:CGRectOffset(line.frame, 0,top++)];
                
                [cell.contentView addSubview:line];
                
                [line release];
            }
            
            //内容
            [temp setFrame:CGRectOffset(temp.frame, 0, top)];
            
            [temp.imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:[good objectForKey:@"photo"]]]];
            
            [temp.specificationsView setText:[good objectForKey:@"specifications"]];
            
            [temp.nameView setText:[good objectForKey:@"name"]];
            
            [temp.colorView setText:[good objectForKey:@"colorcase"]];
            
            if (packageButton.selected) 
            {
                [temp setTag:[[good objectForKey:@"id"] intValue]];
                
                [temp addTarget:self action:@selector(cellTouch:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell.contentView addSubview:temp];
            
            top += temp.frame.size.height;
        }
        
        [cell.contentView setContentSize:CGSizeMake(cell.bounds.size.width, top)];
    }
    else 
    {
        [[StructData sharedStructData] removeAllObject];
        
        //
        uint top = 8;
        
        for (uint i=0; i<products.count; i++)
        {
            id good = [products objectAtIndex:i];
            
            SandboxProductView *temp = [Utils loadNibNamed:@"SandboxSpecificationView"];

            //内容
            [temp setFrame:CGRectOffset(temp.frame, i % 2 * 126 + 9, top)];
            
            [temp.imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:[good objectForKey:@"photo"]]]];
            
            [temp.specificationsView setText:[good objectForKey:@"name"]];
            
            [temp setTag:[[good objectForKey:@"id"] intValue]];
            
            [temp addTarget:self action:@selector(cellTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:temp];
            
            [cell.contentView setContentSize:CGSizeMake(cell.bounds.size.width, top+temp.frame.size.height)];
            
            if (i % 2 == 1)
            {
                top += temp.frame.size.height;
                
                if (i > 0)
                {
                    top += 8;
                    //画线
                    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sandbox_lineH.png"]];
                    
                    [line setFrame:CGRectOffset(line.frame, 0,top++)];
                    
                    [cell.contentView addSubview:line];
                    
                    [line release];
                    
                    top += 9;
                }
            }
            
            [[StructData sharedStructData] addObject:good];
        }
    }
}

-(NSInteger)numberOfRowsInShutterView:(UIShutterView *)shutter;
{
    if (caseButton.selected)
    {
        return [products count];
    }
    
    return 1;
}

-(UIShutterViewCell *)shutterView:(UIShutterView *)shutter cellAtRow:(NSInteger)row
{
    UIShutterViewCell *cell = [[[UIShutterViewCell alloc] init] autorelease];
    
    [self shutterCellWithPackage:cell row:row];
    
    cell.active = (row==0);
    
    return cell;
}

-(void)shutterView:(UIShutterView *)shutter touchCellAtRow:(NSInteger)row
{
    shutterRow = row;
    
    UIShutterViewCell *cell = [shutter cellAtRow:row];
    
    if (NO == cell.active)
    {
        [shutter setSelected:row];
    }
    
    for (UIShutterViewCell *temp in shutter.subviews)
    {
        SandboxTitleView *tit = (SandboxTitleView*)temp.titleView;
        
        if (tit)
        {
            tit.selected = temp.active;
        }
    }
    
    if (caseButton.selected)
    {
        id package = [products objectAtIndex:row];
        
        NSString *files = [Utils getPathWithFile:[package objectForKey:@"file"]];
        
        [self planViewLoadFile:files savePath:filePath name:[package objectForKey:@"name"]];
    }
}

-(CGFloat)titleHeightInShutterView:(UIShutterView *)shutter cellAtRow:(NSInteger)row
{
    if (singleButton.selected || packageButton.selected || [products count]==0)
    {
        return 0;
    }
    
    return 26;
}
@end
