//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import <Foundation/Foundation.h>
#import "PLBaseParser.h"

@protocol PLAttributeConstraintVisualFormatLexerProtocol;

@interface PLRelationParser : PLBaseParser

@property(nonatomic, strong) NSString *parsedRelationString;
@property(nonatomic, readonly) NSLayoutRelation parsedRelationType;

@end
