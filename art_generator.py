#!/usr/bin/env python3
"""
Memory Match Game Art Generator using Pollinations API
Generates all art assets needed for the kids' memory game themes.
"""

import requests
import json
import os
import hashlib
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import argparse
import sys
from datetime import datetime

class PollinationsArtGenerator:
    """Art generator using Pollinations API for Memory Match game assets."""
    
    def __init__(self, base_url: str = "https://pollinations.ai"):
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'MemoryMatchArtGenerator/1.0'
        })
    
    def generate_image(self, 
                      prompt: str, 
                      width: int = 512, 
                      height: int = 512,
                      model: str = "flux",
                      nologo: bool = True,
                      seed: Optional[int] = None) -> bytes:
        """
        Generate an image using Pollinations API.
        
        Args:
            prompt: Text description of the image to generate
            width: Image width in pixels
            height: Image height in pixels
            model: AI model to use (flux, flux-dev, etc.)
            nologo: Remove Pollinations logo from generated images
            seed: Random seed for reproducible results
            
        Returns:
            Image data as bytes
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
            # Use correct Pollinations API format
            url_prompt = prompt.replace(' ', '_')
            url = f"{self.base_url}/p/{url_prompt}?{param_string}"
            response = self.session.get(url, timeout=60)
            response.raise_for_status()
            return response.content
        except requests.exceptions.RequestException as e:
            raise Exception(f"Failed to generate image: {e}")
    
    def save_image(self, image_data: bytes, filepath: str) -> None:
        """Save image data to file."""
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'wb') as f:
            f.write(image_data)
    
    def calculate_hash(self, filepath: str) -> str:
        """Calculate SHA256 hash of a file."""
        hash_sha256 = hashlib.sha256()
        with open(filepath, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_sha256.update(chunk)
        return hash_sha256.hexdigest()

class MemoryMatchThemeGenerator:
    """Generates complete theme packages for Memory Match game."""
    
    def __init__(self, output_dir: str = "generated_themes"):
        self.generator = PollinationsArtGenerator()
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
        # Theme configurations
        self.themes = {
            "space": {
                "name": "Space Adventure",
                "background_prompt": "Colorful space background with stars, planets, and nebula, child-friendly cartoon style, bright colors, 16:9 aspect ratio",
                "cards": [
                    "rocket", "astronaut", "planet", "moon", "star", "comet", 
                    "satellite", "space_station", "alien", "spaceship", "meteor", 
                    "galaxy", "telescope", "mars_rover", "space_shuttle", "asteroid"
                ],
                "mascot_cards": ["rocket", "astronaut", "planet", "alien"]
            },
            "jungle": {
                "name": "Jungle Animals",
                "background_prompt": "Lush jungle background with trees, vines, and tropical plants, child-friendly cartoon style, bright green colors, 16:9 aspect ratio",
                "cards": [
                    "tiger", "elephant", "monkey", "parrot", "snake", "frog",
                    "butterfly", "toucan", "sloth", "jaguar", "panda", "koala",
                    "giraffe", "zebra", "lion", "hippo", "rhino", "cheetah"
                ],
                "mascot_cards": ["tiger", "elephant", "monkey", "parrot"]
            },
            "underwater": {
                "name": "Underwater World",
                "background_prompt": "Underwater ocean background with coral reefs, seaweed, and bubbles, child-friendly cartoon style, blue and teal colors, 16:9 aspect ratio",
                "cards": [
                    "fish", "shark", "whale", "dolphin", "octopus", "crab",
                    "starfish", "jellyfish", "seahorse", "turtle", "lobster",
                    "squid", "penguin", "seal", "walrus", "sea_lion", "ray"
                ],
                "mascot_cards": ["fish", "shark", "whale", "dolphin"]
            },
            "fairy_tale": {
                "name": "Fairy Tale",
                "background_prompt": "Magical fairy tale background with castle, forest, and rainbow, child-friendly cartoon style, pastel colors, 16:9 aspect ratio",
                "cards": [
                    "princess", "prince", "dragon", "fairy", "unicorn", "knight",
                    "wizard", "witch", "troll", "elf", "dwarf", "giant",
                    "magic_wand", "crown", "castle", "horse", "carriage", "sword"
                ],
                "mascot_cards": ["princess", "dragon", "fairy", "unicorn"]
            },
            "construction": {
                "name": "Construction Site",
                "background_prompt": "Construction site background with buildings, cranes, and construction equipment, child-friendly cartoon style, orange and yellow colors, 16:9 aspect ratio",
                "cards": [
                    "excavator", "bulldozer", "crane", "dump_truck", "cement_mixer",
                    "steamroller", "forklift", "loader", "backhoe", "grader",
                    "compactor", "paver", "drill", "hammer", "saw", "wrench"
                ],
                "mascot_cards": ["excavator", "crane", "dump_truck", "bulldozer"]
            }
        }
    
    def generate_theme(self, theme_id: str, custom_cards: Optional[List[str]] = None) -> Dict:
        """Generate a complete theme package."""
        if theme_id not in self.themes:
            raise ValueError(f"Theme '{theme_id}' not found. Available themes: {list(self.themes.keys())}")
        
        theme_config = self.themes[theme_id]
        theme_dir = self.output_dir / theme_id
        theme_dir.mkdir(exist_ok=True)
        cards_dir = theme_dir / "cards"
        cards_dir.mkdir(exist_ok=True)
        
        print(f"Generating theme: {theme_config['name']}")
        
        # Generate background
        print("  Generating background...")
        background_data = self.generator.generate_image(
            prompt=theme_config["background_prompt"],
            width=1920,
            height=1080,
            model="flux"
        )
        background_path = theme_dir / "background.png"
        self.generator.save_image(background_data, str(background_path))
        
        # Generate cards
        cards_to_generate = custom_cards if custom_cards else theme_config["cards"]
        card_paths = []
        
        print(f"  Generating {len(cards_to_generate)} cards...")
        for i, card_name in enumerate(cards_to_generate):
            print(f"    {i+1}/{len(cards_to_generate)}: {card_name}")
            card_prompt = f"Simple, clear illustration of {card_name}, child-friendly cartoon style, bright colors, white background, centered, high contrast"
            card_data = self.generator.generate_image(
                prompt=card_prompt,
                width=512,
                height=512,
                model="flux",
                seed=i  # Consistent generation
            )
            card_path = cards_dir / f"{card_name}.png"
            self.generator.save_image(card_data, str(card_path))
            card_paths.append(f"cards/{card_name}.png")
        
        # Generate theme icon (use first card as icon)
        icon_path = cards_dir / f"{cards_to_generate[0]}.png"
        
        # Generate mascot configurations
        mascots = []
        for i, mascot_card in enumerate(theme_config["mascot_cards"]):
            if mascot_card in cards_to_generate:
                mascots.append({
                    "image": f"cards/{mascot_card}.png",
                    "rotation": i * 15,  # Vary rotation
                    "y": 500 + (i * 100)  # Vary vertical position
                })
        
        # Create theme.json
        theme_json = {
            "id": theme_id,
            "name": theme_config["name"],
            "background": "background.png",
            "cards": card_paths,
            "icon": f"cards/{cards_to_generate[0]}.png",
            "mascots": mascots,
            "hash": ""  # Will be calculated after generation
        }
        
        # Save theme.json
        theme_json_path = theme_dir / "theme.json"
        with open(theme_json_path, 'w') as f:
            json.dump(theme_json, f, indent=2)
        
        # Calculate hash
        theme_hash = self.generator.calculate_hash(str(theme_json_path))
        theme_json["hash"] = theme_hash
        
        # Update theme.json with hash
        with open(theme_json_path, 'w') as f:
            json.dump(theme_json, f, indent=2)
        
        # Create name.txt and icon.txt files
        with open(theme_dir / "name.txt", 'w') as f:
            f.write(theme_config["name"])
        
        with open(theme_dir / "icon.txt", 'w') as f:
            f.write(f"cards/{cards_to_generate[0]}.png")
        
        print(f"  Theme generated successfully: {theme_dir}")
        return theme_json
    
    def generate_all_themes(self) -> None:
        """Generate all predefined themes."""
        for theme_id in self.themes.keys():
            try:
                self.generate_theme(theme_id)
            except Exception as e:
                print(f"Error generating theme {theme_id}: {e}")
    
    def list_available_themes(self) -> List[str]:
        """List all available theme IDs."""
        return list(self.themes.keys())

def main():
    """Main CLI interface."""
    parser = argparse.ArgumentParser(description="Generate art assets for Memory Match game")
    parser.add_argument("--theme", "-t", help="Theme ID to generate")
    parser.add_argument("--all", "-a", action="store_true", help="Generate all themes")
    parser.add_argument("--list", "-l", action="store_true", help="List available themes")
    parser.add_argument("--output", "-o", default="generated_themes", help="Output directory")
    parser.add_argument("--cards", "-c", nargs="+", help="Custom card names for theme")
    
    args = parser.parse_args()
    
    generator = MemoryMatchThemeGenerator(args.output)
    
    if args.list:
        themes = generator.list_available_themes()
        print("Available themes:")
        for theme in themes:
            print(f"  - {theme}: {generator.themes[theme]['name']}")
        return
    
    if args.all:
        generator.generate_all_themes()
    elif args.theme:
        generator.generate_theme(args.theme, args.cards)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()