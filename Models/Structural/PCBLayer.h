//
//  PCBLayer.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface PCBLayer :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* sublayers;

@end


@interface PCBLayer (CoreDataGeneratedAccessors)

- (void)addSublayersObject:(NSManagedObject *)value;
- (void)removeSublayersObject:(NSManagedObject *)value;
- (void)addSublayers:(NSSet *)value;
- (void)removeSublayers:(NSSet *)value;

@end

