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

#import "PLSurface.h"
#import "PLConstants.h"

@implementation PLSurface

@synthesize width;

@synthesize height;

#pragma mark -
#pragma mark init methods

+ (id)surface
{
	return [[[PLSurface alloc] init] autorelease];
}

+ (id)surfaceWithTextures:(PLTexture *)texture
{
	PLSurface * surface = [PLSurface surface];
	[surface addTexture:texture];
	return surface;
}

#pragma mark -
#pragma mark utility methods

- (void)evaluateIfElementIsValid
{
	isValid = ([textures count] >= 1);
}

#pragma mark -
#pragma mark render methods

- (void)internalRender
{
    #define w 20.0f/1024
    #define h 20.0f/1024
    
	static GLfloat surface[] = 
	{
		-w, -h,  0.9f,
		 w, -h,  0.9f,
		-w,  h,  0.9f,
		 w,  h,  0.9f,
	};
	
	static GLfloat textureCoords[] = 
	{
		0.0f, 0.0f,
		1.0f, 0.0f,
		0.0f, 1.0f,
		1.0f, 1.0f
	};
    
    /*
    //光照变量
    GLfloat lightAmbient[] ={0.5f, 0.5f, 0.5f, 1.0f};   //环境光
    GLfloat lightDiffuse[] ={1.0f, 1.0f, 1.0f, 1.0f};   //漫射光
    GLfloat lightSpecular[] ={1.0f, 1.0f, 1.0f, 1.0f};   //镜面光
    GLfloat lightDirection[] ={-1.0f, 1.0f, 0.0f};    //聚光灯位置
    GLfloat lightPos[]     ={0.0f, 0.0f, 2.0f, 1.0f};   //光源位置
    
    glLightfv(GL_LIGHT1, GL_AMBIENT, lightAmbient);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, lightDiffuse);
    glLightfv(GL_LIGHT1, GL_SPECULAR, lightSpecular);
    glLightfv(GL_LIGHT1, GL_POSITION, lightPos);
    
    glLightf(GL_LIGHT1, GL_SPOT_CUTOFF, 180.0f);
    glLightfv(GL_LIGHT1, GL_SPOT_DIRECTION, lightDirection);
    glLightf(GL_LIGHT1, GL_SPOT_EXPONENT, 2.0f);
    
    glEnable(GL_LIGHT1);
    */
	//glTranslatef(self.position.x, self.position.y, self.position.z);
	glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
	
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	glVertexPointer(3, GL_FLOAT, 0, surface);
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glEnable(GL_CULL_FACE);
	glCullFace(GL_FRONT);
	glShadeModel(GL_SMOOTH);
	
	// PLTexture
	glBindTexture(GL_TEXTURE_2D, ((PLTexture *)[textures objectAtIndex:0]).textureId);
	glNormal3f(0.0f, 0.0f, 1.0f);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	//
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);	
	glDisable(GL_CULL_FACE);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}

@end
