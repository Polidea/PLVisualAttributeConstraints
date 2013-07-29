//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLMultiplierExpressionParser.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLVisualFormatErrorLogger.h"

@implementation PLMultiplierExpressionParser {

}

- (id)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super initWithLexer:lexer];
    if (self) {
        _parsedWithSuccess = NO;
    }
    return self;
}

- (BOOL)__parseReportingErrorOnFailure:(BOOL)reportErrorOnFailure {

    NSAssert(_parsedWithSuccess == NO, @"Already parsed with success", nil);

    NSUInteger initialLexerState = _lexer.currentState;

    // *
    PLAttributeConstraintVisualFormatAtom *asteriskAtom = [_lexer next];
    if (asteriskAtom.atomType != PLAtomTypeAsterisk) {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomType:PLAtomTypeAsterisk gotAtom:asteriskAtom inText:_lexer.text onIndex:initialLexerState];
        }
        return NO;
    }

    [_lexer omitWhiteSpaces];

    // Number
    PLAttributeConstraintVisualFormatAtom *numberAtom = [_lexer next];
    if (numberAtom.atomType != PLAtomTypeFloatingPointNumber) {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomType:PLAtomTypeFloatingPointNumber gotAtom:numberAtom inText:_lexer.text onIndex:initialLexerState];
        }
        return NO;
    }

    _multiplierValue = [numberAtom.stringData floatValue];
    _parsedWithSuccess = YES;

    return _parsedWithSuccess;

}

@end
