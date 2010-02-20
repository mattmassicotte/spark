//
//  DesignSurface.h
//  Spark
//
//  Created by Matt Massicotte on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DesignElement;

@interface DesignSurface :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSSet*    elements;

@end


@interface DesignSurface (CoreDataGeneratedAccessors)

- (void)addElementsObject:(DesignElement *)value;
- (void)removeElementsObject:(DesignElement *)value;
- (void)addElements:(NSSet *)value;
- (void)removeElements:(NSSet *)value;

@end

NSString* const DesignSurfaceWasCreatedNotification;