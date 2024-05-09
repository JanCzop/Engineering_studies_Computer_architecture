.data

smallNumber: .float 0.000000000000000000001
startString: .asciiz "Funkcja e^x\nPodaj x:\n"
resultString1: .asciiz "Wynik funkcji e^"
resultString1M: .asciiz "Wynik funkcji e^-"
resultString2: .asciiz "= "
minusString: .asciiz "-"

x: .float 0.0
n: .float 1.0
floatZero: .float 0.0
floatOne: .float 1.0
newLineString: .asciiz "\n"

.text

main:
j menu


menu:
li $v0, 4
la $a0, startString
syscall
# pobranie floata - x
li $v0, 6
syscall
mov.s $f4, $f0
add $t3, $zero, 0
lwc1 $f8, floatZero
# jesli jest mniejszy od zera ustawia rejestr t3 ktory wskazuje czy jest to ujemny x
c.lt.s $f4, $f8 
bc1t ifNegative
# przygotowanie zmiennych (malego skladnika, jedynki, aktualnego skladnika itd.)
swc1 $f4, x
lwc1 $f8, smallNumber
lwc1 $f6, n
add $t1, $zero, 1
mtc1 $t1, $f10
cvt.s.w $f10, $f10
mov.s $f16, $f4
j exp


# $t3 przechowuje czy jest negatywna
# poza ustawieniem t3 reszta jest taka sama co powyzej
ifNegative:
abs.s $f4, $f4
add $t3, $zero, 1
swc1 $f4, x
lwc1 $f8, smallNumber
lwc1 $f6, n
add $t1, $zero, 1
mtc1 $t1, $f10
cvt.s.w $f10, $f10
mov.s $f16, $f4
j exp


# obliczenia arytmetyczne funkcji e^x, dzieli przez aktualny n (potega w mianowniku), mnozy licznik przez x
exp:

div.s $f16, $f16, $f6
# jesli dojdziemy do "malej liczby" ograniczajacej nam wielkosc skladnika, konczymy tworzenie nowych
c.lt.s $f16, $f8
bc1t loadStackP
# dodajemy na stack skladnik
addi $sp, $sp, -4
swc1 $f16, ($sp)
mul.s $f16, $f16, $f4
add.s $f6, $f6, $f10
j exp


# przygotowuje zmienne potrzebne do odczytania floatow ze stacka
loadStackP:
add $t1, $zero, 0
mtc1 $t1, $f8
cvt.s.w $f8, $f8
add $t1, $zero, 1
mtc1 $t1, $f10
cvt.s.w $f10, $f10
mov.s $f16, $f10
j loadStack


# odczytujemy ze stacka poki nie bedzie pusty, dodajemy akualny wyciagniety skladnik do wyniku koncowego
loadStack:
lwc1 $f4, 0($sp)
addi $sp, $sp, 4
add.s $f16,$f16,$f4
c.eq.s $f6, $f8
bc1t results
sub.s $f6, $f6, $f10
j loadStack

# wybor ktory sprawdza czy x bylo ujemne
results:
la $t7, resultString1
beq $t3, 1, fixResults
j printResults

# jesli x jest ujemne wtedy wynik = 1/wynik
fixResults:
lwc1 $f4, floatOne,
div.s $f16, $f4, $f16
la $t7, resultString1M
j printResults

# wypisujemy rezultaty
printResults:
li $v0, 4
la $a0, newLineString
syscall
li $v0, 4
move $a0, $t7
syscall
li $v0, 2
lwc1 $f6, x
mov.s $f12, $f6
syscall
li $v0, 4
la $a0, resultString2
syscall
li $v0, 2
mov.s $f12, $f16
syscall
j exit


#printMinus:
#li $v0, 4
#la $a0, minusString
#syscall


exit:
li $v0, 10
syscall
