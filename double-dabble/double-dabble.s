PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

digits = $0200 ; 5 bytes
source = $0205 ; 2 bytes

E  = %10000000
RW = %01000000
RS = %00100000

  .org $8000

reset:
  ldx #$ff
  txs

  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA

  lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00001110 ; Display on; cursor on; blink off
  jsr lcd_instruction
  lda #%00000110 ; Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda #$00000001 ; Clear display
  jsr lcd_instruction

  ; Initialize source to be the number to convert (in Big-Endian
  ; byte order)
  lda number
  sta source + 1
  lda number + 1
  sta source

  ; Initialize all digits to 0
  lda #0
  sta digits
  sta digits + 1
  sta digits + 2
  sta digits + 3
  sta digits + 4

  ; Repeat the (doubling) loop for each bit in source
  ldy #16
double_loop:

  ; Check each digit and adjust it for '10s carry' if >=5
  ldx #4
add3_loop:
  lda digits,x
  cmp #5
  bmi add3_skip    ; Value was smaller than 5, do nothing

  ; Add 123 so that 5 becomes 128 (10s carry bit)
  clc
  adc #123
  sta digits,x

add3_skip:
  dex
  bpl add3_loop   ; Loop while X is positive (we need an iteration when X=0)

  ; Shift everything to the left (10s carry bits moves to the next digit)
  clc
  rol source + 1
  rol source
  rol digits + 4
  rol digits + 3
  rol digits + 2
  rol digits + 1
  rol digits

  ; Repeat for the next bit in source
  dey
  bne double_loop

  ; Add '0' to each digit to get ASCII chars. After all the shifting, 2 bytes
  ; after the digits (source) are 0 now, conveniently serving as null-terminator
  clc
  ldx #4
mkchar_loop:
  lda digits,x
  adc #'0'
  sta digits,x
  dex
  bpl mkchar_loop

  ; Digits buffer is now filled with decoded decimal digits, but the value is
  ; prefixed by leading zeros. For nicer output, finding first character that
  ; is not '0'. Checking only first 4 chars, because if last one is 0 we should
  ; print that anyway
  ldx #0
nonzero_loop:
  lda digits,x
  cmp #'0'
  bne print
  inx
  cpx #4
  bne nonzero_loop


  ; The X register is now loaded with the index of the first character to print
print:
  lda digits,x
  beq loop
  jsr print_char
  inx
  jmp print


  ; That's it, we're done
loop:
  jmp loop

number: .word 1729

lcd_wait:
  pha
  lda #%00000000  ; Port B is input
  sta DDRB
lcdbusy:
  lda #RW
  sta PORTA
  lda #(RW | E)
  sta PORTA
  lda PORTB
  and #%10000000
  bne lcdbusy

  lda #RW
  sta PORTA
  lda #%11111111  ; Port B is output
  sta DDRB
  pla
  rts

lcd_instruction:
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts

print_char:
  jsr lcd_wait
  sta PORTB
  lda #RS         ; Set RS; Clear RW/E bits
  sta PORTA
  lda #(RS | E)   ; Set E bit to send instruction
  sta PORTA
  lda #RS         ; Clear E bits
  sta PORTA
  rts

  .org $fffc
  .word reset
  .word $0000
