# Ragequit

This plugin gives you control over your unresponsive programs and your
uncontrolled rage by killing your programs with the magic words
`fuck you` or `fuck off` for a more powerful response.

Demo: [URL to mp4]()

## Instructions

There are two main usage modes:

- `fuck you <process_name>`: this will send a normal kill signal (SIGTERM).
  If that doesn't kill the process, try `fuck off`.

- `fuck off <process_name>`: this will send a force-kill signal (SIGKILL).

If you have something else to say, arguments after the first two are ignored,
so you can get out all the rage inside you in one nifty command:

```sh
$ fuck you chrome you freaking memory-devouring monster gaaaaaaa
```

_NOTE: this does not represent my opinion about Chrome. I <3 Chrome :)_

## Thanks

Original idea from [@namuol](https://github.com/namuol).
[Source](https://gist.github.com/namuol/9122237).

Partial port to zsh and completion from [@sztupy](https://github.com/sztupy).
[Source](https://gist.github.com/sztupy/9138124).

Extended syntax (`fuck you / fuck off`) from [@mikisvaz](https://github.com/mikisvaz).
[Source](https://gist.github.com/namuol/9122237).
