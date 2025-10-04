#!/bin/bash

DIR=${1:-.} # default to current directory

# use `find` to find all files and their inode
# akw group by inode, print file list corresponding to inode
find "$DIR" -type f -printf "%i %p\n" |
  awk '
{
    inode[$1] = inode[$1] ? inode[$1] "\n" $2 : $2
}
END {
    for (i in inode) {
        # only show inode having hard links (link count > 1)
        split(inode[i], files, "\n")
        if (length(files) > 1) {
            print "hard link group (inode=" i "):"
            for (f in files) print "  " files[f]
            print ""
        }
    }
}'
