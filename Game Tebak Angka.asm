; =====================================================================================
; UJIAN AKHIR SEMESTER - PEMROGRAMAN BAHASA RAKITAN
; =====================================================================================
; NAMA PROGRAM : Game Tebak Angka
; PROGRAMMER   : Adi Saputro
; COMPILER     : TASM / DOSBox
; =====================================================================================

.model small
.stack 512

.data
; =====================================================================================
; MACRO DEFINITIONS (Menambah LOC dan mempermudah pemanggilan fungsi)
; =====================================================================================
PRINT_STR MACRO string
    lea dx, string
    mov ah, 09h
    int 21h
ENDM

NEW_LINE MACRO
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
ENDM

; ---------------------------------------------------------------------------------
    ; ASCII ART
    ; ---------------------------------------------------------------------------------
    
    ; Judul Utama
    title_01 db 13, 10, ' ======================================================================== ', 13, 10, '$'
    title_02 db         ' ||                                                                    || ', 13, 10, '$'
    title_03 db         ' ||           ___..._                                _...___           || ', 13, 10, '$'
    title_04 db         ' ||       _.-"       "-.                           .-"       "-._      || ', 13, 10, '$'
    title_05 db         ' ||     ."      ___     `.                       .      ___      `.    || ', 13, 10, '$'
    title_06 db         ' ||    /       /   \      \                     /      /   \       \   || ', 13, 10, '$'
    title_07 db         ' ||   |       |  O  |      |                   |      |  O  |       |  || ', 13, 10, '$'
    title_08 db         ' ||    \       \___/      /                     \      \___/       /   || ', 13, 10, '$'
    title_09 db         ' ||     `.             .-`                       `.             .-`    || ', 13, 10, '$'
    title_10 db         ' ||       "-._     _.-"                            "-._     _.-"       || ', 13, 10, '$'
    title_11 db         ' ||                                                                    || ', 13, 10, '$'
    title_12 db         ' ||                M Y S T E R Y    E D I T I O N                      || ', 13, 10, '$'
    title_13 db         ' ||                     ~ Game Tebak Angka ~                           || ', 13, 10, '$'
    title_14 db         ' ======================================================================== ', 13, 10, '$'

    ; Menu Utama
    menu_msg1   db 13, 10, ' SILAKAN PILIH MENU: ', 13, 10, '$'
    menu_msg2   db ' [1] Mulai Permainan Baru', 13, 10, '$'
    menu_msg3   db ' [2] Cara Bermain / Bantuan', 13, 10, '$'
    menu_msg4   db ' [3] Keluar dari Game', 13, 10, '$'
    menu_prompt db 13, 10, ' Pilihan Anda (1-3): $'

    ; Instruksi & Bantuan
    help_01 db 13, 10, ' ======================================================================== ', 13, 10, '$'
    help_02 db         '   __________________________________________________________________     ', 13, 10, '$'
    help_03 db         '  / \                                                                \    ', 13, 10, '$'
    help_04 db         ' |   |                                                               |    ', 13, 10, '$'
    help_05 db         '  \_ |      ~ C A R A   B E R M A I N   &   I N S T R U K S I ~      |    ', 13, 10, '$'
    help_06 db         '     |                                                               |    ', 13, 10, '$'
    help_07 db         '     |  [1] Komputer akan memilih angka misterius (0-9) secara acak. |    ', 13, 10, '$'
    help_08 db         '     |  [2] Anda memiliki 5 buah nyawa (kesempatan) untuk menebak.   |    ', 13, 10, '$'
    help_09 db         '     |  [3] Ketik angka tebakan Anda menggunakan keyboard.           |    ', 13, 10, '$'
    help_10 db         '     |  [4] Gunakan petunjuk TINGGI/RENDAH jika tebakan meleset.     |    ', 13, 10, '$'
    help_11 db         '     |                                                               |    ', 13, 10, '$'
    help_12 db         '     |   ____________________________________________________________|__  ', 13, 10, '$'
    help_13 db         '     |  /                                                              /  ', 13, 10, '$'
    help_14 db         '      \_/_____________________________________________________________/   ', 13, 10, '$'
    help_15 db         ' ======================================================================== ', 13, 10, '$'
    help_16 db 13, 10, '           [ Tekan sembarang tombol untuk kembali ke Menu ]               ', 13, 10, '$'

    ; ASCII Art Menang
    win_01  db 13, 10, ' ======================================================================== ', 13, 10, '$'
    win_02  db         '                            .-=========-.                                 ', 13, 10, '$'
    win_03  db         '                            \ -=======- /                                 ', 13, 10, '$'
    win_04  db         '                            _|   .=.   |_                                 ', 13, 10, '$'
    win_05  db         '                           ((|  {{1}}  |))                                ', 13, 10, '$'
    win_06  db         '                            \|   /|\   |/                                 ', 13, 10, '$'
    win_07  db         '                             \__  _  __/                                  ', 13, 10, '$'
    win_08  db         '                               _`) (`_                                    ', 13, 10, '$'
    win_09  db         '                             _/_______\_                                  ', 13, 10, '$'
    win_10  db         '                            /===========\                                 ', 13, 10, '$'
    win_11  db         '         Y A T T A !   T E B A K A N   A N D A   B E N A R !              ', 13, 10, '$'
    win_12  db         ' ======================================================================== ', 13, 10, '$'

    ; ASCII Art Kalah
    lose_01 db 13, 10, ' ======================================================================== ', 13, 10, '$'
    lose_02 db         '                                  ______                                  ', 13, 10, '$'
    lose_03 db         '                               .-"      "-.                               ', 13, 10, '$'
    lose_04 db         '                              /            \                              ', 13, 10, '$'
    lose_05 db         '                             |              |                             ', 13, 10, '$'
    lose_06 db         '                             |,  .-.  .-.  ,|                             ', 13, 10, '$'
    lose_07 db         '                             | )(__/  \__)( |                             ', 13, 10, '$'
    lose_08 db         '                             |/     /\     \|                             ', 13, 10, '$'
    lose_09 db         '                             (_     ^^     _)                             ', 13, 10, '$'
    lose_10 db         '                              \__|IIIIII|__/                              ', 13, 10, '$'
    lose_11 db         '                               | \IIIIII/ |                               ', 13, 10, '$'
    lose_12 db         '                               \          /                               ', 13, 10, '$'
    lose_13 db         '            G A M E   O V E R  ---  N Y A W A   H A B I S !               ', 13, 10, '$'
    lose_14 db         ' ======================================================================== ', 13, 10, '$'

    ; Notifikasi Game
    prompt_guess db 13, 10, 13, 10, ' Masukkan tebakan angka (0-9): $'
    msg_high     db ' -> Terlalu TINGGI! Coba angka yang lebih kecil.', 13, 10, '$'
    msg_low      db ' -> Terlalu RENDAH! Coba angka yang lebih besar.', 13, 10, '$'
    msg_invalid  db ' -> ERROR: Masukkan hanya angka 0 sampai 9!', 13, 10, '$'
    msg_lives    db 13, 10, ' [+] Sisa Nyawa Anda: $'
    
    msg_reveal   db 13, 10, ' Angka rahasianya adalah: $'
    msg_again    db 13, 10, 13, 10, ' Ingin bermain lagi? (Y/N): $'
    msg_exit     db 13, 10, ' Terima kasih sudah bermain! Sampai jumpa!', 13, 10, '$'

    ; ---------------------------------------------------------------------------------
    ; VARIABLES / STATE GAME
    ; ---------------------------------------------------------------------------------
    random_num  db 0    ; Menyimpan angka rahasia yang digenerate
    user_guess  db 0    ; Menyimpan input tebakan user
    lives       db 5    ; Jumlah nyawa (kesempatan menebak)
    is_playing  db 1    ; Flag status permainan (1 = main, 0 = menu/keluar)
    .code
MAIN PROC
    ; Inisialisasi Data Segment ke dalam DS register
    mov ax, @data
    mov ds, ax
    CALL BOOT_SEQUENCE

MAIN_MENU:
    ; Bersihkan layar sebelum menampilkan menu
    call CLEAR_SCREEN

    ; Menampilkan Judul Game (Memanggil Macro PRINT_STR yang dibuat di Tahap 1)
    PRINT_STR title_01
    PRINT_STR title_02
    PRINT_STR title_03
    PRINT_STR title_04
    PRINT_STR title_05
    PRINT_STR title_06
    PRINT_STR title_07
    PRINT_STR title_08
    PRINT_STR title_09
    PRINT_STR title_10
    PRINT_STR title_11
    PRINT_STR title_12
    PRINT_STR title_13
    PRINT_STR title_14

    ; Menampilkan Pilihan Menu Utama
    PRINT_STR menu_msg1
    PRINT_STR menu_msg2
    PRINT_STR menu_msg3
    PRINT_STR menu_msg4
    PRINT_STR menu_prompt

    ; Membaca 1 karakter input dari keyboard tanpa echo (AH=07h) atau dengan echo (AH=01h)
    mov ah, 01h
    int 21h

    ; Logika Percabangan (Routing) berdasarkan input user
    cmp al, '1'
    je START_GAME       ; Jika tekan 1, lompat ke label START_GAME (Akan dibuat di Tahap 3)
    
    cmp al, '2'
    je SHOW_HELP        ; Jika tekan 2, tampilkan cara bermain
    
    cmp al, '3'
    je EXIT_PROGRAM     ; Jika tekan 3, keluar aplikasi
    
    ; Jika input tidak dikenali (bukan 1, 2, atau 3), refresh menu
    jmp MAIN_MENU

SHOW_HELP:
    ; Bersihkan layar untuk halaman bantuan
    call CLEAR_SCREEN
    
    ; Tampilkan teks instruksi (Perkamen)
    PRINT_STR help_01
    PRINT_STR help_02
    PRINT_STR help_03
    PRINT_STR help_04
    PRINT_STR help_05
    PRINT_STR help_06
    PRINT_STR help_07
    PRINT_STR help_08
    PRINT_STR help_09
    PRINT_STR help_10
    PRINT_STR help_11
    PRINT_STR help_12
    PRINT_STR help_13
    PRINT_STR help_14
    PRINT_STR help_15
    PRINT_STR help_16
    
    ; Tunggu pengguna menekan tombol apa saja sebelum kembali
    mov ah, 07h         ; Input keyboard tanpa echo
    int 21h
    
    ; Kembali ke menu utama
    jmp MAIN_MENU

EXIT_PROGRAM:
    ; Keluar dari permainan dengan aman
    call CLEAR_SCREEN
    CALL SHOW_ABOUT_GAME
    mov ah, 4Ch         ; Interrupt DOS untuk terminasi program
    int 21h

MAIN ENDP

; =====================================================================================
; PROCEDURE: CLEAR_SCREEN
; Deskripsi: Membersihkan terminal DOSBox menggunakan interrupt BIOS Video (Int 10h)
; Membantu menambah LOC dan membuat tampilan UI menjadi profesional.
; =====================================================================================
CLEAR_SCREEN PROC
    push ax
    
    ; Mengatur ulang mode video ke Mode 03h (80x25 karakter, 16 warna)
    ; Efek samping dari interupsi ini adalah layar akan dibersihkan secara total
    ; dan kursor otomatis kembali ke pojok kiri atas (0,0).
    mov ah, 00h
    mov al, 03h
    int 10h
    
    pop ax
    ret
CLEAR_SCREEN ENDP
; =====================================================================================
; CORE GAMEPLAY LOGIC & PROCEDURES
; =====================================================================================

START_GAME:
    ; Reset state permainan setiap kali mulai baru
    mov lives, 5            ; Setel ulang nyawa menjadi 5
    mov is_playing, 1       ; Set status sedang bermain

    ; Panggil prosedur untuk mengacak angka rahasia
    call GENERATE_RANDOM

    ; Bersihkan layar untuk memulai sesi permainan
    call CLEAR_SCREEN

GAME_LOOP:
    ; 1. Cek apakah nyawa sudah habis
    cmp lives, 0
    je LOSE_STATE           ; Jika nyawa = 0, lompat ke kondisi kalah

    ; 2. Tampilkan sisa nyawa ke layar
    NEW_LINE
    PRINT_STR msg_lives
    
    ; Mengubah angka nyawa (integer) menjadi karakter ASCII agar bisa diprint
    mov dl, lives
    add dl, '0'             ; Konversi integer ke ASCII (misal 5 + 48 = '5')
    mov ah, 02h             ; Fungsi DOS untuk print 1 karakter di DL
    int 21h
    NEW_LINE

    ; 3. Meminta input tebakan pengguna
    PRINT_STR prompt_guess
    
    ; Membaca 1 karakter dari keyboard (dengan echo/tampil di layar)
    mov ah, 01h
    int 21h
    
    ; 4. Validasi Input Pengguna
    ; Memastikan bahwa karakter yang ditekan adalah angka '0' sampai '9'
    cmp al, '0'
    jl INVALID_INPUT        ; Jika lebih kecil dari ASCII '0'
    cmp al, '9'
    jg INVALID_INPUT        ; Jika lebih besar dari ASCII '9'

    ; 5. Menyimpan input valid dan konversi ke angka desimal
    sub al, '0'             ; Konversi ASCII ke integer (misal '5' - '0' = 5)
    mov user_guess, al      ; Simpan di variabel user_guess

    ; 6. Membandingkan Tebakan dengan Angka Rahasia
    mov bl, random_num      ; Pindahkan angka rahasia ke register BL
    cmp user_guess, bl      ; Bandingkan tebakan (AL) dengan rahasia (BL)
    
    je WIN_STATE            ; Jika SAMA (Equal) -> Menang
    jl GUESS_LOW            ; Jika KURANG DARI (Less) -> Terlalu Rendah
    jg GUESS_HIGH           ; Jika LEBIH DARI (Greater) -> Terlalu Tinggi

; =====================================================================================
; KONDISI TEBAKAN SALAH
; =====================================================================================
GUESS_LOW:
    NEW_LINE
    PRINT_STR msg_low       ; Tampilkan pesan terlalu rendah
    dec lives               ; Kurangi 1 nyawa (lives = lives - 1)
    jmp GAME_LOOP           ; Ulangi permainan

GUESS_HIGH:
    NEW_LINE
    PRINT_STR msg_high      ; Tampilkan pesan terlalu tinggi
    dec lives               ; Kurangi 1 nyawa
    jmp GAME_LOOP           ; Ulangi permainan

INVALID_INPUT:
    NEW_LINE
    PRINT_STR msg_invalid   ; Pesan error jika input bukan angka
    jmp GAME_LOOP           ; Ulangi tanpa mengurangi nyawa

; =====================================================================================
; KONDISI AKHIR PERMAINAN (MENANG / KALAH)
; =====================================================================================
WIN_STATE:
    call CLEAR_SCREEN
    ; Menampilkan ASCII Art kemenangan
    PRINT_STR win_01
    PRINT_STR win_02
    PRINT_STR win_03
    PRINT_STR win_04
    PRINT_STR win_05
    PRINT_STR win_06
    PRINT_STR win_07
    PRINT_STR win_08
    PRINT_STR win_09
    PRINT_STR win_10
    PRINT_STR win_11
    PRINT_STR win_12
    jmp PLAY_AGAIN_PROMPT

LOSE_STATE:
    call CLEAR_SCREEN
    ; Menampilkan ASCII Art kekalahan
    PRINT_STR lose_01
    PRINT_STR lose_02
    PRINT_STR lose_03
    PRINT_STR lose_04
    PRINT_STR lose_05
    PRINT_STR lose_06
    PRINT_STR lose_07
    PRINT_STR lose_08
    PRINT_STR lose_09
    PRINT_STR lose_10
    PRINT_STR lose_11
    PRINT_STR lose_12
    PRINT_STR lose_13
    PRINT_STR lose_14
    
    ; Beritahu angka yang benar (Kunci Jawaban)
    PRINT_STR msg_reveal
    mov dl, random_num
    add dl, '0'             ; Konversi ke ASCII untuk ditampilkan
    mov ah, 02h
    int 21h
    NEW_LINE

PLAY_AGAIN_PROMPT:
    PRINT_STR msg_again
    
    mov ah, 01h             ; Baca input Y/N
    int 21h

    ; Cek apakah user ingin main lagi
    cmp al, 'y'
    je RESTART_TO_MENU
    cmp al, 'Y'
    je RESTART_TO_MENU
    
    ; Jika tidak, keluar (Lompat ke label EXIT_PROGRAM di Tahap 2)
    jmp EXIT_PROGRAM

RESTART_TO_MENU:
    jmp MAIN_MENU           ; Kembali ke menu utama (Tahap 2)

; =====================================================================================
; PROCEDURE: GENERATE_RANDOM
; Deskripsi: Menghasilkan angka acak dari 0 hingga 9.
; Menggunakan interupsi 1Ah (System Time) untuk mendapatkan nilai seed secara dinamis.
; =====================================================================================
GENERATE_RANDOM PROC
    push ax
    push cx
    push dx

    ; Mengambil System Timer dari BIOS
    ; Interrupt 1Ah dengan AH=00h akan mengisi CX:DX dengan jumlah tick jam sistem
    mov ah, 00h
    int 1Ah

    ; Kita gunakan bagian low byte dari DX (DL) yang terus berubah dengan sangat cepat
    ; sebagai angka acak sementara (seed).
    mov ax, dx              ; Pindahkan nilai waktu ke AX
    mov dx, 0               ; Bersihkan DX untuk persiapan operasi pembagian (DIV)
    
    ; Proses Modulo
    mov cx, 10              ; Kita butuh angka 0-9, jadi pembagi adalah 10
    div cx                  ; AX dibagi CX. Sisa bagi (remainder) akan tersimpan di DX

    ; Menyimpan hasil acak
    mov random_num, dl      ; DL menyimpan sisa bagi (nilai dari 0 sampai 9)

    pop dx
    pop cx
    pop ax
    ret                     ; Kembali ke pemanggil
GENERATE_RANDOM ENDP


; ------------------------------------------------------------------------------
; PROCEDURE: BOOT_SEQUENCE
; ------------------------------------------------------------------------------
BOOT_SEQUENCE PROC
    push ax
    push dx
    push ds             ; Simpan alamat Data Segment asli

    push cs             ; Alihkan Data Segment ke Code Segment sementara
    pop ds

    jmp Start_Boot

boot_msg1 db 0Dh,0Ah,' [i] Memulai sistem game Mystery...$'
boot_msg2 db 0Dh,0Ah,' [i] Memuat modul pengacak angka... OK$'
boot_msg3 db 0Dh,0Ah,' [i] Mengalokasikan memori permainan... OK$'
boot_msg4 db 0Dh,0Ah,' [i] Memeriksa status keyboard BIOS... OK$'
boot_msg5 db 0Dh,0Ah,' [i] Menyiapkan antarmuka teks ASCII... OK$'
boot_msg6 db 0Dh,0Ah,0Dh,0Ah,' >> Sistem Siap! Tekan sembarang tombol untuk masuk...$'

Start_Boot:
    mov ah, 09h
    lea dx, boot_msg1
    int 21h
    lea dx, boot_msg2
    int 21h
    lea dx, boot_msg3
    int 21h
    lea dx, boot_msg4
    int 21h
    lea dx, boot_msg5
    int 21h
    lea dx, boot_msg6
    int 21h

    mov ah, 00h
    int 16h

    mov ah, 00h
    mov al, 03h
    int 10h

    pop ds              ; Kembalikan alamat Data Segment asli
    pop dx
    pop ax
    ret
BOOT_SEQUENCE ENDP

; ------------------------------------------------------------------------------
; PROCEDURE: SHOW_ABOUT_GAME
; ------------------------------------------------------------------------------
SHOW_ABOUT_GAME PROC
    push ax
    push dx
    push ds             ; Simpan alamat Data Segment asli

    push cs             ; Alihkan Data Segment ke Code Segment sementara
    pop ds

    jmp Start_About

abt_1  db 0Dh,0Ah,' ==========================================$'
abt_2  db 0Dh,0Ah,' |        TENTANG GAME TEBAK ANGKA        |$'
abt_3  db 0Dh,0Ah,' ==========================================$'
abt_4  db 0Dh,0Ah,' | Versi    : 1.0 (Mystery Edition)       |$'
abt_5  db 0Dh,0Ah,' | Platform : DOS / emu8086               |$'
abt_6  db 0Dh,0Ah,' | Bahasa   : Assembly 16-bit (x86)       |$'
abt_7  db 0Dh,0Ah,' |                                        |$'
abt_8  db 0Dh,0Ah,' | Developer: Adi Saputro                 |$'
abt_9  db 0Dh,0Ah,' |                                        |$'
abt_10 db 0Dh,0Ah,' | Dibuat untuk memenuhi tugas akhir      |$'
abt_11 db 0Dh,0Ah,' | mata kuliah Bahasa Rakitan / Assembly  |$'
abt_12 db 0Dh,0Ah,' ==========================================$'
abt_13 db 0Dh,0Ah,0Dh,0Ah,' Tekan [ENTER] untuk keluar sepenuhnya...$'

Start_About:
    mov ah, 00h
    mov al, 03h
    int 10h

    mov ah, 09h
    lea dx, abt_1
    int 21h
    lea dx, abt_2
    int 21h
    lea dx, abt_3
    int 21h
    lea dx, abt_4
    int 21h
    lea dx, abt_5
    int 21h
    lea dx, abt_6
    int 21h
    lea dx, abt_7
    int 21h
    lea dx, abt_8
    int 21h
    lea dx, abt_9
    int 21h
    lea dx, abt_10
    int 21h
    lea dx, abt_11
    int 21h
    lea dx, abt_12
    int 21h
    lea dx, abt_13
    int 21h

Wait_About_Enter:
    mov ah, 00h         
    int 16h             
    cmp al, 0Dh         
    jne Wait_About_Enter  

    pop ds              ; Kembalikan alamat Data Segment asli
    pop dx
    pop ax
    ret
SHOW_ABOUT_GAME ENDP