//
//  Home.m
//  KUKA
//
//  Created by liangfei zhou on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "HomeNavigate.h"

#import "OBShapedButton.h"

@interface Home()

- (void)initNavigate;

- (id)getImages:(NSString *)path total:(int)value;

- (void)creatAnimationButton:(NSString *)path frame:(CGRect)rect action:(SEL)event total:(int)value;

-(id)creatLable:(CGRect)frame name:(NSString*)nameStr value:(NSString*)valueStr margin:(int)margin;

@end

@implementation Home


-(void)buttonTouch:(HomeNavigateLayer2 *)sender
{
    
    NSLog(@"%d   ===    ",sender.tag);
 
    sender.userInteractionEnabled = NO;
    
    if(sender.tag == 1002 || sender.tag == 1007)
    {
        [self home_qjty_click];
    }
    
    if(sender.tag == 1003 || sender.tag == 1008)
    {
        
        [self home_cpmd_click];
        
    }
    if(sender.tag == 1004 || sender.tag == 1009)
    {
        [self home_cpzx_click];
    }
    if(sender.tag == 1000 || sender.tag == 1005)
    {
        
        [self home_xnzt_click];
        
    }
    if(sender.tag == 1001 || sender.tag == 1006)
    {
        [self home_ppwh_click];
    }
}

- (void)initApp
{
    //产品里面用的
    
    romid = 0;
    
    productIndex = 0;
    
    choose = false;
    
    goabled = 0;
    
    goabled_erji = 0;
    
    goabled2 = 0;
    
    //电子书里面用的
    goableds = 0;
    
    favbol = NO;

    //背景
    [self addSubview:[global imageWithSource:@"background.png" frame:CGRectMake(0, 0, 1024, 768)]];
    //菜单
    
    //
//    [self creatAnimationButton:@"ppwh_%d.png" frame:CGRectMake(3, 268, 253, 220) action:@selector(home_ppwh_click) total:38];
//    
//    [self creatAnimationButton:@"qjty_%d.png" frame:CGRectMake(197, 279, 253, 220) action:@selector(home_qjty_click) total:38];
//
//    [self creatAnimationButton:@"cpzx_%d.png" frame:CGRectMake(576, 266, 253, 220) action:@selector(home_cpzx_click) total:36];
//    
//    [self creatAnimationButton:@"cpmd_%d.png" frame:CGRectMake(381, 245, 253, 220) action:@selector(home_cpmd_click) total:37];
//    
//    [self creatAnimationButton:@"xnzt_%d.png" frame:CGRectMake(763, 267, 253, 220) action:@selector(home_xnzt_click) total:38];
    
//    
//    [self addSubview:[global buttonWithSource:@"index_1.png" frame:CGRectMake(100, 173, 420, 235) target:self event:@selector(home_qjty_click)]];
//    
//    [self addSubview:[global buttonWithSource:@"index_2.png" frame:CGRectMake(517, 173, 420, 235) target:self event:@selector(home_cpzx_click)]];
//    
//    [self addSubview:[global buttonWithSource:@"index_3.png" frame:CGRectMake(99, 405, 205, 235) target:self event:@selector(home_ppwh_click)]];
//    
//    [self addSubview:[global buttonWithSource:@"index_4.png" frame:CGRectMake(301, 405, 434, 235) target:self event:@selector(home_cpmd_click)]];
//    
//    [self addSubview:[global buttonWithSource:@"index_5.png" frame:CGRectMake(732, 405, 205, 235) target:self event:@selector(home_xnzt_click)]];
    
    HomeNavigate *navigate2 = [[HomeNavigate alloc] initWithFrame:self.bounds];
    
    [self addSubview:navigate2];
    
    [navigate2 release];
    
    NSString *str1 = [[NSBundle mainBundle] pathForResource:@"new_xnqjd.png" ofType:@""];
    
    NSString *str2 = [[NSBundle mainBundle] pathForResource:@"new_ppgs.png" ofType:@""];
    
    NSString *str3 = [[NSBundle mainBundle] pathForResource:@"new_qjty.png" ofType:@""];
    
    NSString *str4 = [[NSBundle mainBundle] pathForResource:@"new_cpmd.png" ofType:@""];
    
    NSString *str5 = [[NSBundle mainBundle] pathForResource:@"new_cpzx.png" ofType:@""];
    
    NSArray *imgData = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str1,str2,str3,str4,str5, nil];
    
    NSArray *urlData = [NSArray arrayWithObjects:@"AboutController",@"ProductTypeController",@"FeatureListController",@"FeatureListController",@"FeatureListController",@"AboutController",@"ProductTypeController",@"FeatureListController",@"FeatureListController",@"FeatureListController",nil];
    
//    NSArray *imgData = [NSArray arrayWithObjects:str1,str2,str3,str4,str5, nil];
//    
//    NSArray *urlData = [NSArray arrayWithObjects:@"AboutController",@"ProductTypeController",@"FeatureListController",@"FeatureListController",@"FeatureListController",nil];
    
    uint i = 0;
    
//    
    
    for (NSString *path in imgData)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        
        HomeNavigateLayer2 *button = [[HomeNavigateLayer2 alloc] initWithImage:img];
        
        [button addTarget:self action:@selector(buttonTouch:)];
        
        button.tag = 1000+i;
        
        [button setHref:[urlData objectAtIndex:i++]];
        
        [navigate2 addSubview:button];

        [button release];
    }
    
    //

    [self initNavigate];
    
    [self addSubview:[global buttonWithSource:@"info_1.png" frame:CGRectMake(978, 723, 34, 35) target:self event:@selector(copy_show)]];
}


-(void)copy_show
{
    copyView = [[UIView alloc] initWithFrame:CGRectMake(786, 558, 227, 199)];
    
    [copyView addSubview:[global imageWithSource:@"info_bg.png" frame:CGRectMake(0, 0, 227, 199)]];
    
    //[copyView addSubview:[global imageWithSource:@"login_line.png" frame:CGRectMake(0, 27, 225, 137)]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 5, 227, 23) name:@"系统名称：" value:@"喜临门可视化营销系统" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 30, 227, 23) name:@"当前版本：" value:@"v1.1" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 57, 227, 23) name:@"最后更新时间：" value:@"2012.12.1" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 85, 227, 23) name:@"最后同步时间：" value:@"2012.12.1" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 112, 227, 23) name:@"版权所有：" value:@"喜临门" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 140, 227, 23) name:@"技术支持：" value:@"上海龙安互动" margin:88]];

    [self addSubview:copyView];
    
    [self addSubview:copy2 = [global buttonWithSource:@"info_2.png" frame:CGRectMake(978, 723, 34, 35) target:self event:@selector(copy_hidden)]];
    
    [self.layer addAnimation:[CATransition animation] forKey:nil];
    
    [copyView release];
}
-(void)copy_hidden
{
    if (copyView) 
    {
       
        [self.layer addAnimation:[CATransition animation] forKey:nil];
        
        [copyView removeFromSuperview];
        
        copyView = nil;
        
        [copy2 removeFromSuperview];
        
        copy2 = nil;
        
    } 
}

- (void)creatAnimationButton:(NSString *)path frame:(CGRect)rect action:(SEL)event total:(int)value
{
    UIImageView *images =  [[UIImageView alloc] initWithFrame:rect];
    
    images.animationImages = [self getImages:path total:value];
    
    NSLog(@"opopo   ＝＝＝＝      %d",[[self getImages:path total:value] count]);
    
    images.animationDuration = 2;
    
    [images startAnimating];
    
    [self addSubview:images];
    
    [images release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(rect.origin.x + 50, rect.origin.y + 50, rect.size.width - 100, rect.size.height - 100);
    
    [btn addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
}

- (id)getImages:(NSString *)path total:(int)value
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0;i<value;i++)
    {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:path,i]];
        
        [array addObject:image];
    }
    
    return [array autorelease];
}

- (void)dealloc
{
    [navigate release];
    
    [super dealloc];
}
//
- (void)home_ppwh_click
{
    [self.root load:@"Ebook"];
}

- (void)home_qjty_click
{
    //[self.root load:@"Room"];
    
    [self.root load:@"ChooseRoom"];
}

- (void)home_cpzx_click
{
    [self.root load:@"ProductList?type=1"]; 
   // [self.root load:@"ChooseProduct"];
}

- (void)home_cpmd_click
{
    [self.root load:@"FeatureChoose"];
}
- (void)home_xnzt_click
{
    [self.root load:@"Virtual"];
}
//菜单
- (void)initNavigate
{
    navigate = [[Navigate alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];

    //[navigate updata:@"请选择栏目"];

    [self addSubview:navigate];
}

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
    
    lef.font = [UIFont systemFontOfSize:11];
    
    lef.textAlignment = UITextAlignmentRight;
    
    lef.textColor = [UIColor colorWithRed:78/255.0f green:131/255.0f blue:166/255.0f alpha:1];
    
    lef.text = nameStr;
    
    [item addSubview:lef];
    
    [lef release];
    //
    UILabel *rig = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, frame.size.width-margin, frame.size.height)];
    
    rig.backgroundColor = [UIColor clearColor];
    
    rig.font = [UIFont systemFontOfSize:11];
    
    rig.text = valueStr;
    
    rig.textColor = [UIColor colorWithRed:1/255.0f green:47/255.0f blue:106/255.0f alpha:1];
    
    [item addSubview:rig];
    
    [rig release];
    //
    //[item addSubview:[global imageWithSource:@"copy_line.png" frame:CGRectMake(0 , frame.size.height-1, frame.size.width, 1)]];
    //
    return [item autorelease];
}

@end
