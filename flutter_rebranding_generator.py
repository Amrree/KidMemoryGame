#!/usr/bin/env python3
"""
Flutter Memory Match Game Rebranding Art Generator
Generates all art assets needed for complete Flutter app rebranding using Pollinations API.
"""

import urllib.request
import urllib.parse
import json
import os
import hashlib
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import argparse
import sys
from datetime import datetime

class FlutterRebrandingGenerator:
    """Complete art generator for Flutter Memory Match game rebranding."""
    
    def __init__(self, base_url: str = "https://pollinations.ai"):
        self.base_url = base_url
        
        # Define all required assets for Flutter app
        self.assets_config = {
            # App Icons (multiple sizes for different screen densities)
            "app_icons": {
                "sizes": [
                    (48, 48, "mdpi"),
                    (72, 72, "hdpi"), 
                    (96, 96, "xhdpi"),
                    (144, 144, "xxhdpi"),
                    (192, 192, "xxxhdpi")
                ],
                "prompt": "Memory Match game app icon, child-friendly cartoon style, bright colorful design, brain and memory theme, rounded square, high contrast",
                "folder": "flutter_assets/icons"
            },
            
            # App Logo (for splash screen and branding)
            "app_logo": {
                "sizes": [(512, 512, "logo")],
                "prompt": "Memory Match for Kids logo, child-friendly cartoon style, bright colors, memory and brain theme, clean design, text included",
                "folder": "flutter_assets/logo"
            },
            
            # Background Images
            "backgrounds": {
                "sizes": [(1920, 1080, "background")],
                "themes": {
                    "main_menu": "Colorful main menu background with memory game elements, child-friendly cartoon style, bright welcoming colors, 16:9 aspect ratio",
                    "game_background": "Neutral game background with subtle patterns, child-friendly design, not distracting, 16:9 aspect ratio",
                    "settings_background": "Settings screen background with gear and option elements, child-friendly cartoon style, 16:9 aspect ratio",
                    "victory_background": "Celebration background with confetti and success elements, child-friendly cartoon style, bright colors, 16:9 aspect ratio"
                },
                "folder": "flutter_assets/backgrounds"
            },
            
            # UI Elements
            "ui_elements": {
                "sizes": [(256, 256, "ui")],
                "elements": {
                    "card_back": "Memory game card back design, child-friendly cartoon style, bright colors, simple pattern",
                    "button_primary": "Primary game button, child-friendly cartoon style, bright colors, rounded corners, 3D effect",
                    "button_secondary": "Secondary game button, child-friendly cartoon style, softer colors, rounded corners",
                    "settings_icon": "Settings gear icon, child-friendly cartoon style, bright colors, simple design",
                    "play_icon": "Play button icon, child-friendly cartoon style, bright colors, triangle shape",
                    "pause_icon": "Pause button icon, child-friendly cartoon style, bright colors, two vertical bars",
                    "sound_on_icon": "Sound on icon, child-friendly cartoon style, bright colors, speaker with sound waves",
                    "sound_off_icon": "Sound off icon, child-friendly cartoon style, muted colors, speaker with X",
                    "theme_icon": "Theme selection icon, child-friendly cartoon style, bright colors, palette or color wheel",
                    "grid_icon": "Grid size icon, child-friendly cartoon style, bright colors, grid or squares",
                    "trophy_icon": "Trophy icon, child-friendly cartoon style, bright colors, victory symbol",
                    "star_icon": "Star icon, child-friendly cartoon style, bright colors, 5-pointed star",
                    "heart_icon": "Heart icon, child-friendly cartoon style, bright colors, love symbol",
                    "confetti": "Confetti particles, child-friendly cartoon style, bright colors, celebration elements"
                },
                "folder": "flutter_assets/ui"
            },
            
            # Game Themes (complete theme packages)
            "game_themes": {
                "themes": {
                    "space_adventure": {
                        "name": "Space Adventure",
                        "background_prompt": "Space adventure background with planets, stars, and rockets, child-friendly cartoon style, bright cosmic colors, 16:9 aspect ratio",
                        "cards": [
                            "rocket", "astronaut", "planet", "moon", "star", "comet",
                            "satellite", "space_station", "alien", "spaceship", "meteor",
                            "galaxy", "telescope", "mars_rover", "space_shuttle", "asteroid", "nebula"
                        ],
                        "mascot_cards": ["rocket", "astronaut", "planet", "alien"]
                    },
                    "jungle_animals": {
                        "name": "Jungle Animals",
                        "background_prompt": "Jungle background with trees, vines, and tropical plants, child-friendly cartoon style, bright green colors, 16:9 aspect ratio",
                        "cards": [
                            "tiger", "elephant", "monkey", "parrot", "snake", "frog",
                            "butterfly", "toucan", "sloth", "jaguar", "panda", "koala",
                            "giraffe", "zebra", "lion", "hippo", "rhino", "cheetah"
                        ],
                        "mascot_cards": ["tiger", "elephant", "monkey", "parrot"]
                    },
                    "fairy_tale": {
                        "name": "Fairy Tale",
                        "background_prompt": "Fairy tale background with castle, forest, and rainbow, child-friendly cartoon style, pastel colors, 16:9 aspect ratio",
                        "cards": [
                            "princess", "prince", "dragon", "fairy", "unicorn", "knight",
                            "wizard", "witch", "troll", "elf", "dwarf", "giant",
                            "magic_wand", "crown", "castle", "horse", "carriage", "sword"
                        ],
                        "mascot_cards": ["princess", "dragon", "fairy", "unicorn"]
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
                    "weather_world": {
                        "name": "Weather World",
                        "background_prompt": "Weather background with clouds, sun, rain, and weather elements, child-friendly cartoon style, bright sky colors, 16:9 aspect ratio",
                        "cards": [
                            "sun", "cloud", "rain", "snow", "lightning", "rainbow",
                            "wind", "storm", "fog", "tornado", "hurricane", "blizzard",
                            "hail", "sleet", "frost", "dew", "mist", "breeze"
                        ],
                        "mascot_cards": ["sun", "cloud", "rain", "rainbow"]
                    }
                },
                "folder": "flutter_assets/themes"
            },
            
            # Splash Screen Assets
            "splash_screen": {
                "sizes": [(1920, 1080, "splash")],
                "prompt": "Memory Match for Kids splash screen, child-friendly cartoon style, bright welcoming colors, game logo, memory theme, 16:9 aspect ratio",
                "folder": "flutter_assets/splash"
            },
            
            # Loading Animations
            "loading_animations": {
                "sizes": [(256, 256, "loading")],
                "elements": {
                    "loading_brain": "Animated brain with thinking elements, child-friendly cartoon style, bright colors, loading animation frame",
                    "loading_cards": "Animated memory cards shuffling, child-friendly cartoon style, bright colors, loading animation frame",
                    "loading_stars": "Animated stars twinkling, child-friendly cartoon style, bright colors, loading animation frame"
                },
                "folder": "flutter_assets/loading"
            }
        }
    
    def generate_image(self, 
                      prompt: str, 
                      width: int = 512, 
                      height: int = 512,
                      model: str = "flux",
                      seed: Optional[int] = None,
                      max_retries: int = 3) -> bytes:
        """Generate an image using Pollinations API with retry logic."""
        # Prepare URL
        url_prompt = prompt.replace(' ', '_')
        params = {
            'width': str(width),
            'height': str(height),
            'model': model
        }
        
        if seed is not None:
            params['seed'] = str(seed)
        
        param_string = '&'.join([f"{k}={v}" for k, v in params.items()])
        url = f"{self.base_url}/p/{url_prompt}?{param_string}"
        
        for attempt in range(max_retries):
            try:
                # Create request with proper headers
                request = urllib.request.Request(url)
                request.add_header('User-Agent', 'FlutterRebrandingGenerator/1.0')
                
                response = urllib.request.urlopen(request, timeout=60)
                
                if response.status != 200:
                    if attempt < max_retries - 1:
                        print(f"    ⚠️ Attempt {attempt + 1} failed (status {response.status}), retrying...")
                        continue
                    raise Exception(f"API returned status {response.status}")
                
                return response.read()
                
            except Exception as e:
                if attempt < max_retries - 1:
                    print(f"    ⚠️ Attempt {attempt + 1} failed: {e}, retrying...")
                    continue
                raise Exception(f"Failed to generate image after {max_retries} attempts: {e}")
    
    def save_image(self, image_data: bytes, filepath: str) -> None:
        """Save image data to file."""
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'wb') as f:
            f.write(image_data)
    
    def generate_app_icons(self, output_dir: str = "flutter_assets") -> None:
        """Generate all app icon sizes."""
        print("🎨 Generating App Icons...")
        
        config = self.assets_config["app_icons"]
        base_folder = Path(output_dir) / config["folder"]
        base_folder.mkdir(parents=True, exist_ok=True)
        
        for width, height, density in config["sizes"]:
            print(f"  📱 Generating {density} icon ({width}x{height})...")
            
            try:
                image_data = self.generate_image(
                    prompt=config["prompt"],
                    width=width,
                    height=height,
                    model="flux"
                )
                
                filename = f"ic_launcher_{density}.png"
                filepath = base_folder / filename
                self.save_image(image_data, str(filepath))
                print(f"    ✅ Saved: {filepath}")
                
            except Exception as e:
                print(f"    ❌ Error generating {density} icon: {e}")
    
    def generate_app_logo(self, output_dir: str = "flutter_assets") -> None:
        """Generate app logo."""
        print("🎨 Generating App Logo...")
        
        config = self.assets_config["app_logo"]
        base_folder = Path(output_dir) / config["folder"]
        base_folder.mkdir(parents=True, exist_ok=True)
        
        for width, height, name in config["sizes"]:
            print(f"  🏷️ Generating {name} logo ({width}x{height})...")
            
            try:
                image_data = self.generate_image(
                    prompt=config["prompt"],
                    width=width,
                    height=height,
                    model="flux"
                )
                
                filename = f"app_logo_{name}.png"
                filepath = base_folder / filename
                self.save_image(image_data, str(filepath))
                print(f"    ✅ Saved: {filepath}")
                
            except Exception as e:
                print(f"    ❌ Error generating logo: {e}")
    
    def generate_backgrounds(self, output_dir: str = "flutter_assets") -> None:
        """Generate all background images."""
        print("🎨 Generating Background Images...")
        
        config = self.assets_config["backgrounds"]
        base_folder = Path(output_dir) / config["folder"]
        base_folder.mkdir(parents=True, exist_ok=True)
        
        for theme_name, prompt in config["themes"].items():
            print(f"  🖼️ Generating {theme_name} background...")
            
            try:
                image_data = self.generate_image(
                    prompt=prompt,
                    width=1920,
                    height=1080,
                    model="flux"
                )
                
                filename = f"{theme_name}_background.png"
                filepath = base_folder / filename
                self.save_image(image_data, str(filepath))
                print(f"    ✅ Saved: {filepath}")
                
            except Exception as e:
                print(f"    ❌ Error generating {theme_name} background: {e}")
    
    def generate_ui_elements(self, output_dir: str = "flutter_assets") -> None:
        """Generate all UI elements."""
        print("🎨 Generating UI Elements...")
        
        config = self.assets_config["ui_elements"]
        base_folder = Path(output_dir) / config["folder"]
        base_folder.mkdir(parents=True, exist_ok=True)
        
        for element_name, prompt in config["elements"].items():
            print(f"  🎯 Generating {element_name}...")
            
            try:
                image_data = self.generate_image(
                    prompt=prompt,
                    width=256,
                    height=256,
                    model="flux"
                )
                
                filename = f"{element_name}.png"
                filepath = base_folder / filename
                self.save_image(image_data, str(filepath))
                print(f"    ✅ Saved: {filepath}")
                
            except Exception as e:
                print(f"    ❌ Error generating {element_name}: {e}")
    
    def generate_game_theme(self, theme_id: str, theme_config: Dict, output_dir: str = "flutter_assets") -> None:
        """Generate a complete game theme package."""
        print(f"🎨 Generating Theme: {theme_config['name']}")
        
        theme_folder = Path(output_dir) / self.assets_config["game_themes"]["folder"] / theme_id
        theme_folder.mkdir(parents=True, exist_ok=True)
        cards_folder = theme_folder / "cards"
        cards_folder.mkdir(parents=True, exist_ok=True)
        
        # Generate background
        print(f"  🖼️ Generating background...")
        try:
            background_data = self.generate_image(
                prompt=theme_config["background_prompt"],
                width=1920,
                height=1080,
                model="flux"
            )
            background_path = theme_folder / "background.png"
            self.save_image(background_data, str(background_path))
            print(f"    ✅ Background saved: {background_path}")
        except Exception as e:
            print(f"    ❌ Error generating background: {e}")
            return
        
        # Generate cards
        print(f"  🃏 Generating {len(theme_config['cards'])} cards...")
        card_paths = []
        
        for i, card_name in enumerate(theme_config["cards"]):
            print(f"    {i+1:2d}/{len(theme_config['cards'])}: {card_name}")
            card_prompt = f"Simple, clear illustration of {card_name}, child-friendly cartoon style, bright colors, white background, centered, high contrast, no text, clean design"
            
            try:
                card_data = self.generate_image(
                    prompt=card_prompt,
                    width=512,
                    height=512,
                    model="flux",
                    seed=i  # Consistent generation
                )
                
                card_path = cards_folder / f"{card_name}.png"
                self.save_image(card_data, str(card_path))
                card_paths.append(f"cards/{card_name}.png")
                print(f"      ✅ {card_name}")
                
            except Exception as e:
                print(f"      ❌ Error generating {card_name}: {e}")
        
        # Generate theme icon (use first card as icon)
        icon_path = cards_folder / f"{theme_config['cards'][0]}.png"
        
        # Generate mascot configurations
        mascots = []
        for i, mascot_card in enumerate(theme_config["mascot_cards"]):
            if mascot_card in theme_config["cards"]:
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
            "icon": f"cards/{theme_config['cards'][0]}.png",
            "mascots": mascots,
            "hash": ""  # Will be calculated after generation
        }
        
        # Save theme.json
        theme_json_path = theme_folder / "theme.json"
        with open(theme_json_path, 'w') as f:
            json.dump(theme_json, f, indent=2)
        
        # Create name.txt and icon.txt files
        with open(theme_folder / "name.txt", 'w') as f:
            f.write(theme_config["name"])
        
        with open(theme_folder / "icon.txt", 'w') as f:
            f.write(f"cards/{theme_config['cards'][0]}.png")
        
        print(f"  ✅ Theme generated: {theme_folder}")
    
    def generate_all_game_themes(self, output_dir: str = "flutter_assets") -> None:
        """Generate all game themes."""
        print("🎨 Generating All Game Themes...")
        
        themes = self.assets_config["game_themes"]["themes"]
        
        for theme_id, theme_config in themes.items():
            try:
                self.generate_game_theme(theme_id, theme_config, output_dir)
            except Exception as e:
                print(f"❌ Error generating theme {theme_id}: {e}")
    
    def generate_splash_screen(self, output_dir: str = "flutter_assets") -> None:
        """Generate splash screen assets."""
        print("🎨 Generating Splash Screen...")
        
        config = self.assets_config["splash_screen"]
        base_folder = Path(output_dir) / config["folder"]
        base_folder.mkdir(parents=True, exist_ok=True)
        
        for width, height, name in config["sizes"]:
            print(f"  🚀 Generating splash screen ({width}x{height})...")
            
            try:
                image_data = self.generate_image(
                    prompt=config["prompt"],
                    width=width,
                    height=height,
                    model="flux"
                )
                
                filename = f"splash_{name}.png"
                filepath = base_folder / filename
                self.save_image(image_data, str(filepath))
                print(f"    ✅ Saved: {filepath}")
                
            except Exception as e:
                print(f"    ❌ Error generating splash screen: {e}")
    
    def generate_loading_animations(self, output_dir: str = "flutter_assets") -> None:
        """Generate loading animation frames."""
        print("🎨 Generating Loading Animations...")
        
        config = self.assets_config["loading_animations"]
        base_folder = Path(output_dir) / config["folder"]
        base_folder.mkdir(parents=True, exist_ok=True)
        
        for element_name, prompt in config["elements"].items():
            print(f"  ⏳ Generating {element_name}...")
            
            try:
                image_data = self.generate_image(
                    prompt=prompt,
                    width=256,
                    height=256,
                    model="flux"
                )
                
                filename = f"{element_name}.png"
                filepath = base_folder / filename
                self.save_image(image_data, str(filepath))
                print(f"    ✅ Saved: {filepath}")
                
            except Exception as e:
                print(f"    ❌ Error generating {element_name}: {e}")
    
    def generate_all_assets(self, output_dir: str = "flutter_assets") -> None:
        """Generate all Flutter app assets."""
        print("🚀 Starting Complete Flutter App Rebranding...")
        print(f"📁 Output directory: {output_dir}")
        print("=" * 60)
        
        # Create main output directory
        Path(output_dir).mkdir(exist_ok=True)
        
        # Generate all asset categories
        self.generate_app_icons(output_dir)
        self.generate_app_logo(output_dir)
        self.generate_backgrounds(output_dir)
        self.generate_ui_elements(output_dir)
        self.generate_all_game_themes(output_dir)
        self.generate_splash_screen(output_dir)
        self.generate_loading_animations(output_dir)
        
        # Create asset manifest
        self.create_asset_manifest(output_dir)
        
        print("\n" + "=" * 60)
        print("🎉 Complete Flutter App Rebranding Finished!")
        print(f"📁 All assets saved to: {output_dir}")
        print("\n📋 Generated Assets:")
        print("  🎨 App Icons (all densities)")
        print("  🏷️ App Logo")
        print("  🖼️ Background Images")
        print("  🎯 UI Elements")
        print("  🎮 Game Themes (6 complete themes)")
        print("  🚀 Splash Screen")
        print("  ⏳ Loading Animations")
        print("  📄 Asset Manifest")
    
    def create_asset_manifest(self, output_dir: str = "flutter_assets") -> None:
        """Create asset manifest for Flutter app."""
        print("📄 Creating Asset Manifest...")
        
        manifest = {
            "app_info": {
                "name": "Memory Match for Kids",
                "version": "2.0.0",
                "description": "Child-friendly memory matching game with beautiful AI-generated art",
                "generated_at": datetime.now().isoformat()
            },
            "assets": {
                "icons": {
                    "app_icons": "icons/",
                    "ui_elements": "ui/"
                },
                "backgrounds": "backgrounds/",
                "themes": "themes/",
                "splash": "splash/",
                "loading": "loading/"
            },
            "themes": list(self.assets_config["game_themes"]["themes"].keys())
        }
        
        manifest_path = Path(output_dir) / "asset_manifest.json"
        with open(manifest_path, 'w') as f:
            json.dump(manifest, f, indent=2)
        
        print(f"  ✅ Asset manifest saved: {manifest_path}")

def main():
    """Main CLI interface."""
    parser = argparse.ArgumentParser(description="Flutter Memory Match Game Rebranding Generator")
    parser.add_argument("--all", "-a", action="store_true", help="Generate all assets")
    parser.add_argument("--icons", action="store_true", help="Generate app icons only")
    parser.add_argument("--logo", action="store_true", help="Generate app logo only")
    parser.add_argument("--backgrounds", action="store_true", help="Generate backgrounds only")
    parser.add_argument("--ui", action="store_true", help="Generate UI elements only")
    parser.add_argument("--themes", action="store_true", help="Generate game themes only")
    parser.add_argument("--splash", action="store_true", help="Generate splash screen only")
    parser.add_argument("--loading", action="store_true", help="Generate loading animations only")
    parser.add_argument("--theme", help="Generate specific theme only")
    parser.add_argument("--output", "-o", default="flutter_assets", help="Output directory")
    
    args = parser.parse_args()
    
    generator = FlutterRebrandingGenerator()
    
    try:
        if args.all:
            generator.generate_all_assets(args.output)
        elif args.icons:
            generator.generate_app_icons(args.output)
        elif args.logo:
            generator.generate_app_logo(args.output)
        elif args.backgrounds:
            generator.generate_backgrounds(args.output)
        elif args.ui:
            generator.generate_ui_elements(args.output)
        elif args.themes:
            generator.generate_all_game_themes(args.output)
        elif args.splash:
            generator.generate_splash_screen(args.output)
        elif args.loading:
            generator.generate_loading_animations(args.output)
        elif args.theme:
            if args.theme in generator.assets_config["game_themes"]["themes"]:
                theme_config = generator.assets_config["game_themes"]["themes"][args.theme]
                generator.generate_game_theme(args.theme, theme_config, args.output)
            else:
                print(f"❌ Theme '{args.theme}' not found. Available themes:")
                for theme_id in generator.assets_config["game_themes"]["themes"].keys():
                    print(f"  - {theme_id}")
        else:
            parser.print_help()
    
    except KeyboardInterrupt:
        print("\n\n👋 Operation cancelled. Goodbye!")
        sys.exit(0)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()