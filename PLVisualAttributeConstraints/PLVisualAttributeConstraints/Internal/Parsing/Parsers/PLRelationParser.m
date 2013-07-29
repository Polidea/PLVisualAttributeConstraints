//
//  Created by Kamil Jaworski on 29.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLRelationParser.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLVisualFormatErrorLogger.h"

@implementation PLRelationParser {

}

- (id)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super initWithLexer:lexer];
    if (self) {
        _parsedRelationType = NSLayoutRelationEqual;
        _parsedWithSuccess = NO;
    }
    return self;
}

- (BOOL)parsedWithSuccess {
    return _parsedWithSuccess;
}

- (BOOL)__parseReportingErrorOnFailure:(BOOL)reportErrorOnFailure {

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    NSUInteger initialLexerState = _lexer.currentState;

    atom = [_lexer next];

    if ([self isRelationAtom:atom]) {
        _parsedRelationString = atom.stringData;
        _parsedWithSuccess = YES;
        _parsedRelationType = [self relationTypeFromAtom:atom];
    } else {
        [_lexer setCurrentState:initialLexerState];
        if (reportErrorOnFailure) {
            [PLVisualFormatErrorLogger logExpectedAtomDescribedByString:@"Relation atom"
                                                                gotAtom:atom
                                                                 inText:_lexer.text
                                                                onIndex:initialLexerState];
        }
        return NO;
    }

    return YES;

}

- (BOOL)isRelationAtom:(PLAttributeConstraintVisualFormatAtom *)atom {
    PLAtomType atomType = atom.atomType;
    return atomType == PLAtomTypeRelationEqual || atomType == PLAtomTypeRelationLessOrEqual || atomType == PLAtomTypeRelationGreaterOrEqual;
}

- (NSLayoutRelation)relationTypeFromAtom:(PLAttributeConstraintVisualFormatAtom *)atom {
    switch (atom.atomType) {
        case PLAtomTypeRelationEqual:
            return NSLayoutRelationEqual;
        case PLAtomTypeRelationLessOrEqual:
            return NSLayoutRelationLessThanOrEqual;
        case PLAtomTypeRelationGreaterOrEqual:
            return NSLayoutRelationGreaterThanOrEqual;
        default:
            @throw [NSException exceptionWithName:@"PLRelationParser"
                                           reason:@"Failed to map an atom to relation type"
                                         userInfo:nil];
    }
}

@end
