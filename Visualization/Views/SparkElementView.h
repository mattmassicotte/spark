//
//  SparkElementView.h
//  Spark
//
//  Created by Matt Massicotte on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SparkOpenGLView.h"
#import "SPGeometry.h"

@protocol SparkElementViewDelegate, SparkElementViewDataSource;
@class    DesignElement, Primitive;

@interface SparkElementView : SparkOpenGLView
{
	SPVec cameraEyePosition;
	SPVec sceneCenter;
	SPVec rotation;
    SPVec zoom;
	
	bool  orientationMarkers;
	
	NSArray*             elements;
	NSMutableSet*        selectionSet;
	
	NSMutableDictionary* elementIndexDictionary;
	GLubyte              baseColorIndex[3];
}

@property (assign) id <SparkElementViewDelegate>   delegate;
@property (assign) id <SparkElementViewDataSource> dataSource;

@property (assign) bool                            orientationMarkers;
@property (assign) SPVec                           zoom;
@property (nonatomic) SPVec                        sceneCenter;

- (IBAction)scrolledHorizontally:(id)sender;
- (IBAction)scrolledVertically:(id)sender;

- (void)reloadData;

@end

@protocol SparkElementViewDelegate <NSObject>
@optional

- (void)elementViewDidLoadElements:(SparkElementView*)view;

- (bool)elementView:(SparkElementView*)view shouldSelectElement:(DesignElement*)element;
- (bool)elementView:(SparkElementView*)view shouldSelectPrimitive:(Primitive*)primitive ofElement:(DesignElement*)element;

@end

@protocol SparkElementViewDataSource <NSObject>
@optional

- (NSArray*)elementsInElementView:(SparkElementView*)view;

@end
