//
//  SparkScrollView.m
//  Spark
//
//  Created by Matt Massicotte on 8/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkScrollView.h"
#import "SparkOpenGLView.h"
#import "SparkElementView.h"

@interface SparkScrollView (PrivateMethods)

- (void)setupScrollersWithFrame:(NSRect)frameRect;

@end


@implementation SparkScrollView

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if (self != nil)
	{
		[self setupScrollersWithFrame:frameRect];
		
		contentView = [[SparkElementView alloc] initWithFrame:[self contentFrame]];
		[self addSubview:contentView];
		
		[contentView release];
		[contentView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
		
		[horizontalScroller setTarget:contentView];
		[horizontalScroller setAction:@selector(scrolledHorizontally:)];
		[verticalScroller setTarget:contentView];
		[verticalScroller setAction:@selector(scrolledVertically:)];
	}
	
	return self;
}

- (void)dealloc
{
	[verticalScroller release];
	[horizontalScroller release];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	// This is a trick to make the content, not the scroll
	// view the first responder.  I think that's both
	// expected by the user and necessary for routing
	// events easily
	if ([[self window] initialFirstResponder] == self)
	{
		if (contentView)
			[[self window] setInitialFirstResponder:contentView];
		else {
			NSLog(@"SparkScrollView has not content - say wha?");
		}

	}
}

@synthesize horizontalScroller;
@synthesize verticalScroller;
@synthesize contentView;

- (void)setupScrollersWithFrame:(NSRect)frameRect
{
	NSRect	frame;
	CGFloat scrollerWidth;
	CGFloat	bottomLeftBoxSize;
	CGFloat bottomBarHeight;
	
	bottomLeftBoxSize = 14.0;
	bottomBarHeight = 23.0;
	
	scrollerWidth = [NSScroller scrollerWidthForControlSize:NSRegularControlSize];
	
	// vertical scroller
	frame = NSMakeRect(0, 0, 0, 0);
	frame.origin.x		= frameRect.size.width - scrollerWidth;
	frame.origin.y		= frameRect.origin.y + bottomLeftBoxSize + bottomBarHeight;
	frame.size.width	= scrollerWidth;
	frame.size.height	= frameRect.size.height - bottomLeftBoxSize - bottomBarHeight;

	verticalScroller = [[NSScroller alloc] initWithFrame:frame];
	
	[verticalScroller setAutoresizingMask:NSViewMinXMargin | NSViewHeightSizable];
	[verticalScroller setDoubleValue:0.5];
	[verticalScroller setKnobProportion:0.5];
	[verticalScroller setEnabled:YES];
	
	// horizontal scroller
	frame = NSMakeRect(0, 0, 0, 0);
	frame.origin.x		= 0;
	frame.origin.y		= bottomBarHeight;
	frame.size.width	= frameRect.size.width - bottomLeftBoxSize;
	frame.size.height	= scrollerWidth;
	
	horizontalScroller = [[NSScroller alloc] initWithFrame:frame];
	
	[horizontalScroller setAutoresizingMask:NSViewMaxYMargin | NSViewWidthSizable];
	[horizontalScroller setDoubleValue:0.5];
	[horizontalScroller setKnobProportion:0.5];
	[horizontalScroller setEnabled:YES];
	
	[self addSubview:verticalScroller];
	[self addSubview:horizontalScroller];
}

- (id)target
{
	return [horizontalScroller target];
}
- (void)setTarget:(id)newTarget
{
	[horizontalScroller setTarget:newTarget];
	[verticalScroller	setTarget:newTarget];
}
- (SEL)action
{
	return [horizontalScroller action];
}
- (void)setAction:(SEL)newAction
{
	[verticalScroller	setAction:newAction];
	[horizontalScroller setAction:newAction];
}

- (NSRect)contentFrame
{
	NSSize	size;
	CGFloat scrollerWidth;
	CGFloat bottomBarHeight;
	
	bottomBarHeight = 23.0;
	scrollerWidth = [NSScroller scrollerWidthForControlSize:NSRegularControlSize];
	
	size = [self frame].size;
	
	size.width -= scrollerWidth;
	size.height -= scrollerWidth + bottomBarHeight;
	
	return NSMakeRect(0, scrollerWidth + bottomBarHeight, size.width, size.height);
}

- (BOOL)isOpaque
{
	return true;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];
	
	[NSBezierPath fillRect:dirtyRect];
}

@end
