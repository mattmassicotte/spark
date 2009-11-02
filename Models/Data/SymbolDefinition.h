//
//  SymbolDefinition.h
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Definition.h"


@interface SymbolDefinition :  Definition  
{
}

@property (nonatomic, retain) NSSet* symbols;

@end


@interface SymbolDefinition (CoreDataGeneratedAccessors)
- (void)addSymbolsObject:(NSManagedObject *)value;
- (void)removeSymbolsObject:(NSManagedObject *)value;
- (void)addSymbols:(NSSet *)value;
- (void)removeSymbols:(NSSet *)value;

@end

