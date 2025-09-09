"""
Pollinations API Client for Kid Memory Template Art Generation
Provides a robust interface to the Pollinations API for generating educational game assets
"""

import requests
import time
import os
from typing import Optional, Dict, Any, List
from dataclasses import dataclass
from pathlib import Path
import json

@dataclass
class ArtSpec:
    """Specification for art generation"""
    name: str
    prompt: str
    width: int = 512
    height: int = 512
    style: str = "cartoon"
    quality: str = "high"
    format: str = "png"
    background: str = "transparent"

class PollinationsClient:
    """Client for Pollinations API image generation"""
    
    def __init__(self, referrer: str = "kid-memory-template"):
        self.referrer = referrer
        self.base_url = "https://image.pollinations.ai/prompt"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': f'KidMemoryTemplate/{referrer}',
            'Referer': f'https://pollinations.ai/{referrer}'
        })
        
    def generate_image(self, spec: ArtSpec, retries: int = 3) -> Optional[bytes]:
        """
        Generate an image using Pollinations API
        
        Args:
            spec: ArtSpec containing generation parameters
            retries: Number of retry attempts
            
        Returns:
            Image bytes or None if generation failed
        """
        prompt = self._build_prompt(spec)
        
        params = {
            'prompt': prompt,
            'width': spec.width,
            'height': spec.height,
            'nologo': 'true',
            'seed': int(time.time() * 1000) % 1000000,  # Random seed
        }
        
        for attempt in range(retries):
            try:
                # Use the correct Pollinations API endpoint format
                response = self.session.get(
                    self.base_url,
                    params=params,
                    timeout=30
                )
                response.raise_for_status()
                
                if response.headers.get('content-type', '').startswith('image/'):
                    return response.content
                else:
                    print(f"Unexpected content type: {response.headers.get('content-type')}")
                    print(f"Response text: {response.text[:200]}...")
                    
            except requests.exceptions.RequestException as e:
                print(f"Attempt {attempt + 1} failed: {e}")
                if attempt < retries - 1:
                    time.sleep(2 ** attempt)  # Exponential backoff
                    
        return None
    
    def _build_prompt(self, spec: ArtSpec) -> str:
        """Build the final prompt for image generation"""
        base_prompt = f"{spec.prompt}, {spec.style} style, {spec.quality} quality"
        
        if spec.background == "transparent":
            base_prompt += ", transparent background, no background"
        elif spec.background == "white":
            base_prompt += ", white background"
        elif spec.background == "colorful":
            base_prompt += ", colorful background"
            
        # Add educational game specific enhancements
        base_prompt += ", child-friendly, educational, bright colors, simple design, clean, professional"
        
        return base_prompt
    
    def generate_batch(self, specs: List[ArtSpec], output_dir: str) -> Dict[str, bool]:
        """
        Generate multiple images in batch
        
        Args:
            specs: List of ArtSpec objects
            output_dir: Directory to save generated images
            
        Returns:
            Dictionary mapping filenames to success status
        """
        results = {}
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        for spec in specs:
            print(f"Generating {spec.name}...")
            
            image_data = self.generate_image(spec)
            if image_data:
                filename = f"{spec.name}.{spec.format}"
                filepath = output_path / filename
                
                with open(filepath, 'wb') as f:
                    f.write(image_data)
                
                results[filename] = True
                print(f"✓ Saved {filename}")
            else:
                results[spec.name] = False
                print(f"✗ Failed to generate {spec.name}")
                
            # Rate limiting - be respectful to the API
            time.sleep(1)
            
        return results

class ArtGenerator:
    """High-level art generator for Kid Memory Template"""
    
    def __init__(self, output_dir: str = "generated_assets"):
        self.client = PollinationsClient()
        self.output_dir = output_dir
        self.specs = self._load_art_specs()
        
    def _load_art_specs(self) -> Dict[str, List[ArtSpec]]:
        """Load all art specifications for the template"""
        return {
            'shapes': self._get_shapes_specs(),
            'colors': self._get_colors_specs(),
            'animals': self._get_animals_specs(),
            'jobs': self._get_jobs_specs(),
            'farm': self._get_farm_specs(),
            'family': self._get_family_specs(),
            'ui': self._get_ui_specs(),
        }
    
    def _get_shapes_specs(self) -> List[ArtSpec]:
        """Get specifications for shapes module art"""
        shapes = ['circle', 'square', 'triangle', 'rectangle', 'star', 'heart']
        specs = []
        
        # Module icon
        specs.append(ArtSpec(
            name="shapes_icon",
            prompt="geometric shapes icon, circle square triangle, colorful, educational, simple design",
            width=256,
            height=256,
            background="transparent"
        ))
        
        # Background
        specs.append(ArtSpec(
            name="shapes_background",
            prompt="colorful geometric shapes background, educational theme, soft pastel colors, clean design",
            width=1920,
            height=1080,
            background="colorful"
        ))
        
        # Individual shape cards
        for shape in shapes:
            specs.append(ArtSpec(
                name=f"shapes_{shape}",
                prompt=f"simple {shape} shape, bright color, educational, child-friendly, clean design, no text",
                width=512,
                height=512,
                background="transparent"
            ))
            
        return specs
    
    def _get_colors_specs(self) -> List[ArtSpec]:
        """Get specifications for colors module art"""
        colors = ['red', 'blue', 'green', 'yellow', 'orange', 'purple']
        specs = []
        
        # Module icon
        specs.append(ArtSpec(
            name="colors_icon",
            prompt="colorful palette icon, paint brush, educational, bright colors, simple design",
            width=256,
            height=256,
            background="transparent"
        ))
        
        # Background
        specs.append(ArtSpec(
            name="colors_background",
            prompt="colorful paint splashes background, rainbow colors, educational theme, artistic",
            width=1920,
            height=1080,
            background="colorful"
        ))
        
        # Individual color cards
        for color in colors:
            specs.append(ArtSpec(
                name=f"colors_{color}",
                prompt=f"simple {color} color swatch, solid {color} background, educational, child-friendly, clean design",
                width=512,
                height=512,
                background="transparent"
            ))
            
        return specs
    
    def _get_animals_specs(self) -> List[ArtSpec]:
        """Get specifications for animals module art"""
        animals = ['cat', 'dog', 'bird', 'fish', 'rabbit', 'butterfly']
        specs = []
        
        # Module icon
        specs.append(ArtSpec(
            name="animals_icon",
            prompt="cute animals icon, cat dog bird, colorful, educational, child-friendly design",
            width=256,
            height=256,
            background="transparent"
        ))
        
        # Background
        specs.append(ArtSpec(
            name="animals_background",
            prompt="zoo background, animals in nature, educational theme, bright colors, child-friendly",
            width=1920,
            height=1080,
            background="colorful"
        ))
        
        # Individual animal cards
        for animal in animals:
            specs.append(ArtSpec(
                name=f"animals_{animal}",
                prompt=f"cute {animal}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
                width=512,
                height=512,
                background="transparent"
            ))
            
        return specs
    
    def _get_jobs_specs(self) -> List[ArtSpec]:
        """Get specifications for jobs module art"""
        jobs = ['doctor', 'teacher', 'firefighter', 'chef', 'police', 'artist']
        specs = []
        
        # Module icon
        specs.append(ArtSpec(
            name="jobs_icon",
            prompt="professions icon, doctor teacher firefighter, colorful, educational, child-friendly design",
            width=256,
            height=256,
            background="transparent"
        ))
        
        # Background
        specs.append(ArtSpec(
            name="jobs_background",
            prompt="workplace background, various professions, educational theme, bright colors, child-friendly",
            width=1920,
            height=1080,
            background="colorful"
        ))
        
        # Individual job cards
        for job in jobs:
            specs.append(ArtSpec(
                name=f"jobs_{job}",
                prompt=f"friendly {job}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
                width=512,
                height=512,
                background="transparent"
            ))
            
        return specs
    
    def _get_farm_specs(self) -> List[ArtSpec]:
        """Get specifications for farm module art"""
        farm_animals = ['cow', 'pig', 'chicken', 'horse', 'sheep', 'duck']
        specs = []
        
        # Module icon
        specs.append(ArtSpec(
            name="farm_icon",
            prompt="farm animals icon, cow pig chicken, colorful, educational, child-friendly design",
            width=256,
            height=256,
            background="transparent"
        ))
        
        # Background
        specs.append(ArtSpec(
            name="farm_background",
            prompt="farm background, barn and fields, educational theme, bright colors, child-friendly",
            width=1920,
            height=1080,
            background="colorful"
        ))
        
        # Individual farm animal cards
        for animal in farm_animals:
            specs.append(ArtSpec(
                name=f"farm_{animal}",
                prompt=f"cute farm {animal}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
                width=512,
                height=512,
                background="transparent"
            ))
            
        return specs
    
    def _get_family_specs(self) -> List[ArtSpec]:
        """Get specifications for family module art"""
        family_members = ['mom', 'dad', 'grandma', 'grandpa', 'sister', 'brother']
        specs = []
        
        # Module icon
        specs.append(ArtSpec(
            name="family_icon",
            prompt="family icon, mom dad children, colorful, educational, child-friendly design",
            width=256,
            height=256,
            background="transparent"
        ))
        
        # Background
        specs.append(ArtSpec(
            name="family_background",
            prompt="family home background, cozy house, educational theme, bright colors, child-friendly",
            width=1920,
            height=1080,
            background="colorful"
        ))
        
        # Individual family member cards
        for member in family_members:
            specs.append(ArtSpec(
                name=f"family_{member}",
                prompt=f"friendly {member}, cartoon style, educational, child-friendly, bright colors, simple design, no text",
                width=512,
                height=512,
                background="transparent"
            ))
            
        return specs
    
    def _get_ui_specs(self) -> List[ArtSpec]:
        """Get specifications for UI elements"""
        return [
            ArtSpec(
                name="card_back",
                prompt="card back design, memory game, educational, child-friendly, bright colors, simple pattern",
                width=512,
                height=512,
                background="colorful"
            ),
            ArtSpec(
                name="app_icon",
                prompt="memory game app icon, brain puzzle, educational, child-friendly, bright colors, simple design",
                width=512,
                height=512,
                background="transparent"
            ),
        ]
    
    def generate_all_art(self) -> Dict[str, Dict[str, bool]]:
        """Generate all art for the template"""
        results = {}
        
        for module, specs in self.specs.items():
            print(f"\n🎨 Generating {module} module art...")
            module_dir = os.path.join(self.output_dir, module)
            results[module] = self.client.generate_batch(specs, module_dir)
            
        return results
    
    def generate_module_art(self, module: str) -> Dict[str, bool]:
        """Generate art for a specific module"""
        if module not in self.specs:
            raise ValueError(f"Unknown module: {module}")
            
        print(f"🎨 Generating {module} module art...")
        module_dir = os.path.join(self.output_dir, module)
        return self.client.generate_batch(self.specs[module], module_dir)
    
    def generate_single_asset(self, name: str, prompt: str, **kwargs) -> bool:
        """Generate a single custom asset"""
        spec = ArtSpec(name=name, prompt=prompt, **kwargs)
        module_dir = os.path.join(self.output_dir, "custom")
        result = self.client.generate_batch([spec], module_dir)
        return result.get(f"{name}.{spec.format}", False)

if __name__ == "__main__":
    # Example usage
    generator = ArtGenerator()
    results = generator.generate_all_art()
    
    print("\n🎉 Art generation complete!")
    for module, assets in results.items():
        success_count = sum(1 for success in assets.values() if success)
        total_count = len(assets)
        print(f"{module}: {success_count}/{total_count} assets generated successfully")