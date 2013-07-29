//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import <Foundation/Foundation.h>
#import "PLBaseParser.h"

@protocol PLAttributeConstraintVisualFormatLexerProtocol;

@interface PLControlWithAttributeParser : PLBaseParser

@property(nonatomic, strong) NSString *controlName;
@property(nonatomic, strong) NSString *attributeName;

@end
