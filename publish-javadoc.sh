#!/bin/bash -xe
#
# publish Hudson javadoc and deploy that into the java.net CVS repository
# 

pushd ../../../www/javadoc
svn revert -R .
svn update
popd

cp -R target/checkout/core/target/apidocs/* ../../../www/javadoc

cd ../../../www/javadoc

# remove timestamp as this creates unnecessary revisions for javadoc files
find . -name "*.html" | xargs perl -p -i.bak -e "s|-- Generated by javadoc .+--|-- --|"
find . -name "*.html" | xargs perl -p -i.bak -e "s|<META NAME=\"DATE\" CONTENT=\"....-..-..\">||"
find . -name "*.bak" | xargs rm

# ignore everything under CVS, then
# ignore all files that are already in CVS, then
# add the rest of the files
#find . -name CVS -prune -o -exec bash in-cvs.sh {} \; -o \( -print -a -exec cvs add {} \+ \)
#rcvsadd . "commiting javadoc"
svn add $(svn status | grep "^?" | cut -d " " -f2-) .
svn commit -m "commiting javadoc"

# sometimes the first commit fails
#cvs commit -m "commit 1 " || cvs commit -m "commit 2"
