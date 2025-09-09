#!/usr/bin/env python3
"""
Quick Art Generator - On-the-fly art generation for Memory Match game
Use this tool to quickly generate individual art assets as needed.
"""

import requests
import os
import json
from pathlib import Path
from typing import Optional
import argparse
import sys

class QuickArtGenerator:
    """Quick art generator for immediate use in Memory Match game development."""
    
    def __init__(self, base_url: str = "https://pollinations.ai"):
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'QuickArtGenerator/1.0'
        })
    
    def generate_image(self, 
                      prompt: str, 
                      width: int = 512, 
                      height: int = 512,
                      model: str = "flux",
                      nologo: bool = True,
                      seed: Optional[int] = None,
                      output_path: Optional[str] = None) -> str:
        """
        Generate an image using Pollinations API and save it.
        
        Args:
            prompt: Text description of the image to generate
            width: Image width in pixels
            height: Image height in pixels
            model: AI model to use (flux, flux-dev, etc.)
            nologo: Remove Pollinations logo from generated images
            seed: Random seed for reproducible results
            output_path: Path to save the image (auto-generated if None)
            
        Returns:
            Path to the saved image
        """
        params = {
            'prompt': prompt,
            'width': width,
            'height': height,
            'model': model,
            'nologo': str(nologo).lower()
        }
        
        if seed is not None:
            params['seed'] = seed
            
        try:
            print(f"Generating image: {prompt[:50]}...")
            # Use correct Pollinations API format
            url_prompt = prompt.replace(' ', '_')
            param_string = '&'.join([f"{k}={v}" for k, v in params.items()])
            url = f"{self.base_url}/p/{url_prompt}?{param_string}"
            response = self.session.get(url, timeout=60)
            response.raise_for_status()
            
            # Generate output path if not provided
            if output_path is None:
                safe_prompt = "".join(c for c in prompt[:30] if c.isalnum() or c in (' ', '-', '_')).rstrip()
                safe_prompt = safe_prompt.replace(' ', '_')
                output_path = f"{safe_prompt}.png"
            
            # Ensure directory exists
            os.makedirs(os.path.dirname(output_path) if os.path.dirname(output_path) else '.', exist_ok=True)
            
            # Save image
            with open(output_path, 'wb') as f:
                f.write(response.content)
            
            print(f"Image saved: {output_path}")
            return output_path
            
        except requests.exceptions.RequestException as e:
            raise Exception(f"Failed to generate image: {e}")
    
    def generate_card(self, item_name: str, theme_style: str = "child-friendly cartoon", output_dir: str = "generated_cards") -> str:
        """Generate a memory game card for a specific item."""
        prompt = f"Simple, clear illustration of {item_name}, {theme_style}, bright colors, white background, centered, high contrast, no text"
        output_path = os.path.join(output_dir, f"{item_name.replace(' ', '_')}.png")
        return self.generate_image(prompt, 512, 512, output_path=output_path)
    
    def generate_background(self, theme: str, style: str = "child-friendly cartoon", output_dir: str = "generated_backgrounds") -> str:
        """Generate a background for a theme."""
        prompt = f"{theme} background, {style}, bright colors, 16:9 aspect ratio, landscape view"
        output_path = os.path.join(output_dir, f"{theme.replace(' ', '_')}_background.png")
        return self.generate_image(prompt, 1920, 1080, output_path=output_path)
    
    def generate_icon(self, item_name: str, theme_style: str = "child-friendly cartoon", output_dir: str = "generated_icons") -> str:
        """Generate an icon for theme selection."""
        prompt = f"Simple, clear icon of {item_name}, {theme_style}, bright colors, white background, centered, high contrast, square format"
        output_path = os.path.join(output_dir, f"{item_name.replace(' ', '_')}_icon.png")
        return self.generate_image(prompt, 256, 256, output_path=output_path)
    
    def generate_mascot(self, item_name: str, theme_style: str = "child-friendly cartoon", output_dir: str = "generated_mascots") -> str:
        """Generate a mascot character for background decoration."""
        prompt = f"Cute, friendly {item_name} character, {theme_style}, bright colors, transparent background, happy expression"
        output_path = os.path.join(output_dir, f"{item_name.replace(' ', '_')}_mascot.png")
        return self.generate_image(prompt, 256, 256, output_path=output_path)

def interactive_mode():
    """Interactive mode for generating art on demand."""
    generator = QuickArtGenerator()
    
    print("🎨 Quick Art Generator for Memory Match Game")
    print("=" * 50)
    
    while True:
        print("\nWhat would you like to generate?")
        print("1. Card (for memory matching)")
        print("2. Background (for theme)")
        print("3. Icon (for theme selection)")
        print("4. Mascot (for background decoration)")
        print("5. Custom image")
        print("6. Exit")
        
        choice = input("\nEnter your choice (1-6): ").strip()
        
        if choice == "6":
            print("Goodbye! 👋")
            break
        
        try:
            if choice == "1":
                item = input("Enter item name for the card: ").strip()
                if item:
                    style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                    output = generator.generate_card(item, style)
                    print(f"✅ Card generated: {output}")
            
            elif choice == "2":
                theme = input("Enter theme name: ").strip()
                if theme:
                    style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                    output = generator.generate_background(theme, style)
                    print(f"✅ Background generated: {output}")
            
            elif choice == "3":
                item = input("Enter item name for the icon: ").strip()
                if item:
                    style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                    output = generator.generate_icon(item, style)
                    print(f"✅ Icon generated: {output}")
            
            elif choice == "4":
                item = input("Enter item name for the mascot: ").strip()
                if item:
                    style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                    output = generator.generate_mascot(item, style)
                    print(f"✅ Mascot generated: {output}")
            
            elif choice == "5":
                prompt = input("Enter custom prompt: ").strip()
                if prompt:
                    width = int(input("Enter width (default: 512): ").strip() or "512")
                    height = int(input("Enter height (default: 512): ").strip() or "512")
                    output = generator.generate_image(prompt, width, height)
                    print(f"✅ Custom image generated: {output}")
            
            else:
                print("❌ Invalid choice. Please try again.")
        
        except Exception as e:
            print(f"❌ Error: {e}")

def main():
    """Main CLI interface."""
    parser = argparse.ArgumentParser(description="Quick Art Generator for Memory Match game")
    parser.add_argument("--card", help="Generate a card for the given item name")
    parser.add_argument("--background", help="Generate a background for the given theme")
    parser.add_argument("--icon", help="Generate an icon for the given item name")
    parser.add_argument("--mascot", help="Generate a mascot for the given item name")
    parser.add_argument("--custom", help="Generate a custom image with the given prompt")
    parser.add_argument("--width", type=int, default=512, help="Image width (default: 512)")
    parser.add_argument("--height", type=int, default=512, help="Image height (default: 512)")
    parser.add_argument("--output", "-o", help="Output file path")
    parser.add_argument("--interactive", "-i", action="store_true", help="Start interactive mode")
    
    args = parser.parse_args()
    
    generator = QuickArtGenerator()
    
    if args.interactive:
        interactive_mode()
        return
    
    try:
        if args.card:
            output = generator.generate_card(args.card)
            print(f"Card generated: {output}")
        
        elif args.background:
            output = generator.generate_background(args.background)
            print(f"Background generated: {output}")
        
        elif args.icon:
            output = generator.generate_icon(args.icon)
            print(f"Icon generated: {output}")
        
        elif args.mascot:
            output = generator.generate_mascot(args.mascot)
            print(f"Mascot generated: {output}")
        
        elif args.custom:
            output = generator.generate_image(args.custom, args.width, args.height, output_path=args.output)
            print(f"Custom image generated: {output}")
        
        else:
            parser.print_help()
    
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()