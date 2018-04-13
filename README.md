Partial Hackage Mirror
======================

This script creates partial Hackage mirrors for new-build based projects. Only
the new "secure" type of hackage repos is supported.

Usage
-----

To create or update the mirror, run the following command in a cabal "new-style"
project:

```
HACKAGE=http://hackage.haskell.org DISTDIR=dist-newstyle/ OUTDIR=/tmp/mirror \
    ./mirror-hackage.sh
```

here the environment variables `HACKAGE`, `DISTDIR` and `OUTDIR` are set to
their default values, you may override them using the syntax above if
desired.

To use one of the hackage.haskell.org mirrors, if it's down:

- `HACKAGE=http://objects-us-west-1.dream.io/hackage-mirror ./mirror-hackage.sh`
- `HACKAGE=http://hackage.fpcomplete.com ./mirror-hackage.sh`

See https://hackage.haskell.org/mirros.json for more.

The script will read `$DISTDIR/cache/plan.json` to figure out the set of
package-versions your current project needs. It then unifies this set with the
package list already in the mirror directory (at `$OUTDIR/package.list`) and
proceeds to download any files which are missing from the `$OUTDIR/package`
directory.


To use the mirror you just created add something like the following to your
`~/.cabal/config` file:

```
repository my-mirror
  url: file:/tmp/mirror
  secure: True
```

You can also create a fully fledged cabal config-file and override the global
one by passing `--config-file=FILE` to all relevant `cabal` invocations. To
create a default config file which you can use as a template, you can run
`cabal --config-file=FILE user-config init`.

Dependencies
------------

- Debian / Ubuntu

```
apt-get install jq wget
```
