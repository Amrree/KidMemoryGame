#!/usr/bin/env python3
"""
Kid Memory Template Art Generator CLI Tool
Command-line interface for generating art assets using Pollinations API
"""

import argparse
import sys
import os
from pathlib import Path
from typing import List, Optional

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pollinations_client import ArtGenerator, ArtSpec

class ArtGeneratorCLI:
    """Command-line interface for art generation"""
    
    def __init__(self):
        self.generator = ArtGenerator(output_dir='/workspace/tarot_book_output')
        
    def list_modules(self) -> List[str]:
        """List available modules"""
        return ['shapes', 'colors', 'animals', 'jobs', 'farm', 'family', 'ui', 'all']
    
    def list_assets(self, module: str) -> List[str]:
        """List available assets for a module"""
        if module == 'shapes':
            return ['icon', 'background', 'circle', 'square', 'triangle', 'rectangle', 'star', 'heart']
        elif module == 'colors':
            return ['icon', 'background', 'red', 'blue', 'green', 'yellow', 'orange', 'purple']
        elif module == 'animals':
            return ['icon', 'background', 'cat', 'dog', 'bird', 'fish', 'rabbit', 'butterfly']
        elif module == 'jobs':
            return ['icon', 'background', 'doctor', 'teacher', 'firefighter', 'chef', 'police', 'artist']
        elif module == 'farm':
            return ['icon', 'background', 'cow', 'pig', 'chicken', 'horse', 'sheep', 'duck']
        elif module == 'family':
            return ['icon', 'background', 'mom', 'dad', 'grandma', 'grandpa', 'sister', 'brother']
        elif module == 'ui':
            return ['card_back', 'app_icon', 'button_primary', 'button_secondary']
        else:
            return []
    
    def generate_module(self, module: str, output_dir: Optional[str] = None) -> bool:
        """Generate all assets for a module"""
        if output_dir:
            self.generator.output_dir = output_dir
            
        if module == 'all':
            return self.generator.generate_all_modules()
        else:
            return self.generator.generate_module(module)
    
    def generate_asset(self, module: str, asset: str, output_dir: Optional[str] = None, 
                      width: int = 512, height: int = 512) -> bool:
        """Generate a specific asset"""
        if output_dir:
            self.generator.output_dir = output_dir
            
        return self.generator.generate_card(module, asset, width, height)
    
    def generate_custom(self, name: str, prompt: str, output_dir: Optional[str] = None,
                       width: int = 512, height: int = 512) -> bool:
        """Generate a custom asset"""
        if output_dir:
            self.generator.output_dir = output_dir
            
        return self.generator.generate_single_asset(name, prompt, width, height)

def main():
    parser = argparse.ArgumentParser(description='Kid Memory Template Art Generator CLI')
    
    # List options
    parser.add_argument('--list-modules', action='store_true', help='List available modules')
    parser.add_argument('--list-assets', action='store_true', help='List assets for a module')
    
    # Generation options
    parser.add_argument('--module', '-m', help='Module to generate')
    parser.add_argument('--asset', '-a', help='Specific asset to generate')
    parser.add_argument('--custom', '-c', help='Custom asset name')
    parser.add_argument('--prompt', '-p', help='Custom generation prompt')
    
    # Output options
    parser.add_argument('--output', '-o', default='/workspace/tarot_book_output', help='Output directory')
    parser.add_argument('--width', '-w', type=int, default=512, help='Image width')
    parser.add_argument('--height', '--height', type=int, default=512, help='Image height')
    
    # Control options
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be generated')
    
    args = parser.parse_args()
    
    cli = ArtGeneratorCLI()
    
    # Handle list operations
    if args.list_modules:
        modules = cli.list_modules()
        print("Available modules:")
        for module in modules:
            print(f"  - {module}")
        return
    
    if args.list_assets:
        if not args.module:
            print("Error: --module required when using --list-assets")
            return
        assets = cli.list_assets(args.module)
        print(f"Available assets for '{args.module}':")
        for asset in assets:
            print(f"  - {asset}")
        return
    
    # Handle generation operations
    if args.custom and args.prompt:
        print(f"🎨 Generating custom asset: {args.custom}")
        if args.dry_run:
            print(f"Would generate: {args.custom} with prompt: {args.prompt}")
            return
        success = cli.generate_custom(args.custom, args.prompt, args.output, args.width, args.height)
        if success:
            print(f"✅ Successfully generated {args.custom}")
        else:
            print(f"❌ Failed to generate {args.custom}")
            
    elif args.module and args.asset:
        print(f"🎨 Generating asset: {args.module}/{args.asset}")
        if args.dry_run:
            print(f"Would generate: {args.module}/{args.asset}")
            return
        success = cli.generate_asset(args.module, args.asset, args.output, args.width, args.height)
        if success:
            print(f"✅ Successfully generated {args.module}/{args.asset}")
        else:
            print(f"❌ Failed to generate {args.module}/{args.asset}")
            
    elif args.module:
        print(f"🎨 Generating module: {args.module}")
        if args.dry_run:
            print(f"Would generate entire module: {args.module}")
            return
        success = cli.generate_module(args.module, args.output)
        if success:
            print(f"✅ Successfully generated {args.module} module")
        else:
            print(f"❌ Failed to generate {args.module} module")
            
    else:
        parser.print_help()

if __name__ == "__main__":
    main()