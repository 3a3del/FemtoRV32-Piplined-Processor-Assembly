def truncate_or_pad_file(input_file, output_file, target_lines=64, pad_value="00000000000000000000000000000000"):
    try:
        # Read the input file
        with open(input_file, 'r') as file:
            lines = file.readlines()

        # Truncate or pad the lines to exactly 64 lines
        if len(lines) > target_lines:
            lines = lines[:target_lines]  # Truncate if more than 64 lines
        elif len(lines) < target_lines:
            # Pad with the pad_value if fewer than 64 lines
            lines += [pad_value + '\n'] * (target_lines - len(lines))

        # Write the result to the output file
        with open(output_file, 'w') as file:
            file.writelines(lines)
        
        print(f"Processed file saved as {output_file}")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage Example
input_file = 'code.hex'  # Input text file
output_file = 'output_64_lines_hex.txt'  # Output text file

truncate_or_pad_file(input_file, output_file)
