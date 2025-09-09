#!/usr/bin/env python3
"""
Simplified Art Generator for Kid Memory Template
Uses simpler prompts that work better with Pollinations API
"""

import requests
import time
import os
from pathlib import Path
from typing import List, Dict

class SimpleArtGenerator:
    """Simplified art generator with working prompts"""
    
    def __init__(self, output_dir: str = "generated_assets"):
        self.base_url = "https://image.pollinations.ai/prompt"
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
    def generate_image(self, prompt: str, filename: str, width: int = 512, height: int = 512) -> bool:
        """Generate a single image"""
        try:
            params = {
                'prompt': prompt,
                'width': width,
                'height': height,
                'nologo': 'true'
            }
            
            response = requests.get(self.base_url, params=params, timeout=30)
            response.raise_for_status()
            
            if response.headers.get('content-type', '').startswith('image/'):
                filepath = self.output_dir / filename
                with open(filepath, 'wb') as f:
                    f.write(response.content)
                print(f"✅ Generated: {filename}")
                return True
            else:
                print(f"❌ Failed: {filename} - Invalid content type")
                return False
                
        except Exception as e:
            print(f"❌ Failed: {filename} - {e}")
            return False
    
    def generate_all_art(self):
        """Generate all art for the Kid Memory Template"""
        print("🎨 Starting art generation for Kid Memory Template...")
        
        # Create module directories
        modules = ['shapes', 'colors', 'animals', 'jobs', 'farm', 'family']
        for module in modules:
            (self.output_dir / module).mkdir(exist_ok=True)
        
        # Generate UI assets
        print("\n📱 Generating UI assets...")
        ui_assets = [
            ("card_back.png", "card back design, memory game, colorful, simple pattern", 512, 512),
            ("app_icon.png", "memory game app icon, brain puzzle, colorful, simple", 512, 512),
        ]
        
        for filename, prompt, width, height in ui_assets:
            self.generate_image(prompt, filename, width, height)
        
        # Generate shapes module
        print("\n🔷 Generating shapes module...")
        shapes = [
            ("shapes_icon.png", "geometric shapes icon, circle square triangle, colorful", 256, 256),
            ("shapes_background.png", "colorful geometric shapes background, educational", 1920, 1080),
            ("shapes_circle.png", "red circle, simple, clean, no background", 512, 512),
            ("shapes_square.png", "blue square, simple, clean, no background", 512, 512),
            ("shapes_triangle.png", "green triangle, simple, clean, no background", 512, 512),
            ("shapes_rectangle.png", "yellow rectangle, simple, clean, no background", 512, 512),
            ("shapes_star.png", "purple star, simple, clean, no background", 512, 512),
            ("shapes_heart.png", "pink heart, simple, clean, no background", 512, 512),
        ]
        
        for filename, prompt, width, height in shapes:
            self.generate_image(prompt, f"shapes/{filename}", width, height)
            time.sleep(1)  # Rate limiting
        
        # Generate colors module
        print("\n🎨 Generating colors module...")
        colors = [
            ("colors_icon.png", "colorful palette icon, paint brush, bright", 256, 256),
            ("colors_background.png", "colorful paint splashes background, rainbow", 1920, 1080),
            ("colors_red.png", "red color swatch, solid red, simple", 512, 512),
            ("colors_blue.png", "blue color swatch, solid blue, simple", 512, 512),
            ("colors_green.png", "green color swatch, solid green, simple", 512, 512),
            ("colors_yellow.png", "yellow color swatch, solid yellow, simple", 512, 512),
            ("colors_orange.png", "orange color swatch, solid orange, simple", 512, 512),
            ("colors_purple.png", "purple color swatch, solid purple, simple", 512, 512),
        ]
        
        for filename, prompt, width, height in colors:
            self.generate_image(prompt, f"colors/{filename}", width, height)
            time.sleep(1)
        
        # Generate animals module
        print("\n🐾 Generating animals module...")
        animals = [
            ("animals_icon.png", "cute animals icon, cat dog bird, colorful", 256, 256),
            ("animals_background.png", "zoo background, animals in nature, colorful", 1920, 1080),
            ("animals_cat.png", "cute cat, cartoon style, simple, no background", 512, 512),
            ("animals_dog.png", "cute dog, cartoon style, simple, no background", 512, 512),
            ("animals_bird.png", "cute bird, cartoon style, simple, no background", 512, 512),
            ("animals_fish.png", "cute fish, cartoon style, simple, no background", 512, 512),
            ("animals_rabbit.png", "cute rabbit, cartoon style, simple, no background", 512, 512),
            ("animals_butterfly.png", "cute butterfly, cartoon style, simple, no background", 512, 512),
        ]
        
        for filename, prompt, width, height in animals:
            self.generate_image(prompt, f"animals/{filename}", width, height)
            time.sleep(1)
        
        # Generate jobs module
        print("\n👷 Generating jobs module...")
        jobs = [
            ("jobs_icon.png", "professions icon, doctor teacher firefighter, colorful", 256, 256),
            ("jobs_background.png", "workplace background, various professions, colorful", 1920, 1080),
            ("jobs_doctor.png", "friendly doctor, cartoon style, simple, no background", 512, 512),
            ("jobs_teacher.png", "friendly teacher, cartoon style, simple, no background", 512, 512),
            ("jobs_firefighter.png", "friendly firefighter, cartoon style, simple, no background", 512, 512),
            ("jobs_chef.png", "friendly chef, cartoon style, simple, no background", 512, 512),
            ("jobs_police.png", "friendly police officer, cartoon style, simple, no background", 512, 512),
            ("jobs_artist.png", "friendly artist, cartoon style, simple, no background", 512, 512),
        ]
        
        for filename, prompt, width, height in jobs:
            self.generate_image(prompt, f"jobs/{filename}", width, height)
            time.sleep(1)
        
        # Generate farm module
        print("\n🚜 Generating farm module...")
        farm_animals = [
            ("farm_icon.png", "farm animals icon, cow pig chicken, colorful", 256, 256),
            ("farm_background.png", "farm background, barn and fields, colorful", 1920, 1080),
            ("farm_cow.png", "cute farm cow, cartoon style, simple, no background", 512, 512),
            ("farm_pig.png", "cute farm pig, cartoon style, simple, no background", 512, 512),
            ("farm_chicken.png", "cute farm chicken, cartoon style, simple, no background", 512, 512),
            ("farm_horse.png", "cute farm horse, cartoon style, simple, no background", 512, 512),
            ("farm_sheep.png", "cute farm sheep, cartoon style, simple, no background", 512, 512),
            ("farm_duck.png", "cute farm duck, cartoon style, simple, no background", 512, 512),
        ]
        
        for filename, prompt, width, height in farm_animals:
            self.generate_image(prompt, f"farm/{filename}", width, height)
            time.sleep(1)
        
        # Generate family module
        print("\n👨‍👩‍👧‍👦 Generating family module...")
        family = [
            ("family_icon.png", "family icon, mom dad children, colorful", 256, 256),
            ("family_background.png", "family home background, cozy house, colorful", 1920, 1080),
            ("family_mom.png", "friendly mom, cartoon style, simple, no background", 512, 512),
            ("family_dad.png", "friendly dad, cartoon style, simple, no background", 512, 512),
            ("family_grandma.png", "friendly grandma, cartoon style, simple, no background", 512, 512),
            ("family_grandpa.png", "friendly grandpa, cartoon style, simple, no background", 512, 512),
            ("family_sister.png", "friendly sister, cartoon style, simple, no background", 512, 512),
            ("family_brother.png", "friendly brother, cartoon style, simple, no background", 512, 512),
        ]
        
        for filename, prompt, width, height in family:
            self.generate_image(prompt, f"family/{filename}", width, height)
            time.sleep(1)
        
        print("\n🎉 Art generation completed!")
        print(f"📁 All assets saved to: {self.output_dir}")

def main():
    """Main function"""
    generator = SimpleArtGenerator()
    generator.generate_all_art()

if __name__ == "__main__":
    main()