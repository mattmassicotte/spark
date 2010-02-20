//
//  DesignElement.h
//  Spark
//
//  Created by Matt Massicotte on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GraphicalRep;

@interface DesignElement : NSManagedObject  
{
	GLubyte*	trackingColorBuffer;
}

@property (nonatomic, retain) NSNumber * yLocation;
@property (nonatomic, retain) NSNumber * xLocation;
@property (nonatomic, retain) NSDecimalNumber * zRotation;
@property (nonatomic, retain) NSNumber * zLocation;
@property (nonatomic, retain) NSManagedObject * surface;
@property (nonatomic, retain) GraphicalRep * graphicalRep;

@property(nonatomic, assign)	GLubyte*	trackingColorBuffer;

- (void)prepareForTrackingWithRed:(GLubyte)red green:(GLubyte)green blue:(GLubyte)blue;

@end



