#!/usr/bin/env python3
"""
Complete Branding Generator for Memory Match Game
Regenerates all existing themes and creates new ones using Pollinations API.
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
import shutil

class CompleteBrandingGenerator:
    """Complete branding generator for Memory Match game using Pollinations API."""
    
    def __init__(self, base_url: str = "https://pollinations.ai"):
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'CompleteBrandingGenerator/1.0'
        })
        
        # Define all existing and new themes
        self.all_themes = {
            # Existing themes (regenerate with new art)
            "sea": {
                "name": "Sea Creatures",
                "background_prompt": "Underwater ocean background with coral reefs, seaweed, and bubbles, child-friendly cartoon style, bright blue and teal colors, 16:9 aspect ratio",
                "cards": [
                    "anglerfish", "blue-tang", "clownfish", "crab", "dolphin", "giant-clam",
                    "hammerhead", "horsefish", "jellyfish", "lobster", "manta-ray", "moray-eel",
                    "octopus", "orca", "penguin", "pufflefish", "sea-snail", "sea-urchin",
                    "sea_lion", "seal", "shark", "starfish", "swordfish", "turtle"
                ],
                "mascot_cards": ["dolphin", "hammerhead", "jellyfish", "lobster", "penguin", "starfish"]
            },
            "dinosaurs": {
                "name": "Dinosaurs",
                "background_prompt": "Prehistoric landscape with volcanoes, palm trees, and ancient rocks, child-friendly cartoon style, bright earth tones, 16:9 aspect ratio",
                "cards": [
                    "ankylosaurus", "brachiosaurus", "carnotaurus", "dilophosaurus", "pachycephalosaurus",
                    "parasaurolophus", "pterodactylus", "spinosaurus", "stegosaurus", "t-rex",
                    "triceratops", "velociraptor"
                ],
                "mascot_cards": ["pterodactylus", "t-rex", "velociraptor"]
            },
            "fruit": {
                "name": "Fruit",
                "background_prompt": "Colorful fruit market background with baskets, crates, and fresh fruits, child-friendly cartoon style, bright rainbow colors, 16:9 aspect ratio",
                "cards": [
                    "apple", "banana", "orange", "grape", "strawberry", "pineapple",
                    "watermelon", "cherry", "peach", "pear", "lemon", "lime",
                    "blueberry", "raspberry", "blackberry", "kiwi", "mango", "papaya"
                ],
                "mascot_cards": ["apple", "banana", "orange", "strawberry"]
            },
            "colours": {
                "name": "Colours",
                "background_prompt": "Rainbow background with colorful paint splashes and art supplies, child-friendly cartoon style, bright rainbow colors, 16:9 aspect ratio",
                "cards": [
                    "black", "blue", "brown", "gray", "green", "orange",
                    "pink", "purple", "red", "white", "yellow"
                ],
                "mascot_cards": ["red", "blue", "green", "yellow"]
            },
            "farm_animals": {
                "name": "Farm Animals",
                "background_prompt": "Farm landscape with barn, fields, and farm buildings, child-friendly cartoon style, bright green and brown colors, 16:9 aspect ratio",
                "cards": [
                    "bee", "cat", "chicken", "cow", "dog", "donkey",
                    "duck", "goat", "goose", "horse", "pig", "rabbit",
                    "rooster", "sheep", "turkey"
                ],
                "mascot_cards": ["bee", "goose", "pig"]
            },
            "city_vehicles": {
                "name": "City Vehicles",
                "background_prompt": "City street background with buildings, roads, and urban elements, child-friendly cartoon style, bright city colors, 16:9 aspect ratio",
                "cards": [
                    "ambulance", "car", "city_bus", "dump_truck", "excavator", "fire_truck",
                    "garbage_truck", "ice_cream_truck", "metro", "motorcycle", "police",
                    "post_office", "snowplow", "street_sweeper", "taxi", "tow_truck", "tram"
                ],
                "mascot_cards": ["ambulance", "car", "fire_truck", "metro"]
            },
            "zoo": {
                "name": "ZOO",
                "background_prompt": "Zoo background with animal enclosures, trees, and zoo buildings, child-friendly cartoon style, bright natural colors, 16:9 aspect ratio",
                "cards": [
                    "giraffe", "elephant", "lion", "tiger", "zebra", "monkey",
                    "penguin", "bear", "kangaroo", "hippo", "rhino", "cheetah",
                    "panda", "koala", "flamingo", "peacock", "parrot", "snake"
                ],
                "mascot_cards": ["giraffe", "elephant", "lion", "penguin"]
            },
            
            # New themes
            "space_adventure": {
                "name": "Space Adventure",
                "background_prompt": "Colorful space background with stars, planets, and nebula, child-friendly cartoon style, bright cosmic colors, 16:9 aspect ratio",
                "cards": [
                    "rocket", "astronaut", "planet", "moon", "star", "comet",
                    "satellite", "space_station", "alien", "spaceship", "meteor",
                    "galaxy", "telescope", "mars_rover", "space_shuttle", "asteroid", "nebula"
                ],
                "mascot_cards": ["rocket", "astronaut", "planet", "alien"]
            },
            "jungle_animals": {
                "name": "Jungle Animals",
                "background_prompt": "Lush jungle background with trees, vines, and tropical plants, child-friendly cartoon style, bright green colors, 16:9 aspect ratio",
                "cards": [
                    "tiger", "elephant", "monkey", "parrot", "snake", "frog",
                    "butterfly", "toucan", "sloth", "jaguar", "panda", "koala",
                    "giraffe", "zebra", "lion", "hippo", "rhino", "cheetah"
                ],
                "mascot_cards": ["tiger", "elephant", "monkey", "parrot"]
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
            "construction_site": {
                "name": "Construction Site",
                "background_prompt": "Construction site background with buildings, cranes, and construction equipment, child-friendly cartoon style, orange and yellow colors, 16:9 aspect ratio",
                "cards": [
                    "excavator", "bulldozer", "crane", "dump_truck", "cement_mixer",
                    "steamroller", "forklift", "loader", "backhoe", "grader",
                    "compactor", "paver", "drill", "hammer", "saw", "wrench"
                ],
                "mascot_cards": ["excavator", "crane", "dump_truck", "bulldozer"]
            },
            "underwater_world": {
                "name": "Underwater World",
                "background_prompt": "Underwater ocean background with coral reefs, seaweed, and bubbles, child-friendly cartoon style, blue and teal colors, 16:9 aspect ratio",
                "cards": [
                    "fish", "shark", "whale", "dolphin", "octopus", "crab",
                    "starfish", "jellyfish", "seahorse", "turtle", "lobster",
                    "squid", "penguin", "seal", "walrus", "sea_lion", "ray"
                ],
                "mascot_cards": ["fish", "shark", "whale", "dolphin"]
            },
            "weather": {
                "name": "Weather",
                "background_prompt": "Weather background with clouds, sun, rain, and weather elements, child-friendly cartoon style, bright sky colors, 16:9 aspect ratio",
                "cards": [
                    "sun", "cloud", "rain", "snow", "lightning", "rainbow",
                    "wind", "storm", "fog", "tornado", "hurricane", "blizzard",
                    "hail", "sleet", "frost", "dew", "mist", "breeze"
                ],
                "mascot_cards": ["sun", "cloud", "rain", "rainbow"]
            }
        }
    
    def generate_image(self, 
                      prompt: str, 
                      width: int = 512, 
                      height: int = 512,
                      model: str = "flux",
                      nologo: bool = True,
                      seed: Optional[int] = None) -> bytes:
        """Generate an image using Pollinations API."""
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
            param_string = '&'.join([f"{k}={v}" for k, v in params.items()])
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
    
    def backup_existing_themes(self, backup_dir: str = "themes_backup") -> None:
        """Backup existing themes before regeneration."""
        if os.path.exists("themes"):
            backup_path = Path(backup_dir)
            backup_path.mkdir(exist_ok=True)
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_timestamped = backup_path / f"themes_{timestamp}"
            shutil.copytree("themes", backup_timestamped)
            print(f"✅ Existing themes backed up to: {backup_timestamped}")
    
    def generate_theme(self, theme_id: str, output_dir: str = "themes") -> Dict:
        """Generate a complete theme package."""
        if theme_id not in self.all_themes:
            raise ValueError(f"Theme '{theme_id}' not found. Available themes: {list(self.all_themes.keys())}")
        
        theme_config = self.all_themes[theme_id]
        theme_dir = Path(output_dir) / theme_id
        theme_dir.mkdir(exist_ok=True)
        cards_dir = theme_dir / "cards"
        cards_dir.mkdir(exist_ok=True)
        
        print(f"🎨 Generating theme: {theme_config['name']}")
        
        # Generate background
        print("  📸 Generating background...")
        background_data = self.generate_image(
            prompt=theme_config["background_prompt"],
            width=1920,
            height=1080,
            model="flux"
        )
        background_path = theme_dir / "background.png"
        self.save_image(background_data, str(background_path))
        
        # Generate cards
        cards_to_generate = theme_config["cards"]
        card_paths = []
        
        print(f"  🃏 Generating {len(cards_to_generate)} cards...")
        for i, card_name in enumerate(cards_to_generate):
            print(f"    {i+1:2d}/{len(cards_to_generate)}: {card_name}")
            card_prompt = f"Simple, clear illustration of {card_name}, child-friendly cartoon style, bright colors, white background, centered, high contrast, no text, clean design"
            card_data = self.generate_image(
                prompt=card_prompt,
                width=512,
                height=512,
                model="flux",
                seed=i  # Consistent generation
            )
            card_path = cards_dir / f"{card_name}.png"
            self.save_image(card_data, str(card_path))
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
        theme_hash = self.calculate_hash(str(theme_json_path))
        theme_json["hash"] = theme_hash
        
        # Update theme.json with hash
        with open(theme_json_path, 'w') as f:
            json.dump(theme_json, f, indent=2)
        
        # Create name.txt and icon.txt files
        with open(theme_dir / "name.txt", 'w') as f:
            f.write(theme_config["name"])
        
        with open(theme_dir / "icon.txt", 'w') as f:
            f.write(f"cards/{cards_to_generate[0]}.png")
        
        print(f"  ✅ Theme generated successfully: {theme_dir}")
        return theme_json
    
    def generate_all_themes(self, output_dir: str = "themes", backup: bool = True) -> None:
        """Generate all themes (existing + new)."""
        if backup:
            self.backup_existing_themes()
        
        print("🚀 Starting complete theme generation...")
        print(f"📁 Output directory: {output_dir}")
        print(f"🎯 Total themes to generate: {len(self.all_themes)}")
        print("=" * 60)
        
        generated_themes = []
        failed_themes = []
        
        for i, theme_id in enumerate(self.all_themes.keys(), 1):
            try:
                print(f"\n[{i}/{len(self.all_themes)}] Processing theme: {theme_id}")
                theme_json = self.generate_theme(theme_id, output_dir)
                generated_themes.append(theme_id)
            except Exception as e:
                print(f"❌ Error generating theme {theme_id}: {e}")
                failed_themes.append(theme_id)
        
        # Update main themes.json
        self.update_main_themes_json(output_dir)
        
        print("\n" + "=" * 60)
        print("🎉 Generation complete!")
        print(f"✅ Successfully generated: {len(generated_themes)} themes")
        if failed_themes:
            print(f"❌ Failed themes: {len(failed_themes)}")
            for theme in failed_themes:
                print(f"   - {theme}")
        
        print(f"\n📁 All themes saved to: {output_dir}")
    
    def update_main_themes_json(self, themes_dir: str = "themes") -> None:
        """Update the main themes.json file with all generated themes."""
        themes_json_path = Path(themes_dir) / "themes.json"
        themes_list = []
        
        for theme_id in self.all_themes.keys():
            theme_dir = Path(themes_dir) / theme_id
            theme_json_path = theme_dir / "theme.json"
            
            if theme_json_path.exists():
                with open(theme_json_path, 'r') as f:
                    theme_data = json.load(f)
                
                themes_list.append({
                    "id": theme_data["id"],
                    "name": theme_data["name"],
                    "configPath": f"{theme_id}/theme.json",
                    "icon": theme_data["icon"],
                    "hash": theme_data["hash"]
                })
        
        # Save main themes.json
        with open(themes_json_path, 'w') as f:
            json.dump(themes_list, f, indent=2)
        
        print(f"📝 Updated main themes.json with {len(themes_list)} themes")
    
    def list_available_themes(self) -> List[str]:
        """List all available theme IDs."""
        return list(self.all_themes.keys())
    
    def regenerate_existing_themes(self, output_dir: str = "themes") -> None:
        """Regenerate only existing themes (not new ones)."""
        existing_theme_ids = ["sea", "dinosaurs", "fruit", "colours", "farm_animals", "city_vehicles", "zoo"]
        
        print("🔄 Regenerating existing themes...")
        for theme_id in existing_theme_ids:
            if theme_id in self.all_themes:
                try:
                    print(f"\n🔄 Regenerating: {theme_id}")
                    self.generate_theme(theme_id, output_dir)
                except Exception as e:
                    print(f"❌ Error regenerating theme {theme_id}: {e}")

def main():
    """Main CLI interface."""
    parser = argparse.ArgumentParser(description="Complete Branding Generator for Memory Match game")
    parser.add_argument("--theme", "-t", help="Theme ID to generate")
    parser.add_argument("--all", "-a", action="store_true", help="Generate all themes (existing + new)")
    parser.add_argument("--existing", "-e", action="store_true", help="Regenerate only existing themes")
    parser.add_argument("--new", "-n", action="store_true", help="Generate only new themes")
    parser.add_argument("--list", "-l", action="store_true", help="List available themes")
    parser.add_argument("--output", "-o", default="themes", help="Output directory")
    parser.add_argument("--no-backup", action="store_true", help="Skip backing up existing themes")
    
    args = parser.parse_args()
    
    generator = CompleteBrandingGenerator()
    
    if args.list:
        themes = generator.list_available_themes()
        print("Available themes:")
        for theme in themes:
            print(f"  - {theme}: {generator.all_themes[theme]['name']}")
        return
    
    if args.all:
        generator.generate_all_themes(args.output, not args.no_backup)
    elif args.existing:
        generator.regenerate_existing_themes(args.output)
    elif args.new:
        new_themes = ["space_adventure", "jungle_animals", "fairy_tale", "construction_site", "underwater_world", "weather"]
        for theme_id in new_themes:
            try:
                generator.generate_theme(theme_id, args.output)
            except Exception as e:
                print(f"Error generating theme {theme_id}: {e}")
    elif args.theme:
        generator.generate_theme(args.theme, args.output)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()