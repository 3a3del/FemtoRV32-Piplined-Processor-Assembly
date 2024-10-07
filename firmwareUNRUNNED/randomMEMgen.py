import random

def generate_mem_file(filename, depth=64, width=32):
    with open(filename, 'w') as f:
        for _ in range(depth):
            # Generate a random 32-bit value
            value = random.randint(0, 2**width - 1)
            # Write the value in hexadecimal format without the '0x' prefix
            f.write(f"{value:08X}\n")

# Usage
generate_mem_file("random_data.mem")
