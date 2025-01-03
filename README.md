# MIPS-File-Encryption-Decryption
This project is a File Encryption and Decryption System implemented in MIPS Assembly Language. It demonstrates core concepts of file handling, binary manipulation, bitwise operations, and user input processing at the assembly level. The system provides a menu-driven interface that allows users to interact with different encryption and decryption functionalities through command-line options.

The project is divided into five main features that cater to various aspects of file security:

## Key Features
# Binary Conversion:

Converts the contents of a text file into binary format for secure storage or further processing.
Reads each byte of data, processes it into binary representation, and writes it to an output file.
Provides error handling for file access and input issues.
# File Encryption:

Encrypts a binary file using XOR-based encryption with a user-specified numeric key (0–255).
Utilizes the XOR operation for lightweight yet effective data obfuscation.
Outputs the encrypted data to a separate file for secure storage.
# Direct Encryption:

Skips binary conversion and directly encrypts the contents of an input text file.
Provides a faster encryption path without intermediate steps.
# File Decryption:

Decrypts encrypted data using the same XOR operation with the user-provided key.
Ensures that data can be recovered accurately if the correct key is used.

# Brute Force Decryption:

Automatically attempts all possible keys (0–255) to decrypt an encrypted file.
Saves the results of each attempt to a separate file for manual inspection.
Useful for testing encryption strength or analyzing encrypted files without a known key.
# Error Handling:

Includes robust file error handling to detect missing files, permission issues, and input errors.
Validates user inputs, including numeric key constraints, to avoid crashes.
# How It Works
The program begins with a menu-driven interface, allowing users to choose from the available options.
Based on the user’s selection, the corresponding operation is executed, such as converting text to binary, encrypting files, or decrypting them.
Input validation is performed to ensure that the provided key or file path meets required conditions.
System calls handle file I/O operations like opening, reading, writing, and closing files securely.
Encryption and decryption rely on bitwise XOR operations, ensuring simplicity and efficiency.
Outputs are saved to specified files for easy access and further analysis.
## Usage Scenarios
# Learning Tool for Assembly Language:
Ideal for students and beginners exploring MIPS Assembly and low-level programming.
# Testing Encryption Techniques:
Demonstrates how XOR encryption can be implemented in practice.
# Cybersecurity Education:
Provides insights into file security, encryption methods, and brute force attacks.
# Practical File Manipulation:
Teaches file handling in assembly, including reading and writing binary data.
# Dependencies
# MIPS Simulator: MARS (MIPS Assembler and Runtime Simulator) or SPIM for assembling and running the code.
Text editor for editing .asm files.
Sample input files for testing the functionality.
