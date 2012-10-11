!
!

USING: kernel sbufs strings arrays sequences assocs hashtables
       io io.files io.encodings.utf8
io io.encodings.utf8 io.files kernel sbufs sequences
strings ;

IN: rosalind.fasta

<PRIVATE

: (read-elem) ( -- meta str last? )
    readln { CHAR: > } read-until not
    [ >sbuf [ CHAR: \n = not ] filter! >string ] dip
;

PRIVATE>


: read-fasta ( -- fasta* )
    read1 drop
    f [ not ] [ (read-elem) [ swap 2array ] dip swap ] produce >hashtable
;