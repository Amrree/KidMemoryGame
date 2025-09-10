#!/usr/bin/env python3
"""
Example usage of Kid Memory Template Art Generator
Demonstrates all three tools and their capabilities
"""

import sys
import os
from pathlib import Path

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pollinations_client import ArtGenerator, ArtSpec
from cursor_art_generator import quick_generate, generate_module, generate_card
from full_branding_generator import FullBrandingGenerator

def example_cursor_tool():
    """Example usage of the Cursor on-the-fly tool"""
    print("🎨 Example: Cursor On-the-fly Tool")
    print("=" * 50)
    
    # Generate a single custom asset
    print("1. Generating custom asset...")
    success = quick_generate(
        name="example_elephant",
        prompt="a cute cartoon elephant, educational, child-friendly, bright colors",
        width=256,
        height=256
    )
    print(f"   Result: {'✅ Success' if success else '❌ Failed'}")
    
    # Generate a specific card
    print("\n2. Generating specific card...")
    success = generate_card(
        module="animals",
        item="elephant",
        width=512,
        height=512
    )
    print(f"   Result: {'✅ Success' if success else '❌ Failed'}")
    
    # Generate entire module
    print("\n3. Generating entire module...")
    results = generate_module("shapes")
    success_count = sum(1 for success in results.values() if success)
    total_count = len(results)
    print(f"   Result: {success_count}/{total_count} assets generated")

def example_cli_tool():
    """Example usage of the CLI tool"""
    print("\n🎨 Example: CLI Tool")
    print("=" * 50)
    
    # Simulate CLI commands
    print("CLI Commands you can run:")
    print("1. List modules:")
    print("   python3 cli_tool.py --list-modules")
    print("")
    print("2. List assets for shapes module:")
    print("   python3 cli_tool.py --list-assets --module shapes")
    print("")
    print("3. Generate entire shapes module:")
    print("   python3 cli_tool.py --module shapes")
    print("")
    print("4. Generate specific circle asset:")
    print("   python3 cli_tool.py --module shapes --asset circle")
    print("")
    print("5. Generate custom asset:")
    print("   python3 cli_tool.py --custom my_elephant --prompt 'a cute elephant'")
    print("")
    print("6. Generate with custom dimensions:")
    print("   python3 cli_tool.py --module shapes --asset circle --width 256 --height 256")

def example_full_branding():
    """Example usage of the full branding generator"""
    print("\n🎨 Example: Full Branding Generator")
    print("=" * 50)
    
    print("Full branding generator creates complete art assets for the entire app.")
    print("This includes:")
    print("- App icons in multiple sizes")
    print("- UI elements and components")
    print("- All module assets (shapes, colors, animals, etc.)")
    print("- Marketing materials")
    print("- Alternative color schemes")
    print("")
    print("To run the full branding generator:")
    print("  python3 full_branding_generator.py")
    print("")
    print("To run with custom output directory:")
    print("  python3 full_branding_generator.py --output my_branding")
    print("")
    print("To generate with manifest:")
    print("  python3 full_branding_generator.py --manifest")

def example_custom_generation():
    """Example of custom art generation"""
    print("\n🎨 Example: Custom Art Generation")
    print("=" * 50)
    
    generator = ArtGenerator(output_dir="example_output")
    
    # Generate a custom educational asset
    print("Generating custom educational asset...")
    success = generator.generate_single_asset(
        name="custom_math_symbol",
        prompt="plus sign, educational, child-friendly, bright colors, simple design, no text",
        width=256,
        height=256,
        background="transparent"
    )
    print(f"Result: {'✅ Success' if success else '❌ Failed'}")
    
    # Generate a custom background
    print("\nGenerating custom background...")
    success = generator.generate_single_asset(
        name="custom_background",
        prompt="educational classroom background, bright colors, child-friendly, clean design",
        width=1920,
        height=1080,
        background="colorful"
    )
    print(f"Result: {'✅ Success' if success else '❌ Failed'}")

def example_batch_operations():
    """Example of batch operations"""
    print("\n🎨 Example: Batch Operations")
    print("=" * 50)
    
    generator = ArtGenerator(output_dir="example_batch")
    
    # Create custom specs for batch generation
    custom_specs = [
        ArtSpec(
            name="math_plus",
            prompt="plus sign, educational, child-friendly, bright colors, simple design",
            width=128,
            height=128,
            background="transparent"
        ),
        ArtSpec(
            name="math_minus",
            prompt="minus sign, educational, child-friendly, bright colors, simple design",
            width=128,
            height=128,
            background="transparent"
        ),
        ArtSpec(
            name="math_equals",
            prompt="equals sign, educational, child-friendly, bright colors, simple design",
            width=128,
            height=128,
            background="transparent"
        ),
    ]
    
    print("Generating batch of math symbols...")
    results = generator.client.generate_batch(custom_specs, "example_batch/math")
    
    success_count = sum(1 for success in results.values() if success)
    total_count = len(results)
    print(f"Result: {success_count}/{total_count} assets generated successfully")

def main():
    """Run all examples"""
    print("🎨 Kid Memory Template Art Generator - Examples")
    print("=" * 60)
    
    # Run examples
    example_cursor_tool()
    example_cli_tool()
    example_full_branding()
    example_custom_generation()
    example_batch_operations()
    
    print("\n🎉 Examples completed!")
    print("\n📚 Next Steps:")
    print("1. Run the installation script: ./install.sh")
    print("2. Test the API: python3 test_api.py")
    print("3. Generate some art: python3 cli_tool.py --module shapes")
    print("4. Read the full documentation: README.md")

if __name__ == "__main__":
    main()