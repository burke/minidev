# minidev

`minidev` is a *reeaaaaallly* limited public replacement for Shopify's internal `dev` tool.

Where most of `dev` is concerned with `dev up`, which provisions dependencies and various other
things, there's a little bit of accessory function that's pretty easy to replicate, which is what's
been done here.

## install

```bash
curl https://raw.githubusercontent.com/burke/minidev/master/install.sh | bash
```

this writes minidev to ~/.local/minidev and sources it from your  .profile

## notes

`minidev` implements:

* `dev cd`
* `dev clone`
* Project-local commands (`dev {build,style,console,server,test,etc.}`).


`minidev` does not:

* Implement `dev up` at all
* have adequate help
* try very hard to prevent randomly crashing
* be good

Use `minidev` by adding `source /path/to/minidev/dev.sh` to your shell config.

Everything this does is far more limited than `dev`, including that it won't self-update.

If you want to use the same dotfiles at home and at work, you may enjoy something like:

```bash
if [ -f /opt/dev/dev.sh ]; then
  source /opt/dev/dev.sh
elif [ -f ~/src/github.com/burke/minidev/dev.sh ]; then
  source ~/src/github.com/burke/minidev/dev.sh
fi
```

You can config the default directory for `dev clone` and `dev cd` by calling `dev config set default.github_root <path to directory>`, otherwise it defaults to `~/src/github.com`.

## contributing

Are you ex-Shopify? Feel free to send patches to implement the thing the way you
remember it working.

Are you current Shopify? There's really very little I could point to in `dev`
itself that couldn't be made open source. You can pretty much feel free to copy
code directly over here, just try not to introduce a whole lot of complexity.

In general we don't want minidev to do _different_ things than `dev`, except to
the extent necesary for simplicity or a bit less Shopify-specificness.
