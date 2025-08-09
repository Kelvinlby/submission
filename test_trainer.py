#!/usr/bin/env python3

import time
import sys

def main():
    print("Starting training script...")
    print("This is a test trainer script")
    
    # Simulate some training output
    for i in range(5):
        print(f"Epoch {i+1}/5 - Training progress: {(i+1)*20}%")
        time.sleep(1)
        
        # Simulate some warnings/errors to stderr
        if i == 2:
            print("Warning: This is a test warning message", file=sys.stderr)
    
    print("Training completed successfully!")
    print("Final accuracy: 95.2%")

if __name__ == "__main__":
    main()