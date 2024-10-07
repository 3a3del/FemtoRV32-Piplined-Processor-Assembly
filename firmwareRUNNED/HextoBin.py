def hex_to_bin(hex_file, output_file):
    try:
        # Open the hex file in read mode
        with open(hex_file, 'r') as file:
            hex_lines = file.readlines()
        
        # Open the output file to write the binary values
        with open(output_file, 'w') as bin_file:
            for hex_value in hex_lines:
                # Strip any whitespace or newlines from the hex value
                hex_value = hex_value.strip()
                
                # Convert hex to binary and remove the '0b' prefix
                binary_value = bin(int(hex_value, 16))[2:]
                
                # Pad the binary number to ensure it's 32 bits (or another length if needed)
                binary_value = binary_value.zfill(32)
                
                # Write the binary value to the output file
                bin_file.write(binary_value + '\n')
        
        print(f"Conversion completed. Binary values written to {output_file}")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage Example
hex_file = 'code.hex'  # Input text file with hex values
output_file = 'binary_output.txt'  # Output text file to save binary values

hex_to_bin(hex_file, output_file)
