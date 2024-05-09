.data
stringGiven: .space 51
stringResult: .space 51
stringKey: .asciiz
newLineString: .asciiz "\n"
giveString: .asciiz "\nPodaj string (do 50 znakow)"
giveKey: .asciiz "Podaj klucz (do 8 znakow)"
giveTypeString: .asciiz "\nPodaj operacje:\n1)s jak szyfrowanie\n2)d jak deszyfrowanie\n"

.text

main:
j chooseType

#wybieramy typ szyfrowanie/lub deszyfrowanie jesli podamy cos zle to ponawaiamy
chooseType:
li $v0, 4
la $a0, giveTypeString
syscall
li $v0, 12
syscall
move $s0, $v0
beq $s0, 'd', giveStr
beq $s0, 's', giveStr
j chooseType

# tu podajemy string do szyfrowania
giveStr:
li $v0, 4
la $a0, giveString
syscall
li $v0, 4
la $a0, newLineString
syscall
li $v0, 8
la $a0, stringGiven
li $a1, 51
syscall
j giveK


# tu podajemy klucz, nastepnie oblicza sie dlugosc klucza
giveK:
li $v0, 4
la $a0, giveKey
syscall
li $v0, 4
la $a0, newLineString
syscall
li $v0, 8
la $a0, stringKey
li $a1, 9
syscall
j sLoad

# jesli deszyfrujemy musimy zmienic klucz
path:
beq $s0, 's', prep
beq $s0, 'd', prepD

prepD:
li $t0, 0
jal fixKey

# klucz zmieniamy poprzez 26-K
fixKey:
beq $t0, $t3, prep
li $t1, 220
lb $t2, stringKey($t0)
sub $t1, $t1, $t2
sb $t1, stringKey($t0)
add $t0, $t0, 1
j fixKey


# przygotowujemy liczniki
prep:

#li $v0, 4
#la $a0, stringKey
#syscall

li $t0, 0
li $t2, 0
j encrypt

# t0 jest licznikiem petli en/dekryptujacej
# t1 jest pojedynczym charem z stringu
# $t2 jest licznikiem klucza
# $t3 jest dlugoscia klucza

# $t5 jest rezultatem
# $t6 jest pojedynczym charem klucza


# wczytujemy akutalny(zgodny z licznikiem) znak klucza i stringu
encrypt:
lb $t1, stringGiven($t0)
lb $t6, stringKey($t2)
beq $t1, $zero, printE
j prepE


# uzyskujemy zakodowany zgodnie z kluczem i podanym stringiem znak
prepE:
add $t5, $t1, $t6
sub $t5, $t5, 97
bge $t5, 123, ifE
j saveE

# przekroczenie alfabetu
ifE:
sub $t5, $t5, 26
j saveE

# zapis rezultatu
saveE:
sb $t5, stringResult($t0)
add $t0, $t0, 1
add $t2, $t2, 1
beq $t2, $t3, keyE
j encrypt

# jesli klucz byl na swoim maxie to trzeba go zresetowac
keyE:
add $t2, $zero, 0
j encrypt



printE:
li $t1, 0
sb $t1, stringResult($t0)
li $t0, 0
#li $v0, 4
#la $a0, stringResult
#syscall
#j exit
j sLoad1

printLoop:
lb $t1, stringResult($t0)
beq $t0, $t3, exit
li $v0, 11
move $a0, $t1
syscall
add $t0, $t0, 1
j printLoop

exit:
li $v0, 10
syscall




# funkcja z zadania 3 gdzie obliczam sobie dlugosc stringa
sLoad:
li $t1,0
la $t0,stringKey
j sLen
     
 
sLen:
lb   $a0,0($t0)
beqz $a0,done
addi $t0,$t0,1
addi $t1,$t1,1
j     sLen
    
done:
sub $t1, $t1, 1
move $t3, $t1
j path


# to samo tylko z rezultatem
sLoad1:
li $t1,0
la $t4,stringResult
j sLen1
     
 
sLen1:
lb   $a0,0($t4)
beqz $a0,done1
addi $t4,$t4,1
addi $t1,$t1,1
j     sLen1
    
done1:
sub $t1, $t1, 1
move $t3, $t1
j printLoop
