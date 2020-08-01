PORTB = $6000

; This is a copy of Ben Eater's hello-world-final.s, but all VIA and LCD routines
; removed, as emulator just prints everything that is written to the output address.

  .org $8000

reset:
  ldx #$ff
  txs

  ldx #0
print:
  lda message,x
  beq loop
  jsr print_char
  inx
  jmp print

loop:
  jmp loop

message: .asciiz "Hello, world!"

print_char:
  sta PORTB
  rts

  .org $fffc
  .word reset
  .word $0000
