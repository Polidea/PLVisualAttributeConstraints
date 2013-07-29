//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLControlWithAttributeParser.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLVisualFormatErrorLogger.h"

@implementation PLControlWithAttributeParser {

}

- (id)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super initWithLexer:lexer];
    if (self) {
        _controlName = nil;
        _attributeName = nil;
    }
    return self;
}

- (BOOL)parsedWithSuccess {
    return _controlName != nil && _attributeName != nil;
}

- (BOOL)__parseReportingErrorOnFailure:(BOOL)reportErrorOnFailure {

    NSUInteger initialLexerState = _lexer.currentState;

    // Control name
    PLAttributeConstraintVisualFormatAtom *controlNameAtom = [_lexer next];
    if (controlNameAtom.atomType != PLAtomTypeIdentifier) {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomType:PLAtomTypeIdentifier gotAtom:controlNameAtom inText:_lexer.text onIndex:initialLexerState];
        }
        return NO;
    }

    _controlName = controlNameAtom.stringData;

    // Dot
    PLAttributeConstraintVisualFormatAtom *dotAtom = [_lexer next];
    if (dotAtom.atomType != PLAtomTypeDot) {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomType:PLAtomTypeDot gotAtom:dotAtom inText:_lexer.text onIndex:initialLexerState];
        }
        return NO;
    }

    // Control attribute
    PLAttributeConstraintVisualFormatAtom *controlAttributeAtom = [_lexer next];
    if (controlNameAtom.atomType != PLAtomTypeIdentifier) {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomType:PLAtomTypeIdentifier gotAtom:controlAttributeAtom inText:_lexer.text onIndex:initialLexerState];
        }
        return NO;
    }

    _attributeName = controlAttributeAtom.stringData;

    return YES;

}

@end
