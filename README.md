# Flashblocks

Flashblocks is a ActionScript library to support the creation of visual, block-based programming applications. Originally developed as my senior project while I was at MIT, it is heavily influenced by the work of several other projects also developed at MIT, including [StarLogo TNG](http://mitstep.org/projects/starlogo-tng) and [Scratch](http://scratch.mit.edu/).

![flashblocks](https://raw.github.com/trun/flashblocks/master/static/flashblocks.png)

## Building Flashblocks

Requirements

 - Flex SDK 3 (sorry, no Flex 4 yet)
 - Java JDK 6+
 - Ant

Be sure to set your `FLEX_HOME` environment variable and then run...

```
ant build
```

## Sample Projects

Included in the source are some sample projects built using the Flashblocks library.

### [LogoBlocks](http://logoblocks.herokuapp.com)

A very simple simulator based on the [Logo](http://en.wikipedia.org/wiki/Logo_%28programming_language%29) programming language. Users use commands like `Turn Right` and `Forward` to control a virtual turtle that draws lines with its tail. You can also utilize loops and colors to make interesting patterns.

<a href="https://raw.github.com/trun/flashblocks/master/static/logoblocks.png">
  <img src="https://raw.github.com/trun/flashblocks/master/static/logoblocks_small.png">
</a>

## Related Projects

### StarLogo TNG

[**StarLogo TNG**](http://education.mit.edu/projects/starlogo-tng) is a 3D simulator that uses a block-based programming interface. Flashblocks was designed working closely with the several members of the StarLogo TNG team.

### Scratch

[**Scratch**](http://scratch.mit.edu) is an application that allows you to create interactive stories, games, music and art using a block-based progamming interface.

### ScriptBlocks

[**ScriptBlocks**](http://code.google.com/p/scriptblocks/) is a Javascript library that was developed by the same teams that built Scratch and StarLogo TNG. I haven't really played around with it yet, but with mobile and HTML5 ready platforms becoming more mainstream, Javascript is quickly overtaking Flash as the lingua franca for rich interactive applications on the web.
