/*
 * This file is part of the PanoramaGL library.
 *
 *  Author: Javier Baez <javbaezga@gmail.com>
 *
 *  $Id$
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; version 3 of
 * the License
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

#import "PLView.h"
#import "PLSurface.h"

@implementation PLButton
@synthesize u;
@synthesize v;
@synthesize data;

-(void)dealloc
{
    [data release];
    [super dealloc];
}
@end

//
@interface PLView()

- (void)updataPoint;

- (void)startTurn;

- (void)stopTurn;

@end

@implementation PLView

@synthesize type;

#pragma mark -
#pragma mark init methods

- (void)initializeValues
{
	[super initializeValues];
    //
    points = [[NSMutableArray alloc] init];
	textures = [[NSMutableArray alloc] init];
	type = PLViewTypeUnknown;
}

#pragma mark -
#pragma mark dealloc methods

- (void)dealloc 
{ 
    NSLog(@"removed plview");

    [self removeAllPoint];
    
    if (points) 
    {
        [points release];
    }
    
    if (textures) 
    {
        [textures release];
    }
    
	[super dealloc];
}

- (void)reset
{
	[super reset];
	if(scene && scene.currentCamera)
		[scene.currentCamera reset];
}
//zhouliangfei
- (void)addCubeTexture:(NSDictionary*)texture
{
    [self addTexture:[texture objectForKey:@"front"]];
    
    [self addTexture:[texture objectForKey:@"back"]];
    
    [self addTexture:[texture objectForKey:@"left"]];
    
    [self addTexture:[texture objectForKey:@"right"]];
    
    [self addTexture:[texture objectForKey:@"top"]];
    
    [self addTexture:[texture objectForKey:@"bottom"]];
}

- (void)removeCubeTexture:(NSDictionary*)texture
{
    [self removeTexture:[texture objectForKey:@"front"]];

    [self removeTexture:[texture objectForKey:@"back"]];
    
    [self removeTexture:[texture objectForKey:@"left"]];
    
    [self removeTexture:[texture objectForKey:@"right"]];
    
    [self removeTexture:[texture objectForKey:@"top"]];
    
    [self removeTexture:[texture objectForKey:@"bottom"]];
}

- (id)addPointWithImage:(UIImage*)image
{
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    
    PLButton *point = [[PLButton alloc] initWithFrame:imageview.bounds];
    
    [point addTarget:self action:@selector(clickPoint:) forControlEvents:UIControlEventTouchUpInside];

    [point addSubview:imageview];
    
    [self addSubview:point];
    
    [points addObject:point];
    
    [self updataPoint];
    
    [imageview release];

    return [point autorelease];
}

- (void)removeAllPoint
{
    for (PLButton *item in points) 
    {
        [item removeFromSuperview];
    }

    [points removeAllObjects];
    
    current = nil;
}

-(void)updataPoint
{
    int viewport[4];
    float model[16];
    float proj[16];
    
    glGetIntegerv(GL_VIEWPORT, viewport);
    glGetFloatv(GL_MODELVIEW_MATRIX, model);
    glGetFloatv(GL_PROJECTION_MATRIX, proj);
    GLfloat winx, winy, winz;
    for (PLButton *item in points)
    {
        float ax = M_PI * (0.75f - item.u) * 2;
        float ay = M_PI * (0.50f - item.v);
        float x = cosf(ax) * cosf(ay);
        float y = sinf(ax) * cosf(ay);
        float z = -sinf(ay);
        //
        gluProject(x,y,z, model,proj,viewport,&winx,&winy,&winz);
        
        if(winz<1.0f)
        {
            [item setHidden:YES];
        }
        else
        {
            item.center = CGPointMake(winx, self.frame.size.height-winy);
            [item setHidden:NO];
        }
    }
}

- (void)clickPoint:(PLButton*)sender
{
    current = sender;
    
    float ax = 180 * (0.5f-sender.u) * 2;
    float ay = 0;
    //
    from = CGPointMake(scene.currentCamera.rotation.yaw, scene.currentCamera.rotation.pitch);
    
    if(ax-scene.currentCamera.rotation.yaw>180)
    {
        from = CGPointMake(scene.currentCamera.rotation.yaw+360, scene.currentCamera.rotation.pitch);
    }
    
    if(scene.currentCamera.rotation.yaw-ax>180)
    {
        from = CGPointMake(scene.currentCamera.rotation.yaw-360, scene.currentCamera.rotation.pitch);
    }
    //
    to = CGPointMake(ax, ay);

    [self startTurn];
}

- (void)startTurn
{
	[self stopTurn];
    
	inertiaTimer = [NSTimer scheduledTimerWithTimeInterval:0.024 target:self selector:@selector(turn) userInfo:nil repeats:YES];
}

- (void)stopTurn
{
	if(inertiaTimer)
		[inertiaTimer invalidate];
	inertiaTimer = nil;
}

- (void)stopAnimation
{
    [self stopTurn];
    
    [super stopAnimation];
}

- (void)turn
{
	float tx = (to.x - from.x) * 0.2f;
    
    float ty = (to.y - from.y) * 0.2f;
	
	if(ABS(tx) < 0.01f && ABS(ty) < 0.01f)
	{
		[self stopTurn];
        
        if ([delegate respondsToSelector:@selector(view:pointTouch:)]) 
        {
            [delegate view:self pointTouch:current];
        }
        
        return;
	}
	else
	{
		from.x += tx;
        
        from.y += ty;
	}

	scene.currentCamera.rotation = PLRotationMake(from.y, from.x, 0);
    
    scene.currentCamera.fov += 0.025;
    
    [self drawView];
}
//zhouliangfei
#pragma mark -
#pragma mark property methods

- (void)setType:(PLViewType)value
{
	type = value;
	[scene removeAllElements];
	
	switch (value)
	{
		case PLViewTypeCylindrical:
			sceneElement = [PLCylinder cylinder];
			break;
		case PLViewTypeSpherical:
			sceneElement = [PLSphere sphere];
			break;
		case PLViewTypeCubeFaces:
			sceneElement = [PLCube cube];
			break;
		case PLViewTypeUnknown:
			sceneElement = nil;
			break;
		default:
			[NSException raise:@"Invalid panorama type" format:@"Type unknown", nil];
			break;
	}
	
	if(sceneElement)
	{
		for(PLTexture * texture in textures)
			[sceneElement addTexture:texture];
		
		[scene addElement:sceneElement];
	}
}

#pragma mark -
#pragma mark draw methods

- (void)drawViewInternally
{
	[super drawViewInternally];
	if(!isValidForFov && !isValidForOrientation)
		[scene.currentCamera rotateWithStartPoint:startPoint endPoint:endPoint sensitivity:scene.currentCamera.rotateSensitivity];
	[renderer render];
}

- (void)drawView
{
    [super drawView];
    
    [self updataPoint];  
}

#pragma mark -
#pragma mark fov methods

- (BOOL)calculateFov:(NSSet *)touches
{
	if([super calculateFov:touches])
	{
		[scene.currentCamera addFovWithDistance:fovDistance];
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark texture methods

- (void)addTexture:(PLTexture *)texture
{
	if(texture)
	{
		[textures addObject:texture];
		if(sceneElement)
			[sceneElement addTexture:texture];
	}
}

- (void)addTextureAndRelease:(PLTexture *)texture
{
	if(texture)
	{
		[textures addObject:texture];
		if(sceneElement)
			[sceneElement addTextureAndRelease:texture];
	}
}
				
- (void)removeTexture:(PLTexture *)texture
{
	if(texture)
	{
		[textures removeObject:texture];
		if(sceneElement)
			[sceneElement removeTexture:texture];
	}
}
				
- (void)removeTextureAtIndex:(NSUInteger) index
{
	[textures removeObjectAtIndex:index];
	if(sceneElement)
		[sceneElement removeTextureAtIndex:index];
}
				
- (void)removeAllTextures
{
	[textures removeAllObjects];
	if(sceneElement)
		[sceneElement removeAllTextures];
}

#pragma mark -
#pragma mark orientation methods

- (void)orientationChanged:(UIDeviceOrientation)orientation
{
	if(scene && scene.currentCamera)
		scene.currentCamera.orientation = orientation;
}
				
@end
