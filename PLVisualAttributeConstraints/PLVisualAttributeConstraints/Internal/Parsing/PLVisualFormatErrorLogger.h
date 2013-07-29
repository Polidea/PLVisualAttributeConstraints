//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import <Foundation/Foundation.h>
#import "PLAttributeConstraintVisualFormatAtom.h"

@interface PLVisualFormatErrorLogger : NSObject
+ (void)logExpectedAtomType:(PLAtomType)expectedAtomType gotAtomType:(PLAtomType)actualAtomType inText:(NSString *)text onIndex: (NSUInteger) index;
+ (void) logExpectedAtomType: (PLAtomType) expectedAtomType gotAtom: (PLAttributeConstraintVisualFormatAtom *)actualAtom inText: (NSString *) text onIndex: (NSUInteger) index;
+ (void)logExpectedAtomDescribedByString:(NSString *)expectedAtomDescription gotAtom:(PLAttributeConstraintVisualFormatAtom *)actualAtom inText:(NSString *)text onIndex:(NSUInteger)index1;
@end
