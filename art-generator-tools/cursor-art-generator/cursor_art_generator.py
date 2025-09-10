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
    parser.add_argument('--output', '-o', default='generated_assets', help='Output directory')
    parser.add_argument('--width', '-w', type=int, default=512, help='Image width')
    parser.add_argument('--height', '-h', type=int, default=512, help='Image height')
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
        # Generate all art
        print("🎨 Generating all art assets...")
        results = generator.generate_all_art()
        
        print("\n📊 Generation Summary:")
        for module, assets in results.items():
            success_count = sum(1 for success in assets.values() if success)
            total_count = len(assets)
            status = "✅" if success_count == total_count else "⚠️"
            print(f"{status} {module}: {success_count}/{total_count} assets")
            
    else:
        # Generate specific module
        print(f"🎨 Generating {args.module} module art...")
        results = generator.generate_module_art(args.module)
        
        success_count = sum(1 for success in results.values() if success)
        total_count = len(results)
        status = "✅" if success_count == total_count else "⚠️"
        print(f"{status} {args.module}: {success_count}/{total_count} assets generated")

def quick_generate(asset_name: str, prompt: str, **kwargs):
    """
    Quick function for generating single assets in Cursor
    Usage: quick_generate("my_asset", "a cute cat", width=256, height=256)
    """
    generator = ArtGenerator()
    return generator.generate_single_asset(asset_name, prompt, **kwargs)

def generate_module(module_name: str):
    """
    Quick function for generating entire modules in Cursor
    Usage: generate_module("shapes")
    """
    generator = ArtGenerator()
    return generator.generate_module_art(module_name)

def generate_card(module: str, item: str, **kwargs):
    """
    Quick function for generating individual cards
    Usage: generate_card("animals", "elephant", width=512, height=512)
    """
    generator = ArtGenerator()
    asset_name = f"{module}_{item}"
    
    # Create appropriate prompt based on module
    prompts = {
        'shapes': f"simple {item} shape, bright color, educational, child-friendly, clean design, no text",
        'colors': f"simple {item} color swatch, solid {item} background, educational, child-friendly, clean design",
        'animals': f"cute {item}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
        'jobs': f"friendly {item}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
        'farm': f"cute farm {item}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
        'family': f"friendly {item}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
    }
    
    prompt = prompts.get(module, f"educational {item}, child-friendly, bright colors, simple design")
    
    return generator.generate_single_asset(asset_name, prompt, **kwargs)

if __name__ == "__main__":
    main()