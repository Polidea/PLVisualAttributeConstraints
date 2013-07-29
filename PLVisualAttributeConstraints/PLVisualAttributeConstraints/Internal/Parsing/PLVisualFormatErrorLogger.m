//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLVisualFormatErrorLogger.h"

@implementation PLVisualFormatErrorLogger {

}

+ (void)logExpectedAtomType:(PLAtomType)expectedAtomType
                gotAtomType:(PLAtomType)actualAtomType
                     inText:(NSString *)text
                    onIndex:(NSUInteger)index {

    [self beginLogging];
    NSLog(@"In text:");
    [self printText:text pointingAtCharAtIndex:index];
    NSLog(@"Expected atom type: %@", @(expectedAtomType));
    NSLog(@"Got atom type: %@", @(actualAtomType));
    [self endLogging];

}

+ (void)logExpectedAtomType:(PLAtomType)expectedAtomType
                    gotAtom:(PLAttributeConstraintVisualFormatAtom *)actualAtom
                     inText:(NSString *)text
                    onIndex:(NSUInteger)index {
    [self beginLogging];
    NSLog(@"In text:");
    [self printText:text pointingAtCharAtIndex:index];
    NSLog(@"Expected atom type: %@", @(expectedAtomType));
    NSLog(@"Got atom: %@", actualAtom);
    [self endLogging];
}

+ (void)logExpectedAtomDescribedByString:(NSString *)expectedAtomDescription
                                 gotAtom:(PLAttributeConstraintVisualFormatAtom *)actualAtom
                                  inText:(NSString *)text
                                 onIndex:(NSUInteger)index {
    [self beginLogging];
    NSLog(@"In text:");
    [self printText:text pointingAtCharAtIndex:index];
    NSLog(@"Expected atom: %@", expectedAtomDescription);
    NSLog(@"Got atom: %@", actualAtom);
    [self endLogging];
}


#pragma mark - Helpers =================================================================================================

+ (void)beginLogging {
    NSLog(@"==============================================================================================");
}

+ (void)endLogging {
    NSLog(@"==============================================================================================");
}

+ (void)printText:(NSString *)text pointingAtCharAtIndex:(NSUInteger)index {
    NSLog(@"%@", text);
    NSMutableString *arrow = [NSMutableString string];
    for (NSUInteger i = 1; i < index; i++) {
        [arrow appendString:(i % 2 == 0) ? @" " : @"-"];
    }
    [arrow appendString:@"^"];
    NSLog(@"%@", arrow);
}

@end
