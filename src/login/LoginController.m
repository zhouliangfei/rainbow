//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "LoginController.h"
#import "ManageAccess.h"
#import "global.h"

#define LOGINDEFAULTUSER @"loginDefaultUser"

@interface LoginController ()
{
    UIView *copyView ;
    
    UIButton *remb;
    
    UIButton *remb2;
    
    Boolean  rem;
    
    int cun;
    
    UIView *bottom;
    
    UITextField *nameView;
    
    UITextField *passView;
}

//@property (retain, nonatomic) IBOutlet UIView *inputView;
//@property (retain, nonatomic) IBOutlet UITextField *nameView;
//@property (retain, nonatomic) IBOutlet UITextField *passView;
@property (retain, nonatomic) IBOutlet UIButton *infoButton;

@end

//
@implementation LoginController

//@synthesize inputView;
//@synthesize nameView;
//@synthesize passView;
@synthesize infoButton;

- (IBAction)inforTouch:(id)sender 
{
    copyView = [[UIView alloc] initWithFrame:CGRectMake(798, 570, 213, 187)];
    
    [copyView addSubview:[global imageWithSource:@"copy_back.png" frame:CGRectMake(0, 0,  213, 187)]];
    
    [copyView addSubview:[global imageWithSource:@"copy_line.png" frame:CGRectMake(0, 25,  213, 127)]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 1, 227, 23) name:@"系统名称：" value:@"虹桥可视化营销系统" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 26, 227, 23) name:@"当前版本：" value:@"v1.0" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 51, 227, 23) name:@"最后更新时间：" value:@"2013.3.16" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 77, 227, 23) name:@"最后同步时间：" value:@"2013.3.16" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 101, 227, 23) name:@"版权所有：" value:@"虹桥" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 126, 227, 23) name:@"技术支持：" value:@"上海龙安互动" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 151, 227, 23) name:@"QQ群：" value:@"323385342" margin:88]];
    
    [self.view addSubview:copyView];
    
    [self.view.layer addAnimation:[CATransition animation] forKey:nil];
    
    [copyView release];
    
}

-(void)copy_hidden
{
    if (copyView) 
    {
        [self.view.layer addAnimation:[CATransition animation] forKey:nil];
        
        [copyView removeFromSuperview];
        
        copyView = nil;
    } 
}

//
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self copy_hidden];
}

//
-(id)creatLable:(CGRect)frame name:(NSString*)nameStr value:(NSString*)valueStr margin:(int)margin
{
    UIView *item = [[UIView alloc] initWithFrame:frame];
    //
    UILabel *lef = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, margin, frame.size.height)];
    
    lef.backgroundColor = [UIColor clearColor];
    
    lef.font = [UIFont systemFontOfSize:12];
    
    lef.textAlignment = UITextAlignmentRight;
    
    lef.textColor = [UIColor grayColor];
    
    lef.text = nameStr;
    
    [item addSubview:lef];
    
    [lef release];
    //
    UILabel *rig = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, frame.size.width-margin, frame.size.height)];
    
    rig.backgroundColor = [UIColor clearColor];
    
    rig.font = [UIFont systemFontOfSize:12];
    
    rig.text = valueStr;
    
    rig.textColor = [UIColor whiteColor];
    
    [item addSubview:rig];
    
    [rig release];

    return [item autorelease];
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
    [self.view addSubview:bottom = [[UIView alloc] initWithFrame:CGRectMake(254, 715, 664, 42)]];
    
    [bottom addSubview:[global imageWithSource:@"login_bg.png" frame:CGRectMake(0, 0, 564, 42)]];
    
    [bottom addSubview:(remb =[global buttonWithSource:@"h_1.png" frame:CGRectMake(436, 13, 38, 20) target:self event:@selector(choose_click:)])];
    
    [bottom addSubview:(remb2 =[global buttonWithSource:@"h_2.png" frame:CGRectMake(436, 13, 38, 20) target:self event:@selector(choose_click:)])];
    
    remb2.alpha = 0;
    
    //[bottom addSubview:[global imageWithSource:@"home_rem.png" frame:CGRectMake(242, 79, 67, 8)]];
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[global bitmapWithFile:@"login_login.png"] forState:UIControlStateNormal];
    
    [btn setFrame:CGRectInset(CGRectMake(487, 16, 44, 12), -10, -10)];
    
    [btn addTarget:self action:@selector(login_click) forControlEvents:UIControlEventTouchUpInside];
    
    [bottom addSubview:btn];
    
    //
    [bottom addSubview:nameView = [self creatText:CGRectMake(102,11,126,21) size:15 color:[UIColor blackColor]]];
    
    nameView.returnKeyType = UIReturnKeyNext;
    
    nameView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //
    [bottom addSubview:passView = [self creatText:CGRectMake(300,11,126,21) size:15 color:[UIColor blackColor]]];
    
    passView.returnKeyType = UIReturnKeyGo;
    
    passView.secureTextEntry = YES;
    
    //
    id user = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINDEFAULTUSER];
    
    if (user)
    {
        NSArray *splitarray = [user componentsSeparatedByString:@","];
        
        nameView.text=[splitarray objectAtIndex:0];
        
        passView.text=[splitarray objectAtIndex:1];

        remb2.alpha = 1;
        
        remb.alpha = 0;
        
        rem = YES;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)choose_click:(UIButton *)btn{
    
    cun++;
    
    btn.selected=TRUE; 
    
    rem=TRUE;
    
    remb2.alpha = 1;
    
    remb.alpha = 0;
    
    if(cun%2==0)
    {
        
        remb2.alpha = 0;
        
        remb.alpha = 1;
        
        btn.selected=FALSE;  
        
        rem=FALSE;
    }
    
}

-(NSString *) readFromFile:(NSString *)filepath;
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSArray *array=[[NSArray alloc] initWithContentsOfFile:filepath];
        
        NSString *datas=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        
        [array release];
        
        return datas;
    }
    else
    {
        return nil;
    }
}
-(void)writetoFile:(NSString *)text withFileName:(NSString *)filePath;
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    [array addObject:text];
    
    [array writeToFile:filePath atomically:YES];
    
    [array release];
}

//

- (void)viewDidUnload
{
  
    
//    [self setInfoButton:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc
{ 
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [nameView release];
    
    [passView release];
    
    [infoButton release];
    
    [super dealloc];
}


- (id)creatText:(CGRect)frame size:(int)size color:(UIColor *)color
{
    UITextField *temp = [[UITextField alloc] initWithFrame:frame];
    
    [temp setBackgroundColor:[UIColor clearColor]];
    
    [temp setTextColor:color];
    
    [temp setDelegate:self];
    
    [temp setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [temp setFont:[UIFont systemFontOfSize:size]]; 
    
   // [temp addSubview:[global imageWithSource:@"1.png" frame:CGRectMake(0, 0, frame.size.width, frame.size.height)]];
    
    return [temp autorelease];
}

//键盘隐藏事件
-(void)keyboardWillHide:(NSNotification *)sender
{
    [UIView beginAnimations:nil context:nil];
    
    bottom.frame = CGRectMake(254, 715, 664, 42);
    
    [UIView commitAnimations];
}
//文本代理事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    
    bottom.frame = CGRectMake(254, 715-350, 664, 42);
    
    [UIView commitAnimations];
}

-(void)login_click
{
    if(rem==TRUE)
    {
        id data = [NSString stringWithFormat:@"%@,%@",nameView.text,passView.text];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:LOGINDEFAULTUSER];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LOGINDEFAULTUSER];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    //
    id sales = [ManageAccess loginWithSalesName:nameView.text passWord:passView.text];
    
    if (sales)
    {
        if ([sales isKindOfClass:[NSError class]])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败！" message:((NSError*)sales).localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
            [alert release]; 
        }
        else 
        {
            window.location = [MSRequest requestWithName:@"HomeController"];
            
            /*if ([self isTimeout])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"试用版已过期！" message:@"请联系系统开发商！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];
                
                [alert release];
            }
            else 
            {
                window.location = [MSRequest requestWithName:@"HomeController"];
            }*/
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆错误！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        [alert release]; 
    }
}

-(BOOL)isTimeout
{
    //zhouliangfei 过期
    static NSString *useDate = @"useDate";
    
    NSString *loginTime = [[NSUserDefaults standardUserDefaults] objectForKey:useDate];
    
    //
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateStyle:NSDateFormatterShortStyle];
    
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //
    
    if (nil == loginTime)
    {
        loginTime = [format stringFromDate:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults] setObject:loginTime forKey:useDate];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSDate *date = [format dateFromString:loginTime];
    
    [format release];
    
    //
    return ([date timeIntervalSinceNow] < -86400*30);
}

@end
