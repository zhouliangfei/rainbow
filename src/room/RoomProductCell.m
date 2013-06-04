//
//  RoomProductCell.m
//  steelland
//
//  Created by mac on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RoomProductCell.h"

@implementation RoomProductCell

@synthesize photoView;

@synthesize nameView;

@synthesize colorView;

@synthesize packageView;

- (void)dealloc 
{
    [photoView release];
    
    [nameView release];
    
    [colorView release];
    
    [packageView release];
    
    [super dealloc];
}

@end







/*
 
 //
 //  RoomViewController.m
 //  rainbow
 //
 //  Created by 360 e on 13-2-27.
 //  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
 //
 
 #import "RoomViewController.h"
 
 #import "global.h"
 #import "GUI.h"
 #import "MSWindow.h"
 #import "NavigateView.h"
 #import "UISequenceView.h"
 #import "Access.h"
 #import "Thumbnail.h"
 
 #import "Turn.h"
 
 @interface RoomViewController ()
 {
 
 NSMutableDictionary *data;
 
 NSString *file;
 
 UISequenceView *sequenceView;
 
 Turn *sequenceDanzhen;
 
 UIView *btnview;
 
 UIButton *inbtn;
 
 UIButton *btn360;
 
 UIButton *b0;
 
 UIButton *b1;
 
 UIButton *b2;
 
 UIButton *b3;
 
 UIView *roomProperty;
 
 UIScrollView *propertyThumb;
 
 UIScrollView *propertyColorThumb;
 
 int typeID;
 
 int roomID;
 
 NSArray *contentData;
 
 NSArray *contentColorlData;
 
 UIScrollView *infoScroll;
 
 NSArray * dataPic;
 
 Boolean hidden;
 
 CGPoint touchBegin;
 
 UIView *proInfoView;
 
 UIButton *probtn;
 
 UIButton *colorbtn;
 
 UIButton *wallbtn;
 
 UIButton *groundbtn;
 
 Boolean isplay;
 //
 
 int jiaodu;
 
 int index;
 
 int bantai;
 
 int chagui;
 
 int shayi;
 
 //实拍 
 int sfID;
 
 int yzID;
 
 int cjID;
 
 int sgID;
 
 int dsgID;
 
 int sfcolID;
 
 int yzcolID;
 
 int cjcolID;
 
 int sgcolID;
 
 int dsgcolID;
 
 //虚拟
 
 int tableID;
 
 int tableColorID;
 
 int chaguiID;
 
 int chaguiColorID;
 
 int shayiID;
 
 int shayiColorID;
 
 int wallID;
 
 int capID;
 
 //yanse id
 
 int chajiID;
 
 int guiziID;
 
 int shafaID;
 
 int yiziID;
 
 UIControl *proList;
 
 UIControl *sandbox;
 
 UISwipeGestureRecognizer *recognizer;
 
 UISwipeGestureRecognizer *recognizer2;
 }
 
 - (void)resetItemButton:(UIButton *)button;
 
 - (void)resetViewButton:(UIButton *)button;
 
 - (void)taskFinished:(NSArray *)task identifier:(NSString*)identifier;
 
 -(void)makePropertyThumberWithEvent:(SEL)event select:(int)select lable:(NSString*)lable;
 
 -(void)makePropertyColorThumberWithEvent:(SEL)event select:(int)select lable:(NSString*)lable;
 
 - (id)thumbWithFile:(NSString *)files lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event;
 
 - (id)buttonWithSource:(NSString *)source active:(NSString *)active lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event ;
 
 - (id)thumbWithFile:(NSString *)files xinghao:(NSString*)xinghao guige:(NSString*)guige colorstr:(NSString*)colorstr frame:(CGRect)frame event:(SEL)event tag:(int)tag;
 
 @end
 
 @implementation RoomViewController
 
 
 
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization  
 }
 return self;
 }
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 [self.view addSubview:[global imageWithSource:@"background.png" frame:CGRectMake(0, 0, 1024, 768)]];
 
 index = 0;
 
 //
 
 chagui = 0;
 
 bantai = 1;
 
 shayi = 2;
 
 //菜单
 NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
 
 proList = [menu addChildWithLable:@"产品列表"];
 
 sandbox = [menu addChildWithLable:@"模拟沙盘"];
 
 [proList addTarget:self action:@selector(proListTouch:) forControlEvents:UIControlEventTouchUpInside];
 
 [sandbox addTarget:self action:@selector(sandboxTouch:) forControlEvents:UIControlEventTouchUpInside];
 
 [self.view addSubview:menu];
 
 //
 [self.view addSubview:roomProperty = [[UIView alloc] initWithFrame:CGRectMake(0, 535, 1024, 198)]];
 
 //
 if(window.location.search)
 {
 
 data = window.location.search;
 
 typeID = [[data objectForKey:@"type"]intValue];
 
 roomID = [[data objectForKey:@"id"]intValue];
 
 //普通虚拟（360＋单针 2角度）
 if(typeID == 0)
 {
 file = [data objectForKey:@"files"];
 
 if(file!=nil)
 {
 
 [self creatSequenceView];
 
 [self creatmenuButton];
 
 }
 
 }
 //宜家虚拟（单针）
 if(typeID == 2)
 {
 
 [self.view addSubview:[global buttonWithSource:@"3_btn_over.png" active:@"3_btn_over.png" frame:CGRectMake(980, 53, 44, 44) target:self event:@selector(FourbtnClick)]];
 
 [self FourbtnClick];
 
 //            [self.view addSubview:b0 = [global buttonWithSource:@"room1_1.png" active:@"room1_over1.png" frame:CGRectMake(980, 53, 44, 44) target:self event:@selector(showpic1:)]];
 //            
 //            [self.view addSubview:b1 =[global buttonWithSource:@"room1_2.png" active:@"room1_over2.png" frame:CGRectMake(980, 96, 44, 44) target:self event:@selector(showpic2:)]];
 //            
 //            [self.view addSubview:b2 = [global buttonWithSource:@"room1_1.png" active:@"room1_over1.png" frame:CGRectMake(980, 139, 44, 44) target:self event:@selector(showpic3:)]];
 //            
 //            [self.view addSubview:b3 =[global buttonWithSource:@"room1_2.png" active:@"room1_over2.png" frame:CGRectMake(980, 183, 44, 44) target:self event:@selector(showpic4:)]];
 //            
 //            [self showpic1:b0];
 
 //[self creatproList];
 
 }
 //实拍（单针 2角度）
 if(typeID == 1)
 {
 //[self creatproList];
 
 [self.view addSubview:b0 = [global buttonWithSource:@"room1_1.png" active:@"room1_over1.png" frame:CGRectMake(980, 53, 44, 44) target:self event:@selector(showpic1:)]];
 
 [self.view addSubview:b1 =[global buttonWithSource:@"room1_2.png" active:@"room1_over2.png" frame:CGRectMake(980, 96, 44, 44) target:self event:@selector(showpic2:)]];
 
 [self showpic1:b0];
 }
 //产品列表
 
 }
 }
 
 -(void)FourbtnClick
 {
 if(!btnview){
 
 btnview = [[UIView alloc]initWithFrame:CGRectMake(980, 97, 44, 172+11)];
 
 [self.view addSubview:btnview];
 
 [btnview addSubview:[global buttonWithSource:@"3_di.png" frame:CGRectMake(0, 0, 44, 172) target:self event:nil]];
 
 [btnview addSubview:[global buttonWithSource:@"room_out.png" frame:CGRectMake(0, 172, 44, 11) target:self event:@selector(outClick)]];
 
 [btnview addSubview:b0 = [global buttonWithSource:@"3_1.png" active:@"3_1_over.png" frame:CGRectMake(5, 9, 36, 27) target:self event:@selector(showpic1:)]];
 
 [btnview addSubview:b1 =[global buttonWithSource:@"3_2.png" active:@"3_2_over.png" frame:CGRectMake(5, 52, 36, 27) target:self event:@selector(showpic2:)]];
 
 [btnview addSubview:b2 = [global buttonWithSource:@"3_3.png" active:@"3_3_over.png" frame:CGRectMake(5, 95, 36, 27) target:self event:@selector(showpic3:)]];
 
 [btnview addSubview:b3 =[global buttonWithSource:@"3_4.png" active:@"3_4_over.png" frame:CGRectMake(5, 138, 36, 27) target:self event:@selector(showpic4:)]];
 
 [self showpic1:b0];
 }
 
 }
 
 -(void)creatproInfo
 {
 
 proInfoView = [[UIView alloc]initWithFrame:CGRectMake(760+264, 42, 264, 726)];
 
 [self.view addSubview:proInfoView];
 
 [proInfoView addSubview:[global imageWithSource:@"room_proBg.png" frame:CGRectMake(0, 0, 264, 726)]];
 
 [proInfoView addSubview:[global buttonWithFile:@"room_proBtn2.png" frame:CGRectMake(55, 690, 27, 26) target:self event:nil]];
 
 [proInfoView addSubview:[global buttonWithFile:@"room_proBtn1.png" frame:CGRectMake(181, 690, 29, 25) target:self event:nil]];
 
 infoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 25, 264, 640)];
 
 [infoScroll setAlwaysBounceHorizontal:NO];
 
 [infoScroll setAlwaysBounceVertical:YES];
 
 [infoScroll setDelegate:self];
 
 [proInfoView addSubview:infoScroll];
 
 }
 
 -(void)getPic:(int)tag layer:(int)layer
 {
 dataPic = [[Access getRoomproduct:tag] retain];
 
 if(dataPic)
 {
 Thumbnail* item = (Thumbnail*)[infoScroll viewWithTag:layer+1000];
 
 if(item)
 {
 [item removeFromSuperview];
 }
 
 
 NSString *model;
 
 NSString *size;
 
 NSString *color;
 
 NSString *url;
 
 
 url = [NSString stringWithFormat:@"%@",[[dataPic objectAtIndex:0]objectForKey:@"photo"]];
 
 color = [[dataPic objectAtIndex:0]objectForKey:@"color"];
 
 model = [[dataPic objectAtIndex:0]objectForKey:@"model"];
 
 size =  [[dataPic objectAtIndex:0]objectForKey:@"size"];
 
 [infoScroll addSubview:[self thumbWithFile:url xinghao:model guige:size colorstr:color frame:CGRectMake(15,120 *layer, 109, 81) event:nil tag:layer+1000]];
 }
 
 [dataPic release];
 
 }
 
 -(void)creatSequenceDanzhen
 {
 
 if(sequenceDanzhen){
 
 [sequenceDanzhen removeFromSuperview];
 
 [sequenceDanzhen release];
 
 sequenceDanzhen = nil;
 }
 
 if(!sequenceDanzhen)
 {
 sequenceDanzhen = [[Turn alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
 
 [self.view insertSubview:sequenceDanzhen atIndex:1];
 }
 
 //默认 
 
 [self creatproInfo];
 
 //xuni
 if(typeID ==0)
 {
 
 [self taskFinished:[Access getRoomdefaultWallCapPath:roomID] identifier:@"DefaultwallCap"];
 
 [self taskFinished:[Access getRoomTableDefaultPath:0 roomID:roomID] identifier:@"tablePath"];
 
 
 id value = [Access getRoomDefaultshayiPath_xuni:1 roomID:roomID tableID:tableID];
 
 if (value) 
 {
 [self taskFinished:value identifier:@"DefaultshayiPath_xuni"];
 }
 else
 {
 [self taskFinished:[Access getRoomDefaultshayiPath_xn:1 tableID:tableID roomID:roomID] identifier:@"DefaultshayiPath_xuni"];
 }
 
 
 id temp = [Access getRoomDefaultchaguiPath_xuni:0 roomID:roomID tableID:tableID];
 
 if (temp) 
 {
 [self taskFinished:temp identifier:@"DefaultchaguiPath_xuni"];
 }
 else 
 {
 [self taskFinished:[Access getRoomDefaultchaguiPath_xn:0 tableID:tableID roomID:roomID] identifier:@"DefaultchaguiPath_xuni"];
 }
 
 
 
 
 
 
 }
 //shipai
 if(typeID == 1)
 {
 [self taskFinished:[Access getSenceDefaultPath:roomID] identifier:@"Defaultsence"];
 }
 //yijia
 if(typeID == 2)
 {
 [self taskFinished:[Access getRoomdefaultWallCapPath:roomID] identifier:@"DefaultwallCap"];
 
 [self taskFinished:[Access getRoomTableDefaultPath:0 roomID:roomID] identifier:@"tablePath"];
 
 [self taskFinished:[Access getRoomDefaultshayiPath:1 roomID:roomID] identifier:@"DefaultshayiPath"];
 
 [self taskFinished:[Access getRoomDefaultchaguiPath:0 roomID:roomID] identifier:@"DefaultchaguiPath"];
 }
 
 
 [self UITapSwapEvent];
 }
 
 -(void)creatSequenceView
 {
 
 if(recognizer)
 {
 
 recognizer.enabled = NO;
 
 recognizer2.enabled = NO;
 }
 
 if(sequenceDanzhen){
 
 [sequenceDanzhen removeFromSuperview];
 
 [sequenceDanzhen release];
 
 sequenceDanzhen = nil;
 }
 
 
 
 if(!sequenceView)
 {
 proList.userInteractionEnabled = NO;
 
 sequenceView =[[UISequenceView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
 
 [sequenceView setLoop:NO];
 
 [sequenceView setTotalFrame:25];
 
 [sequenceView setLayerCount:1];
 
 [self.view insertSubview:sequenceView atIndex:1];
 
 //
 
 NSString *low = [Utils getPathWithFile:[file stringByAppendingPathComponent:@"s%d.png"]];
 
 NSString *high = [Utils getPathWithFile:[file stringByAppendingPathComponent:@"%d.png"]];
 
 [sequenceView updata:0 low:low high:high];
 }
 }
 -(void)creatmenuButton
 {
 
 btnview = [[UIView alloc]initWithFrame:CGRectMake(980, 50, 44, 86+11)];
 
 [self.view addSubview:btnview];
 
 btnview.alpha = 0;
 
 [self.view addSubview:btn360 = [global buttonWithSource:@"room_360BtnNormal.png" active:@"room_360BtnActive.png" frame:CGRectMake(980, 53, 44, 44) target:self event:@selector(show360)]];
 
 [self.view addSubview:[global buttonWithSource:@"room_angBtnNormal.png" active:@"room_angBtnNormal.png" frame:CGRectMake(980, 96, 44, 44) target:self event:@selector(showpic)]];
 
 [self.view addSubview:inbtn = [global buttonWithSource:@"room_in.png" frame:CGRectMake(980, 139, 44, 11) target:self event:@selector(showpic)]];
 
 [btnview addSubview:[global buttonWithSource:@"room_angOpenBg.png" frame:CGRectMake(0, 0, 44, 86) target:self event:nil]];
 
 [btnview addSubview:[global buttonWithSource:@"room_out.png" frame:CGRectMake(0, 86, 44, 11) target:self event:@selector(outClick)]];
 
 [btnview addSubview:b0 = [global buttonWithSource:@"room_1.png" active:@"room_over1.png" frame:CGRectMake(5, 9, 36, 27) target:self event:@selector(showpic1:)]];
 
 [btnview addSubview:b1 =[global buttonWithSource:@"room_2.png" active:@"room_over2.png" frame:CGRectMake(5, 52, 36, 27) target:self event:@selector(showpic2:)]];
 
 btn360.selected = YES;
 //
 }
 -(void)showpic1:(UIButton *)sender
 {
 
 isplay = YES;
 
 sender.selected = YES;
 
 b1.selected = NO;
 
 b2.selected = NO;
 
 b3.selected = NO;
 
 jiaodu = 1;
 
 proList.userInteractionEnabled = YES;
 
 NSLog(@"角度yi");
 
 [self creatSequenceDanzhen];
 
 [self creatproList];
 
 }
 -(void)showpic2:(UIButton *)sender
 {
 sender.selected = YES;
 
 b0.selected = NO;
 
 b2.selected = NO;
 
 b3.selected = NO;
 
 jiaodu = 2;
 
 [self creatSequenceDanzhen];
 
 NSLog(@"角度er");
 
 }
 
 -(void)showpic3:(UIButton *)sender
 {
 sender.selected = YES;
 
 b1.selected = NO;
 
 b3.selected = NO;
 
 b0.selected = NO;
 
 jiaodu = 3;
 
 [self creatSequenceDanzhen];
 
 NSLog(@"角度san");
 }
 
 -(void)showpic4:(UIButton *)sender
 {
 sender.selected = YES;
 
 b1.selected = NO;
 
 b2.selected = NO;
 
 b0.selected = NO;
 
 jiaodu = 4;
 
 [self creatSequenceDanzhen];
 
 NSLog(@"角度si");
 }
 -(void)showpic
 {
 
 [self showpic1:b0];
 
 btn360.selected = NO;
 
 if(sequenceView)
 {
 [sequenceView removeFromSuperview];
 
 [sequenceView release];
 
 sequenceView = nil;
 }
 
 [UIView beginAnimations:nil context:nil];
 
 inbtn.alpha =0;
 
 btnview.alpha =1;
 
 btnview.frame = CGRectMake(980, 140, 44, 97);
 
 [UIView commitAnimations];
 
 }
 -(void)outClick
 {
 [UIView beginAnimations:nil context:nil];
 
 inbtn.alpha =1;
 
 btnview.alpha =0;
 
 btnview.frame = CGRectMake(980, 50, 44, 97);
 
 [UIView commitAnimations];
 }
 -(void)show360
 {
 isplay = NO;
 
 for (id item in roomProperty.subviews)
 {
 [item removeFromSuperview];
 
 item = nil;
 }
 
 btn360.selected = YES;
 
 [self outClick];
 
 [self creatSequenceView];
 
 }
 
 //
 -(void)hiddenbtn
 {
 wallbtn.hidden = NO;
 
 groundbtn.hidden = NO;
 
 probtn.hidden = YES;
 
 colorbtn.hidden = YES;
 
 }
 -(void)hidden
 {
 wallbtn.hidden = YES;
 
 groundbtn.hidden = YES;
 
 probtn.hidden = NO;
 
 colorbtn.hidden = NO;
 
 }
 
 
 -(void)creatproList
 {
 
 if (propertyThumb)
 {
 [propertyThumb removeFromSuperview];
 
 [propertyThumb release];
 
 propertyThumb = nil;
 
 }
 
 for (id item in roomProperty.subviews)
 {
 [item removeFromSuperview];
 
 item = nil;
 }
 
 UIButton *select = nil;
 
 [roomProperty addSubview:[global imageWithSource:@"room_attBg.png" frame:CGRectMake(0, 35, 1024, 198)]];
 
 [roomProperty addSubview:[global imageWithSource:@"room_attLine1.png" frame:CGRectMake(0, 34, 84, 199)]];
 
 [roomProperty addSubview:probtn = [global buttonWithSource:@"room1_pro.png" frame:CGRectMake(22, 61, 40, 43) target:self event:@selector(proClick)]];
 
 [roomProperty addSubview:colorbtn = [global buttonWithSource:@"room1_color.png" frame:CGRectMake(22, 160, 40, 41) target:self event:@selector(colorClick)]];
 
 [roomProperty addSubview:wallbtn = [global buttonWithSource:@"wall.png" frame:CGRectMake(22, 61, 40, 43) target:self event:@selector(wallClick)]];
 
 [roomProperty addSubview:groundbtn = [global buttonWithSource:@"ground.png" frame:CGRectMake(22, 160, 40, 41) target:self event:@selector(groundClick)]];
 
 wallbtn.hidden = YES;
 
 groundbtn.hidden = YES;
 
 
 
 [roomProperty addSubview:propertyThumb = [[UIScrollView alloc] initWithFrame:CGRectMake(99, 60, 905, 135)]];
 
 [propertyThumb setAlwaysBounceHorizontal:YES];
 
 propertyThumb.delegate = self;
 
 [roomProperty addSubview:propertyColorThumb = [[UIScrollView alloc] initWithFrame:CGRectMake(99, 60, 905, 135)]];
 
 [propertyColorThumb setAlwaysBounceHorizontal:YES];
 
 propertyColorThumb.delegate = self;
 
 propertyColorThumb.hidden = YES;
 
 //propertyColorThumb.userInteractionEnabled = NO;
 
 
 
 //..............................................
 
 UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 700, 35)];
 
 if(typeID == 0 || typeID == 2)
 {
 
 [content addSubview:select=[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"班台替换" frame:CGRectMake(0, 0, 84, 35) event:@selector(tableClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"茶柜替换"  frame:CGRectMake(84, 0, 84, 35) event:@selector(chaguiClick:)]];
 
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"沙椅替换"  frame:CGRectMake(168, 0, 84, 35) event:@selector(shayiClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"搭配替换"  frame:CGRectMake(252, 0, 84, 35) event:@selector(dapeiClick:)]];
 
 [self tableClick:select];
 
 }
 
 if(typeID == 3)
 {
 
 [content addSubview:select=[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"摆放形式一" frame:CGRectMake(0, 0, 84, 35) event:@selector(oneClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"摆放形式二"  frame:CGRectMake(84, 0, 84, 35) event:@selector(twoClick:)]];
 
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"摆放形式三"  frame:CGRectMake(168, 0, 84, 35) event:@selector(threeClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"摆放形式四"  frame:CGRectMake(252, 0, 84, 35) event:@selector(fourClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"搭配替换"  frame:CGRectMake(336, 0, 84, 35) event:@selector(dpClick:)]];
 
 [self oneClick:select];
 
 }
 
 if(typeID == 1)
 {
 
 [content addSubview:select=[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"沙发替换" frame:CGRectMake(0, 0, 84, 35) event:@selector(shafaClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"椅子替换"  frame:CGRectMake(84, 0, 84, 35) event:@selector(yiziClick:)]];
 
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"茶几替换"  frame:CGRectMake(168, 0, 84, 35) event:@selector(chajiClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"书柜替换"  frame:CGRectMake(252, 0, 84, 35) event:@selector(shuguiClick:)]];
 
 [content addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"电视柜替换"  frame:CGRectMake(336, 0, 84, 35) event:@selector(dianshiguiClick:)]];
 
 [self shafaClick:select];
 
 }
 
 [roomProperty addSubview:content];
 
 [roomProperty addSubview:[global buttonWithSource:@"room1_close.png" frame:CGRectMake(989, 0, 35, 35) target:self event:@selector(shou_Click)]];
 
 
 
 }
 
 -(void)proClick
 {
 propertyThumb.hidden = NO;
 
 propertyColorThumb.hidden = YES;
 
 }
 -(void)colorClick
 {
 propertyThumb.hidden = YES;
 
 propertyColorThumb.hidden = NO;
 
 }
 
 -(void)wallClick
 {
 [self proClick];
 }
 -(void)groundClick
 {
 [self colorClick];
 
 [self taskFinished:[Access getcapThumb:roomID] identifier:@"cap"];
 }
 
 
 //实拍
 -(void)shafaClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self taskFinished:[Access getSenceRoomSFThumb:roomID] identifier:@"senceSF"];
 }
 -(void)yiziClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self taskFinished:[Access getSenceRoomYZThumb:roomID] identifier:@"senceYZ"];
 }
 -(void)chajiClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self taskFinished:[Access getSenceRoomCJThumb:roomID] identifier:@"senceCJ"];
 }
 -(void)shuguiClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self taskFinished:[Access getSenceRoomSGThumb:roomID] identifier:@"senceSG"];
 
 }
 -(void)dianshiguiClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self taskFinished:[Access getSenceRoomDSGThumb:roomID] identifier:@"senceDSG"];
 }
 //
 -(void)oneClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 }
 -(void)twoClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 }
 
 -(void)threeClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 }
 
 -(void)fourClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 }
 
 -(void)dpClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 }
 
 //  --------------------------------------------- 
 
 -(void)tableClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self hidden];
 
 [self taskFinished:[Access getRoomTableThumb:roomID] identifier:@"table"];
 
 }
 -(void)chaguiClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self hidden];
 
 // [self taskFinished:[Access getRoomchaguiThumb_xuni:roomID ID:0 tableID:tableID] identifier:@"chagui"];
 
 if(typeID == 2){
 
 [self taskFinished:[Access getRoomchaguiThumb:roomID ID:0] identifier:@"chagui"];
 }
 if(typeID == 0){
 
 //xuni
 [self taskFinished:[Access getRoomchaguiThumb_xuni:roomID ID:0 tableID:tableID] identifier:@"chagui"];
 }
 
 }
 -(void)shayiClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self hidden];
 
 // [self taskFinished:[Access getRoomchaguiThumb_xuni:roomID ID:1 tableID:tableID] identifier:@"shayi"];
 
 if(typeID == 2){
 
 [self taskFinished:[Access getRoomchaguiThumb:roomID ID:1] identifier:@"shayi"];
 }
 if(typeID == 0){
 
 //xuni
 [self taskFinished:[Access getRoomchaguiThumb_xuni:roomID ID:1 tableID:tableID] identifier:@"shayi"];
 }
 
 }
 -(void)dapeiClick:(UIButton *)sender
 {
 [self resetViewButton:sender];
 
 [self hiddenbtn];
 
 [self taskFinished:[Access getwallThumb:roomID] identifier:@"wall"];
 
 
 }
 
 
 //  -----------------------------------------------------
 -(void)shou_Click
 {
 [UIView beginAnimations:nil context:nil];
 
 roomProperty.frame = CGRectMake(0, 768, 1024, 198);
 
 [UIView commitAnimations];
 }
 -(void)proListTouch:(UIControl*)sender
 {
 
 sender.selected = YES;
 
 [UIView beginAnimations:nil context:nil];
 
 proInfoView.frame = CGRectMake(760, 42, 264, 726);
 
 [UIView commitAnimations];
 
 
 }
 -(void)sandboxTouch:(UIControl*)sender
 {
 //window.location = [MSRequest requestWithName:@"SandboxController"];
 }
 
 - (void)viewDidUnload
 {
 [super viewDidUnload];
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
 }
 
 - (id)buttonWithSource:(NSString *)source active:(NSString *)active lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event 
 {
 UIColor *nor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
 
 UIColor *sel = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
 
 UIButton *temp = [global buttonWithSource:source active:active frame:frame target:self event:event];
 
 [temp setTitle:lable forState:UIControlStateNormal];
 
 [temp setTitleColor:nor forState:UIControlStateNormal];
 
 [temp setTitleColor:sel forState:UIControlStateSelected];
 
 [temp.titleLabel setFont:[UIFont systemFontOfSize: 12.0]];
 
 [nor release];
 
 [sel release];
 
 return temp;
 }
 
 - (void)resetViewButton:(UIButton *)button
 {
 for(Thumbnail *item in propertyThumb.subviews)
 {
 [item removeFromSuperview];
 
 item = nil;
 }
 for(Thumbnail *item in propertyColorThumb.subviews)
 {
 [item removeFromSuperview];
 
 item = nil;
 }
 
 [self proClick];
 
 //
 UIView *parent = [button superview];
 
 for (id item in parent.subviews)
 {
 if ([item isKindOfClass:UIButton.class])
 {
 if (button == item) 
 {
 [item setSelected:YES];
 }
 else
 {
 [item setSelected:NO]; 
 }
 }
 }
 }
 - (void)resetItemButton:(UIButton *)button
 {
 for(Thumbnail *item in propertyColorThumb.subviews)
 {
 [item removeFromSuperview];
 
 item = nil;
 }
 
 UIScrollView *parent = (UIScrollView *)[button superview];
 
 for (id item in parent.subviews)
 {
 if ([item isKindOfClass:Thumbnail.class])
 {
 if (button == item) 
 {
 [item setSelected:YES];
 }
 else
 {
 [item setSelected:NO]; 
 }
 }
 }
 }
 
 - (void)resetItemColorButton:(UIButton *)button
 {
 
 UIScrollView *parent = (UIScrollView *)[button superview];
 
 for (id item in parent.subviews)
 {
 if ([item isKindOfClass:Thumbnail.class])
 {
 if (button == item) 
 {
 [item setSelected:YES];
 }
 else
 {
 [item setSelected:NO]; 
 }
 }
 }
 }
 
 -(void)makePropertyThumberWithEvent:(SEL)event select:(int)select lable:(NSString*)lable
 {
 int len = [contentData count];
 
 propertyThumb.contentSize = CGSizeMake(len * 154, 135);
 
 for (int i=0; i<len; i++)
 {
 NSString *lab =  [lable stringByAppendingString:[NSString stringWithFormat:@"%@",[[contentData objectAtIndex:i] objectForKey:@"model"]]];
 
 NSString *src = [[contentData objectAtIndex:i] objectForKey:@"photo"];
 
 int selectID = [[[contentData objectAtIndex:i] objectForKey:@"id"] intValue];
 
 Thumbnail *item = [self thumbWithFile:src lable:lab frame:CGRectMake(i * 154, 0, 140, 135) event:event];
 
 [item setSelected:(selectID == select)];
 
 [item setTag:selectID];
 
 [propertyThumb addSubview:item];
 }
 }
 -(void)makePropertyColorThumberWithEvent2:(SEL)event select:(int)select lable:(NSString*)lable
 {
 int len = [contentColorlData count];
 
 propertyColorThumb.contentSize = CGSizeMake(len * 154, 135);
 
 for (int i=0; i<len; i++)
 {
 NSString *lab =  [lable stringByAppendingString:[NSString stringWithFormat:@"%@",[[contentColorlData objectAtIndex:i] objectForKey:@"model"]]];
 
 NSString *src = [[contentColorlData objectAtIndex:i] objectForKey:@"photo"];
 
 int selectID = [[[contentColorlData objectAtIndex:i] objectForKey:@"id"] intValue];
 
 Thumbnail *item = [self thumbWithFile:src lable:lab frame:CGRectMake(i * 154, 0, 140, 135) event:event];
 
 [item setSelected:(selectID == select)];
 
 [item setTag:i];
 
 [propertyColorThumb addSubview:item];
 }
 }
 -(void)makePropertyColorThumberWithEvent:(SEL)event select:(int)select lable:(NSString*)lable
 {
 int len = [contentColorlData count];
 
 propertyColorThumb.contentSize = CGSizeMake(len * 154, 135);
 
 for (int i=0; i<len; i++)
 {
 NSString *lab = [lable stringByAppendingString:[NSString stringWithFormat:@"%@",[[contentColorlData objectAtIndex:i] objectForKey:@"model"]]];
 
 NSString *src = [[contentColorlData objectAtIndex:i] objectForKey:@"photo"];
 
 int selectID = [[[contentColorlData objectAtIndex:i] objectForKey:@"id"] intValue];
 
 Thumbnail *item = [self thumbWithFile:src lable:lab frame:CGRectMake(i * 154, 0, 140, 135) event:event];
 
 [item setSelected:(selectID == select)];
 
 //[item setTag:i];
 [item setTag:selectID];
 
 [propertyColorThumb addSubview:item];
 }
 }
 - (id)thumbWithFile:(NSString *)files lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event
 {
 
 int th = 30;
 
 Thumbnail *temp = [[Thumbnail alloc] initWithFrame:frame normal:nil active:nil];
 
 [temp addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
 
 if ((id)files != [NSNull null])
 {
 [temp setImage:[global bitmapWithFile:files]];
 }
 
 [temp setTitle:lable];
 
 [temp.titleLabel setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1]];
 
 [temp.titleLabel setFont:[UIFont systemFontOfSize:14]];
 
 [temp.titleLabel setTextColor:[UIColor blackColor]];
 
 [temp.titleLabel setTextAlignment:UITextAlignmentCenter];
 
 [temp.imageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-th)];
 
 [temp.titleLabel setFrame:CGRectMake(0, frame.size.height-th, frame.size.width, th)];
 
 return [temp autorelease];
 
 }
 - (id)thumbWithFile:(NSString *)files xinghao:(NSString*)xinghao guige:(NSString*)guige colorstr:(NSString*)colorstr frame:(CGRect)frame event:(SEL)event tag:(int)tag
 {
 Thumbnail *temp = [[Thumbnail alloc] initWithFrame:frame normal:[UIImage imageNamed:@"room_kuang.png"] active:nil];
 
 temp.tag = tag;
 
 [temp setImage:[global bitmapWithFile:[NSString stringWithFormat:@"%@",files]]];
 
 [temp addSubview:[global imageWithSource:@"room_line.png" frame:CGRectMake(-15, frame.size.height+20, 274, 1)]];
 
 
 
 UILabel *xh=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+10, 10 ,180, 14)];
 
 [xh setFont:[UIFont systemFontOfSize:14]];
 
 xh.text = [NSString stringWithFormat:@"沙发型号：%@",xinghao];
 
 xh.textColor = [UIColor grayColor];
 
 xh.backgroundColor=[UIColor clearColor];
 
 xh.textAlignment=UITextAlignmentLeft;
 
 [temp addSubview:xh];
 
 [xh release];
 
 
 
 
 UILabel *size=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+10, 30 ,180, 14)];
 
 [size setFont:[UIFont systemFontOfSize:14]];
 
 size.text = [NSString stringWithFormat:@"规格尺寸：%@",guige];
 
 size.textColor = [UIColor grayColor];
 
 size.backgroundColor=[UIColor clearColor];
 
 size.textAlignment=UITextAlignmentLeft;
 
 [temp addSubview:size];
 
 [size release];
 
 return [temp autorelease];
 }
 
 - (void)taskFinished:(NSArray *)task identifier:(NSString*)identifier
 {
 
 
 if ([identifier isEqualToString:@"sencePathByID"] && task)
 {
 [self sequenceDanzhenChangeAngle:task layer:0];
 
 return;
 }
 
 if ([identifier isEqualToString:@"Defaultsence"] && task)
 {
 
 NSLog(@"123   %@",task);
 
 sfID = [[[task objectAtIndex:0]objectForKey:@"product1_id"]intValue];
 
 yzID = [[[task objectAtIndex:0]objectForKey:@"product2_id"]intValue];
 
 cjID = [[[task objectAtIndex:0]objectForKey:@"product3_id"]intValue];
 
 sgID = [[[task objectAtIndex:0]objectForKey:@"product4_id"]intValue];
 
 dsgID = [[[task objectAtIndex:0]objectForKey:@"product5_id"]intValue];
 
 //
 
 sfcolID = [[[task objectAtIndex:0]objectForKey:@"color1_id"]intValue];
 
 yzcolID = [[[task objectAtIndex:0]objectForKey:@"color2_id"]intValue];
 
 cjcolID = [[[task objectAtIndex:0]objectForKey:@"color3_id"]intValue];
 
 sgcolID = [[[task objectAtIndex:0]objectForKey:@"color4_id"]intValue];
 
 dsgcolID = [[[task objectAtIndex:0]objectForKey:@"color5_id"]intValue];
 
 
 [self sequenceDanzhenChangeAngle:task layer:0];
 
 [self getPic:sfID layer:0];
 [self getPic:yzID layer:1];
 [self getPic:cjID layer:2];
 [self getPic:sgID layer:3];
 [self getPic:dsgID layer:4];
 
 return;
 }
 
 //实拍
 if ([identifier isEqualToString:@"senceSF"] && task)
 {
 
 contentData = [task retain];
 
 [self makePropertyThumberWithEvent:@selector(shafaItemClick:) select:sfID lable:@"沙发型号："];
 
 [self taskFinished:[Access getSenceRoomSFColorThumbBypro:roomID proID:sfID] identifier:@"senceSFColor"];
 
 return;
 }
 if ([identifier isEqualToString:@"senceSFColor"] && task)
 {
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(SFColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"SF颜色型号："];
 
 return;
 }
 //
 if ([identifier isEqualToString:@"senceYZ"] && task)
 {
 
 contentData = [task retain];
 
 [self makePropertyThumberWithEvent:@selector(yiziItemClick:) select:yzID lable:@"椅子型号："];
 
 [self taskFinished:[Access getSenceRoomYZColorThumbBypro:roomID proID:yzID] identifier:@"senceYZColor"];
 
 return;
 }
 if ([identifier isEqualToString:@"senceYZColor"] && task)
 {
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(YZColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"YZ颜色型号："];
 
 return;
 }
 //
 if ([identifier isEqualToString:@"senceCJ"] && task)
 {
 
 contentData = [task retain];
 
 [self makePropertyThumberWithEvent:@selector(chajiItemClick:) select:cjID lable:@"茶几型号："];
 
 [self taskFinished:[Access getSenceRoomCJColorThumbBypro:roomID proID:cjID] identifier:@"senceCJColor"];
 
 return;
 }
 if ([identifier isEqualToString:@"senceCJColor"] && task)
 {
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(CJColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"CJ颜色型号："];
 
 return;
 }
 //
 if ([identifier isEqualToString:@"senceSG"] && task)
 {
 
 contentData = [task retain];
 
 [self makePropertyThumberWithEvent:@selector(shuguiItemClick:) select:sgID lable:@"书柜型号："];
 
 [self taskFinished:[Access getSenceRoomSGColorThumbBypro:roomID proID:sgID] identifier:@"senceSGColor"];
 
 return;
 }
 if ([identifier isEqualToString:@"senceSGColor"] && task)
 {
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(SGColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"SG颜色型号："];
 
 return;
 }
 //
 if ([identifier isEqualToString:@"senceDSG"] && task)
 {
 
 contentData = [task retain];
 
 [self makePropertyThumberWithEvent:@selector(dianshiguiItemClick:) select:dsgID lable:@"电视柜型号："];
 
 [self taskFinished:[Access getSenceRoomDSGColorThumbBypro:roomID proID:dsgID] identifier:@"senceDSGColor"];
 
 return;
 }
 if ([identifier isEqualToString:@"senceDSGColor"] && task)
 {
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(DSGColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"DSG颜色型号："];
 
 return;
 }
 //普通  虚拟 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 if ([identifier isEqualToString:@"table"] && task)
 {
 
 contentData = [task retain];
 
 [self makePropertyThumberWithEvent:@selector(tableItemClick:) select:tableID lable:@"班台型号："];
 
 [self taskFinished:[Access getRoomTableColorThumb:tableID] identifier:@"tableColor"];
 
 return;
 }
 
 if ([identifier isEqualToString:@"tableColor"] && task)
 {
 
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(tableColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"班台颜色型号："];
 
 return;
 }
 if ([identifier isEqualToString:@"tablePath"] && task)
 {
 
 if(tableID == 0)
 {
 tableID = [[[task objectAtIndex:0]objectForKey:@"id"]intValue];
 }
 
 [self getPic:tableID layer:1];
 
 [self sequenceDanzhenChangeAngle:task layer:1];
 
 return;
 
 }
 //
 if ([identifier isEqualToString:@"chagui"] && task)
 {
 contentData = [task retain];
 
 NSLog(@"contentData    ==   %@",contentData);
 
 [self makePropertyThumberWithEvent:@selector(chaguiItemClick:) select:chaguiID lable:@"茶柜型号："];
 
 [self taskFinished:[Access getRoomchaguiColorThumb:chaguiID] identifier:@"chaguiColor"];
 
 return;
 
 }
 if ([identifier isEqualToString:@"chaguiColor"] && task)
 {
 
 NSLog(@"task    ==   %@",task);
 
 contentColorlData = [task retain];
 
 chajiID = [[[task objectAtIndex:0]objectForKey:@"color1_id"]intValue];
 
 if([[task objectAtIndex:0]objectForKey:@"color2_id"] != [NSNull null])
 {
 guiziID = [[[task objectAtIndex:0]objectForKey:@"color2_id"]intValue]; 
 }
 else 
 {
 guiziID = -1;
 }
 
 [self makePropertyColorThumberWithEvent2:@selector(chaguiColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"茶柜颜色型号："];
 
 return;
 }
 if ([identifier isEqualToString:@"DefaultchaguiPath"])
 {
 
 if(!task)
 {
 [self taskFinished:[Access getRoomDefaultchaguiPath:0 chaguiID:chaguiID roomID:roomID] identifier:@"DefaultchaguiPath"];
 
 return;
 
 }
 
 chaguiID = [[[task objectAtIndex:0]objectForKey:@"id"]intValue];  
 
 chajiID = [[[task objectAtIndex:0]objectForKey:@"color1_id"]intValue];
 
 guiziID = [[[task objectAtIndex:0]objectForKey:@"color2_id"]intValue];
 
 [self getPic:chaguiID layer:0];
 
 [self sequenceDanzhenChangeAngle:task layer:2];
 return;
 }
 if ([identifier isEqualToString:@"DefaultchaguiPath_xuni"] && task)
 {
 chaguiID = [[[task objectAtIndex:0]objectForKey:@"id"]intValue];  
 
 chajiID = [[[task objectAtIndex:0]objectForKey:@"color1_id"]intValue];
 
 guiziID = [[[task objectAtIndex:0]objectForKey:@"color2_id"]intValue];
 
 [self getPic:chaguiID layer:0];
 
 [self sequenceDanzhenChangeAngle:task layer:2];
 
 return;
 }
 if ([identifier isEqualToString:@"chaguiPath"])
 {
 
 if(!task)
 {
 
 //[self taskFinished:[Access getRoomchaguiPath:chaguiID] identifier:@"chaguiPath"];
 
 return;
 
 }
 
 chaguiID = [[[task objectAtIndex:0] objectForKey:@"id"]intValue];
 
 [self sequenceDanzhenChangeAngle:task layer:2];
 
 return;
 }
 
 
 //
 if ([identifier isEqualToString:@"shayi"] && task)
 {
 contentData = [task retain];
 
 NSLog(@"contentData   ==  %@",contentData);
 
 [self makePropertyThumberWithEvent:@selector(shayiItemClick:) select:shayiID lable:@"沙椅型号："];
 
 [self taskFinished:[Access getRoomchaguiColorThumb:shayiID] identifier:@"shayiColor"];
 
 return;
 }
 if ([identifier isEqualToString:@"shayiColor"] && task)
 {
 contentColorlData = [task retain];
 
 //shayiID = [[[task objectAtIndex:0]objectForKey:@"id"]intValue];
 
 shafaID = [[[task objectAtIndex:0]objectForKey:@"color1_id"]intValue];
 
 yiziID = [[[task objectAtIndex:0]objectForKey:@"color2_id"]intValue];
 
 [self makePropertyColorThumberWithEvent2:@selector(shayiColorItemClick:) select:[[[contentColorlData objectAtIndex:0]objectForKey:@"id"]intValue] lable:@"沙椅颜色型号："];
 return;
 }
 
 if ([identifier isEqualToString:@"DefaultshayiPath"])
 {
 
 if(!task)
 {
 
 [self taskFinished:[Access getRoomDefaultshayiPath:1 shayiID:shayiID roomID:roomID] identifier:@"DefaultshayiPath"];
 
 return;
 
 }
 
 shayiID = [[[task objectAtIndex:0]objectForKey:@"id"]intValue];
 
 shafaID = [[[task objectAtIndex:0]objectForKey:@"color1_id"]intValue];
 
 yiziID = [[[task objectAtIndex:0]objectForKey:@"color2_id"]intValue];
 
 [self getPic:shayiID layer:2];
 
 [self sequenceDanzhenChangeAngle:task layer:3];
 return;
 }
 if ([identifier isEqualToString:@"DefaultshayiPath_xuni"] && task)
 {
 shayiID = [[[task objectAtIndex:0]objectForKey:@"id"]intValue];
 
 [self getPic:shayiID layer:2];
 
 [self sequenceDanzhenChangeAngle:task layer:3];
 
 return;
 }
 
 
 if ([identifier isEqualToString:@"shayiPath"])
 {
 
 if(!task)
 {
 
 [self taskFinished:[Access getRoomshayiPath:shayiID] identifier:@"shayiPath"];
 
 return;
 
 }
 
 //shayiID = [[[task objectAtIndex:0] objectForKey:@"id"]intValue];
 
 [self sequenceDanzhenChangeAngle:task layer:3];
 
 //NSLog(@"dddd    ==   %@",task);
 
 return;
 }
 //
 if ([identifier isEqualToString:@"wall"] && task)
 {
 contentData = [task retain];
 
 NSLog(@"  ---------   %d",wallID);
 
 [self makePropertyThumberWithEvent:@selector(wallItemClick:) select:wallID lable:@"墙面颜色型号："];
 return;
 }
 if ([identifier isEqualToString:@"cap"] && task)
 {
 contentColorlData = [task retain];
 
 [self makePropertyColorThumberWithEvent:@selector(capItemClick:) select:capID lable:@"地面颜色型号："];
 
 return;
 }
 //
 if ([identifier isEqualToString:@"DefaultwallCap"] && task)
 {
 wallID = [[[task objectAtIndex:0]objectForKey:@"wall_id"]intValue];
 
 capID = [[[task objectAtIndex:0]objectForKey:@"carpet_id"]intValue];
 
 [self sequenceDanzhenChangeAngle:task layer:0];
 
 return;
 }
 
 if ([identifier isEqualToString:@"wallcapPath"] && task)
 {  
 [self sequenceDanzhenChangeAngle:task layer:0];
 }
 
 }
 
 
 -(void)sequenceDanzhenChangeAngle:(NSArray *)array layer:(int)layer
 {
 id path;
 
 if(jiaodu == 1)
 {
 path = [[array objectAtIndex:0]objectForKey:@"viewPhoto1"];
 }
 if(jiaodu == 2)
 {
 path = [[array objectAtIndex:0]objectForKey:@"viewPhoto2"];
 }
 if(jiaodu == 3)
 {
 path = [[array objectAtIndex:0]objectForKey:@"viewPhoto3"];
 }
 if(jiaodu == 4)
 {
 path = [[array objectAtIndex:0]objectForKey:@"viewPhoto4"];
 }
 
 if(path != [NSNull null]){
 
 [sequenceDanzhen updata:layer value:[global getFolderWithName:path]];
 }
 }
 
 //实拍
 - (void)shafaItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 sfID = sender.tag;
 
 [self getPic:sfID layer:0];
 
 [self taskFinished:[Access getSenceRoomSFColorThumbBypro:roomID proID:sfID] identifier:@"senceSFColor"];
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 
 
 - (void)yiziItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 yzID = sender.tag;
 
 [self getPic:yzID layer:1];
 
 [self taskFinished:[Access getSenceRoomYZColorThumbBypro:roomID proID:yzID] identifier:@"senceYZColor"];
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 
 
 - (void)chajiItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 cjID = sender.tag;
 
 [self getPic:cjID layer:2];
 
 
 [self taskFinished:[Access getSenceRoomCJColorThumbBypro:roomID proID:cjID] identifier:@"senceCJColor"];
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 } 
 
 }
 
 
 - (void)shuguiItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 sgID = sender.tag;
 
 [self getPic:sgID layer:3];
 
 [self taskFinished:[Access getSenceRoomSGColorThumbBypro:roomID proID:sgID] identifier:@"senceSGColor"];
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 } 
 
 }
 
 - (void)dianshiguiItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 dsgID = sender.tag;
 
 [self getPic:dsgID layer:4];
 
 [self taskFinished:[Access getSenceRoomDSGColorThumbBypro:roomID proID:dsgID] identifier:@"senceDSGColor"];
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 } 
 
 }
 
 
 - (void)SFColorItemClick:(UIButton *)sender
 {
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 sfcolID = sender.tag;
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 
 - (void)YZColorItemClick:(UIButton *)sender
 {
 
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 yzcolID = sender.tag;
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 - (void)CJColorItemClick:(UIButton *)sender
 {
 
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 cjcolID = sender.tag;
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 - (void)SGColorItemClick:(UIButton *)sender
 {
 
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 sgcolID = sender.tag;
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 - (void)DSGColorItemClick:(UIButton *)sender
 {
 
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 dsgcolID = sender.tag;
 
 [self taskFinished:[Access getSencePathByID:roomID sfid:sfID yzid:yzID cjid:cjID sgid:sgID dsgid:dsgID sfcolID:sfcolID yzcolID:yzcolID cjcolID:cjcolID sgcolID:sgcolID dsgcolID:dsgcolID] identifier:@"sencePathByID"];
 
 break;
 }
 }
 }
 
 
 //虚拟
 
 
 
 
 // 班台----------------------------------------------------------------------------------------------------------------------------------------------------------
 - (void)tableItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 tableID = sender.tag;
 
 [self getPic:tableID layer:1];
 
 [self taskFinished:[Access getRoomTableColorThumb:tableID] identifier:@"tableColor"];
 
 [self taskFinished:[Access getRoomTableDefaultPath:tableID roomID:roomID] identifier:@"tablePath"];
 
 [self taskFinished:[Access getRoomchaguishayiPathByTableID:tableID typeID:0] identifier:@"chaguiPath"];
 
 [self taskFinished:[Access getRoomchaguishayiPathByTableID:tableID typeID:1] identifier:@"shayiPath"];
 
 
 
 break;
 }
 }
 }
 - (void)tableColorItemClick:(UIButton *)sender
 {
 
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 tableColorID = sender.tag;
 
 NSLog(@"tableColorID   ===  %d",tableColorID);
 
 [self taskFinished:[Access getRoomTablePathByColor:tableColorID tableID:tableID] identifier:@"tablePath"];
 
 break;
 }
 }
 }
 
 
 
 //  茶柜------------------------------------------------------------------------------------------------------------------------------------------------------
 
 - (void)chaguiItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 chaguiID = sender.tag;
 
 [self getPic:chaguiID layer:0];
 
 [self taskFinished:[Access getRoomchaguiColorThumb:chaguiID] identifier:@"chaguiColor"];
 
 NSLog(@"ssss   ====   %d  %d %d %d ",chaguiID,shayiID,chajiID,guiziID);
 
 [self taskFinished:[Access getRoomchaguiPath:chaguiID shayiID:shayiID chajiID:chajiID guiziID:guiziID] identifier:@"chaguiPath"];
 
 
 
 break;
 }
 }
 }
 
 - (void)chaguiColorItemClick:(UIButton *)sender
 {
 
 [self resetItemColorButton:sender];
 
 chaguiColorID = sender.tag;
 
 chajiID = [[[contentColorlData objectAtIndex:sender.tag] objectForKey:@"color1_id"]intValue];
 
 if([[contentColorlData objectAtIndex:0]objectForKey:@"color2_id"] != [NSNull null])
 {
 guiziID = [[[contentColorlData objectAtIndex:sender.tag] objectForKey:@"color2_id"]intValue];
 }
 else 
 {
 guiziID = -1;
 }
 
 NSLog(@"ssss   ====   %d  %d %d %d ",chaguiID,shayiID,chajiID,guiziID);
 
 [self taskFinished:[Access getRoomchaguiPath:chaguiID shayiID:shayiID chajiID:chajiID guiziID:guiziID] identifier:@"chaguiPath"];
 
 }
 
 //沙椅  -----------------------------------------------------------------------------------------------------------------------------------------------------
 
 - (void)shayiItemClick:(UIButton *)sender
 {
 
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 shayiID = sender.tag;
 
 [self getPic:shayiID layer:2];
 
 [self taskFinished:[Access getRoomchaguiColorThumb:shayiID] identifier:@"shayiColor"];
 
 NSLog(@"%d  %d %d %d ",chaguiID,shayiID,shafaID,yiziID);
 
 [self taskFinished:[Access getRoomshiyiPath:shayiID shafaID:shafaID yiziID:yiziID] identifier:@"shayiPath"];
 
 [self taskFinished:[Access getRoomchaguiPath:chaguiID shayiID:shayiID chajiID:chajiID guiziID:guiziID] identifier:@"chaguiPath"];
 
 break;
 }
 }
 }
 
 - (void)shayiColorItemClick:(UIButton *)sender
 {
 [self resetItemColorButton:sender];
 
 shayiColorID = sender.tag;
 
 shafaID = [[[contentColorlData objectAtIndex:sender.tag] objectForKey:@"color1_id"]intValue];
 
 yiziID = [[[contentColorlData objectAtIndex:sender.tag] objectForKey:@"color2_id"]intValue];
 
 NSLog(@"%d         00      %d   tt       %d",chajiID,guiziID,chaguiID);
 
 [self taskFinished:[Access getRoomshiyiPath:shayiID shafaID:shafaID yiziID:yiziID] identifier:@"shayiPath"];
 
 
 }
 - (void)wallItemClick:(UIButton *)sender
 {
 [self resetItemButton:sender];
 
 for (id item in contentData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 
 wallID = sender.tag;
 
 NSLog(@"  00    %d",wallID);
 
 [self taskFinished:[Access getRoomWallCapPath:roomID wallID:wallID capID:capID] identifier:@"wallcapPath"];
 
 break;
 }
 }
 }
 - (void)capItemClick:(UIButton *)sender
 {
 [self resetItemColorButton:sender];
 
 for (id item in contentColorlData)
 {
 if ([[item objectForKey:@"id"] intValue]==sender.tag)
 {
 
 capID = sender.tag;
 
 [self taskFinished:[Access getRoomWallCapPath:roomID wallID:wallID capID:capID] identifier:@"wallcapPath"];
 
 break;
 }
 }
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 //手势 
 -(void)UITapSwapEvent
 {
 recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)]; 
 
 [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)]; 
 
 [self.view addGestureRecognizer:recognizer]; 
 
 [recognizer release]; 
 
 
 recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom2:)]; 
 
 [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionLeft)]; 
 
 [self.view addGestureRecognizer:recognizer2]; 
 
 [recognizer2 release]; 
 
 }
 -(void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender
 {
 
 if(isplay)
 {
 [UIView beginAnimations:nil context:nil];
 
 proList.selected=NO;
 
 proInfoView.frame = CGRectMake(1024, 42, 264, 726);
 
 [UIView commitAnimations];
 }
 
 }
 
 -(void)handleSwipeFrom2:(UISwipeGestureRecognizer *)sender
 {
 if(isplay)
 {
 [UIView beginAnimations:nil context:nil];
 
 proList.selected=YES;
 
 proInfoView.frame = CGRectMake(760, 42, 264, 726);
 
 [UIView commitAnimations];
 }
 
 }
 
 //touch 事件
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 touchBegin = [[touches anyObject] locationInView:self.view];
 //
 if (!hidden  && touchBegin.y<573) 
 {
 hidden = YES;
 
 [UIView beginAnimations:nil context:nil];
 
 roomProperty.frame = CGRectMake(0, 768, 1024, 198);
 
 [UIView commitAnimations];
 }
 }
 
 -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UITouch *touch = [touches anyObject];
 
 CGPoint pre = [touch locationInView:self.view];
 
 CGPoint nex = [touch previousLocationInView:self.view];
 
 if (abs(pre.x-nex.x) > 0 && abs(pre.x-nex.x) > abs(pre.y-nex.y))
 {
 if (sequenceView.quality == UISequenceViewQualityHigh)
 {
 sequenceView.quality = UISequenceViewQualityLow;
 }
 
 if (pre.x-nex.x > 0)
 {
 sequenceView.currentFrame++;
 }
 else
 {
 sequenceView.currentFrame--;
 }
 }
 }
 
 -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if (sequenceView.quality == UISequenceViewQualityLow)
 {
 sequenceView.quality = UISequenceViewQualityHigh;
 }
 
 //
 if (hidden) 
 {
 CGPoint temp = [[touches anyObject] locationInView:self.view];
 
 int lx = temp.x-touchBegin.x;
 
 int ly = temp.y-touchBegin.y;
 
 if (lx != 0 && ly != 0 && abs(ly / lx) > 1)
 {
 
 [UIView beginAnimations:nil context:nil];
 
 if(temp.y<touchBegin.y)
 {
 
 
 roomProperty.frame = CGRectMake(0, 535, 1024, 198);
 
 }
 else 
 {
 
 roomProperty.frame = CGRectMake(0, 768, 1024, 198);
 }
 
 [UIView commitAnimations];
 }
 }
 }
 
 
 
 @end
 
 
 
 */
