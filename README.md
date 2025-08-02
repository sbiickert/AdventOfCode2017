# AdventOfCode2017
 
Just an excuse to play with programming languages in a safe environment. Next up: [Objective-C](https://en.wikipedia.org/wiki/Objective-C).

## 10 Days Solved in Objective-C

After doing 2019 in Java and [NetBeans](https://netbeans.apache.org), the thing that annoyed me the most was not the Java language or libraries, which were powerful (if uninspiring), it was the editor. There were so many glitches and delays and other annoyances using NetBeans that I just wanted a good editor. I'd done 2022 in [BBEdit](https://www.barebones.com/products/bbedit/), and I wanted to try the older language combined with a first-class IDE. Hence, Objective-C and Xcode.

I had done some ObjC in the past, but never really mastered it. As soon as Swift was on the scene, I started using it. But ObjC has actually kept moving ahead in the meantime, with some nice features and still has first-class support in Xcode, which has made the actual writing of code a pleasure.

Things that have annoyed me:
- Working with .h files. I'd rather not, but ObjC needs them.
- Constantly having to type out variable types instead of "var" and type inference. Especially when using complex types like NSMutableDictionary<NSString *, NSMutableSet *>. Auto-complete only goes so far. Perl would just be %dict.

Things that have surprised me (pleasantly):
- The aforementioned [Xcode](https://developer.apple.com/xcode/) IDE.
- ObjC property syntax removing a lot of boilerplate (I'm looking in *your* direction, Java...)
- Inline creation of objects, like creating an NSNumber with @13, NSArray with @[], etc. Also removes a lot of boilerplate.
- Automatic Reference Counting (ARC) freeing up the brain cells that would have needed to track memory leaks.
- [NSString](https://developer.apple.com/documentation/foundation/nsstring), [NSArray](https://developer.apple.com/documentation/foundation/nsarray), [NSDictionary](https://developer.apple.com/documentation/foundation/nsdictionary) and [NSSet](https://developer.apple.com/documentation/foundation/nsset). You can do so much with these, and they have such a rich API that I rarely have to step outside them. It's almost like writing Perl, and just sticking to scalars, lists and hashes.
- And speaking of NSArray, [valueForKey](https://developer.apple.com/documentation/foundation/nsarray/1412219-valueforkey). It is what is called a map in other languages and covers a lot of what I would use a map for.

Overall, I'm pretty enthusiastic at this point. I imagine that at some point I'm going to run into long integers, so I've started tracking numbers in NSInteger (i.e. a long) and NSNumber.

## 18 Days Solved in ObjC

The language and tools continue to impress. I suppose the biggest annoyance is wrapping/unwrapping integers in NSNumber in order to put them into NSArray, NSDictionary. It's not that big a deal, but it *feels* like something to avoid. Most days I look at my code and I like what I see.

## 25 Days Solved in ObjC

Wow. Considering I was doing this as a bit of a challenge, raising the bar as it were, that was easy. I really enjoyed doing the puzzles in Objective C, and I really didn't get into trouble much. I can't think of a time where I really misunderstood what an API call was for and headed down into a dark hole. I think the only blemish was regular expressions. They are there in Foundation, but so awkward to use that I avoided them almost entirely.

I don't know if I will take on another AoC with ObjC, but if I did, it wouldn't really be a stunt. It would be a finely-honed tool in the toolbox. With 2019's Java run, I couldn't wait for the 25th to be over. With ObjC, I was sad to see it finished.

## Raku

In 2024, I did my AoC solve in Raku. One of the things that I focused on was the [functional programming](https://raku.guide/#_functional_programming) capabilities of the language, and I followed that up with learning Scala and then F#. Here, I'm returning to Raku and using the FP capabilities where possible and taking the time to understand and optimize instead of just hacking it until it works.

Since my only previous solve of 2017 was with ObjC, it makes for an interesting contrast. Some days, I find my solution is effectively the same, but much less verbose. Other days, the Raku solution is radically different. In some cases, that's because I've changed as a developer and in others, it's just the way the language works. When the solutions are the same, the ObjC one wins on performance. But the total LOC for Raku is always shorter.

I'm also using Visual Studio Code, whereas in 2024 I used nano. VS Code works really well for Raku. Not as much assistance as VS Code + Iodide for F#, but autocomplete and live compilation and error messages go a long way to speed things up.

## 25 Days Solved in Raku

If I had to sum this experience up, I would say: "slow and concise".

Slow, because there's no getting around the fact that Raku's processing is slow. Slower than Perl, and way slower than F# or ObjC or Swift. When the solution requires looping over something millions of times, there's no alternative to waiting. I tried using the hyper operator to multithread, but that did nothing for overall speed. I also figured out that using the ==> feed operator was slower than just chaining functions. Example: 

```
	# This is slower
	@bridge ==> map( -> @comp { @comp.sum }) ==> sum;
	
	# This is faster
	@bridge.map( -> @comp { @comp.sum }).sum;
```

Concise, because when I was comparing my Raku solutions to the ObjC solutions, they were at least half the number of lines of code, and sometimes more than 3x less. Not that I was obfuscating my code or doing something ridiculous, just the code was very compact. Writing Raku in Visual Studio Code was way, way faster than doing it in nano. Having the editor compiling and finding errors in the background meant that there were almost no times where I would run and hit compilation errors. The offending lines were highlighted and hovering over them showed the problem.

I was a little disappointed that my code didn't end up being as "functional" towards the end. I started using more Perl-like code patterns and even OO, just using .map and .sum here and there. I found when writing F#, I would love reviewing the elegance of the code. Raku code is compact and not pretty.

I'm glad I did it. I still think that Raku is the best language for doing things like this, except for the speed issue.

## F#

The contest for Simon's fave language rages on.

Day 4 made for an interesting comparison between [Raku](https://github.com/sbiickert/AdventOfCode2017/blob/main/Raku/day04.raku) and [F#](https://github.com/sbiickert/AdventOfCode2017/blob/main/F%23/AoC2017/Day04.fs). I used the same method to solve (independently arrived at) but the differences are interesting. With Raku, the core code is more concise and more readable (and made of built-in functions). But F# is not a lot more difficult to read, and I automatically chose to pass the passphrase validation as a function to a generic solve routine, which is elegant.