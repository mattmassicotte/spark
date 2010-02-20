// 
//  Quad.m
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Quad.h"
#import "SPFacet.h"

@implementation Quad

- (SPVec)center
{
    SPVec center;
    
    // very rough approximation
    
    center.x = [self.aX doubleValue] + ([self.cX doubleValue] - [self.aX doubleValue]) / 2.0;
    center.y = [self.dY doubleValue] + ([self.bY doubleValue] - [self.dY doubleValue]) / 2.0;
    center.z = (self.zTop - self.zBottom) / 2.0;
    
    return center;
}

- (GLdouble)width
{
    return ([self.cX doubleValue] - [self.aX doubleValue]) / 2.0;
}

- (GLdouble)length
{
    return ([self.dX doubleValue] - [self.bX doubleValue]) / 2.0;
}

@dynamic bY;
@dynamic aY;
@dynamic dX;
@dynamic cX;
@dynamic bX;
@dynamic dY;
@dynamic aX;
@dynamic cY;

- (void)assign:(NSString*)name with:(NSDictionary*)dict
{
	NSNumber* x;
	NSNumber* y;
	
	x = [NSNumber numberWithDouble:[[dict objectForKey:@"x"] doubleValue]];
	y = [NSNumber numberWithDouble:[[dict objectForKey:@"y"] doubleValue]];
	
	if ([name caseInsensitiveCompare:@"a"] == NSOrderedSame)
	{
		[self setAX:x];
		[self setAY:y];
	}
	else if ([name caseInsensitiveCompare:@"b"] == NSOrderedSame)
	{
		[self setBX:x];
		[self setBY:y];
	}
	else if ([name caseInsensitiveCompare:@"c"] == NSOrderedSame)
	{
		[self setCX:x];
		[self setCY:y];
	}
	else if ([name caseInsensitiveCompare:@"d"] == NSOrderedSame)
	{
		[self setDX:x];
		[self setDY:y];
	}
}

- (NSArray *)facetArray
{
	NSMutableArray*	array;
	SPFacet*		facet;
	SPVec			bottomColor;
	SPVec			a, b, c, d;
	
	a = SPMakeVec([[self aX] doubleValue], [[self aY] doubleValue], 0);
	b = SPMakeVec([[self bX] doubleValue], [[self bY] doubleValue], 0);
	c = SPMakeVec([[self cX] doubleValue], [[self cY] doubleValue], 0);
	d = SPMakeVec([[self dX] doubleValue], [[self dY] doubleValue], 0);
	
	array = [NSMutableArray array];
	bottomColor = [self color];
	bottomColor = SPMakeVec(bottomColor.x/4.0, bottomColor.y/4.0, bottomColor.z/4.0);
	
	// top face
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(a.x, a.y, self.zTop);
	facet.vertexB = SPMakeVec(b.x, b.y, self.zTop);
	facet.vertexC = SPMakeVec(c.x, c.y, self.zTop);
	facet.normal = SPMakeVec(0, 0, 1);
	facet.color = self.color;
	[array addObject:facet];
	[facet release];
	
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(a.x, a.y, self.zTop);
	facet.vertexB = SPMakeVec(c.x, c.y, self.zTop);
	facet.vertexC = SPMakeVec(d.x, d.y, self.zTop);
	facet.normal = SPMakeVec(0, 0, 1);
	facet.color = self.color;
	[array addObject:facet];
	[facet release];
	
	//bottom face
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(c.x, c.y, self.zBottom);
	facet.vertexB = SPMakeVec(b.x, b.y, self.zBottom);
	facet.vertexC = SPMakeVec(a.x, a.y, self.zBottom);
	facet.normal = SPMakeVec(0, 0, -1);
	facet.color = bottomColor;
	[array addObject:facet];
	[facet release];
	
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(d.x, d.y, self.zBottom);
	facet.vertexB = SPMakeVec(c.x, c.y, self.zBottom);
	facet.vertexC = SPMakeVec(a.x, a.y, self.zBottom);
	facet.normal = SPMakeVec(0, 0, -1);
	facet.color = bottomColor;
	[array addObject:facet];
	[facet release];
	
	// north face
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(a.x, a.y, self.zTop);
	facet.vertexB = SPMakeVec(b.x, b.y, self.zBottom);
	facet.vertexC = SPMakeVec(b.x, b.y, self.zTop);
	facet.normal = SPMakeVec(0, 1, 0);
	facet.color = [self color];
	facet.colorB = bottomColor;
	[array addObject:facet];
	[facet release];
	
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(a.x, a.y, self.zTop);
	facet.vertexB = SPMakeVec(a.x, a.y, self.zBottom);
	facet.vertexC = SPMakeVec(b.x, b.y, self.zBottom);
	facet.normal = SPMakeVec(0, 1, 0);
	facet.color = [self color];
	facet.colorB = bottomColor;
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	// south face
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(d.x, d.y, self.zTop);
	facet.vertexB = SPMakeVec(c.x, c.y, self.zTop);
	facet.vertexC = SPMakeVec(c.x, c.y, self.zBottom);
	facet.normal = SPMakeVec(0, -1, 0);
	facet.color = [self color];
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(d.x, d.y, self.zTop);
	facet.vertexB = SPMakeVec(c.x, c.y, self.zBottom);
	facet.vertexC = SPMakeVec(d.x, d.y, self.zBottom);
	facet.normal = SPMakeVec(0, 1, 0);
	facet.color = [self color];
	facet.colorB = bottomColor;
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	// east face
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(c.x, c.y, self.zTop);
	facet.vertexB = SPMakeVec(b.x, b.y, self.zTop);
	facet.vertexC = SPMakeVec(b.x, b.y, self.zBottom);
	facet.normal = SPMakeVec(1, 0, 0);
	facet.color = [self color];
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(c.x, c.y, self.zTop);
	facet.vertexB = SPMakeVec(b.x, b.y, self.zBottom);
	facet.vertexC = SPMakeVec(c.x, c.y, self.zBottom);
	facet.normal = SPMakeVec(0, 1, 0);
	facet.color = [self color];
	facet.colorB = bottomColor;
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	// west face
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(a.x, a.y, self.zTop);
	facet.vertexB = SPMakeVec(d.x, d.y, self.zTop);
	facet.vertexC = SPMakeVec(d.x, d.y, self.zBottom);
	facet.normal = SPMakeVec(1, 0, 0);
	facet.color = [self color];
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	facet = [SPFacet new];
	facet.vertexA = SPMakeVec(a.x, a.y, self.zTop);
	facet.vertexB = SPMakeVec(d.x, d.y, self.zBottom);
	facet.vertexC = SPMakeVec(a.x, a.y, self.zBottom);
	facet.normal = SPMakeVec(0, -1, 0);
	facet.color = [self color];
	facet.colorB = bottomColor;
	facet.colorC = bottomColor;
	[array addObject:facet];
	[facet release];
	
	return array;
}

@end
