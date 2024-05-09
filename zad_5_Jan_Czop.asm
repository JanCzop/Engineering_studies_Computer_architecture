.data

podajZnakString: .asciiz "Podaj znak uzywany podczas gry przez gracza:(tylko o lub x)\n"
podajLiczbeRundString: .asciiz "Podaj ilosc rund: (tylko zakres 1-5)\n"
podajKomorkeString: .asciiz "\nPodaj komorke do zaznaczenia(tylko zakres 1-9)\n"
#komputerGraZnakString: .asciiz "\nKomputer gra "
gramyString: .asciiz "Wszystko przygotowane, gramy!\n"
ruchKomputeraString: .asciiz "\nKomputer wybiera komorke "
test: .asciiz "\ntest\n"
spaceString: .asciiz " "
newLineString: .asciiz "\n"
graczWygralString: .asciiz "Gracz wygral\n"
komputerWygralString: .asciiz "Komputer wygral\n"
rezultatString: .asciiz "Runda nr "
remisString: .asciiz "Remis\n"
wynikiString: .asciiz "\n\n\n\n Wyniki:\n\n"
gameArray: .space 9
resultsArray: .space 5

znakGraczaChar: .byte ' '
znakKomputeraChar: .byte ' '
iloscRundInt: .word 0

.text


main:
j podajRundy

# s6 - licznik rund
# s5 - max rund
podajRundy:
li $v0, 4
la $a0, podajLiczbeRundString
syscall
li $v0, 5
syscall
move $s5, $v0
bgt $s5, 5, podajRundy
blt $s5, 1, podajRundy
li $s6, 0
j progres0

progres0:
beq $s5, $s6, rezultaty
jal podajZnak
sb $t0, znakGraczaChar
la $t1, znakGraczaChar
lb $t2, ($t1)
j komputerOX


# t9 znak pomocniczy
podajZnak:
li $v0, 4
la $a0, podajZnakString
syscall
li $v0, 12
syscall
move $t0, $v0
#li $v0, 11
#move $a0, $t0
#syscall
add $t9, $zero, 0
beq $t0, 'x', znakPoprawny
beq $t0, 'o', znakPoprawny
beq $t9, 0, podajZnak
jr $ra

znakPoprawny:
add $t9, $t9, 1
jr $ra

komputerOX:
beq $t2, 'x', komputerO
beq $t2, 'o', komputerX
jr $ra

komputerO:
li $v0, 'o'
move $t0, $v0
sb $t0, znakKomputeraChar
j progres1

komputerX:
li $v0, 'x'
move $t0, $v0
sb $t0, znakKomputeraChar
j progres1

progres1:

la $t1, znakKomputeraChar
lb $t2, ($t1)
#li $v0, 11
#move $a0, $t2
#syscall
j przygotujGre

przygotujGre:
li $t1, 1
li $s0, 1
la $t7, znakGraczaChar
lb $s3, ($t7)
la $t7, znakKomputeraChar
lb $s4, ($t7)
li $t2, 0
jal fillArray
j runda


fillArray:
li $t0, '-'
sb $t0, gameArray($t1)
add $t1, $t1, 1
bne $t1, 10, fillArray
jr $ra

# s0 - 1 jesli runda toczy sie dalej 0 jesli koniec
# s3 - znak gracza
# s4 - znak komputera
# t2 - zajmowana komorka
# t3 - znak z tablicy o indeksie t2
# t6 - przed chwila byl: 0 ruch gracza , 1 ruch komputera


runda:
j ruchGracza

ruchGracza:
li $t6, 0
li $v0, 4
la $a0, podajKomorkeString
syscall
li $v0, 5
syscall
move $t2, $v0
bgt $t2, 9, ruchGracza
blt $t2, 1, ruchGracza
lb $t3, gameArray($t2)
bne $t3, '-', ruchGracza
j wpisTabG



wpisTabG:
sb $s3, gameArray($t2)
j printGame




printGame:
li $v0, 4
la $a0, newLineString
syscall
add $t1, $zero, 1
add $t4, $zero, 1
jal printArray



printArray:
lb $t0, gameArray($t1)
add $t1, $t1, 1
li $v0, 11
move $a0, $t0
syscall
bne $t1, 10, printArray
j wiersz0



wiersz0:
add $t4, $zero, 1
lb $t0, gameArray($t4)
add $t4, $t4, 1
lb $t1, gameArray($t4)
add $t4, $t4, 1
lb $t2, gameArray($t4)
bne $t0, $t1, wiersz1
bne $t1, $t2, wiersz1
beq $t1, '-', wiersz1
j wygrana

wiersz1:
add $t4, $zero, 4
lb $t0, gameArray($t4)
add $t4, $t4, 1
lb $t1, gameArray($t4)
add $t4, $t4, 1
lb $t2, gameArray($t4)
bne $t0, $t1, wiersz2
bne $t1, $t2, wiersz2
beq $t1, '-', wiersz2
j wygrana

wiersz2:
add $t4, $zero, 7
lb $t0, gameArray($t4)
add $t4, $t4, 1
lb $t1, gameArray($t4)
add $t4, $t4, 1
lb $t2, gameArray($t4)
bne $t0, $t1, kolumna0
bne $t1, $t2, kolumna0
beq $t1, '-', kolumna0
j wygrana

kolumna0:
add $t4, $zero, 1
lb $t0, gameArray($t4)
add $t4, $t4, 3
lb $t1, gameArray($t4)
add $t4, $t4, 3
lb $t2, gameArray($t4)
bne $t0, $t1, kolumna1
bne $t1, $t2, kolumna1
beq $t1, '-', kolumna1
j wygrana

kolumna1:
add $t4, $zero, 2
lb $t0, gameArray($t4)
add $t4, $t4, 3
lb $t1, gameArray($t4)
add $t4, $t4, 3
lb $t2, gameArray($t4)
bne $t0, $t1, kolumna2
bne $t1, $t2, kolumna2
beq $t1, '-', kolumna2
j wygrana

kolumna2:
add $t4, $zero, 3
lb $t0, gameArray($t4)
add $t4, $t4, 3
lb $t1, gameArray($t4)
add $t4, $t4, 3
lb $t2, gameArray($t4)
bne $t0, $t1, diagonal0
bne $t1, $t2, diagonal0
beq $t1, '-', diagonal0
j wygrana

diagonal0:
add $t4, $zero, 1
lb $t0, gameArray($t4)
add $t4, $t4, 4
lb $t1, gameArray($t4)
add $t4, $t4, 4
lb $t2, gameArray($t4)
bne $t0, $t1, diagonal1
bne $t1, $t2, diagonal1
beq $t1, '-', diagonal1
j wygrana

diagonal1:
add $t4, $zero, 3
lb $t0, gameArray($t4)
add $t4, $t4, 2
lb $t1, gameArray($t4)
add $t4, $t4, 2
lb $t2, gameArray($t4)
bne $t0, $t1, kogoRuch
bne $t1, $t2, kogoRuch
beq $t1, '-', kogoRuch
j wygrana

kogoRuch:
beq $t6, 0, ruchKomputera
beq $t6, 1, ruchGracza

ruchKomputera:
li $t6, 1
j kSrodek

kSrodek:
li $t0, 5
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 2
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 4
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 6
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 8
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 1
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 3
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 7
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
li $t0, 9
lb $t1, gameArray($t0)
beq $t1, '-', kWstaw
j remis


kWstaw:
li $v0, 4
la $a0, ruchKomputeraString
syscall
li $v0, 1
move $a0, $t0
syscall
sb $s4, gameArray($t0)
j printGame

wygrana:
beq $t0, $s4, komputerWygral
beq $t0, $s3, graczWygral

remis:
li $v0, 4
la $a0, newLineString
syscall
li $v0, 4
la $a0, remisString
syscall
add $s6, $s6, 1
li $t0, 0
sb $t0, resultsArray($s6)
j progres0

graczWygral:
li $v0, 4
la $a0, newLineString
syscall
li $v0, 4
la $a0, graczWygralString
syscall
add $s6, $s6, 1
li $t0, 1
sb $t0, resultsArray($s6)
j progres0

komputerWygral:
li $v0, 4
la $a0, newLineString
syscall
li $v0, 4
la $a0, komputerWygralString
syscall
add $s6, $s6, 1
li $t0, -1
sb $t0, resultsArray($s6)
j progres0

rezultaty:
li $s6, 0
li $v0, 4
la $a0, wynikiString
syscall


rezultatyLoop:
beq $s6, $s5, exit
add $s6, $s6, 1
lb $t0, resultsArray($s6)
li $v0, 4
la $a0, rezultatString
syscall
li $v0, 1
move $a0, $s6
syscall
beq $t0, -1, drukujWK
beq $t0, 1, drukujWG
beq $t0, 0, drukujR


drukujWK:
li $v0, 4
la $a0, spaceString
syscall
li $v0, 4
la $a0, komputerWygralString
syscall
li $v0, 4
la $a0, newLineString
syscall
j rezultatyLoop

drukujWG:
li $v0, 4
la $a0, spaceString
syscall
li $v0, 4
la $a0, graczWygralString
syscall
li $v0, 4
la $a0, newLineString
syscall
j rezultatyLoop

drukujR:
li $v0, 4
la $a0, spaceString
syscall
li $v0, 4
la $a0, remisString
syscall
li $v0, 4
la $a0, newLineString
syscall
j rezultatyLoop

exit:
li $v0, 10
syscall

