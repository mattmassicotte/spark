//
//  SparkScrollView.h
//  Spark
//
//  Created by Matt Massicotte on 8/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SparkOpenGLView;

@interface SparkScrollView : NSView
{
	NSScroller*	horizontalScroller;
	NSScroller* verticalScroller;
	
	SparkOpenGLView*	contentView;
}

@property (assign, readonly)	NSScroller*			horizontalScroller;
@property (assign, readonly)	NSScroller*			verticalScroller;
@property (assign, readonly)	NSRect				contentFrame;
@property (assign, readonly)	SparkOpenGLView*	contentView;

@end
