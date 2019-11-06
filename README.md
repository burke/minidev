# minidev

`minidev` is a *reeaaaaallly* limited public replacement for Shopify's internal `dev` tool.

Where most of `dev` is concerned with `dev up`, which provisions dependencies and various other
things, there's a little bit of accessory function that's pretty easy to replicate, which is what's
been done here.

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
