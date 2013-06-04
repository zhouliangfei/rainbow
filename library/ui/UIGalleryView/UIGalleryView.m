//
//  FlowCoverView.m
//  FlowCoverView
//
//  Created by mac on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIGalleryView.h"

//透视效果
CATransform3D CATransform3DMakePerspective(CGPoint center, float positionZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    
    CATransform3D scale = CATransform3DIdentity;
    
    scale.m34 = -1.0f / positionZ;
    
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

//排序
NSInteger compareViewDepth(id obj1, id obj2, void *context)
{
	CATransform3D t1 = ((UIView *)obj1).layer.transform;
    
	CATransform3D t2 = ((UIView *)obj2).layer.transform;
    
    CGFloat z1 = t1.m13 + t1.m23 + t1.m33 + t1.m43;
    
    CGFloat z2 = t2.m13 + t2.m23 + t2.m33 + t2.m43;
    
    CGFloat difference = z1 - z2;
    
    if (difference == 0.0f)
    {
        CATransform3D t3 = ((UIView *)context).layer.transform;
        
        CGFloat x1 = t1.m11 + t1.m21 + t1.m31 + t1.m41;
        
        CGFloat x2 = t2.m11 + t2.m21 + t2.m31 + t2.m41;
        
        CGFloat x3 = t3.m11 + t3.m21 + t3.m31 + t3.m41;
        
        difference = fabsf(x2 - x3) - fabsf(x1 - x3);
    }
    
    return (difference < 0.0f)? NSOrderedAscending: NSOrderedDescending;
}

//............................................NSIndexPath......................................
@implementation NSIndex

@synthesize row = _row;

@synthesize column = _column;

+(NSIndex *)indexForRow:(NSInteger)row inColumn:(NSInteger)column
{
    NSIndex *temp = [[NSIndex alloc] initWithRow:row column:column];

    return [temp autorelease];
}

-(id)initWithRow:(NSUInteger)row column:(NSUInteger)column
{
    self = [super init];
    
    if (self)
    {
        _row = row;
        
        _column = column;
    }
    
    return self;
}

@end

//............................................NSRect......................................
@interface NSRect:NSObject

+(id)rectWithCGRect:(CGRect)rect;

-(id)initWithCGRect:(CGRect)rect;

@property(nonatomic,readonly) CGFloat x;

@property(nonatomic,readonly) CGFloat y;

@property(nonatomic,readonly) CGFloat width;

@property(nonatomic,readonly) CGFloat height;

@property(nonatomic,readonly) CGFloat centerX;

@property(nonatomic,readonly) CGFloat centerY;

@end

//
@implementation NSRect

@synthesize x;

@synthesize y;

@synthesize width;

@synthesize height;

@synthesize centerX;

@synthesize centerY;

+(id)rectWithCGRect:(CGRect)rect
{
    return [[[NSRect alloc] initWithCGRect:rect] autorelease];
}

-(id)initWithCGRect:(CGRect)rect
{
    self = [super init];
    
    if (self) 
    {
        x = rect.origin.x;
        
        y = rect.origin.y;
        
        width = rect.size.width;
        
        height = rect.size.height;
        
        centerX = x + width / 2.0;
        
        centerY = y + height / 2.0;
    }
    
    return self;
}

@end

//............................................UIGalleryView......................................
@interface UIGalleryView ()
{
    NSInteger centerIndex;

    NSMutableDictionary *visiableCells;
    
    NSMutableArray *reusableTableCells;

    NSMutableArray *flipPosition;
}

@end

@implementation UIGalleryView

@synthesize dataSource;

@dynamic delegate;

@synthesize type;
//
@synthesize centerGap;

@synthesize focalLength;

@synthesize angle;

//
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        focalLength = 120;
        
        visiableCells = [[NSMutableDictionary alloc] init];
        
        reusableTableCells = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        focalLength = 120;
        
        visiableCells = [[NSMutableDictionary alloc] init];
        
        reusableTableCells = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [visiableCells release];
    
    [reusableTableCells release];
    
    [flipPosition release];
    
    [super dealloc];
}

- (void)setDelegate:(id<UIGalleryViewDelegate>)delegate
{
    if (delegate != self.delegate)
    {
        //继承scrollView代理事件
        [super setDelegate:delegate];
    }
}

//修正ContentOffset
-(void)reviseContentOffset:(inout CGPoint*)targetContentOffset
{
    if (type == UIGalleryTypeCoverFlow)
    {
        NSInteger off = NSIntegerMin;
        
        NSInteger min = NSIntegerMax;
        
        NSArray *items = [flipPosition objectAtIndex:0];
        
        CGFloat tx = targetContentOffset->x + self.bounds.size.width / 2.0;
        
        for (int i=0;i<items.count;i++)
        {
            NSRect *rect = [items objectAtIndex:i];
            
            NSInteger temp = fmin(min, abs(tx-rect.centerX));
            
            if (temp < min) 
            {
                off = i;
            }
            
            min = temp;
        }
        
        //重设结束位置
        NSRect *rect = [items objectAtIndex:off];
        
        targetContentOffset->x = rect.centerX - self.bounds.size.width/2.0;
    }
}

-(void)reloadData
{
    for (UIView *layer in [visiableCells allValues])
    {
        [layer removeFromSuperview];
    }
    
    for (UIView *layer in reusableTableCells)
    {
        [layer removeFromSuperview];
    }
    
    [visiableCells removeAllObjects];
    
    [reusableTableCells removeAllObjects];
    
    [flipPosition release];

    flipPosition = nil;
    
    //
    [self layoutSubviews];
}

-(UIGalleryViewCell*)cellAtRow:(int)rowIndex atColumn:(int)columnIndex
{
    NSInteger count = [self getColumns];
    
    NSInteger index = rowIndex * count + columnIndex;
    
    return [visiableCells objectForKey:[NSNumber numberWithInt:index]];
}

//
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self makePosition];

    [self render];
}

- (void)render
{
    //visible view indices
    NSSet *visibleIndices = [self getVisibleCell];
    
    //remove offscreen layer
    for (NSNumber *number in [visiableCells allKeys])
    {
        if (![visibleIndices containsObject:number])
        {
            UIGalleryViewCell *layer = [visiableCells objectForKey:number];
            
            [layer setHidden:YES];

            [reusableTableCells addObject:layer];

            [visiableCells removeObjectForKey:number];
        }
    }

    //add onscreen layer
    NSInteger count = [self getColumns];
    
    for (NSNumber *number in visibleIndices)
    {
        UIGalleryViewCell *layer = [visiableCells objectForKey:number];
        
        NSInteger index = [number integerValue];

        NSInteger row = index / count;
        
        NSInteger col = index % count;
        
        if (layer == nil)
        {
            layer = [dataSource galleryView:self cellForRowAtIndexPath:[NSIndex indexForRow:row inColumn:col]];

            if ([reusableTableCells indexOfObject:layer] != NSNotFound)
            {
                //重复使用旧对象
                [reusableTableCells removeObject:layer];
                
                [layer setHidden:NO];
            }
            else 
            {
                //新对象
                [self addSubview:layer];
            }

            [visiableCells setObject:layer forKey:number];
            
            [self transformItemView:layer atIndex:index animations:NO];
        }
        else 
        {
           [self transformItemView:layer atIndex:index animations:YES]; 
        }
    }
    
    [self depthSortViews];
}

//生成可见cell
-(NSSet*)getVisibleCell
{
    NSInteger ind = 0;
    
    NSInteger min = NSNotFound;
    
    CGFloat tx = self.contentOffset.x + self.bounds.size.width / 2.0;
    
    NSInteger page = [flipPosition count];
    
    NSMutableSet *visibleIndices = [NSMutableSet set];

    for (int i=0; i<page; i++)
    {
        NSArray *items = [flipPosition objectAtIndex:i];
        
        NSInteger count = [items count];
        
        for (int j=0;j<count;j++)
        {
            NSRect *rect = [items objectAtIndex:j];
            
            CGRect rects = CGRectMake(rect.x, rect.y, rect.width, rect.height);
            
            if ((CGRectContainsRect(rects, self.bounds) || CGRectIntersectsRect(rects, self.bounds)))
            {
                [visibleIndices addObject:[NSNumber numberWithInteger:ind]];
                
                //取居中的那个索引
                if (type == UIGalleryTypeCoverFlow)
                {
                    NSInteger temp = fmin(min, abs(tx-rect.centerX));
                    
                    if (temp < min) 
                    {
                        centerIndex = ind;
                    }
                    
                    min = temp;
                }
            }
            
            ind++;
        }
    }

    return visibleIndices;
}

-(void)makePosition
{
    if (nil == flipPosition)
    {
        flipPosition = [[NSMutableArray alloc] init];
        //
        switch (type) 
        {
            case UIGalleryTypeCoverFlow:
            {
                CGFloat tx = self.frame.size.width / 2.0;
                
                CGFloat ty = self.frame.size.height / 2.0;
                
                CGFloat th = [self.delegate galleryView:self heightForRowAt:0];
                
                NSMutableArray *page = [NSMutableArray array];
                
                NSInteger column = [self getColumns];
                
                for (NSInteger i=0; i<column; i++)
                {
                    if (i > 0 && [self.delegate respondsToSelector:@selector(galleryView:gapForColumnAt:)])
                    {
                        tx += [self.delegate galleryView:self gapForColumnAt:i];
                    }
                    
                    CGFloat tw = [self.delegate galleryView:self widthForColumnAt:i];
                    
                    [page addObject:[NSRect rectWithCGRect:CGRectMake(tx-tw/2.0, ty-th/2.0, tw, th)]];
                }

                [flipPosition addObject:page];
                
                [self setContentSize:CGSizeMake(tx + self.frame.size.width / 2.0, self.frame.size.height)];
            }
                break;
                
            case UIGalleryTypeFlipList:
            {
                NSInteger count = [dataSource numberOfCellInGalleryView:self];
                
                NSInteger col = [self getColumns];

                NSInteger row = [self getRows];

                NSInteger page = ceilf((float)count / (float)(row * col));
                
                for (int p=0; p<page; p++)
                {
                    NSMutableArray *page = [NSMutableArray array];
                    
                    //列
                    CGFloat ty = 0.0;
                    
                    for (NSInteger i=0; i<row; i++)
                    {
                        if ([self.delegate respondsToSelector:@selector(galleryView:gapForRowAt:)])
                        {
                            ty += [self.delegate galleryView:self gapForRowAt:i];
                        }
                        
                        CGFloat tx = p * self.bounds.size.width;
                        
                        CGFloat th = [self.delegate galleryView:self heightForRowAt:i];
                        
                        for (NSInteger j=0; j<col; j++)
                        {
                            if (count-- > 0)
                            {
                                if ([self.delegate respondsToSelector:@selector(galleryView:gapForColumnAt:)])
                                {
                                    tx += [self.delegate galleryView:self gapForColumnAt:j];
                                }
                                
                                CGFloat tw = [self.delegate galleryView:self widthForColumnAt:j];
                                
                                CGRect rect = CGRectMake(tx, ty, tw, th);
                                
                                [page addObject:[NSRect rectWithCGRect:rect]];
                                
                                tx += tw;
                            }
                        }
                        
                        ty += th;
                    }
                    
                    //页面数据
                    [flipPosition addObject:page];
                }
                
                [self setContentSize:CGSizeMake(self.frame.size.width * page, self.frame.size.height)];
            }
                break;
                
            default:
            {
                NSInteger count = [dataSource numberOfCellInGalleryView:self];
                
                NSInteger col = [self getColumns];

                NSInteger row = ceil((float)count / (float)col);
                
                NSMutableArray *page = [NSMutableArray array];
                
                //列
                CGFloat ty = 0.0;
                
                for (NSInteger i=0; i<row; i++)
                {
                    if ([self.delegate respondsToSelector:@selector(galleryView:gapForRowAt:)])
                    {
                        ty += [self.delegate galleryView:self gapForRowAt:i];
                    }
                    
                    CGFloat tx = 0.0;
                    
                    CGFloat th = [self.delegate galleryView:self heightForRowAt:i];
                    
                    for (NSInteger j=0; j<col; j++)
                    {
                        if (count-- > 0)
                        {
                            if ([self.delegate respondsToSelector:@selector(galleryView:gapForColumnAt:)])
                            {
                                tx += [self.delegate galleryView:self gapForColumnAt:j];
                            }
                            
                            CGFloat tw = [self.delegate galleryView:self widthForColumnAt:j];
                            
                            CGRect rect = CGRectMake(tx, ty, tw, th);
                            
                            [page addObject:[NSRect rectWithCGRect:rect]];
                            
                            tx += tw;
                        }
                    }
                    
                    ty += th;
                }

                if ([self.delegate respondsToSelector:@selector(galleryView:gapForRowAt:)])
                {
                    ty += [self.delegate galleryView:self gapForRowAt:row];
                }
                
                //页面数据
                [flipPosition addObject:page];
                
                [self setContentSize:CGSizeMake(self.frame.size.width, ty)];
            }
                break;
        }
    }
}

-(void)transformItemView:(UIView*)view atIndex:(NSInteger)index animations:(BOOL)animations
{
    switch (type) 
    {
        case UIGalleryTypeCoverFlow:
        {
            NSRect *rect = [[flipPosition objectAtIndex:0] objectAtIndex:index];

            NSInteger between = index - centerIndex;
            
            if (animations)
            {
                [UIView beginAnimations:nil context:nil];
            }
            
            if (between == 0)
            {
                view.alpha = 1.0;
                
                view.frame = CGRectMake(rect.x, rect.y, rect.width, rect.height);
                
                view.layer.transform = CATransform3DIdentity;
            }
            else
            {
                view.alpha = 0.4;
                
                if (between < 0)
                {
                    view.frame = CGRectMake(rect.x-centerGap, rect.y, rect.width, rect.height);
                    
                    view.layer.transform = [self makeTransformWithAngle:+angle positionZ:focalLength];
                }
                else
                {
                    view.frame = CGRectMake(rect.x+centerGap, rect.y, rect.width, rect.height);
                    
                    view.layer.transform = [self makeTransformWithAngle:-angle positionZ:focalLength];
                }
            }
            
            if (animations)
            {
                [UIView commitAnimations];
            }
        }
            break;
            
        case UIGalleryTypeFlipList:
        {
            NSInteger rows = [self getRows];
            
            NSInteger cols = [self getColumns];
            
            NSInteger page = index / (rows * cols);

            NSRect *rect = [[flipPosition objectAtIndex:page] objectAtIndex:index - (page * rows * cols)];
            
            view.frame = CGRectMake(rect.x, rect.y, rect.width, rect.height);
        }
            break;

        default:   
        {
            NSRect *rect = [[flipPosition objectAtIndex:0] objectAtIndex:index];
            
            view.frame = CGRectMake(rect.x, rect.y, rect.width, rect.height);
        }
            break;
    }
}

-(UIGalleryViewCell*)dequeueReusableCellWithIdentifier:(NSString*)value
{
    for (UIGalleryViewCell *cell in reusableTableCells)
    {
        if ([value isEqualToString:cell.reuseIdentifier])
        {
            return cell;
        }
    }
    
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //
    if ([dataSource respondsToSelector:@selector(galleryView:willSelectRowAtIndexPath:)])
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        
        UIView *view = [self hitTest:point withEvent:event];
        
        while (view.superview != self)
        {
            view = view.superview;
            
            if (view == nil)
            {
                return;
            }
        }
        
        NSInteger index = [self indexOfLayer:view];
        
        if (index != NSNotFound)
        {
            NSInteger cols = [self getColumns];
            
            [dataSource galleryView:self willSelectRowAtIndexPath:[NSIndex indexForRow:index/cols inColumn:index%cols]];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([dataSource respondsToSelector:@selector(galleryView:didSelectRowAtIndexPath:)])
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        
        UIView *view = [self hitTest:point withEvent:event];
        
        while (view.superview != self)
        {
            view = view.superview;
            
            if (view == nil)
            {
                return;
            }
        }
        
        NSInteger index = [self indexOfLayer:view];
        
        if (index != NSNotFound)
        {
            NSInteger cols = [self getColumns];
            
            [dataSource galleryView:self didSelectRowAtIndexPath:[NSIndex indexForRow:index/cols inColumn:index%cols]];
        }
    }
}

-(NSInteger)indexOfLayer:(UIView *)layer
{
    NSInteger index = [[visiableCells allValues] indexOfObject:layer];
    
    if (index != NSNotFound)
    {
        return [[[visiableCells allKeys] objectAtIndex:index] integerValue];
    }
    
    return NSNotFound;
}

-(void)depthSortViews
{
    id center = [visiableCells objectForKey:[NSNumber numberWithInt:centerIndex]];
    
    NSArray *sort = [[visiableCells allValues] sortedArrayUsingFunction:compareViewDepth context:center];
    
    for (UIView *view in sort)
    {
        [self addSubview:view];
    }  
}

//角度
-(CATransform3D)makeTransformWithAngle:(float)value positionZ:(float)positionZ
{
    CGFloat ang = value * M_PI / 180.0;
    
	CATransform3D rot = CATransform3DRotate(CATransform3DIdentity, ang, 0.0f, 1.0f, 0.0f);
    
    CATransform3D tra = CATransform3DConcat(rot,CATransform3DMakeTranslation(0, 0, -positionZ));
    
    return CATransform3DPerspect(tra,CGPointMake(0, 0),120);
}

//每页行数
-(NSInteger)getRows
{
    if (type == UIGalleryTypeCoverFlow)
    {
        return 1;
    }
    else 
    {
        if ([dataSource respondsToSelector:@selector(numberOfRowInGalleryView:)])
        {
            return [dataSource numberOfRowInGalleryView:self];
        }
    }

    return 1;
}

//每行列数
-(NSInteger)getColumns
{
    if (type == UIGalleryTypeCoverFlow)
    {
        return [dataSource numberOfCellInGalleryView:self];
    }
    else 
    {
        if ([dataSource respondsToSelector:@selector(numberOfColumnInGalleryView:)])
        {
            return [dataSource numberOfColumnInGalleryView:self];
        } 
    }

    return 1;
}

@end
