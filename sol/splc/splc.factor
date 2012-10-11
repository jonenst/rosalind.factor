!
!

USING: kernel io sequences rosalind ;
IN: rosalind.sol.splc

: rosalind-splc ( -- ) lines unclip swap splice dna>pro print ;

MAIN: rosalind-splc