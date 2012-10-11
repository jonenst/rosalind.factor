!
!

USING: kernel sbufs strings sequences
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

: read-fasta ( -- seq* )
    f [ not ] [ (read-elem) [ nip ] dip swap ] produce
;