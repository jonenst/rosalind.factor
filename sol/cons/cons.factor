!
!

USING: kernel io arrays sequences columns rosalind rosalind.util ;
IN: rosalind.sol.cons

: rosalind-cons ( -- ) 
    lines [ consensus print nl ] [ profile ] bi
    { "A: " "C: " "G: " "T: " } 
    swap <flipped> [ as-string append print nl ] 2each
;

MAIN: rosalind-cons