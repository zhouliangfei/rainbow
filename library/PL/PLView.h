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

#import <UIKit/UIKit.h>

#import "PLMath.h"
#import "PLEnums.h"

#import "PLViewBase.h"
#import "PLSceneElement.h"
#import "PLTexture.h"

#import "PLCylinder.h"
#import "PLSphere.h"
#import "PLCube.h"

@interface PLButton:UIControl

@property(nonatomic) float u;
@property(nonatomic) float v;
@property(nonatomic,retain) NSDictionary *data;

@end

//
@interface PLView : PLViewBase 
{
    CGPoint from;
    CGPoint to;
    PLButton *current;
    //
	PLSceneElement * sceneElement;
	NSMutableArray * textures;
    NSMutableArray * points;
	PLViewType type;
}

@property(nonatomic) PLViewType type;

- (void)addTexture:(PLTexture *)texture;
- (void)addTextureAndRelease:(PLTexture *)texture;
- (void)removeTexture:(PLTexture *)texture;
- (void)removeTextureAtIndex:(NSUInteger)index;
- (void)removeAllTextures;
//
- (void)addCubeTexture:(NSDictionary*)texture;
- (void)removeCubeTexture:(NSDictionary*)texture;
//
- (id)addPointWithImage:(UIImage*)image;
- (void)removeAllPoint;
@end