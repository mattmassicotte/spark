//
//  SparkOpenGLView.m
//  Spark
//
//  Created by Matt Massicotte on 8/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkOpenGLView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>

@interface SparkOpenGLView (PrivateMethods)

+ (NSOpenGLPixelFormat*)defaultPixelFormat;

- (NSScrollView*)scrollView;
- (void)update:(NSTimer*)timer;

@end

@implementation SparkOpenGLView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame pixelFormat:[[self class] defaultPixelFormat]];
    if (self)
	{
		[self setRenderingInterval:1.0f];
		controllingView = nil;
    }
	
    return self;
}

- (void)dealloc
{
	[renderTimer invalidate];
	[renderTimer release];
	[controllingView release];
	
	[super dealloc];
}

#pragma mark Accessors
@synthesize dataSource;
@synthesize delegate;

@synthesize renderingInterval;

- (double)aspectRatio
{
	NSRect bounds = [self bounds];
	
	return NSWidth(bounds)/NSHeight(bounds);
}

#pragma mark Setup Methods
- (void)awakeFromNib
{
	NSScrollView* scrollView = [self scrollView];
	
	if (scrollView)
	{
		// ok, we need to do the following:
		// remove ourselves, make a new, dummy controlling view
		// and then re-add ourselves as a subview
		
		[self retain]; // incase we are about to be dealloc'ed
		
		controllingView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
		
		[scrollView setDocumentView:controllingView];
		
		[scrollView addSubview:self];
		[scrollView setDrawsBackground:false];
		[[scrollView contentView] setCopiesOnScroll:false];
		
		[self release];
		
		[self setFrame:[[scrollView contentView] frame]];
		[self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	}
}

#pragma mark IBActions
- (IBAction)beginRendering:(id)sender
{
	[self stopRendering:self];
	
	renderTimer = [NSTimer scheduledTimerWithTimeInterval:self.renderingInterval
												   target:self
												 selector:@selector(update:)
												 userInfo:nil
												  repeats:YES];
	[renderTimer retain];
	
	[[NSRunLoop currentRunLoop] addTimer:renderTimer forMode:NSEventTrackingRunLoopMode];
}
- (IBAction)stopRendering:(id)sender
{
	[renderTimer invalidate];
	[renderTimer release];
	renderTimer = nil;
}

#pragma mark NSOpenGLView Overrides
- (void)prepareOpenGL
{
	[dataSource prepareOpenGLView:self];
}

- (void)reshape
{
	NSRect	superVisibleRect;
	
	if (controllingView)
	{
		superVisibleRect = [controllingView visibleRect];
	
		// Conversion captures any scaling in effect
		superVisibleRect = [controllingView convertRect:superVisibleRect toView:[self superview]];
		[self setFrame:superVisibleRect];
	}
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	[self projection];
}

#pragma mark *** Drawing ***
- (void)projection
{
	[dataSource projectionForOpenGLView:self];
}
- (void)modelview
{
	[dataSource modelviewForOpenGLView:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	[self modelview];
	
	[[self openGLContext] flushBuffer];
}

- (void)drawCube
{
//	GLfloat*	vertexArray;
//	GLfloat*	colorArray;
//	GLfloat*	normalArray;
}
@end

@implementation SparkOpenGLView (PrivateMethods)

+ (NSOpenGLPixelFormat*)defaultPixelFormat
{
    NSOpenGLPixelFormatAttribute attributes[8];
	
	attributes[0] = NSOpenGLPFAWindow;
	attributes[1] = NSOpenGLPFADoubleBuffer; // double buffered
	attributes[2] = NSOpenGLPFADepthSize;
	attributes[3] = (NSOpenGLPixelFormatAttribute)16; // 16 bit depth buffer
	attributes[4] = NSOpenGLPFAColorSize;
	attributes[5] = (NSOpenGLPixelFormatAttribute)24;
	attributes[6] = NSOpenGLPFAMinimumPolicy;
	attributes[7] = (NSOpenGLPixelFormatAttribute)0;
	
    return [[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes] autorelease];
}

- (NSScrollView*)scrollView
{
	NSView* view = [[self superview] superview];
	
	if (![view isKindOfClass:[NSScrollView class]])
		return nil;
	
	return (NSScrollView*)view;
}

- (void)update:(NSTimer*)timer
{
	[self setNeedsDisplay:YES];
}

@end