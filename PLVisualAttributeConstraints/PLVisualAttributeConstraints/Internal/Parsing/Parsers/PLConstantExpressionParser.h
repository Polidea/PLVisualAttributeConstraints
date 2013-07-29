//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import <Foundation/Foundation.h>
#import "PLBaseParser.h"

@interface PLConstantExpressionParser : PLBaseParser
@property (nonatomic) BOOL requireLeadingSignChar;
@property(nonatomic, readonly) CGFloat constantValue;
@end
