#!/usr/bin/env python3
"""
Simple Art Generator for Kids Game Template
Generates all necessary art assets using the Pollinations API
"""

import requests
import os
import time
from typing import Dict, List, Optional
import argparse

class SimpleArtGenerator:
    def __init__(self):
        self.base_url = "https://image.pollinations.ai/prompt"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'KidsGameTemplate/1.0',
            'Referer': 'https://kidsgame.template'
        })
        
        # Define all art assets to generate
        self.assets = [
            # Common assets
            {
                "name": "app_icon",
                "prompt": "a cute, colorful app icon for a kids educational game, pastel colors, simple design, friendly mascot, high quality, clean background",
                "width": 512, "height": 512, "output_filename": "app_icon.png"
            },
            {
                "name": "card_back",
                "prompt": "a simple, colorful pattern for a card back, child-friendly, pastel colors, clean design, high quality, no text",
                "width": 256, "height": 256, "output_filename": "card_back.png"
            },
            
            # Shapes module
            {
                "name": "shapes_icon",
                "prompt": "a cute icon representing shapes learning, pastel colors, simple geometric shapes, child-friendly, high quality",
                "width": 256, "height": 256, "output_filename": "shapes/icon.png"
            },
            {
                "name": "shapes_background",
                "prompt": "a soft, pastel background for a shapes learning game, gentle colors, simple geometric patterns, child-friendly, high quality",
                "width": 1024, "height": 768, "output_filename": "shapes/background.png"
            },
            {
                "name": "shapes_circle",
                "prompt": "a simple red circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "shapes/circle.png"
            },
            {
                "name": "shapes_square",
                "prompt": "a simple blue square, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "shapes/square.png"
            },
            {
                "name": "shapes_triangle",
                "prompt": "a simple yellow triangle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "shapes/triangle.png"
            },
            {
                "name": "shapes_rectangle",
                "prompt": "a simple green rectangle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "shapes/rectangle.png"
            },
            {
                "name": "shapes_star",
                "prompt": "a simple purple star, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "shapes/star.png"
            },
            {
                "name": "shapes_heart",
                "prompt": "a simple pink heart, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "shapes/heart.png"
            },
            
            # Colors module
            {
                "name": "colors_icon",
                "prompt": "a cute icon representing colors learning, pastel colors, paint palette, child-friendly, high quality",
                "width": 256, "height": 256, "output_filename": "colors/icon.png"
            },
            {
                "name": "colors_background",
                "prompt": "a soft, pastel background for a colors learning game, gentle rainbow colors, child-friendly, high quality",
                "width": 1024, "height": 768, "output_filename": "colors/background.png"
            },
            {
                "name": "colors_red",
                "prompt": "a simple red circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "colors/red.png"
            },
            {
                "name": "colors_blue",
                "prompt": "a simple blue circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "colors/blue.png"
            },
            {
                "name": "colors_green",
                "prompt": "a simple green circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "colors/green.png"
            },
            {
                "name": "colors_yellow",
                "prompt": "a simple yellow circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "colors/yellow.png"
            },
            {
                "name": "colors_purple",
                "prompt": "a simple purple circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "colors/purple.png"
            },
            {
                "name": "colors_orange",
                "prompt": "a simple orange circle, educational, child-friendly, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "colors/orange.png"
            },
            
            # Animals module
            {
                "name": "animals_icon",
                "prompt": "a cute icon representing animals learning, pastel colors, friendly animals, child-friendly, high quality",
                "width": 256, "height": 256, "output_filename": "animals/icon.png"
            },
            {
                "name": "animals_background",
                "prompt": "a soft, pastel background for an animals learning game, gentle nature colors, child-friendly, high quality",
                "width": 1024, "height": 768, "output_filename": "animals/background.png"
            },
            {
                "name": "animals_cat",
                "prompt": "a cute cartoon cat, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "animals/cat.png"
            },
            {
                "name": "animals_dog",
                "prompt": "a cute cartoon dog, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "animals/dog.png"
            },
            {
                "name": "animals_bird",
                "prompt": "a cute cartoon bird, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "animals/bird.png"
            },
            {
                "name": "animals_fish",
                "prompt": "a cute cartoon fish, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "animals/fish.png"
            },
            {
                "name": "animals_rabbit",
                "prompt": "a cute cartoon rabbit, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "animals/rabbit.png"
            },
            {
                "name": "animals_bear",
                "prompt": "a cute cartoon bear, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "animals/bear.png"
            },
            
            # Jobs module
            {
                "name": "jobs_icon",
                "prompt": "a cute icon representing jobs learning, pastel colors, friendly workers, child-friendly, high quality",
                "width": 256, "height": 256, "output_filename": "jobs/icon.png"
            },
            {
                "name": "jobs_background",
                "prompt": "a soft, pastel background for a jobs learning game, gentle workplace colors, child-friendly, high quality",
                "width": 1024, "height": 768, "output_filename": "jobs/background.png"
            },
            {
                "name": "jobs_doctor",
                "prompt": "a cute cartoon doctor, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "jobs/doctor.png"
            },
            {
                "name": "jobs_teacher",
                "prompt": "a cute cartoon teacher, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "jobs/teacher.png"
            },
            {
                "name": "jobs_firefighter",
                "prompt": "a cute cartoon firefighter, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "jobs/firefighter.png"
            },
            {
                "name": "jobs_chef",
                "prompt": "a cute cartoon chef, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "jobs/chef.png"
            },
            {
                "name": "jobs_police",
                "prompt": "a cute cartoon police officer, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "jobs/police.png"
            },
            {
                "name": "jobs_artist",
                "prompt": "a cute cartoon artist, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "jobs/artist.png"
            },
            
            # Farm module
            {
                "name": "farm_icon",
                "prompt": "a cute icon representing farm learning, pastel colors, friendly farm animals, child-friendly, high quality",
                "width": 256, "height": 256, "output_filename": "farm/icon.png"
            },
            {
                "name": "farm_background",
                "prompt": "a soft, pastel background for a farm learning game, gentle farm colors, child-friendly, high quality",
                "width": 1024, "height": 768, "output_filename": "farm/background.png"
            },
            {
                "name": "farm_cow",
                "prompt": "a cute cartoon cow, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "farm/cow.png"
            },
            {
                "name": "farm_pig",
                "prompt": "a cute cartoon pig, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "farm/pig.png"
            },
            {
                "name": "farm_chicken",
                "prompt": "a cute cartoon chicken, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "farm/chicken.png"
            },
            {
                "name": "farm_sheep",
                "prompt": "a cute cartoon sheep, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "farm/sheep.png"
            },
            {
                "name": "farm_horse",
                "prompt": "a cute cartoon horse, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "farm/horse.png"
            },
            {
                "name": "farm_duck",
                "prompt": "a cute cartoon duck, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "farm/duck.png"
            },
            
            # Family module
            {
                "name": "family_icon",
                "prompt": "a cute icon representing family learning, pastel colors, friendly family members, child-friendly, high quality",
                "width": 256, "height": 256, "output_filename": "family/icon.png"
            },
            {
                "name": "family_background",
                "prompt": "a soft, pastel background for a family learning game, gentle home colors, child-friendly, high quality",
                "width": 1024, "height": 768, "output_filename": "family/background.png"
            },
            {
                "name": "family_mom",
                "prompt": "a cute cartoon mom, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "family/mom.png"
            },
            {
                "name": "family_dad",
                "prompt": "a cute cartoon dad, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "family/dad.png"
            },
            {
                "name": "family_sister",
                "prompt": "a cute cartoon sister, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "family/sister.png"
            },
            {
                "name": "family_brother",
                "prompt": "a cute cartoon brother, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "family/brother.png"
            },
            {
                "name": "family_grandma",
                "prompt": "a cute cartoon grandma, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "family/grandma.png"
            },
            {
                "name": "family_grandpa",
                "prompt": "a cute cartoon grandpa, educational, child-friendly, pastel colors, clean design, high quality, transparent background, no background",
                "width": 256, "height": 256, "output_filename": "family/grandpa.png"
            },
        ]

    def generate_image(self, prompt: str, width: int = 256, height: int = 256) -> Optional[bytes]:
        """Generate an image using the Pollinations API"""
        try:
            url = f"{self.base_url}?prompt={prompt}&width={width}&height={height}&nologo=true"
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            return response.content
        except Exception as e:
            print(f"Error generating image: {e}")
            return None

    def save_image(self, image_data: bytes, filepath: str) -> bool:
        """Save image data to file"""
        try:
            os.makedirs(os.path.dirname(filepath), exist_ok=True)
            with open(filepath, 'wb') as f:
                f.write(image_data)
            return True
        except Exception as e:
            print(f"Error saving image to {filepath}: {e}")
            return False

    def generate_all_assets(self, output_dir: str = "generated_assets") -> None:
        """Generate all art assets"""
        print("🎨 Starting Kids Game Art Generation...")
        print(f"📁 Output directory: {output_dir}")
        
        success_count = 0
        total_count = len(self.assets)
        
        for i, asset in enumerate(self.assets, 1):
            print(f"\n[{i}/{total_count}] Generating {asset['name']}...")
            
            # Generate image
            image_data = self.generate_image(
                asset['prompt'],
                asset['width'],
                asset['height']
            )
            
            if image_data:
                # Save image
                filepath = os.path.join(output_dir, asset['output_filename'])
                if self.save_image(image_data, filepath):
                    print(f"✅ Saved: {filepath}")
                    success_count += 1
                else:
                    print(f"❌ Failed to save: {filepath}")
            else:
                print(f"❌ Failed to generate: {asset['name']}")
            
            # Add delay to avoid rate limiting
            time.sleep(1)
        
        print(f"\n🎉 Generation complete!")
        print(f"✅ Successfully generated: {success_count}/{total_count} assets")
        print(f"📁 Assets saved to: {output_dir}")

    def generate_module_assets(self, module_name: str, output_dir: str = "generated_assets") -> None:
        """Generate assets for a specific module"""
        module_assets = [asset for asset in self.assets if asset['name'].startswith(module_name)]
        
        if not module_assets:
            print(f"❌ No assets found for module: {module_name}")
            return
        
        print(f"🎨 Generating {module_name} module assets...")
        print(f"📁 Output directory: {output_dir}")
        
        success_count = 0
        total_count = len(module_assets)
        
        for i, asset in enumerate(module_assets, 1):
            print(f"\n[{i}/{total_count}] Generating {asset['name']}...")
            
            # Generate image
            image_data = self.generate_image(
                asset['prompt'],
                asset['width'],
                asset['height']
            )
            
            if image_data:
                # Save image
                filepath = os.path.join(output_dir, asset['output_filename'])
                if self.save_image(image_data, filepath):
                    print(f"✅ Saved: {filepath}")
                    success_count += 1
                else:
                    print(f"❌ Failed to save: {filepath}")
            else:
                print(f"❌ Failed to generate: {asset['name']}")
            
            # Add delay to avoid rate limiting
            time.sleep(1)
        
        print(f"\n🎉 {module_name} generation complete!")
        print(f"✅ Successfully generated: {success_count}/{total_count} assets")

def main():
    parser = argparse.ArgumentParser(description='Generate art assets for Kids Game Template')
    parser.add_argument('--module', type=str, help='Generate assets for specific module only')
    parser.add_argument('--output', type=str, default='generated_assets', help='Output directory')
    
    args = parser.parse_args()
    
    generator = SimpleArtGenerator()
    
    if args.module:
        generator.generate_module_assets(args.module, args.output)
    else:
        generator.generate_all_assets(args.output)

if __name__ == "__main__":
    main()