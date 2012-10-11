USING: kernel arrays sequences sequences.extras combinators grouping assocs sets
       math math.parser math.functions math.ranges columns
       strings io.files io.encodings.utf8 ;

IN: rosalind


<PRIVATE

CONSTANT: 'A CHAR: A    CONSTANT: 'B CHAR: B    CONSTANT: 'C CHAR: C
CONSTANT: 'D CHAR: D    CONSTANT: 'E CHAR: E    CONSTANT: 'F CHAR: F
CONSTANT: 'G CHAR: G    CONSTANT: 'H CHAR: H    CONSTANT: 'I CHAR: I
CONSTANT: 'J CHAR: J    CONSTANT: 'K CHAR: K    CONSTANT: 'L CHAR: L
CONSTANT: 'M CHAR: M    CONSTANT: 'N CHAR: N    CONSTANT: 'O CHAR: O
CONSTANT: 'P CHAR: P    CONSTANT: 'Q CHAR: Q    CONSTANT: 'R CHAR: R
CONSTANT: 'S CHAR: S    CONSTANT: 'T CHAR: T    CONSTANT: 'U CHAR: U
CONSTANT: 'V CHAR: V    CONSTANT: 'W CHAR: W    CONSTANT: 'X CHAR: X
CONSTANT: 'Y CHAR: Y    CONSTANT: 'Z CHAR: Z    CONSTANT: '* CHAR: *

CONSTANT: (weights)
    H{ { CHAR: A  71.03711 } 
       { CHAR: C 103.00919 } 
       { CHAR: D 115.02694 } 
       { CHAR: E 129.04259 }
       { CHAR: F 147.06841 } 
       { CHAR: G  57.02146 } 
       { CHAR: H 137.05891 } 
       { CHAR: I 113.08406 }
       { CHAR: K 128.09496 } 
       { CHAR: L 113.08406 } 
       { CHAR: M 131.04049 } 
       { CHAR: N 114.04293 }
       { CHAR: P  97.05276 } 
       { CHAR: Q 128.05858 } 
       { CHAR: R 156.10111 } 
       { CHAR: S  87.03203 }
       { CHAR: T 101.04768 } 
       { CHAR: V  99.06841 } 
       { CHAR: W 186.07931 } 
       { CHAR: Y 163.06333 } 
     }

CONSTANT: (codons)
    H{ { "UUU" CHAR: F } { "CUU" CHAR: L } { "AUU" CHAR: I } { "GUU" CHAR: V }
       { "UUC" CHAR: F } { "CUC" CHAR: L } { "AUC" CHAR: I } { "GUC" CHAR: V }
       { "UUA" CHAR: L } { "CUA" CHAR: L } { "AUA" CHAR: I } { "GUA" CHAR: V }
       { "UUG" CHAR: L } { "CUG" CHAR: L } { "AUG" CHAR: M } { "GUG" CHAR: V }
       { "UCU" CHAR: S } { "CCU" CHAR: P } { "ACU" CHAR: T } { "GCU" CHAR: A }
       { "UCC" CHAR: S } { "CCC" CHAR: P } { "ACC" CHAR: T } { "GCC" CHAR: A }
       { "UCA" CHAR: S } { "CCA" CHAR: P } { "ACA" CHAR: T } { "GCA" CHAR: A }
       { "UCG" CHAR: S } { "CCG" CHAR: P } { "ACG" CHAR: T } { "GCG" CHAR: A }
       { "UAU" CHAR: Y } { "CAU" CHAR: H } { "AAU" CHAR: N } { "GAU" CHAR: D }
       { "UAC" CHAR: Y } { "CAC" CHAR: H } { "AAC" CHAR: N } { "GAC" CHAR: D }
       { "UAA" CHAR: * } { "CAA" CHAR: Q } { "AAA" CHAR: K } { "GAA" CHAR: E }
       { "UAG" CHAR: * } { "CAG" CHAR: Q } { "AAG" CHAR: K } { "GAG" CHAR: E }
       { "UGU" CHAR: C } { "CGU" CHAR: R } { "AGU" CHAR: S } { "GGU" CHAR: G }
       { "UGC" CHAR: C } { "CGC" CHAR: R } { "AGC" CHAR: S } { "GGC" CHAR: G }
       { "UGA" CHAR: * } { "CGA" CHAR: R } { "AGA" CHAR: R } { "GGA" CHAR: G }
       { "UGG" CHAR: W } { "CGG" CHAR: R } { "AGG" CHAR: R } { "GGG" CHAR: G } }

PRIVATE>

: arginf* ( seq -- arg val ) dup infimum  [ = ] curry find ;
: arginf  ( seq -- arg     ) arginf* drop ;
: argsup* ( seq -- arg val ) dup supremum [ = ] curry find ;
: argsup  ( seq -- arg     ) argsup* drop ;

: codon>amino  ( codon -- amino/f ) (codons) at ;
: codon>amino* ( codon -- amino/f ) 
    dup length 3 / [0,b) swap
    [ [ [ 3 * ] [ 1 + 3 * ] bi ] dip subseq codon>amino ] curry map
    dup '* swap index dup [ head ] [ nip ] if dup [ >string ] when
;

: rev-compliment ( dna -- rev-compliment )
    reverse 
    [ { { 'A [ 'T ] } { 'C [ 'G ] } { 'G [ 'C ] } { 'T [ 'A ] } } case ] map
;

: nucleotide ( dna n -- N )
    [ = [ 1 + ] when ] curry 0 swap reduce
;

: nucleotides ( dna -- A C G T )
    { [ 'A nucleotide ] 
      [ 'C nucleotide ] 
      [ 'G nucleotide ] 
      [ 'T nucleotide ] } cleave
;

: gc-content ( dna -- % )
    nucleotides -rot + -rot + over + /f
;

: motifs ( seq seq -- indices )
    [ [ length ] [ length ] bi* - [0,b) ] 2keep
    [ [ over tail-slice ] dip head? [ suffix! ] [ drop ] if ] 2curry 
    V{ } clone swap reduce
;

: profile ( dna-v -- profile )
    <flipped> [ nucleotides 4array ] map
;

: consensus* ( profile -- dna )
    [ argsup ] map { CHAR: A CHAR: C CHAR: G CHAR: T } [ nth ] curry map
    >string
;

: consensus ( dna-v -- dna )
    profile consensus*
;



: dna>rna ( dna -- rna )
    [ dup 'T = [ drop 'U ] when ] map
;

: rna>pro ( rna -- pro/f )
    dup "AUG" head? [ codon>amino* ] when
;

: rna>pro* ( rna -- pro* )
    dup "AUG" motifs swap [ swap tail-slice rna>pro ] curry map
;

: dna>pro ( dna -- pro/f )
    dna>rna rna>pro
;

: dna>pro* ( dna -- pro* )
    dup rev-compliment [ dna>rna rna>pro* [ ] filter! ] bi@ append members
;


: splice ( dna introns -- pro )
    swap
    [ 2dup motifs first swap length over + [ over ] dip 
      [ head-slice ] [ tail-slice ] 2bi* append
    ] reduce
;

: hamming ( dna dna -- hamming )
    0 [ = [ 1 + ] unless ] 2reduce
;

: protein-transcriptions ( amino -- count )
    '* suffix
    H{ } clone (codons) values over [ inc-at ] curry each
    1 swap [ at * ] curry reduce
;



: mass ( amino -- mass )
    0 [ (weights) at + ] reduce
;







