# AdventOfCode2017
 
Just an excuse to play with programming languages in a safe environment. Next up: [Objective-C](https://en.wikipedia.org/wiki/Objective-C).

## 10 Days Solved in Objective-C

After doing 2019 in Java and [NetBeans](https://netbeans.apache.org), the thing that annoyed me the most was not the Java language or libraries, which were powerful (if uninspiring), it was the editor. There were so many glitches and delays and other annoyances using NetBeans that I just wanted a good editor. I'd done 2022 in [BBEdit](https://www.barebones.com/products/bbedit/), and I wanted to try the older language combined with a first-class IDE. Hence, Objective-C and Xcode.

I had done some ObjC in the past, but never really mastered it. As soon as Swift was on the scene, I started using it. But ObjC has actually kept moving ahead in the meantime, with some nice features and still has first-class support in Xcode, which has made the actual writing of code a pleasure.

Things that have annoyed me:
- Working with .h files. I'd rather not, but ObjC needs them.
- Constantly having to type out variable types instead of "var" and type inference. Especially when using complex types like NSMutableDictionary<<NSString *>, <NSMutableSet *>>. Auto-complete only goes so far. Perl would just be %dict.

Things that have surprised me (pleasantly):
- The aforementioned [Xcode](https://developer.apple.com/xcode/) IDE.
- ObjC property syntax removing a lot of boilerplate (I'm looking in *your* direction, Java...)
- Inline creation of objects, like creating an NSNumber with @13, NSArray with @[], etc. Also removes a lot of boilerplate.
- Automatic Reference Counting (ARC) freeing up the brain cells that would have needed to track memory leaks.
- [NSString](https://developer.apple.com/documentation/foundation/nsstring), [NSArray](https://developer.apple.com/documentation/foundation/nsarray), [NSDictionary](https://developer.apple.com/documentation/foundation/nsdictionary) and [NSSet](https://developer.apple.com/documentation/foundation/nsset). You can do so much with these, and they have such a rich API that I rarely have to step outside them. It's almost like writing Perl, and just sticking to scalars, lists and hashes.
- And speaking of NSArray, [valueForKey](https://developer.apple.com/documentation/foundation/nsarray/1412219-valueforkey). It is what is called a map in other languages and covers a lot of what I would use a map for.

Overall, I'm pretty enthusiastic at this point. I imagine that at some point I'm going to run into long integers, so I've started tracking numbers in NSInteger (i.e. a long) and NSNumber.