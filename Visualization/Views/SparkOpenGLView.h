//
//  SparkOpenGLView.h
//  Spark
//
//  Created by Matt Massicotte on 8/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGeometry.h"

@protocol SparkOpenGLViewDataSource;

@interface SparkOpenGLView : NSOpenGLView
{
	IBOutlet id	delegate;
	IBOutlet id	dataSource;
	
	NSTimer*		renderTimer;
	NSTimeInterval	renderingInterval;
	NSView*			controllingView;
	
	NSMutableDictionary*	colorIndexDictionary;
	GLubyte					baseIndex[3];
}

@property(assign) id								delegate;
@property(assign) id <SparkOpenGLViewDataSource>	dataSource;

@property(assign) NSTimeInterval	renderingInterval;

@property (assign, readonly)	double		aspectRatio;

- (IBAction)beginRendering:(id)sender;
- (IBAction)stopRendering:(id)sender;

@end

@protocol SparkOpenGLViewDataSource <NSObject>

- (void)prepareOpenGLView:(SparkOpenGLView*)view;
- (void)projectionForOpenGLView:(SparkOpenGLView*)view;
- (void)modelviewForOpenGLView:(SparkOpenGLView*)view;

@end
