//
//  SparkElementView.m
//  Spark
//
//  Created by Matt Massicotte on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkElementView.h"
#import "DesignElement.h"
#import "GraphicalRep.h"
#import "SparkScrollView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>

@interface SparkElementView (PrivateMethods)
- (void)loadElements;

- (id)keyAtLocation:(NSPoint)location;
- (void)trackElement:(DesignElement*)element;
- (void)resetTracking;
- (void)incrementBaseIndex;

- (void)drawAxisMarkerFor:(SPAxis)axis withBase:(GLfloat)baseSize;
- (void)drawOrientationMarkers;

- (void)modelviewWithPicking:(BOOL)pickingEnabled forElement:(DesignElement*)pickedElement;
- (void)drawWithPickedElement:(DesignElement*)element;
@end

@implementation SparkElementView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// init view control
		cameraEyePosition = SPMakeVec(0, 0, 35.0);
		sceneCenter = SPMakeVec(0, 0, 0);
		rotation = SPMakeVec(0, 0, 0);
		
		orientationMarkers = true;
		
		// init picking
		elementIndexDictionary = [NSMutableDictionary new];
		[self resetTracking];
		
		selectionSet = [NSMutableSet new];
	}
	
	return self;
}
- (void)dealloc
{
	[elementIndexDictionary release];
	[selectionSet release];
	
	[super dealloc];
}

#pragma mark Accessors
@synthesize orientationMarkers;

- (id <SparkElementViewDelegate>)delegate
{
	return delegate;
}
- (void)setDelegate:(id <SparkElementViewDelegate>)newDelegate
{
	delegate = newDelegate;
}
- (id <SparkElementViewDataSource>)dataSource
{
	return dataSource;
}
- (void)setDataSource:(id <SparkElementViewDataSource>)newDataSource
{
	dataSource = newDataSource;
}

#pragma mark IBActions
- (IBAction)scrolledHorizontally:(id)sender
{
	//cameraEyePosition.x = ([sender doubleValue] - 0.5) * -50.0;
	
	rotation.x = ([sender doubleValue] - 0.5) * 360.0;
	
	[self setNeedsDisplay:true];
}
- (IBAction)scrolledVertically:(id)sender
{
	//cameraEyePosition.y = ([sender doubleValue] - 0.5) * -50.0;
	
	rotation.y = ([sender doubleValue] - 0.5) * 360.0;
	
	[self setNeedsDisplay:true];
}

- (void)reloadData
{
	[elements release];
	elements = nil;
	
	[self loadElements];
}


#pragma mark Selection
- (void)selectElements:(NSArray*)selectElements byExtendingSelection:(BOOL)extending
{
	[self reloadData];
	
	if (!extending)
		[selectionSet removeAllObjects];
	
	[selectionSet addObjectsFromArray:selectElements];
	
	[self setNeedsDisplay:true];
}
- (void)selectElement:(DesignElement*)element byExtendingSelection:(BOOL)extending
{
	[self selectElements:[NSArray arrayWithObject:element] byExtendingSelection:extending];
}

#pragma mark Event Handling
- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint			point;
	DesignElement*	element;
	BOOL			commandKeyPressed;
	
	point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	commandKeyPressed = ([theEvent modifierFlags] & NSCommandKeyMask) != 0;
	
	// draw with no element focused
	[self drawWithPickedElement:nil];
	
	element = [elementIndexDictionary objectForKey:[self keyAtLocation:point]];
	
	if (!element)
	{
		[selectionSet removeAllObjects];
		[self setNeedsDisplay:true];
		return;
	}
	
	if (![delegate respondsToSelector:@selector(elementView:shouldSelectElement:)] || 
		[delegate elementView:self shouldSelectElement:element])
	{
		[self selectElement:element byExtendingSelection:commandKeyPressed];
	}
}

#pragma mark SparkOpenGLView Overrides
// this prevents the original datasource from
// being called the SparkOpenGLView methods
- (void)prepareOpenGL
{
	GLint swapInt = 1;
	
	// set to vbl sync
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
	// basic features
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glClearColor(0, 0, 0, 0);
	
	glShadeModel(GL_SMOOTH);
	
	glFrontFace(GL_CW);
	glEnable(GL_COLOR_MATERIAL);
	glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
	
	// appearance improvements
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	
	// lighting
	GLfloat lightAmbient[]= { 0.5f, 0.5f, 0.5f, 1.0f };
	GLfloat lightDiffuse[]= { 1.0f, 1.0f, 1.0f, 1.0f };
	GLfloat lightPosition[]= { 0.0f, 0.0f, 15.0f, 1.0f };
	
	glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
	glEnable(GL_LIGHT0);
//	glEnable(GL_LIGHTING);
}
- (void)projection
{
	NSRect bounds = [self bounds];

	glViewport(0, 0, NSWidth(bounds), NSHeight(bounds));
	gluPerspective(45.0f, [self aspectRatio], 1.0f, 100.0f);
}
- (void)modelview
{
	[self modelviewWithPicking:NO forElement:nil];
}

@end

@implementation SparkElementView (PrivateMethods)

- (void)loadElements
{
	if (elements == nil)
	{
		elements = [[dataSource elementsInElementView:self] copy];
		
		for (DesignElement* element in elements)
		{
			[[element graphicalRep] prepareBuffers]; // create triangle representation
			
			[self trackElement:element];
		}
	}
}

#pragma mark Picking
- (id)keyAtLocation:(NSPoint)location
{
	GLbyte		pixel[3];
	
	pixel[0] = pixel[1] = pixel[2] = 0;
	
	glReadBuffer(GL_BACK);
	
    glReadPixels(location.x, location.y, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, &pixel);
	
	//NSLog(@"pixel %x, %x, %x", pixel[0], pixel[1], pixel[2]);
	//return [NSColor colorWithCalibratedRed:pixel[0] green:pixel[1] blue:pixel[2] alpha:1];
	return [NSString stringWithFormat:@"%x %x %x", pixel[0], pixel[1], pixel[2]];
}
- (void)trackElement:(DesignElement*)element
{
	NSString*	key;
	
	key = [NSString stringWithFormat:@"%x %x %x", baseColorIndex[0], baseColorIndex[1], baseColorIndex[2]];
	
	[element prepareForTrackingWithRed:baseColorIndex[0] green:baseColorIndex[1] blue:baseColorIndex[2]];
	[elementIndexDictionary setObject:element forKey:key];
	
//	NSLog(@"%@ => %@", key, [element description]);
	
	[self incrementBaseIndex];
}
- (void)resetTracking
{
	[elementIndexDictionary removeAllObjects];
	baseColorIndex[0] = 0;
	baseColorIndex[1] = 0;
	baseColorIndex[2] = 50;
}
- (void)incrementBaseIndex
{
	if (baseColorIndex[0] >= 255)
	{
		NSLog(@"crap!");
	}
	else
	{
		if (baseColorIndex[1] >= 255)
		{
			baseColorIndex[0]++;
			baseColorIndex[1] = 0;
		}
		else
		{
			if (baseColorIndex[2] >= 255)
			{
				baseColorIndex[1]++;
				baseColorIndex[2] = 0;
			}
			else
			{
				baseColorIndex[2]++;
			}
		}
	}	
}
	 
#pragma mark Drawing
- (void)drawAxisMarkerFor:(SPAxis)axis withBase:(GLfloat)baseSize
{
	GLUquadric* quadric;
	GLfloat		axisLength;
	GLfloat		axisRadius;
	GLfloat		coneLength;
	GLfloat		coneRadius;
	
	axisRadius = baseSize / 2.0;
	axisLength = baseSize * 4.0;
	coneRadius = axisRadius * 2.0;
	coneLength = axisLength / 2.0;
	
	glPushMatrix();
	
	quadric = gluNewQuadric();
	gluQuadricNormals(quadric, GLU_SMOOTH);
	gluQuadricDrawStyle(quadric, GLU_LINE);
	
	switch (axis)
	{
		case SP_X_AXIS:
			glRotated(90.0, 0.0, 1.0, 0.0);
			glColor3f(1.0f, 0.0f, 0.0f);
			break;
		case SP_Y_AXIS:
			glRotated(-90.0, 1.0, 0.0, 0.0);
			glColor3f(0.0f, 1.0f, 0.0f);
			break;
		case SP_Z_AXIS:
			glColor3f(0.0f, 0.0f, 1.0f);
			break;
		default:
			break;
	}
	
	glTranslated(0, 0, baseSize);
	
	gluDisk(quadric, 0, axisRadius, 32, 32);
	gluCylinder(quadric, axisRadius, axisRadius, axisLength, 32, 32);
	
	glTranslated(0, 0, axisLength);
	
	gluDisk(quadric, 0, coneRadius, 32, 32);
	gluCylinder(quadric, coneRadius, 0, coneLength, 32, 32);
	
	gluDeleteQuadric(quadric);
	
	glPopMatrix();
}
- (void)drawOrientationMarkers
{
	glPushMatrix();
	
	glTranslated(-10, -10, 0);//-1.0*cameraEyePosition.z);
	
	glRotated(rotation.x, 0.0, 1.0, 0.0);
	glRotated(rotation.y, 1.0, 0.0, 0.0);
	
	[self drawAxisMarkerFor:SP_X_AXIS withBase:0.5];
	[self drawAxisMarkerFor:SP_Y_AXIS withBase:0.5];
	[self drawAxisMarkerFor:SP_Z_AXIS withBase:0.5];
	
	glPopMatrix();
}

- (void)modelviewWithPicking:(BOOL)pickingEnabled forElement:(DesignElement*)pickedElement
{
	GraphicalRep* model;
	
	gluLookAt(cameraEyePosition.x, cameraEyePosition.y, cameraEyePosition.z, sceneCenter.x, sceneCenter.y, sceneCenter.z, 0, 1, 0);
	
	if (orientationMarkers && !pickingEnabled)
		[self drawOrientationMarkers];
	
	glRotated(rotation.x, 0.0, 1.0, 0.0);
	glRotated(rotation.y, 1.0, 0.0, 0.0);
	
	[self loadElements];
	
	for (DesignElement* element in elements)
	{
		model = [element graphicalRep];
		
		glPushMatrix();
		
		glTranslated([[element xLocation] doubleValue], [[element yLocation] doubleValue], [[element zLocation] doubleValue]);
		glRotated(0, 1.0, 0.0, 0.0);
		glRotated(0, 0.0, 1.0, 0.0);
		glRotated([[element zRotation] doubleValue], 0.0, 0.0, 1.0);
		
		glEnableClientState(GL_NORMAL_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		glVertexPointer(3, GL_DOUBLE, 0, [model vertexBuffer]);
		glNormalPointer(GL_DOUBLE, 0, [model normalBuffer]);
		
		if (pickingEnabled)
		{
			glColorPointer(3, GL_UNSIGNED_BYTE, 0, [element trackingColorBuffer]);
		}
		else
		{
			if ([selectionSet containsObject:element])
			{
				glColorPointer(3, GL_UNSIGNED_BYTE, 0, [element trackingColorBuffer]);
			}
			else
			{
				glColorPointer(3, GL_DOUBLE, 0, [model colorBuffer]);
			}
		}
		
		glDrawArrays(GL_TRIANGLES, 0, [model numberOfFacets]);
		
		// after glDrawArrays completes, these are all undefined
		// and have to be disabled
		glDisableClientState(GL_VERTEX_ARRAY);
		glDisableClientState(GL_COLOR_ARRAY);
		glDisableClientState(GL_NORMAL_ARRAY);
		
		
		glPopMatrix();
	}
}

- (void)drawWithPickedElement:(DesignElement*)element
{
	glShadeModel(GL_FLAT);
	glDisable(GL_DITHER);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	[self modelviewWithPicking:YES forElement:element];
	
	glEnable(GL_DITHER);
	glShadeModel(GL_SMOOTH);
	
	// we haven't swapped buffers yet, so nothing has been displayed
	// but, our back buffer has picking colors in it, so we need to
	// redraw it
	//[self setNeedsDisplay:YES];
	//[[self openGLContext] flushBuffer];
}

@end
