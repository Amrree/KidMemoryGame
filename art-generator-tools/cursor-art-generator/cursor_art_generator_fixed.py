#!/usr/bin/env python3
"""
Cursor Art Generator - On-the-fly art generation for Kid Memory Template
This script can be used directly in Cursor to generate specific assets as needed
"""

import sys
import os
import argparse
from pathlib import Path

# Add the current directory to the path so we can import our modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pollinations_client import ArtGenerator, ArtSpec

def main():
    parser = argparse.ArgumentParser(description='Generate art assets for Kid Memory Template')
    parser.add_argument('--module', '-m', choices=['shapes', 'colors', 'animals', 'jobs', 'farm', 'family', 'ui', 'all'], 
                       default='all', help='Module to generate art for')
    parser.add_argument('--asset', '-a', help='Specific asset to generate (e.g., "shapes_circle")')
    parser.add_argument('--prompt', '-p', help='Custom prompt for asset generation')
    parser.add_argument('--output', '-o', default='/workspace/tarot_book_output', help='Output directory')
    parser.add_argument('--width', '-w', type=int, default=512, help='Image width')
    parser.add_argument('--height', '--height', type=int, default=512, help='Image height')
    parser.add_argument('--style', '-s', default='cartoon', help='Art style')
    parser.add_argument('--background', '-b', default='transparent', 
                       choices=['transparent', 'white', 'colorful'], help='Background type')
    
    args = parser.parse_args()
    
    generator = ArtGenerator(output_dir=args.output)
    
    if args.asset and args.prompt:
        # Generate single custom asset
        print(f"🎨 Generating custom asset: {args.asset}")
        success = generator.generate_single_asset(
            name=args.asset,
            prompt=args.prompt,
            width=args.width,
            height=args.height,
            style=args.style,
            background=args.background
        )
        
        if success:
            print(f"✅ Successfully generated {args.asset}")
        else:
            print(f"❌ Failed to generate {args.asset}")
            
    elif args.module == 'all':
        # Generate all modules
        print("🎨 Generating all modules...")
        success = generator.generate_all_modules()
        if success:
            print("✅ Successfully generated all modules")
        else:
            print("❌ Failed to generate some modules")
            
    else:
        # Generate specific module
        print(f"🎨 Generating module: {args.module}")
        success = generator.generate_module(args.module)
        if success:
            print(f"✅ Successfully generated {args.module} module")
        else:
            print(f"❌ Failed to generate {args.module} module")

def quick_generate(name: str, prompt: str, width: int = 256, height: int = 256):
    """Quick generation function for Cursor IDE integration"""
    generator = ArtGenerator(output_dir='/workspace/tarot_book_output')
    return generator.generate_single_asset(name, prompt, width, height)

def generate_module(module: str):
    """Generate entire module function for Cursor IDE integration"""
    generator = ArtGenerator(output_dir='/workspace/tarot_book_output')
    return generator.generate_module(module)

def generate_card(module: str, card: str, width: int = 512, height: int = 512):
    """Generate specific card function for Cursor IDE integration"""
    generator = ArtGenerator(output_dir='/workspace/tarot_book_output')
    return generator.generate_card(module, card, width, height)

if __name__ == "__main__":
    main()