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
        self.generator = ArtGenerator()
        
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
            
        try:
            if module == 'all':
                results = self.generator.generate_all_art()
                success_count = sum(
                    sum(1 for success in assets.values() if success) 
                    for assets in results.values()
                )
                total_count = sum(len(assets) for assets in results.values())
                print(f"✅ Generated {success_count}/{total_count} assets across all modules")
                return success_count == total_count
            else:
                results = self.generator.generate_module_art(module)
                success_count = sum(1 for success in results.values() if success)
                total_count = len(results)
                print(f"✅ Generated {success_count}/{total_count} assets for {module} module")
                return success_count == total_count
        except Exception as e:
            print(f"❌ Error generating {module} module: {e}")
            return False
    
    def generate_asset(self, module: str, asset: str, output_dir: Optional[str] = None, **kwargs) -> bool:
        """Generate a specific asset"""
        if output_dir:
            self.generator.output_dir = output_dir
            
        try:
            asset_name = f"{module}_{asset}"
            
            # Create appropriate prompt based on module and asset
            prompt = self._create_prompt(module, asset)
            
            success = self.generator.generate_single_asset(
                name=asset_name,
                prompt=prompt,
                **kwargs
            )
            
            if success:
                print(f"✅ Generated {asset_name}")
            else:
                print(f"❌ Failed to generate {asset_name}")
                
            return success
        except Exception as e:
            print(f"❌ Error generating {asset_name}: {e}")
            return False
    
    def generate_custom(self, name: str, prompt: str, output_dir: Optional[str] = None, **kwargs) -> bool:
        """Generate a custom asset with user-provided prompt"""
        if output_dir:
            self.generator.output_dir = output_dir
            
        try:
            success = self.generator.generate_single_asset(
                name=name,
                prompt=prompt,
                **kwargs
            )
            
            if success:
                print(f"✅ Generated custom asset: {name}")
            else:
                print(f"❌ Failed to generate custom asset: {name}")
                
            return success
        except Exception as e:
            print(f"❌ Error generating custom asset {name}: {e}")
            return False
    
    def _create_prompt(self, module: str, asset: str) -> str:
        """Create appropriate prompt for module and asset"""
        prompts = {
            'shapes': {
                'icon': 'geometric shapes icon, circle square triangle, colorful, educational, simple design',
                'background': 'colorful geometric shapes background, educational theme, soft pastel colors, clean design',
                'circle': 'simple circle shape, bright color, educational, child-friendly, clean design, no text',
                'square': 'simple square shape, bright color, educational, child-friendly, clean design, no text',
                'triangle': 'simple triangle shape, bright color, educational, child-friendly, clean design, no text',
                'rectangle': 'simple rectangle shape, bright color, educational, child-friendly, clean design, no text',
                'star': 'simple star shape, bright color, educational, child-friendly, clean design, no text',
                'heart': 'simple heart shape, bright color, educational, child-friendly, clean design, no text',
            },
            'colors': {
                'icon': 'colorful palette icon, paint brush, educational, bright colors, simple design',
                'background': 'colorful paint splashes background, rainbow colors, educational theme, artistic',
                'red': 'simple red color swatch, solid red background, educational, child-friendly, clean design',
                'blue': 'simple blue color swatch, solid blue background, educational, child-friendly, clean design',
                'green': 'simple green color swatch, solid green background, educational, child-friendly, clean design',
                'yellow': 'simple yellow color swatch, solid yellow background, educational, child-friendly, clean design',
                'orange': 'simple orange color swatch, solid orange background, educational, child-friendly, clean design',
                'purple': 'simple purple color swatch, solid purple background, educational, child-friendly, clean design',
            },
            'animals': {
                'icon': 'cute animals icon, cat dog bird, colorful, educational, child-friendly design',
                'background': 'zoo background, animals in nature, educational theme, bright colors, child-friendly',
                'cat': 'cute cat, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'dog': 'cute dog, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'bird': 'cute bird, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'fish': 'cute fish, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'rabbit': 'cute rabbit, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'butterfly': 'cute butterfly, cartoon style, educational, child-friendly, bright colors, simple design, no text',
            },
            'jobs': {
                'icon': 'professions icon, doctor teacher firefighter, colorful, educational, child-friendly design',
                'background': 'workplace background, various professions, educational theme, bright colors, child-friendly',
                'doctor': 'friendly doctor, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'teacher': 'friendly teacher, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'firefighter': 'friendly firefighter, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'chef': 'friendly chef, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'police': 'friendly police officer, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'artist': 'friendly artist, cartoon style, educational, child-friendly, bright colors, simple design, no text',
            },
            'farm': {
                'icon': 'farm animals icon, cow pig chicken, colorful, educational, child-friendly design',
                'background': 'farm background, barn and fields, educational theme, bright colors, child-friendly',
                'cow': 'cute farm cow, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'pig': 'cute farm pig, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'chicken': 'cute farm chicken, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'horse': 'cute farm horse, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'sheep': 'cute farm sheep, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'duck': 'cute farm duck, cartoon style, educational, child-friendly, bright colors, simple design, no text',
            },
            'family': {
                'icon': 'family icon, mom dad children, colorful, educational, child-friendly design',
                'background': 'family home background, cozy house, educational theme, bright colors, child-friendly',
                'mom': 'friendly mom, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'dad': 'friendly dad, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'grandma': 'friendly grandma, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'grandpa': 'friendly grandpa, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'sister': 'friendly sister, cartoon style, educational, child-friendly, bright colors, simple design, no text',
                'brother': 'friendly brother, cartoon style, educational, child-friendly, bright colors, simple design, no text',
            },
            'ui': {
                'card_back': 'card back design, memory game, educational, child-friendly, bright colors, simple pattern',
                'app_icon': 'memory game app icon, brain puzzle, educational, child-friendly, bright colors, simple design',
                'button_primary': 'educational game button, rounded corners, bright colors, child-friendly, simple design, no text',
                'button_secondary': 'educational game button, rounded corners, pastel colors, child-friendly, simple design, no text',
            }
        }
        
        return prompts.get(module, {}).get(asset, f"educational {asset}, child-friendly, bright colors, simple design")

def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description='Kid Memory Template Art Generator CLI',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate all art for shapes module
  python cli_tool.py --module shapes

  # Generate specific asset
  python cli_tool.py --module shapes --asset circle

  # Generate custom asset
  python cli_tool.py --custom "my_asset" --prompt "a cute elephant"

  # List available modules
  python cli_tool.py --list-modules

  # List assets for a module
  python cli_tool.py --list-assets --module shapes

  # Generate with custom dimensions
  python cli_tool.py --module shapes --asset circle --width 256 --height 256
        """
    )
    
    # Main commands
    parser.add_argument('--module', '-m', choices=['shapes', 'colors', 'animals', 'jobs', 'farm', 'family', 'ui', 'all'],
                       help='Module to generate art for')
    parser.add_argument('--asset', '-a', help='Specific asset to generate')
    parser.add_argument('--custom', help='Custom asset name')
    parser.add_argument('--prompt', '-p', help='Custom prompt for asset generation')
    
    # List commands
    parser.add_argument('--list-modules', action='store_true', help='List available modules')
    parser.add_argument('--list-assets', action='store_true', help='List available assets for a module')
    
    # Generation options
    parser.add_argument('--output', '-o', default='generated_assets', help='Output directory')
    parser.add_argument('--width', '-w', type=int, default=512, help='Image width')
    parser.add_argument('--height', '-h', type=int, default=512, help='Image height')
    parser.add_argument('--style', '-s', default='cartoon', help='Art style')
    parser.add_argument('--background', '-b', default='transparent', 
                       choices=['transparent', 'white', 'colorful'], help='Background type')
    
    args = parser.parse_args()
    
    cli = ArtGeneratorCLI()
    
    # Handle list commands
    if args.list_modules:
        modules = cli.list_modules()
        print("Available modules:")
        for module in modules:
            print(f"  - {module}")
        return
    
    if args.list_assets:
        if not args.module:
            print("Error: --module is required when using --list-assets")
            return
        assets = cli.list_assets(args.module)
        print(f"Available assets for {args.module} module:")
        for asset in assets:
            print(f"  - {asset}")
        return
    
    # Validate arguments
    if not any([args.module, args.custom]):
        print("Error: Must specify either --module or --custom")
        parser.print_help()
        return
    
    if args.custom and not args.prompt:
        print("Error: --prompt is required when using --custom")
        return
    
    # Generate art
    try:
        if args.custom:
            # Generate custom asset
            success = cli.generate_custom(
                name=args.custom,
                prompt=args.prompt,
                output_dir=args.output,
                width=args.width,
                height=args.height,
                style=args.style,
                background=args.background
            )
        elif args.asset:
            # Generate specific asset
            success = cli.generate_asset(
                module=args.module,
                asset=args.asset,
                output_dir=args.output,
                width=args.width,
                height=args.height,
                style=args.style,
                background=args.background
            )
        else:
            # Generate entire module
            success = cli.generate_module(
                module=args.module,
                output_dir=args.output
            )
        
        if success:
            print(f"🎉 Art generation completed successfully!")
            print(f"📁 Output directory: {args.output}")
        else:
            print("❌ Art generation failed")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\n⏹️  Art generation cancelled by user")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()