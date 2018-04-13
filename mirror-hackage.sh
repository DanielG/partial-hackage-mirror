#!/bin/sh

HACKAGE=${HACKAGE:-http://haskell.hackage.org}
DISTDIR=${DISTDIR:-dist-newstyle/}
OUTDIR=${OUTDIR:-/tmp/mirror}
NPROC=${NPROC:-8}

IFS=

mkdir -p $OUTDIR

wget -c -O $OUTDIR/root.json         $HACKAGE/root.json    
wget -c -O $OUTDIR/timestamp.json    $HACKAGE/timestamp.json
wget -c -O $OUTDIR/snapshot.json     $HACKAGE/snapshot.json
wget -c -O $OUTDIR/mirrors.json      $HACKAGE/mirrors.json
wget -c -O $OUTDIR/01-index.tar.gz   $HACKAGE/01-index.tar.gz

jq -r '."install-plan" | map(select(.style == "global") | .id)[]' \
   < $DISTDIR/cache/plan.json \
    | sort | sed -r -e 's/-[^-]+$//' -e 's/-([^-]+)$/ \1/' \
		 >> $OUTDIR/package.list

cd $OUTDIR

# remove duplicates from package list
cat package.list | sort | uniq > package.list.1
mv package.list.1 package.list

mkdir -p $OUTDIR/package

# download packages
cat $OUTDIR/package.list \
    | awk '{ print "package/" $1 "-" $2 ".tar.gz" }' \
    | xargs -P$NPROC --verbose -n1 -- sh -c 'mkdir -p $(dirname $1); if [ ! -e "$1" ]; then wget -c -O $1 '$HACKAGE'/$1; fi' sh
