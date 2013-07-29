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

    CGFloat signMultiplier = 1.0f;

    // + | -
    PLAttributeConstraintVisualFormatAtom *signAtom = [_lexer next];
    if (signAtom.atomType == PLAtomTypeMinus || signAtom.atomType == PLAtomTypePlus) {
        signMultiplier = (signAtom.atomType == PLAtomTypePlus) ? 1.0f : -1.0f;
    } else {

        [_lexer setCurrentState:initialLexerState];

        if (self.requireLeadingSignChar) {
            if (self.requireLeadingSignChar && reportErrorOnFailure) {
                [PLVisualFormatErrorLogger logExpectedAtomDescribedByString:@"Sign (+/-)" gotAtom:signAtom inText:_lexer.text onIndex:initialLexerState];
            }
            return NO;
        }

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

    _constantValue = [numberAtom.stringData floatValue] * signMultiplier;
    _parsedWithSuccess = YES;

    return _parsedWithSuccess;

}

@end
