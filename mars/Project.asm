.data
menu_prompt:        .asciiz "\n--- Main Menu ---\n1. Convert to Binary\n2. Encrypt Binary File\n3. Directly Encrypt Input File\n4. Decrypt\n5.Brute Force\n6.Exit\nChoose an option: "
file_error:         .asciiz "\nError opening file.\n"
binary_conversion_msg: .asciiz "\nBinary conversion completed successfully.\n"
encrypt_prompt:     .asciiz "\nEncryption completed successfully.\n"
decrypt_prompt:     .asciiz "\nDecryption completed successfully.\n"
direct_encrypt_msg: .asciiz "\nDirect encryption completed successfully.\n"
exit_message:       .asciiz "\nExiting the program.\n"
key_label:          .asciiz "\nKey: "
output_label:       .asciiz "\nDecrypted Output:\n"
separator:          .asciiz "\n------------------------\n"
input_file:         .asciiz "input.txt"
binary_file:        .asciiz "binary.txt"
encrypted_file:     .asciiz "encrypted.txt"
decrypted_file:     .asciiz "decrypted.txt"
encryption_key_prompt: .asciiz "\nEnter the encryption key (a number between 0 and 255): "
brute_force_file:       .asciiz "brute_force_output.txt"
brute_force_msg:        .asciiz "\nBrute force completed. Check brute_force_output.txt\n"
key_header_template:    .asciiz "\n--- Decryption using key: "
newline:                .asciiz "\n"
buffer:             .space 1    # Buffer for reading/writing single bytes
user_key:           .word 0     # Placeholder for the user-provided key

.text
.globl main

main:
    # Display Main Menu
    li $v0, 4
    la $a0, menu_prompt
    syscall

    # Take User Input
    li $v0, 5
    syscall
    move $t0, $v0          # Store user's choice in $t0

    # Main Menu Logic
    beq $t0, 1, convert_to_binary   # Convert to Binary option
    beq $t0, 2, encrypt             # Encrypt Binary File
    beq $t0, 3, direct_encrypt      # Directly Encrypt Input File
    beq $t0, 4, decrypt             # Decrypt
    beq $t0, 5, brute_force
    beq $t0, 6, exit_program        # Exit program
    j main                         # Return to the main menu for other options

exit_program:
    li $v0, 4
    la $a0, exit_message
    syscall
    li $v0, 10
    syscall

convert_to_binary:
    # Open input.txt in read mode
    li $v0, 13
    la $a0, input_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0
    bltz $s0, file_error_handler

    # Open binary.txt in write mode
    li $v0, 13
    la $a0, binary_file
    li $a1, 1
    li $a2, 644
    syscall
    move $s1, $v0
    bltz $s1, file_error_handler

binary_conversion_loop:
    # Read a byte from input.txt
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 1
    syscall
    beq $v0, 0, close_binary_files

    # Process byte to convert to binary
    lb $t1, buffer
    li $t2, 128
    li $t3, 8

write_binary_bits:
    beqz $t3, binary_conversion_loop
    and $t4, $t1, $t2
    beqz $t4, write_zero
    li $a0, 49
    j write_bit

write_zero:
    li $a0, 48

write_bit:
    sb $a0, buffer
    li $v0, 15
    move $a0, $s1
    la $a1, buffer
    li $a2, 1
    syscall
    srl $t2, $t2, 1
    subu $t3, $t3, 1
    j write_binary_bits

close_binary_files:
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 16
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, binary_conversion_msg
    syscall
    j main

file_error_handler:
    li $v0, 4
    la $a0, file_error
    syscall
    j main

encrypt:
    # Ask the user to input the encryption key
    li $v0, 4
    la $a0, encryption_key_prompt
    syscall

    # Read user input (key)
    li $v0, 5
    syscall
    move $t0, $v0          # Store user-provided key

    # Ensure the key is within valid range (0 to 255)
    bge $t0, 0, key_in_range
    li $v0, 4
    la $a0, file_error
    syscall
    j main

key_in_range:
    ble $t0, 255, key_valid
    li $v0, 4
    la $a0, file_error
    syscall
    j main

key_valid:
    sw $t0, user_key       # Save the key in user_key variable

    # Open binary.txt in read mode
    li $v0, 13
    la $a0, binary_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0
    bltz $s0, file_error_handler

    # Open encrypted.txt in write mode
    li $v0, 13
    la $a0, encrypted_file
    li $a1, 1
    li $a2, 644
    syscall
    move $s1, $v0
    bltz $s1, file_error_handler

encryption_loop:
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 1
    syscall
    beq $v0, 0, close_encryption_files

    lb $t1, buffer
    lw $t2, user_key
    xor $t3, $t1, $t2
    sb $t3, buffer

    li $v0, 15
    move $a0, $s1
    la $a1, buffer
    li $a2, 1
    syscall
    j encryption_loop

close_encryption_files:
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 16
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, encrypt_prompt
    syscall
    j main

direct_encrypt:
    # Ask the user to input the encryption key
    li $v0, 4
    la $a0, encryption_key_prompt
    syscall

    # Read user input (key)
    li $v0, 5
    syscall
    move $t0, $v0          # Store user-provided key

    # Ensure the key is within valid range (0 to 255)
    bge $t0, 0, key_in_range_direct
    li $v0, 4
    la $a0, file_error
    syscall
    j main

key_in_range_direct:
    ble $t0, 255, key_valid_direct
    li $v0, 4
    la $a0, file_error
    syscall
    j main

key_valid_direct:
    sw $t0, user_key       # Save the key in user_key variable

    # Open input.txt in read mode
    li $v0, 13
    la $a0, input_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0
    bltz $s0, file_error_handler

    # Open encrypted.txt in write mode
    li $v0, 13
    la $a0, encrypted_file
    li $a1, 1
    li $a2, 644
    syscall
    move $s1, $v0
    bltz $s1, file_error_handler

direct_encryption_loop:
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 1
    syscall
    beq $v0, 0, close_direct_encrypt_files

    lb $t1, buffer
    lw $t2, user_key
    xor $t3, $t1, $t2
    sb $t3, buffer

    li $v0, 15
    move $a0, $s1
    la $a1, buffer
    li $a2, 1
    syscall
    j direct_encryption_loop

close_direct_encrypt_files:
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 16
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, direct_encrypt_msg
    syscall
    j main

decrypt:
    # Ask the user to input the encryption key
    li $v0, 4
    la $a0, encryption_key_prompt
    syscall

    # Read user input (key)
    li $v0, 5
    syscall
    move $t0, $v0          # Store user-provided key

    # Ensure the key is within valid range (0 to 255)
    bge $t0, 0, key_in_range_decrypt
    li $v0, 4
    la $a0, file_error
    syscall
    j main

key_in_range_decrypt:
    ble $t0, 255, key_valid_decrypt
    li $v0, 4
    la $a0, file_error
    syscall
    j main

key_valid_decrypt:
    sw $t0, user_key       # Save the key in user_key variable

    # Open encrypted.txt in read mode
    li $v0, 13
    la $a0, encrypted_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0
    bltz $s0, file_error_handler

    # Open decrypted.txt in write mode
    li $v0, 13
    la $a0, decrypted_file
    li $a1, 1
    li $a2, 644
    syscall
    move $s1, $v0
    bltz $s1, file_error_handler

decryption_loop:
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 1
    syscall
    beq $v0, 0, close_decryption_files

    lb $t1, buffer
    lw $t2, user_key
    xor $t3, $t1, $t2
    sb $t3, buffer

    li $v0, 15
    move $a0, $s1
    la $a1, buffer
    li $a2, 1
    syscall
    j decryption_loop

close_decryption_files:
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 16
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, decrypt_prompt
    syscall
    j main

brute_force:
    # Open encrypted.txt in read mode
    li $v0, 13
    la $a0, encrypted_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0
    bltz $s0, file_error_handler

    # Open brute_force_output.txt in write mode
    li $v0, 13
    la $a0, brute_force_file
    li $a1, 1
    li $a2, 644
    syscall
    move $s1, $v0
    bltz $s1, file_error_handler

    li $t0, 0             # Start brute force key (0)

brute_force_loop:
    bgt $t0, 255, close_brute_force_files

    # Write the key label to the output file
    li $v0, 15
    move $a0, $s1
    la $a1, key_label
    li $a2, 6
    syscall

    # Convert the key to a string and write it to the file
    li $v0, 5           # Prepare buffer for integer-to-string conversion
    move $t1, $t0       # Save the current key
    li $t2, 10          # Divider for converting to string (base 10)
    la $a1, buffer
key_conversion:
    divu $t1, $t2       # Perform division
    mfhi $t3            # Get the remainder
    addiu $t3, $t3, 48  # Convert to ASCII ('0' = 48)
    sb $t3, 0($a1)      # Save ASCII digit in buffer
    addiu $a1, $a1, -1  # Move buffer pointer backward
    mflo $t1            # Update quotient
    bnez $t1, key_conversion

    addiu $a1, $a1, 1   # Adjust pointer to the start of the string
    li $t4, 256
    sub $t4, $t4, $a1   # Calculate string length
    li $v0, 15
    move $a0, $s1       # Output file descriptor
    la $a1, buffer      # Address of the converted string
    syscall

    # Write the decrypted output label to the file
    li $v0, 15
    move $a0, $s1
    la $a1, output_label
    li $a2, 19
    syscall

    # Reset file pointer for decryption
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 13
    la $a0, encrypted_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0

decrypt_with_key:
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 1
    syscall
    beq $v0, 0, write_separator

    lb $t1, buffer
    xor $t2, $t1, $t0

    li $t3, 32
    li $t4, 126
    blt $t2, $t3, decrypt_with_key
    bgt $t2, $t4, decrypt_with_key

    sb $t2, buffer
    li $v0, 15
    move $a0, $s1
    la $a1, buffer
    li $a2, 1
    syscall
    j decrypt_with_key

write_separator:
    # Write separator to the file
    li $v0, 15
    move $a0, $s1
    la $a1, separator
    li $a2, 25
    syscall

    # Increment key and continue the brute force loop
    addiu $t0, $t0, 1
    j brute_force_loop

close_brute_force_files:
    li $v0, 16
    move $a0, $s0
    syscall
    li $v0, 16
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, brute_force_msg
    syscall
    j main


    
