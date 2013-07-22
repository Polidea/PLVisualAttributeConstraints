## Description

**PLVisualAttributeConstraints** is small lib that makes it easier to create layout constraints (see: [NSLayoutConstraint](http://developer.apple.com/library/ios/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html) class).

If you don't know much about the **AutoLayout** mechanism, I strongly suggest you to go [there](https://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html) for more information.

PLVisualAttributeConstraints **does not** try to replace standard [VFL (Visual Format Language)](http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/formatLanguage.html) or alter default Apple's mechanisms. It integrates with it seamlessly and greatly improves developer's productivity and code readability.

## Example

In a nutshell, having two views...
```objective-c
  UIView *firstView = ...
  UIView *secondView = ...
```

using this lib you can create layout constraint like...
```objective-c
  NSDictionary *views = @{
          @"firstView" : firstView,
          @"secondView" : secondView
  };

  NSLayoutConstraint *constraint1 = 
    [NSLayoutConstraint attributeConstraintWithVisualFormat:@"secondView.left >= firstView.left * 2 + 10"
                                                                                      views:views];
```

instead of standard
```objective-c
  NSLayoutConstraint *constraint2 = 
    [NSLayoutConstraint constraintWithItem:secondView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:firstView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:2
                                  constant:10];
```

Those two constraints (`constraint1` and `constraint2`) are **identical** to each other.

It's very likely that you'll have lots of constraints (it's usual case). 
Note, that you need to create dictionary with views only *once* (f.e. at the very beggining of a constraints-creating method) and then you go on creating them with similar one-liners (like in the example above) or you can take advantage of another method:

```objective-c
  NSArray *constraints = [NSLayoutConstraint attributeConstraintsWithVisualFormatsArray:@[
          @"secondView.left <= firstView.left - 10",
          @"secondView.right >= firstView.right + 10",
          @"secondView.top == firstView.bottom * 2.5 + 5",
  ]                                                                               views:views];

```

## Grammar by example ;)

### Valid grammar examples
Instead of introducing formal grammar here, I'm quite convinced that a few examples will be more that enough to get you up and running.

``control1.top >= control2.bottom + 20``
``control1.top <= control2.bottom - 20.5``
``control1.top == control2.bottom * 2.3 + 4.5``
``control1.top >= control2.bottom * 2 - 10``

A little bit hacky (read on to see why):
``control1.top >= 100``
``control1.top == 100.5``

###Supported attributes are:
`top`, `bottom`, `left`, `right`, `leading`, `trailing`, `width`, `height`, `centerx`, `centery`, `baseline` (**case insensitive**)
Those attributes are mapped one-to-one with [those enums](http://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html#//apple_ref/doc/c_ref/NSLayoutAttribute).

###Supported relations:
``==``, ``>=``, ``<=``


## Installation

Just copy source files under `PLVisualAttributeConstraints/PLVisualAttributeConstraints/*` into your project.
Support for installation via [CocoaPods](https://github.com/CocoaPods/CocoaPods) will follow shortly.

## Requirements
* iOS 6.0+

## Author
Kamil Jaworski (kamil.jaworski@gmail.com), [Polidea](http://www.polidea.com/)
