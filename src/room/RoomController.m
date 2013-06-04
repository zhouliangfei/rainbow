//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "RoomController.h"

#import "RoomTypeCellExtends.h"

#import "GUI.h"
#import "Access.h"
#import "MSWindow.h"
#import "NavigateView.h"


#import "UIGalleryView.h"
#import "UIGalleryViewCell.h"
#import "AboutAlbumCellExtends.h"
#import "global.h"

#import "popTableViewController.h"

@interface RoomController ()
{
    NSMutableArray *spaceType;
    
    NSMutableArray *spaceLeave;
    
    NSMutableArray *spaceSize;
    
    NSMutableDictionary *spaceArr;
    
    int spaceTypeID;
    
    int leaveID;
    
    int sizeID;
    
    //int touchID;
    
    UIGalleryView *content;
    
    NSMutableArray *Data;
    
    //
    UIPopoverController *popover;
    
    popTableViewController *popoverContent;
    
    int row_id;
    
    
    
}


@end

@implementation RoomController

@synthesize touchID;


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
    
    //
    
    isPropduct = NO;
    
    Intjiaodu = 0;
    
    wallID = 0;
    
    capID = 0;
    
    tableID = 0;
    
    shayiID = 0;
    
    shafaID = 0;
    
    yiziID = 0;
    
    chaguiID = 0;
    
    chajiID = 0;
    
    guiziID = 0;
    
    //
    tableColorID = 0;
    
    chaguiColorID = 0;
    
    shayiColorID = 0;
    
    
    tableBool = NO;
    
    CGBool  = NO;
    
    isplay  = NO;
    
    change = NO;
    
    
    //实拍 
    sfID = 0;
    
    yzID = 0;
    
    cjID = 0;
    
    sgID = 0;
    
    dsgID = 0;
    
    sfcolID = 0;
    
    yzcolID = 0;
    
    cjcolID = 0;
    
    sgcolID = 0;
    
    dsgcolID = 0;
    //
    
    leaveID = 0;
    
    [super viewDidLoad];
    
    isPropduct = NO;
    
    [self.view addSubview:[global imageWithSource:@"background.png" frame:CGRectMake(0, 0, 1024, 768)]];
    
    
    spaceLeave = [[NSMutableArray alloc]init];
    
    spaceSize = [[NSMutableArray alloc]init];
    
    spaceArr = [[NSMutableDictionary alloc] init];
    
    //分配三个空间
    for(int i=0;i<3;i++)
    {
        [spaceArr setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:i]];
    }
    
    
    content = [[UIGalleryView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    content.delegate = self;
    
    content.dataSource = self;
    
    content.alwaysBounceHorizontal = YES;
    
    content.type = UIGalleryTypeFlipList;
    
    content.pagingEnabled =YES;
    
    [self.view addSubview:content];

    if(window.location.search)
    {
        spaceTypeID = [[NSString stringWithFormat:@"%@",window.location.search]intValue];
        
        NSLog(@"spaceTypeID   ==   %d",spaceTypeID);
        
        [spaceArr setObject:[NSString stringWithFormat:@"%d",spaceTypeID] forKey:[NSNumber numberWithInt:0]];
        
        if(spaceTypeID ==1)
        {
            Data = [[Access getRoomPicByspaceType:spaceTypeID] retain];
        }
        else 
        {
            Data = [[Access getRoomPic] retain];
        }
    }
    
    NSLog(@"Data   ==   %@",Data);
    
    
    [content reloadData];
    
    [content scrollRectToVisible:CGRectMake(curindex, 0, 1024, 768) animated:NO];
    
    
    [self updata];
    
    //菜单
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    UIControl *spacetype = [menu addChildWithLable:@"空间类型"];
    
    spacetype.tag =0;
    
    UIControl *spaceleave = [menu addChildWithLable:@"空间级别"];
    
    spaceleave.tag = 1;
    
    UIControl *size = [menu addChildWithLable:@"户型大小"];
    
    size.tag = 2;
    
    [spacetype addTarget:self action:@selector(typeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [spaceleave addTarget:self action:@selector(leaveTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [size addTarget:self action:@selector(sizeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:menu];
    //
    
    pages = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 768-31, 1024, 31)];
    
    NSLog(@"---------     %d",Data.count);
        
    pages.numberOfPages = Data.count;
       
    pages.currentPage = curp;
        
    [self.view addSubview:pages];
    
    
}

-(void)updata
{
    
    //经理办公室，老板办公室
    //16平米，24平米，35平米，42平米，51平米，70平米以上
    //空间级别和大小
    [spaceSize removeAllObjects];
    
    [spaceLeave removeAllObjects];
    
    NSLog(@"%@",Data);
    
    for(int i=0;i<[Data count];i++)
    {
        id val = [NSString stringWithFormat:@"%@",[[Data objectAtIndex:i] objectForKey:@"level"]];

        id value = [self getLevel:val];
        
        if (value && ![spaceLeave containsObject:value])
        {
            [spaceLeave addObject:value];
        }
        
        id val2 = [NSString stringWithFormat:@"%@",[[Data objectAtIndex:i] objectForKey:@"size"]];
        
        id value2 = [self getSize:val2];

        
        if (value2 && ![spaceSize containsObject:value2])
        {
            [spaceSize addObject:value2];
        }
    }
    
    if (spaceLeave.count > 0 && spaceSize.count > 0)
    {
        [spaceArr setObject:[NSString stringWithFormat:@"%@",[spaceLeave objectAtIndex:0]] forKey:[NSNumber numberWithInt:1]];
        
        [spaceArr setObject:[NSString stringWithFormat:@"%@",[spaceSize objectAtIndex:0]] forKey:[NSNumber numberWithInt:2]];
    }

}


-(void)updatasize
{
    
    //经理办公室，老板办公室
    //16平米，24平米，35平米，42平米，51平米，70平米以上
    //空间级别和大小
    [spaceSize removeAllObjects];
    
    NSLog(@"%@",Data);
    
    for(int i=0;i<[Data count];i++)
    {
        id val2 = [NSString stringWithFormat:@"%@",[[Data objectAtIndex:i] objectForKey:@"size"]];
        
        id value2 = [self getSize:val2];
        
        if (value2 && ![spaceSize containsObject:value2])
        {
            [spaceSize addObject:value2];
        }
    }
    
    if (spaceSize.count > 0)
    {
        [spaceArr setObject:[NSString stringWithFormat:@"%@",[spaceSize objectAtIndex:0]] forKey:[NSNumber numberWithInt:2]];
    }
    
}


-(id)getLevel:(id)level
{
    NSLog(@"level=====      %@",level);
    
    NSArray *levTemp = [NSArray arrayWithObjects:@"经理办公室",@"老板办公室",nil];
    
    if ([level intValue] < levTemp.count)
    {
        return [levTemp objectAtIndex:[level intValue]];
    }
    
    return nil;
}

-(id)getLevelWithName:(id)level
{
    
    NSLog(@"level=====      %@",level);
    
    NSArray *levTemp = [NSArray arrayWithObjects:@"经理办公室",@"老板办公室",nil];
    
    for (int i=0; i<levTemp.count; i++) {
        if ([[levTemp objectAtIndex:i] isEqual:level])
        {
            return [NSNumber numberWithInt:i];
        }
    }
    
    return [NSNumber numberWithInt:0];
}

-(id)getSize:(id)size
{
    NSArray *sizTemp = [NSArray arrayWithObjects:@"15-20平米",@"20-25平米",@"25-35平米",@"35-45平米",@"45-55平米",@"24平米",@"55-70平米或以上",nil];
    
    if ([size intValue] < sizTemp.count)
    {
        return [sizTemp objectAtIndex:[size intValue]];
    }
    
    return nil;
}

-(id)getSizeWithName:(id)size
{
    NSArray *sizTemp = [NSArray arrayWithObjects:@"15-20平米",@"20-25平米",@"25-35平米",@"35-45平米",@"45-55平米",@"24平米",@"55-70平米或以上",nil];
    
    for (int i=0; i<sizTemp.count; i++) {
        if ([[sizTemp objectAtIndex:i] isEqual:size])
        {
            return [NSNumber numberWithInt:i];
        }
    }
    
    return [NSNumber numberWithInt:0];
}


- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)dealloc
{
    
    [super dealloc];
}


-(void)openpop:(NSMutableArray *)arr con:(UIView*)sender
{
    popoverContent = [[popTableViewController alloc] init];
    
    popoverContent.oceanaViewController = self;
    //
    popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    [popover setPopoverContentSize:CGSizeMake(200,arr.count * 43)];
    
    popoverContent.contentSizeForViewInPopover=popoverContent.view.bounds.size;
    
    popoverContent.popoverController = popover;
    
    popoverContent.myArray = arr;
    
    
    if(touchID == 0)
    {
        if(spaceTypeID==1)
        {
            popoverContent.active = 1;
        }
        else 
        {
            popoverContent.active = 0;
        }
    }
    if(touchID == 1)
    {
        if(b1)
        {
            popoverContent.active = leaveID;
        }
        else 
        {
            popoverContent.active = -1;
        }
        
    }
    if(touchID == 2)
    {
        if(b2)
        {
            popoverContent.active = sizeID;
        }
        else 
        {
            popoverContent.active = -1;
        }
    }
   
    
    
    CGRect rect = CGRectMake(((UIView *)sender).frame.origin.x+50,((UIView *)sender).frame.origin.y-10,((UIView *)sender).frame.size.width,((UIView *)sender).frame.size.height);
    
    [popover presentPopoverFromRect:rect
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];  
    
    [popoverContent release]; 
    
    [popoverContent.myArray release];
    
}

-(void)typeTouch:(UIControl*)sender
{
    boo = YES;
    
    touchID = sender.tag;
    
    spaceType = [[NSMutableArray alloc] initWithObjects:@"虚拟空间",@"实拍样板间", nil];
    
    [self openpop:spaceType con:((UIView *)sender)];
}
-(void)leaveTouch:(UIControl*)sender
{
    boo = NO;
    
    touchID = sender.tag;
    
    [self openpop:spaceLeave con:((UIView *)sender)];
    
}
-(void)sizeTouch:(UIControl*)sender
{
    boo = NO;
    
    touchID = sender.tag;
    
    [self openpop:spaceSize con:((UIView *)sender)];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController*)popoverController
{
    if (popover) 
    {
        [popover dismissPopoverAnimated:YES];
        
        [popover release];
        
        popover=nil;
        
        if (popoverContent != nil) 
        {
            [popoverContent release];
            
            popoverContent = nil;
        }
    }
}


-(void)killPopoversOnSight:(int)rowid
{
    
    NSLog(@"  ....   ==   %d    %d",touchID,rowid);
    
    if(touchID == 1)
    {
        leaveID = rowid;
    }
    
    if(touchID == 2)
    {
        sizeID = rowid;
    }
    
    if (popover)
    {
        if(boo)
        {
            spaceTypeID = rowid;
        }
    }

    pages.currentPage=0;
    
    [content scrollRectToVisible:CGRectMake(0, 0, 1024, 768) animated:NO];
}
-(void)textGetValue:(NSString *)value 
{
    
    NSLog(@"value   ===   %@",value);
    
    if(touchID==0)
    {
        
        b1 = NO;
        
        b2 = NO;
        
        t = 0;
        
        [spaceLeave removeAllObjects];
        
        [spaceSize removeAllObjects];
        
        if([value isEqualToString:@"虚拟空间"])
        {
            [spaceArr setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSNumber numberWithInt:0]];
            
            Data = [[Access getRoomPic] retain];
        }
        if([value isEqualToString:@"实拍样板间"])
        {
            [spaceArr setObject:[NSString stringWithFormat:@"%d",1] forKey:[NSNumber numberWithInt:0]];
            
            Data = [[Access getRoomPicByspaceType:1] retain];
        }
        
        [content reloadData];
        
        pages.numberOfPages = Data.count;
        
        pages.currentPage = 0;

        
        //空间级别和大小 
        [self updata];
        
        return;
    }
    //

    if(touchID ==  1)
    {
        b1 = YES;
        
        b2 = NO;
        
        [spaceArr setObject:[NSString stringWithFormat:@"%@",value] forKey:[NSNumber numberWithInt:1]];
        
        id lev = [self getLevelWithName:[spaceArr objectForKey:[NSNumber numberWithInt:1]]];

        t = lev;
        
        Data = [[Access getRoomPicByspaceTypeAndLev:[[spaceArr objectForKey:[NSNumber numberWithInt:0]] intValue] lev:lev spaceid:spaceTypeID] retain];
        
        [content reloadData];
        
        pages.numberOfPages = Data.count;
        
        pages.currentPage = 0;
        
        [self updatasize];
    }
    if(touchID ==  2)
    {
        
        b2 = YES;
        
        [spaceArr setObject:[NSString stringWithFormat:@"%@",value] forKey:[NSNumber numberWithInt:2]];
        
        id siz = [self getSizeWithName:[spaceArr objectForKey:[NSNumber numberWithInt:2]]];
        
        int temp;
        
        if([[spaceArr objectForKey:[NSNumber numberWithInt:2]] rangeOfString:@"16"].location !=NSNotFound)
        {
            
            temp = 2;
        }
        else 
        {
            temp = [[spaceArr objectForKey:[NSNumber numberWithInt:0]] intValue];
        }
        
        NSLog(@"----  %@", t);
        
        Data = [[Access getRoomPicByspaceTypeAndLevSize:temp lev:t size:siz spaceid:spaceTypeID] retain];
        
        [content reloadData];
        
        pages.numberOfPages = Data.count;
        
        pages.currentPage = 0;


    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int value = (scrollView.contentOffset.x+scrollView.bounds.size.width / 2) / scrollView.bounds.size.width;
    
    curp = value;
    
    pages.currentPage = value;
}


//代理  
-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)flowCover
{
    return [Data count];
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
{
    return 768;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;
{
    return 1024;
}

-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndex *)indexPath
{
    static NSString *roomGridCell = @"roomGridCell";
    
    RoomTypeCellExtends *cell = (RoomTypeCellExtends*)[galleryView dequeueReusableCellWithIdentifier:roomGridCell];
    
    if (nil == cell)
    {
        cell = [[[RoomTypeCellExtends alloc] initWithReuseIdentifier:roomGridCell] autorelease];
    }
    
    NSString *path = [[Data objectAtIndex:indexPath.row] objectForKey:@"photo"];
    
    cell.image = [UIImage imageWithContentsOfFile:[Utils getPathWithFile:path]];
    
    return cell;
}


- (void)galleryView:(UIGalleryView *)galleryView didSelectRowAtIndexPath:(NSIndex *)indexPath
{
    id cur = [Data objectAtIndex:indexPath.row];

    curindex = content.contentOffset.x;
    
    window.location.hash = [NSNumber numberWithFloat:content.contentOffset.x];
    
    window.location = [MSRequest requestWithName:@"RoomViewController" search:cur];
}

//


@end




////
////  ViewController.m
////  project
////
////  Created by mac on 12-10-22.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//#import "RoomController.h"
//
//#import "RoomTypeCellExtends.h"
//
//#import "GUI.h"
//#import "Access.h"
//#import "MSWindow.h"
//#import "NavigateView.h"
//
//
//#import "UIGalleryView.h"
//#import "UIGalleryViewCell.h"
//#import "AboutAlbumCellExtends.h"
//#import "global.h"
//
//#import "popTableViewController.h"
//
//@interface RoomController ()
//{
//    NSMutableArray *spaceType;
//    
//    NSMutableArray *spaceLeave;
//    
//    NSMutableArray *spaceSize;
//    
//    NSMutableDictionary *spaceArr;
//    
//    int spaceTypeID;
//    
//    //int touchID;
//    
//    UIGalleryView *content;
//    
//    NSMutableArray *Data;
//
//    //
//    UIPopoverController *popover;
//    
//    popTableViewController *popoverContent;
//    
//    int row_id;
//    
//    
//}
//
//
//@end
//
//@implementation RoomController
//
//@synthesize touchID;
//
//
//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    
//    if (self)
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
//    }
//    
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    isPropduct = NO;
//
//    [self.view addSubview:[global imageWithSource:@"background.png" frame:CGRectMake(0, 0, 1024, 768)]];
//    
//    
//    spaceLeave = [[NSMutableArray alloc]init];
//    
//    spaceSize = [[NSMutableArray alloc]init];
//    
//    spaceArr = [[NSMutableDictionary alloc] init];
//    
//    //分配三个空间
//    [spaceArr setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:0]];
//    /*for(int i=0;i<3;i++)
//    {
//        [spaceArr setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:i]];
//    }*/
//    
//
//    content = [[UIGalleryView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//    
//    content.delegate = self;
//    
//    content.dataSource = self;
//    
//    content.alwaysBounceHorizontal = YES;
//    
//    content.type = UIGalleryTypeFlipList;
//    
//    content.pagingEnabled =YES;
//    
//    [self.view addSubview:content];
//    
//    
//    if(window.location.search)
//    {
//        spaceTypeID = [[NSString stringWithFormat:@"%@",window.location.search]intValue];
//        
//        NSLog(@"spaceTypeID   ==   %d",spaceTypeID);
//        
//        [spaceArr setObject:[NSString stringWithFormat:@"%d",spaceTypeID] forKey:[NSNumber numberWithInt:0]];
//        
//        if(spaceTypeID ==1)
//        {
//             Data = [[Access getRoomPicByspaceType:spaceTypeID] retain];
//        }
//        else 
//        {
//            Data = [[Access getRoomPic] retain];
//        }
//    }
//    
//    [content reloadData];
//    
//    //content.frame = CGRectMake(curindex, 0, 1024, 768);
//    
//    
//    [self updata];
//
//    //菜单
//    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
//    
//    UIControl *spacetype = [menu addChildWithLable:@"空间类型"];
//    
//    spacetype.tag =0;
//    
//    UIControl *spaceleave = [menu addChildWithLable:@"空间级别"];
//    
//    spaceleave.tag = 1;
//
//    UIControl *size = [menu addChildWithLable:@"户型大小"];
//    
//    size.tag = 2;
//    
//    [spacetype addTarget:self action:@selector(typeTouch:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [spaceleave addTarget:self action:@selector(leaveTouch:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [size addTarget:self action:@selector(sizeTouch:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:menu];
//    
//    pages = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 768-31, 1024, 31)];
//    
//    pages.numberOfPages = Data.count;
//    
//    pages.currentPage = 0;
//    
//    [self.view addSubview:pages];
//}
//
//-(void)updata
//{
//    
//    //经理办公室，老板办公室
//    //16平米，24平米，35平米，42平米，51平米，70平米以上
//    //空间级别和大小
//    [spaceSize removeAllObjects];
//    
//    [spaceLeave removeAllObjects];
//    
//    for(int i=0;i<[Data count];i++)
//    {
//        id val = [NSString stringWithFormat:@"%@",[[Data objectAtIndex:i] objectForKey:@"level"]];
//        
//        id value = [self getLevel:val];
//        
//        if (value && ![spaceLeave containsObject:value])
//        {
//            [spaceLeave addObject:value];
//        }
//        
//        id val2 = [NSString stringWithFormat:@"%@",[[Data objectAtIndex:i] objectForKey:@"size"]];
//        
//        id value2 = [self getSize:val2];
//        
//        if (value2 && ![spaceSize containsObject:value2])
//        {
//            [spaceSize addObject:value2];
//        }
//    }
//    
//    if (spaceLeave.count > 0 && spaceSize.count > 0)
//    {
//        [spaceArr setObject:[NSString stringWithFormat:@"%@",[spaceLeave objectAtIndex:0]] forKey:[NSNumber numberWithInt:1]];
//        
//        [spaceArr setObject:[NSString stringWithFormat:@"%@",[spaceSize objectAtIndex:0]] forKey:[NSNumber numberWithInt:2]];
//    }
//}
//
//-(id)getLevel:(id)level
//{
//    NSArray *levTemp = [NSArray arrayWithObjects:@"经理办公室",@"老板办公室",nil];
//
//    if ([level intValue] < levTemp.count)
//    {
//        return [levTemp objectAtIndex:[level intValue]];
//    }
//    
//    return nil;
//}
//
//-(id)getLevelWithName:(id)level
//{
//    NSArray *levTemp = [NSArray arrayWithObjects:@"经理办公室",@"老板办公室",nil];
//    
//    for (int i=0; i<levTemp.count; i++) {
//        if ([[levTemp objectAtIndex:i] isEqual:level])
//        {
//            return [NSNumber numberWithInt:i];
//        }
//    }
//    
//    return [NSNumber numberWithInt:0];
//}
//
//-(id)getSize:(id)size
//{
//    NSArray *sizTemp = [NSArray arrayWithObjects:@"16平米",@"24平米",@"35平米",@"42平米",@"51平米",@"24平米",@"70平米以上",nil];
//    
//    if ([size intValue] < sizTemp.count)
//    {
//        return [sizTemp objectAtIndex:[size intValue]];
//    }
//    
//    return nil;
//}
//
//-(id)getSizeWithName:(id)size
//{
//    NSArray *sizTemp = [NSArray arrayWithObjects:@"16平米",@"24平米",@"35平米",@"42平米",@"51平米",@"24平米",@"70平米以上",nil];
//    
//    for (int i=0; i<sizTemp.count; i++) {
//        if ([[sizTemp objectAtIndex:i] isEqual:size])
//        {
//            return [NSNumber numberWithInt:i];
//        }
//    }
//    
//    return [NSNumber numberWithInt:0];
//}
//
//- (void)viewDidUnload
//{
//  
//    [super viewDidUnload];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
//}
//
//-(void)dealloc
//{
//
//    [super dealloc];
//}
//
//
//-(void)openpop:(NSMutableArray *)arr con:(UIView*)sender
//{
//
//    popoverContent = [[popTableViewController alloc] init];
//    
//    popoverContent.oceanaViewController = self;
//    //
//    popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
//    
//    [popover setPopoverContentSize:CGSizeMake(200,200)];
//    
//    popoverContent.contentSizeForViewInPopover=popoverContent.view.bounds.size;
//    
//    popoverContent.popoverController = popover;
//    
//    popoverContent.myArray = arr;
//    
//  
//    if(touchID==1)
//    {
//        id lev = [spaceArr objectForKey:[NSNumber numberWithInt:1]];
//        
//        if (lev)
//        {
//            popoverContent.active = [[self getLevelWithName:lev] intValue];
//        }
//    }
//    else 
//    {
//        id siz = [spaceArr objectForKey:[NSNumber numberWithInt:2]];
//        
//        if (siz)
//        {
//            popoverContent.active = [[self getSizeWithName:siz] intValue];
//        }
//    }
//
//    
//    CGRect rect = CGRectMake(((UIView *)sender).frame.origin.x+50,((UIView *)sender).frame.origin.y-10,((UIView *)sender).frame.size.width,((UIView *)sender).frame.size.height);
//    
//    [popover presentPopoverFromRect:rect
//                             inView:self.view
//           permittedArrowDirections:UIPopoverArrowDirectionAny
//                           animated:YES];  
//    
//    [popoverContent release]; 
//    
//    [popoverContent.myArray release];
//
//}
//
//-(void)typeTouch:(UIControl*)sender
//{
//    boo = YES;
//    
//    touchID = sender.tag;
//    
//    spaceType = [[NSMutableArray alloc] initWithObjects:@"虚拟空间",@"实拍样板间", nil];
//
//    [self openpop:spaceType con:((UIView *)sender)];
//}
//-(void)leaveTouch:(UIControl*)sender
//{
//    boo = NO;
//    
//    touchID = sender.tag;
//    
//    [self openpop:spaceLeave con:((UIView *)sender)];
//    
//}
//-(void)sizeTouch:(UIControl*)sender
//{
//    boo = NO;
//    
//    touchID = sender.tag;
//
//    [self openpop:spaceSize con:((UIView *)sender)];
//}
//
//
//- (void)popoverControllerDidDismissPopover:(UIPopoverController*)popoverController
//{
//    if (popover) 
//    {
//        [popover dismissPopoverAnimated:YES];
//        
//        [popover release];
//        
//        popover=nil;
//        
//        if (popoverContent != nil) 
//        {
//            [popoverContent release];
//            
//            popoverContent = nil;
//        }
//    }
//}
//
//
//-(void)killPopoversOnSight:(int)rowid
//{
//    if (popover)
//    {
//        if(boo)
//        {
//            spaceTypeID = rowid;
//        }
//    }
//}
//-(void)textGetValue:(NSString *)value 
//{
//
//    if(touchID==0)
//    {
//        
//        [spaceLeave removeAllObjects];
//        
//        [spaceSize removeAllObjects];
//        
//        if([value isEqualToString:@"虚拟空间"])
//        {
//            [spaceArr setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSNumber numberWithInt:0]];
//            
//            Data = [[Access getRoomPic] retain];
//        }
//        
//        if([value isEqualToString:@"实拍样板间"])
//        {
//            [spaceArr setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSNumber numberWithInt:0]];
//            
//            Data = [[Access getRoomPicByspaceType:1] retain];
//        }
//
//        [content reloadData];
//
//        
//        //空间级别和大小 
//        [self updata];
//        
//        return;
//    }
//    //
//    if(touchID ==  1)
//    {
//        [spaceArr setObject:[NSString stringWithFormat:@"%@",value] forKey:[NSNumber numberWithInt:1]];
//    }
//    if(touchID ==  2)
//    {
//        [spaceArr setObject:[NSString stringWithFormat:@"%@",value] forKey:[NSNumber numberWithInt:2]];
//    }
//
//    //
//    id lev = [self getLevelWithName:[spaceArr objectForKey:[NSNumber numberWithInt:1]]];
//    
//    id siz = [self getSizeWithName:[spaceArr objectForKey:[NSNumber numberWithInt:2]]];
//    
//    Data = [[Access getRoomPicByspaceTypeAndLevSize:[[spaceArr objectForKey:[NSNumber numberWithInt:0]] intValue] lev:lev size:siz] retain];
//    
//   [content reloadData];
//
//    pages.numberOfPages = Data.count;
//    
//    pages.currentPage = 0;
//}
//
//
////代理  
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int value = (scrollView.contentOffset.x+scrollView.bounds.size.width / 2) / scrollView.bounds.size.width;
//    
//    pages.currentPage = value;
//}
//
//-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)flowCover
//{
//    return [Data count];
//}
//
//-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
//{
//    return 768;
//}
//
//-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;
//{
//    return 1024;
//}
//
//-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndex *)indexPath
//{
//    
//    static NSString *roomGridCell = @"roomGridCell";
//    
//    RoomTypeCellExtends *cell = (RoomTypeCellExtends*)[galleryView dequeueReusableCellWithIdentifier:roomGridCell];
//    
//    if (nil == cell)
//    {
//        cell = [[[RoomTypeCellExtends alloc] initWithReuseIdentifier:roomGridCell] autorelease];
//    }
//    
//    NSString *path = [[Data objectAtIndex:indexPath.row] objectForKey:@"photo"];
//    
//    cell.image = [UIImage imageWithContentsOfFile:[Utils getPathWithFile:path]];
//    
//    return cell;
//}
//
//
//- (void)galleryView:(UIGalleryView *)galleryView didSelectRowAtIndexPath:(NSIndex *)indexPath
//{
//    id cur = [Data objectAtIndex:indexPath.row];
//    
//    NSLog(@"cur    ===   %@",cur);
//    
//    curindex = content.contentOffset.x;
//    
//    window.location.hash = [NSNumber numberWithFloat:content.contentOffset.x];
//    
//   // window.location = [MSRequest requestWithName:@"RoomViewController" search:cur];
//}
//
////
//
//
//@end
