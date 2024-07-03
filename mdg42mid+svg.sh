#!/bin/bash
#===================================================================================
#
#	 FILE:	haydn2mid+svg2.sh (minuets+trios)
#
#	USAGE:	haydn2mid+svg2.sh.sh n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12 n13 n14 n15 n16 
#									n17 n18 n19 n20 n21 n22 n23 n24 n25 n26 n27 n28 n29 n30 n31 n32
#
#		where n1-n16 are any of the 11 possible outcomes of a toss of
#		two ordinary six-sided dice, e.g., n1-n16 are 16 integers, not necessarily 
#		unique, chosen from the set {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}, while 
#		n17-n32 are any of the 6 possible outcomes of a toss of one die, e.g., n17-n32 
#		are from the set {1, 2, 3, 4, 5, 6}.
#
# DESCRIPTION:	Used for generating ABC, MIDI, and SVG files of a particular 
#		Musical Dice Game (MDG) minuet + trio based on Joseph Haydn's
#		"Gioco Filarmonico"
#
#      AUTHOR:	J.L.A. Uro (justineuro@gmail.com)
#     VERSION:	0.0.0
#     LICENSE:	Creative Commons Attribution 4.0 International License (CC-BY)
#     CREATED:	2024/06/22 22:02:12
#    REVISION:	
#==================================================================================

#----------------------------------------------------------------------------------
# declare the variables "diceS" and "measNR" as arrays
# diceS - array containing the 16 outcomes from input line
# measNR - array of all possible measure notes for a specific outcome
#----------------------------------------------------------------------------------
declare -a diceS measNR
#----------------------------------------------------------------------------------
# input 132-sequence of tosses as given in the command line
#----------------------------------------------------------------------------------
diceS=( $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} ${31} ${32} )

#----------------------------------------------------------------------------------
# input rule table to determine corresponding G/F measures for each toss outcome
#----------------------------------------------------------------------------------
## for minuets
ruletab() {
	case $1 in
	2) measNR=(96 22 141 41 105 122 11 30 70 121 26 9 112 49 109 14);;
	3) measNR=(32 06 128 63 146 46 134 81 117 39 126 56 174 18 116 83);;
	4) measNR=(69 95 158 13 153 55 110 24 66 139 15 132 73 58 145 79);;
	5) measNR=(40 17 113 85 161 2 159 100 90 176 7 34 67 160 52 170);;
	6) measNR=(148 74 163 45 80 97 36 107 25 143 64 125 76 136 1 93);;
	7) measNR=(104 157 27 167 154 68 118 91 138 71 150 29 101 162 23 151);;
	8) measNR=(152 60 171 53 99 133 21 127 16 155 57 175 43 168 89 172);;
	9) measNR=(119 84 114 50 140 86 169 94 120 88 48 166 51 115 72 111);;
	10) measNR=(98 142 42 156 75 129 62 123 65 77 19 82 137 38 149 8);;
	11) measNR=(3 87 165 61 135 47 147 33 102 4 31 164 144 59 173 78);;
	12) measNR=(54 130 10 103 28 37 106 5 35 20 108 92 12 124 44 131);;
	esac
}

## for trios
ruletabT() {
	case $1 in
	1) measNR=(72  6 59 25 81 41 89 13 36  5 46 79 30 95 19 66);;
	2) measNR=(56 82 42 74 14  7 26 71 76 20 64 84  8 35 47 88);;
	3) measNR=(75 39 54  1 65 43 15 80  9 34 93 48 69 58 90 21);;
	4) measNR=(40 73 16 68 29 55  2 61 22 67 49 77 57 87 33 10);;
	5) measNR=(83  3 28 53 37 17 44 70 63 85 32 96 12 23 50 91);;
	6) measNR=(18 45 62 38  4 27 52 94 11 92 24 86 51 60 78 31);;
	esac
}

#----------------------------------------------------------------------------------
# input notes
# declare variables "notesG" and "notesF" as arrays
# notesG - array that contains the possible treble clef notes per measure for minuets
# notesF - array that contains the possible bass clef notes per measure for minuets
# notesGT - array that contains the possible treble clef notes per measure for trios
# notesF - array that contains the possible bass clef notes per measure for trios
#----------------------------------------------------------------------------------
declare -a notesG notesF notesGT notes FT

#----------------------------------------------------------------------------------
# define notesG, array of 176 possible treble clef notes for minuets
#----------------------------------------------------------------------------------
notesG=( "afegce" "z !wedge!E(^GA)(ce)" "[d2F2][d2F2][d2F2]" "e3/B/A3/B/ G2" "A6" "gdbg a2" "BAA3a" "d6" 
"aAgGf2" "G2 ge {g/}fe/d/" "fe/d/ [c2A2][B2^G2]" "{B}b2b/a/g/f/ e/d/c/B/" "{A/}[a3f3][ge][f2d2]" "d6" "A/B/c/B/ A a2 c" "B4 b/a/g/f/" 
"(^d/e3/) (a/c3/)(d/A3/)" "(a/f/)(c/d/) A2 z2" "(ce)z !wedge!e (d/c/B/A/)" "(ef)(=ga)b2" "B[fd][ec][dB][cA][B^G]" "g/a/b/g/ e/f/g/e/ f2" "B/b/a/g/ [d2f2][c2e2]" "A6" 
"A2 a/=g/f/e/ ^d2" "g3/b/e3/g/c3/e/" "Bbgfed" "fd^ABcd" "(de)(fg)a2" "A6" "[E4c4][E2c2]" "f3/g/e3/f/d2" 
"A6" "ad c/d/e/c/ d2" "a3/=c'/ f3/a/ ^d3/f/" "f/a/f/d/ c2 !trill!B2" "e3/a/ c3/e/ A3/a/" "afgefd" "z!wedge!b z !wedge!^d z !wedge!e" "d4 b/a/^g/a/" 
"!wedge!c2!wedge!e2!wedge!a2" "B3/d/ c3/e/ d3/f/" "B/d/c/B/ c/e/d/c/ d2" "A3/d/ [f2d2][e2c2]" "c/e/d/c/ {c/}BA/^G/ A2" "cdef^ga" "c/d/B/^G/ Ed c2" "[G2E2][g2e2][e2c2]" 
"A2[c'e]2[d'f]2" "cd e/d/e/f/ d2" "B3/d/ g3/d/ b2" "b/f/g/e/ d2!trill!c2" "(dc)(ec)d2" "DAFdAf" "z[cA]1[dB]1[ec]1[fd]1[ec]1" "d2 e/d/e/g/ f2" 
"G2 g/f/e/d/ c2" "(a2a/)g/f/g/ f2" "Aa!trill!ag!trill!gf" "A3/c/e3/g/f2" "[AF]2[GE]2[FD]2" "(3ea^g (3fed (3cdB" "c2e/d/B/^G/A2" "A4 a/=g/f/e/" 
"B/c/^d/c/ Bb2^d" "(^df) z!wedge!f (e/d/)(!wedge!c/!wedge!B/)" "(B/c3/) !trill!d4" "(E2E/)F/^G/A/ B/c/d/e/" "a4 g/f/e/d/" "[bd]4[fd]2" "bBaB =g2" "B[bg]1[af]1[ge]1[fd]1[ec]1" 
"G2 Bdgb" " dcac d2" "f3/a/ d3/f/ A3/f/" "z b z g z e" "eBA=GFE" "d6" "d6" "(d2 (3d)fe (3dcB" 
"A6" "z!wedge!a z!wedge!c z!wedge!d" "d6" "a3/b/ g3/a/ f2 & f2e2d2" "(d2c/)B/c/d/e2" "d3/f/2 B3/d/ c2" "[a2A2] a/g/f/2e/ f2" "be ^d/e/f/d/ e2" 
"z !wedge!^d(eg)(ce)" "A2[f2a2][^d2f2]" "A6" "d3/f/ e3/g/ f2" "d6" "A6" "d2 e/f/g/2e/ f2" "a3/d'/ f3/a/ d3/f/" 
"z/E/F/^G/ A/B/c/d/ e/f/g/a/" "[F2d2](c/d3/)(c/d3/)" "f2 {e}d2 {c}B2" "A6" "(3bfg (3bfg (3bge" "[f4a4] [e=g][^df]" "ce^GB A2" "[f2a2d'2] d'/c'/b/a/ g/f/e/d/" 
 "(3^gab [B2d2][B2d2]" "a/f/e/d/ c2!trill!B2" "A6" "[c4a4][c2e2]" "(3Bgb (3agf (3edc" "(3Ace [E2=G2] F3/D/" "d6" "d3/g/ !trill!g3/f/4g/4 b2" 
 "e/f/g/e/ fa{g/}f{e/}d" "!trill!a3/g/4a/4 bGge" "A3/d/f3/d/ a2" "(3Bge d2!trill!c2" "[F4^d4][F2d2]" "z!wedge!^A(Bd)(^GB)" "d4c/d/e/c/" "(=cB)c3b" 
 "e3/=g/f3/a/ g2" "e3/a/ f3/a/ e3/a/" "A6" "A/B/c/d/ e/f/g/e/ f2" "ef d4" "[e4g4][df][ce]" "A6" "z!wedge!B(^de)(gb)" 
 "ae{f/}ed{e/}dc" "(3e^ga A2z2" "d6" "d/A/B/c/ d/e/f/g/ a2" "(3ea^g (3fed (3cBA" "A2 !trill!=GF!trill!ED" "^G3/B/ e3/B/ ^g3/e/" "(A2A/)B/c/d/ e/f/g/a/" 
 "z!wedge!B(^de)(gb)" "Aa=gfe^d" "f/e/^d/e/ B4" "d4bd" "z2 (3fag (3fed" "!trill!a3/g/4a/4 b3/g/ f2" "(3eBe (3geg b2" "e/d/c/d/ B2 z2" 
 "f/e/g/e/ d2c2" "z!wedge!F(^AB)(df)" "(3Ace =g3/e/ f3/d/" "d2 e/d/e/f/ d2" "B/^d/e/g/ b2c2" "Ggfedc" "d6" "(3afd A2d2" 
 "^GddccB" "zf{g/}fe{f/}ed" "e2f/e/f/a/ g2" "(d2c2)d2" "(Bd)!wedge!g!wedge!ba2" "B2(3bag (3fed" "c/B/d/B/ A2^G2" "(3Gge (3ceG F2" 
 "(3dcd (3b^ge (3bgd" "cgfe {e/}dc/d/" "d2 !trill!e3/d/4e/4 f2" "d3/A/G3/A/ F2" "a2a2 g/f/e/d/" "!wedge!d!wedge!A!wedge!G!wedge!F!wedge!E!wedge!D" "aAgG f2" "z!wedge!A(cd)(fa)" 
 "E3/A/ [A2c2][^G2B2]" "d6" "g2 {a/}gf/e/ {g/}fe/d/" "d6" "(B/e/)!wedge!g/!wedge!e/ [f2a2][E2c2]" "z d!trill!dc!trill!cB" "e/d/c/d/ A4" "f=g e4" )

#----------------------------------------------------------------------------------
# define notesF, array of 176 possible bass clef notes minuets
#----------------------------------------------------------------------------------
notesF=( "[F,2F,,2][G,2G,,2][A,2A,,2]" "z2 E,2A,2 & C,6" "D,2F,A,D2" "[G,2G,,2][F,2F,,2][E,2E,,2]" "A,,C,E,A,A,,2" "[B,2B,,2][G,2G,,2][F,2F,,2]" "z2 [E2C2][E2C2]" "z D,A,,F,,D,,2" 
"F,FE,ED,D" "[E,2E,,2][C,2C,,2][D,2D,,2]" "D2E2E,2" "G,,2G,2 z2" "z2 A,2D2" " D,2A,,2D,,2" "z2 [E2C2G,2][E2C2G,2]" "(3^D,F,B, (3D,F,B, (3D,F,B," 
"z2 A,4  & z2 G,2F,2" "z2 (3 F,A,D (3 F,A,D" "z2 A,2A,2 & z2G,2G,2" "z2 E,F, G,2" "D,2E,2E,,2" " [E,2E,,2][C2C,2][D2D,2]" "G,2A,2A,,2" "A,2 E,3/C,/ A,,2" 
"[F,2F,,2]z2[B,2B,,2]" "z2[G,2G,,2][A,2A,,2]" "[G,2G,,2][B,2B,,2][G,2G,,2]" "D,2D2z2" "z2 D,E,F,2" "A,2E,2A,,2" "z _B,A,G,F,E," "A,2G,2F,2 & D,6" 
"zA,E,C, A,,2" "A,6 & F,2G,2F,2" "[A,2A,,2]z2[B,2B,,2]" "A,4^G,2 & D,2E,4" "[C2C,2][A,2A,,2]z2" "F,DE,CD,D" "[^G,E,]z [A,F,]z [B,G,]z" "(3D,F,A, (3D,F,A, (3D,F,A," 
"(3A,,E,A, (3A,,E,A, (3A,,E,A," "[G,2G,,2][E,2E,,2][F,2F,,2]" "G,2E,2F,2 & D,4D,2" "z2 A,,A,A,,A," "A,,2E,2A,2" "[A,2A,,2]C,4" "z2[^G,2^G,,2][A,2A,,2]" "(3C,E,A, (3C,E,A, (3C,E,A," 
"z2G2F2" "z2G2F2 &  A,4D2" "[G,G,,]2[B,B,,]2[G,G,,]2" "z2F2E2 & G,2A,4" "z2G2F2 & A,4D2" "[D,D,,]2[F,F,,]2[A,A,,]2" "[A,A,,]2z2z2" "z2[CA,]2[DD,]2" 
"[E,E,,]2z2[A,A,,]2" " z2[CA,]2[DB,]2" "[F,F,,]2[E,E,,]2[D,D,,]2" "C,2A,,2D,2" "z2A,,2D,2" "[CC,]2[DD,]2[EE,]2" "A,2E,2A,,2" "(3C,E,A, (3C,E,A, (3C,E,A," 
"z2[F^DA,]2[FDA,]2" "z2B,2B,2&z2A,2A,2" "(3G,B,D (3G,B,D (3G,B,D" "z2[B,^G,D,]2[A,E,C,]2" "D,A,F,A,D,A," "zB,,^D,F,B,B,," "=G,GF,FE,E" "G,2A,2A,,2" 
"[B,,4B,4][G,,2G,2]" "[G,,4G,4][F,,2F,2]" "[D,,2D,2][F,,2F,2]z2" "G, z E, z C, z" "=G,B,A,G,F,E," "D,2 F,3/A,/ D2" "z D,F,A, D2" "B,2 z2 E2 & ^G,6" 
"A,,2E,2A,2" "[D,F,]z [G,E,]z [A,F,]z" "D,F,A,D D,2" "z2A,2D2" "A,2E,2A,,2" "[B,2B,,2][^G,2^G,,2][A,2A,,2]" "(3C,E,A, (3C,E,A, (3D,F,A," "B,6 & =G,2A,2G,2" 
"[G,,4G,4][A,,2A,2]" "(3D,F,A, (3D,F,A, (3B,,F,B," "A,,A,E,C, A,,2" "[F,,2F,2][C,,2C,2][D,,2D,2]" "D,2 F,A, D2" "A,2 E,C, A,,2" "[F,,2F,2][C,,2C,2][D,,2D,2]" "[A,,2A,2][F,,2F,2][D,,2D,2]" 
"[C,2C2]z2z2" "[D,,2D,2][F,2A,2][F,2A,2]" "(3D,F,B, (3D,F,B, (3D,F,B," "A,E,C,E, A,,2" "[G,,2G,2]z2z2" "D,A,F,A,B,,B," "[A,,2A,2][B,,2B,2][C,2C2]" "[^D,,2D,2][F,,2F,2]z2" 
"z2 (3E,^G,B, (3E,G,B," "D,2E,4 & A,4^G,2" "zA,E,C,A,,2" "zA,,C,E,A,A,," "[G,,2G,2]A,2A,,2" "z2 C,2 D,3/F,/" "D,DA,F, D,2" "B,DB,DG,D" 
"[C,,2C,2][D,,2D,2]z2" "[F,,2F,2][G,,2G,2]z2" "[F,,2F,2][D,,2D,2]zF," "z2F2E2 & G,2A,4" "z=CB,A,=G,F," "[D,,4D,4][E,,2E,2]" "[D,,2D,2][F,,2F,2][A,,2A,2]" "z2 [^D2F2][D2F2]" 
"[G,,2=G,2][^D,,2^D,2][E,,2E,2]" "[C,2C2][D,2D2][C,2C2]" "A,2E,2A,,2" "z2[C,2C2][D,2D2]" "(3D,F,A, (3D,F,A, (3D,F,A," "A,,A,C,A,A,,A," "A,A,,C,E,A,2" "[G,,4G,4][E,,2E,2]" 
"[C,2C2][B,,2B,2][A,,2A,2]" "z2[C2E2][C2E2]" "D,A,,F,,A,, D,,2" "[F,,2F,2]z2z2" "[C,2C2]z2z2" "A,2 =G,F,E,D," "z2[D,2^G,2B,2][D,2^G,2B,2]" "z2[G,2C2E2][F,2A,2D2]" 
"z2B,2E2 & G,6" "z2[A,2C2][A,2C2]" "z2 (3=G,B,E (3G,B,E" "^G,EB,EG,E" "(3FAd z2z2" "C,A,E,A,D,A," "[A,,2=G,2]z2z2" "z2(3G,B,D (3G,B,D" "z2F2E2 & G,2A,4" 
"z2F,2B,2 & D,6" "z2[C,2C2][D,2D2]" "[D2F2][A,2G2][D2F2]" "[G,,4G,4][A,,2A,2]" "z2[G,2_B,][G,2B,]" "D,2A,,3/F,,/D,,2" "z2[F,,2F,2][D,,2D,2]" "z2 [B,2D2][B,2D2]" "[D,2D2][C,2C2][B,,2B,2]" 
"z2[B,2^D2][E,2E2]" "F2E2D2 & A,4D,2" "[G,,4G,4][F,,2F,2]" "G,2G,,2z2" "D2C2B,2 & D,2E,4" "z2[A,2E2][B,2D2]" 
"[B,,2B,2][^G,,2^G,2][E,,2E,2]" "[A,,4A,4][B,,2B,2]" "F,A,C,A,D,A," "[F,,2F,2][E,,2E,2][D,,2D,2]" "D,A,F,A,D,A," "!wedge!F,!wedge!A,!wedge!G,!wedge!F,!wedge!E,!wedge!E," "[F,,2F,2][E,,2E,2][D,,2D,2]" "z2A,2D2 & F,6" 
"z2E,2E,,2" "D,2A,2D2" "[B,,2B,2][C,2C2][D,2D2]" "D,2 A,,3/F,,/ D,,2" "[G,,2G,2]z2[A,,2A,2]" "[B,,2B,2][A,,2A,2][G,,2G,2]" "z2(3F,A,D (3F,A,D" "(3E,=G,B, (3E,G,B, (3E,G,B," )

#----------------------------------------------------------------------------------
# define notesGT, array of 96 possible measures treble clef notes for the trios
#----------------------------------------------------------------------------------
notesGT=( "(3c^AB B2z2" "^d/e/g/e/ =d2!trill!^c2" "(3ece !wedge!g!wedge!g (3gec" "(^ce)(ge)(ce)" "[=Fd][Ec][Ec]4" "{g}fe/d/d2 z2" "[df][fa][fa]4" "(3afd c2c2" 
"(3de=f (3Bcd (3GAB" "G6" "d/e/=f/g/ {g}fe/d/ {e}dc/B/" "(3=caf !wedge!c!wedge!c (3dcA" "d6" "G4c2 & ^c4ge" "(3Bbg (3fad (3ge^c" "(3afg (3agf (3edc" 
"(3dAf !wedge!a!wedge!a (3afd" "(gf)(gb)(dg)" "{f}ed/c/ [GB]2[FA]2" "(3Bce G2 z2" "G6" "B2c2d2" "(3Bdg !wedge!f!wedge!f (3gbd" "e/f/g/f/ {a}gf/e/ {f}ed/^c/" 
"d2{d/}cB/c/ B2" "B3/g/ [df]2[^ce]2" "(3dfa f2 df" "(3aAB !wedge!c!wedge!c (3dcA" "[Aa]2[Bb]2^c2" "=c2z2ac" "G6" "(3^cec !wedge!g!wedge!g (3gec" 
"e/B/c/A/ G2!trill!A2" "c2!trill!d2e2" "(3Bcd (3efg (3de=f" "[d=f]4[=Fd]2" "(3^cAc !wedge!e!wedge!e (3aec" "BABd G2" "(3dcA F2z2" "d3ed3/g/" 
"f/g/a/f/ d/e/f/d/ A/B/^c/d/" "[ca]2[Ac]2[Ac]2" "(3dAe (3fdg (3afd" "(3Bbg !wedge!e!wedge!e (3ge^c" "cBce g2" "[eg]4[Ge]2" "(3edc (3Bcd (3FGA" "d2e2f2" 
"c2d2e2" "(3egc (3BdG (3cAF" "z2 D/F/A/c/ d/c/B/A/" "egBd^ce" "(3BGB !wedge!d!wedge!d (3dBG" "(3dcA F2 (3dcA" "d[Aa]2[Gg]2[Ff]" "[Bg]6" 
"(=c2c/)e/d/c/ a/f/d/c/" "(3Bcd (3cde (3de=f" "A2B2c2" "B/d/g/d/ b/a/g/f/ e/d/c/B/" "d6" "afc'afc" "(3BdB !wedge!=f!wedge!f (3fdB" "(3age ^c2c2" 
"(3A^ce gedc" "G6" "d3dc2" "[F^A][GB][GB]2 z2" "(3agf (3ed^c (3de=c" "d6" "d6" "(d2d)e fg" 
"(3=cBA (3GFE D3/c/" "[Ac][GB][GB]4" "(3DGB d2d2" "(3g=fd B2B2" "e3 ^f d2" "e/c/B/A/ G2F2" "[Ge][Fd][Fd]4" "d6" 
"A2g2{a}gf/e/" "[ce]6" "(3dBd !wedge!g!wedge!g (3gdB" "(3cdf A2z2" "(3cec !wedge!g!wedge!g (3gec" "d/^c/d/A/ e/d/e/A/ f2" "(^AB)zedg" "G6" 
"(3Bge d2^c2" "(3ecA G2F2" "G6" "c/B/c/G/ d/c/d/G/ e2" "(3efg (3^cde (3ABc" "d6" "Bdegdg" "(3dfd !wedge!a!wedge!a (3!wedge!afd" )

#----------------------------------------------------------------------------------
# define notesFT, array of 96 possible measures bass clef notes for the trios
#----------------------------------------------------------------------------------
notesFT=( "z2[G,B,]2[G,B,]2" "z2F2E2 & G,2A,4" "C2C,2z2" "(E,G,)(E,G,)(E,G,)" "zC,E,G,CC," "(3A,CD (3A,CD (3A,CD" "zD,F,A,DD," "z2[F,D]2[F,D]2" 
"[=F,,=F,]2z2[G,,G,]2" "G,2D,2G,,2" "[=F,,=F,]2z2[G,,G,]2" "[F,A,]2z2[F,D]2" "D2A,2D,2" "zA,,^C,E,A,A,," "G,2A,2A,,2" "[F,D]2z2[F,D]2" 
"[F,D]2[F,D]2z2" "(B,D)(B,D)(B,D)" "C2D2D,2" "z2[CE]2[CE]2" "zG,D,B,, G,,2" "D,G,,E,G,,=F,G,," "G,2[A,C]2[B,D]2" "[G,,G,]2z2[A,,A,]2" 
"B,D,A,D,G,D," "G,2A,2A,,2" "F,A,F,A,F,A," "[F,D]2z2[F,D]2" "F,DE,DE,G," "zE,G,CF,D" "G,2D,2G,,2" "[A,,A,]2z2[A,,A,]2" 
"C2B,2C2 & C,2D,4" "(3E,=F,G, (3B,,D,G, (3C,E,G," "G,2z2[B,,B,]2" "zG,,B,,D,G,G,," "[G,E]2[G,E]2z2" "z2 [G,B,]2[G,B,]2" "z2[D,A,C]2[D,A,C]2" "z2B,2G,2" 
"[D,D,]2[F,,F,]2z2" "zF,A,DF,D" "[F,,F,]2z2z2" "[G,,G,]2z2[A,,A,]2" "E,G,E,G,E,G," "zA,,^C,E,A,A,," "C2D2D,2" "(3F,G,A, (3^C,E,A, (3D,F,A," 
"E,A,,F,A,,G,A,," "C2D2D,2" "D,/F,/A,/C/ z2[F,,F,]2" "[G,,G,]4[A,,A,]2" "G,2G,,2z2" "z2[D,A,C]2[D,A,C]2" "[F,,F,]2[^C,,^C,]2[D,,D,]2" "zG,,B,,D,G,G,," 
"z2[E,G,]2[F,A,]2" "[G,,G,]2[E,,E,]2B,,2" "F,D,G,D,A,D," "[G,,G,]4G,2" "D2A,F,D,2" "F,DF,DF,D" "[G,,G,]2z2[G,,G,]2" "z2[A,EG]2[A,EG]2" 
"z2[E,G,]2[E,G,]2" "G,2D,2G,,2" "=F,G,,F,G,,E,G,," "zG,D,B,,G,,G," "[F,D]2z2[F,D]2" "D2A,F,D,2" "D2A,F,D,2" "(3G,B,D (3G,B,D (3G,B,D" 
"[A,,A,]2z2z2" "zG,,B,,D,G,G,," "z2[G,B,]2[G,B,]2" "z2[G,D=F]2[G,D=F]2" "G,A,,G,A,,F,A,," "C2B,2A,2 & C,2D,4" "zD,F,A,DD," "D,2A,2D2" 
"^C,A,E,A,C,A," "zC,E,G,CC," "[G,B,]2z2[G,B,]2" "z2[DF]2[DF]2" "[E,,E,]2[C,,C,]2z2" "[F,,F,]2[^C,,^C,]2[D,,D,]2" "G,2[C,C]2[B,,B,]2" "G,2D,B,,G,,2" 
"z2F2E2 & G,2A,4" "C2B,2A,2 & C,2D,4" "G,2D,2G,,2" "[E,,E,]2[B,,,B,,]2[C,,C,]2" "[G,,G,]2z2[A,,A,]2" "D,2 A,,F,, D,,2" "G,2C2B,2" "[F,,F,]2[D,,D,]2z2" )

#----------------------------------------------------------------------------------
# create cat-to-output-file function
#----------------------------------------------------------------------------------
catToFile(){
	cat >> $filen << EOT
$1
EOT
}

#----------------------------------------------------------------------------------
# create empty ABC file
# set header info: generic index number, filename
# Total MDGs: 129,629,238,163,050,258,624,287,932,416	= (11^16)(6^16)
# Unique MDGs: 35,710,533,929,214,947,279,418,163,200	= (11^14)*(10^2)*(6^14*4*3)
# meas#/same for tosses: VIII/2=10; XVI/7=8; XXIV/2=4=5; XXXII/3=4=5=6 
#----------------------------------------------------------------------------------
fileInd=$1-$2-$3-$4-$5-$6-$7-$8-$9-${10}-${11}-${12}-${13}-${14}-${15}-${16}
fileInd2=${17}-${18}-${19}-${20}-${21}-${22}-${23}-${24}-${25}-${26}-${27}-${28}-${29}-${30}-${31}-${32}
filen="gfmt-$fileInd-$fileInd2.abc"
if [ "${diceS[7]}" = "10" ]; then diceS[7]=2; fi
if [ "${diceS[7]}" = "11" ]; then diceS[7]=10; fi
if [ "${diceS[7]}" = "12" ]; then diceS[7]=11; fi
if [ "${diceS[15]}" = "8" ]; then diceS[15]=7; fi
if [ "${diceS[15]}" = "9" ]; then diceS[15]=8; fi
if [ "${diceS[15]}" = "10" ]; then diceS[15]=9; fi
if [ "${diceS[15]}" = "11" ]; then diceS[15]=10; fi
if [ "${diceS[15]}" = "12" ]; then diceS[15]=11; fi
if [ "${diceS[23]}" = "4" -o "${diceS[23]}" = "5" ]; then diceS[23]=2; fi
if [ "${diceS[23]}" = "6" ]; then diceS[23]=4; fi
if [ "${diceS[31]}" = "4" -o "${diceS[31]}" = "5" -o "${diceS[31]}" = "6" ]; then diceS[31]=3; fi
#dbNum=$(( ${diceS[0]}-1 + (${diceS[1]}-2)*11 + (${diceS[2]}-2)*11**2 + (${diceS[3]}-2)*11**3 + (${diceS[4]}-2)*11**4 + (${diceS[5]}-2)*11**5 + (${diceS[6]}-2)*11**6 + (${diceS[7]}-2)*11**7 + (${diceS[8]}-2)*10*11**7 + (${diceS[9]}-2)*10*11**8 + (${diceS[10]}-2)*10*11**9 + (${diceS[11]}-2)*10*11**10 + (${diceS[12]}-2)*10*11**11 + (${diceS[13]}-2)*10*11**12 + (${diceS[14]}-2)*10*11**13 + (${diceS[15]}-2)*10*11**14 + (${diceS[16]}-1)*10*10*11**14 + (${diceS[17]}-1)*6*10*10*11**14 + (${diceS[18]}-1)*6**2*10*10*11**14 + (${diceS[19]}-1)*6**3*10*10*11**14 + (${diceS[20]}-1)*6**4*10*10*11**14 + (${diceS[21]}-1)*6**5*10*10*11**14 + (${diceS[22]}-1)*6**6*10*10*11**14 + (${diceS[23]}-1)*6**7*10*10*11**14 + (${diceS[24]}-1)*4*6**7*10*10*11**14 + (${diceS[25]}-1)*4*6**8*10*10*11**14 + (${diceS[26]}-1)*4*6**9*10*10*11**14 + (${diceS[27]}-1)*4*6**10*10*10*11**14 + (${diceS[28]}-1)*4*6**11*10*10*11**14 + (${diceS[29]}-1)*4*6**12*10*10*11**14 + (${diceS[30]}-1)*4*6**13*10*10*11**14 + (${diceS[31]}-1)*4*6**14*10*10*11**14 ))
#echo "${diceS[0]}-1 + (${diceS[1]}-2)*11 + (${diceS[2]}-2)*11**2 + (${diceS[3]}-2)*11**3 + (${diceS[4]}-2)*11**4 + (${diceS[5]}-2)*11**5 + (${diceS[6]}-2)*11**6 + (${diceS[7]}-2)*11**7 + (${diceS[8]}-2)*10*11**7 + (${diceS[9]}-2)*10*11**8 + (${diceS[10]}-2)*10*11**9 + (${diceS[11]}-2)*10*11**10 + (${diceS[12]}-2)*10*11**11 + (${diceS[13]}-2)*10*11**12 + (${diceS[14]}-2)*10*11**13 + (${diceS[15]}-2)*10*11**14 + (${diceS[16]}-1)*10*10*11**14 + (${diceS[17]}-1)*6*10*10*11**14 + (${diceS[18]}-1)*6**2*10*10*11**14 + (${diceS[19]}-1)*6**3*10*10*11**14 + (${diceS[20]}-1)*6**4*10*10*11**14 + (${diceS[21]}-1)*6**5*10*10*11**14 + (${diceS[22]}-1)*6**6*10*10*11**14 + (${diceS[23]}-1)*6**7*10*10*11**14 + (${diceS[24]}-1)*4*6**7*10*10*11**14 + (${diceS[25]}-1)*4*6**8*10*10*11**14 + (${diceS[26]}-1)*4*6**9*10*10*11**14 + (${diceS[27]}-1)*4*6**10*10*10*11**14 + (${diceS[28]}-1)*4*6**11*10*10*11**14 + (${diceS[29]}-1)*4*6**12*10*10*11**14 + (${diceS[30]}-1)*4*6**13*10*10*11**14 + (${diceS[31]}-1)*4*6**14*10*10*11**14"

# Use maxima for calculation
cat > /tmp/001.mac << EOF
with_stdout("/tmp/001.txt",print(${diceS[0]}-1 + (${diceS[1]}-2)*11 + (${diceS[2]}-2)*11**2 + (${diceS[3]}-2)*11**3 + (${diceS[4]}-2)*11**4 + (${diceS[5]}-2)*11**5 + (${diceS[6]}-2)*11**6 + (${diceS[7]}-2)*11**7 + (${diceS[8]}-2)*10*11**7 + (${diceS[9]}-2)*10*11**8 + (${diceS[10]}-2)*10*11**9 + (${diceS[11]}-2)*10*11**10 + (${diceS[12]}-2)*10*11**11 + (${diceS[13]}-2)*10*11**12 + (${diceS[14]}-2)*10*11**13 + (${diceS[15]}-2)*10*11**14 + (${diceS[16]}-1)*10*10*11**14 + (${diceS[17]}-1)*6*10*10*11**14 + (${diceS[18]}-1)*6**2*10*10*11**14 + (${diceS[19]}-1)*6**3*10*10*11**14 + (${diceS[20]}-1)*6**4*10*10*11**14 + (${diceS[21]}-1)*6**5*10*10*11**14 + (${diceS[22]}-1)*6**6*10*10*11**14 + (${diceS[23]}-1)*6**7*10*10*11**14 + (${diceS[24]}-1)*4*6**7*10*10*11**14 + (${diceS[25]}-1)*4*6**8*10*10*11**14 + (${diceS[26]}-1)*4*6**9*10*10*11**14 + (${diceS[27]}-1)*4*6**10*10*10*11**14 + (${diceS[28]}-1)*4*6**11*10*10*11**14 + (${diceS[29]}-1)*4*6**12*10*10*11**14 + (${diceS[30]}-1)*4*6**13*10*10*11**14 + (${diceS[31]}-1)*4*6**14*10*10*11**14))$
printfile("/tmp/001.txt")$
quit();
EOF
/usr/local/bin/maxima < /tmp/001.mac >/dev/null
dbNum=`cat /tmp/001.txt`

# restore original toss values
diceS[7]=$8; diceS[15]=$16; diceS[23]=$24; diceS[31]=$32 

#----------------------------------------------------------------------------------
# calculate the measure numbers for the current dice tosses; 
# from (11**16)(6**16) possibilities; (11**14)*(10^2)*(6**14*4*3) unique MDGs
#----------------------------------------------------------------------------------
currMeas=0
for measj in ${diceS[*]} ; do
	currMeas=`expr $currMeas + 1`
	if [ "$currMeas" -lt "17" ]; then
		ruletab $measj
		measPerm="$measPerm${measNR[$currMeas-1]}:"
	else
		ruletabT $measj
		measPerm="$measPerm${measNR[$currMeas-17]}:"
	fi
done
measPerm="$measPerm:"

#----------------------------------------------------------------------------------
# if output abc file already exists, then make a back-up copy
#----------------------------------------------------------------------------------
if [ -f $filen ]; then 
	mv $filen $filen."bak"
fi


#----------------------------------------------------------------------------------
# generate the header of the ABC file
#----------------------------------------------------------------------------------
catToFile "%%scale 0.65
%%pagewidth 21.082cm
%%bgcolor white
%%topspace 0
%%composerspace 0
%%leftmargin 0.254cm
%%rightmargin 0.254cm
X:$dbNum
T:${fileInd}-${fileInd2}
%%setfont-1 Courier-Bold 12
T:\$1gfmt::$measPerm\$0
T:\$1Perm. No.: $dbNum\$0
M:3/4
L:1/8
Q:1/4=90
%%staves [1 2]
V:1 clef=treble
V:2 clef=bass
K:D"

#----------------------------------------------------------------------------------
# write the notes of the ABC file
#----------------------------------------------------------------------------------
currMeas=0
for measj in ${diceS[*]} ; do
	currMeas=`expr $currMeas + 1`
	if [ "$currMeas" -lt "17" ]; then 
		ruletab $measj
		measN=${measNR[$currMeas-1]}
		phrG=${notesG[$measN-1]}
		phrF=${notesF[$measN-1]}
	else
		ruletabT $measj
		measN=${measNR[$currMeas-17]}
		phrG=${notesGT[$measN-1]}
		phrF=${notesFT[$measN-1]}
	fi
	if [ "${currMeas}" == "1" ]; then
		catToFile "%1
[V:1]|: $phrG |\\
[V:2]|: $phrF |\\"
		continue
	elif [ "$currMeas" == "8" ] || [ "$currMeas" == "16" ] || [ "$currMeas" == "24" ]; then
		catToFile "%8,16,24 returns
[V:1] $phrG ::
[V:2] $phrF ::"
		continue
	elif [ "$currMeas" == "17" ]; then
		catToFile "%17 key change
[V:1] [K:G] $phrG|\\
[V:2] [K:G] $phrF|\\"
		continue
	elif [ "$currMeas" == "32" ]; then
		catToFile "%32
[V:1] $phrG :|]
[V:2] $phrF :|]"
		continue
	else
		catToFile "%$currMeas 2-7,9-15,18-23,25-31
[V:1] $phrG |\\
[V:2] $phrF |\\"
	fi
done

# create SVG
abcm2ps ./$filen -O ./"gfmt-$fileInd-$fileInd2.svg" -g 

# create MIDI
abc2midi ./$filen -quiet -silent -o ./"gfmt-$fileInd-$fileInd2.mid"
#
##
###
