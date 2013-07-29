//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLConstantExpressionParser.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLVisualFormatErrorLogger.h"

@implementation PLConstantExpressionParser {

}

- (id)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super initWithLexer:lexer];
    if (self) {
        _requireLeadingSignChar = YES;
    }
    return self;
}

- (BOOL)__parseReportingErrorOnFailure:(BOOL)reportErrorOnFailure {

    NSAssert(_parsedWithSuccess == NO, @"Already parsed with success", nil);

    NSUInteger initialLexerState = _lexer.currentState;

    // + | -
    PLAttributeConstraintVisualFormatAtom *signAtom = [_lexer next];
    if (signAtom.atomType != PLAtomTypePlus && signAtom.atomType != PLAtomTypeMinus) {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomDescribedByString:@"Sign (+/-)" gotAtom:signAtom inText:_lexer.text onIndex:initialLexerState];
        }
        return NO;
    }

    CGFloat signMultiplier = (signAtom.atomType == PLAtomTypePlus) ? 1.0f : -1.0f;

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

    _constantValue = [numberAtom.stringData floatValue] * signMultiplier;
    _parsedWithSuccess = YES;

    return _parsedWithSuccess;

}

@end
