#!/usr/bin/env python3
"""
Full Branding Art Generator for Kid Memory Template
Generates complete art assets for the entire application including all modules, UI elements, and branding materials
"""

import os
import sys
import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pollinations_client import ArtGenerator, ArtSpec

class FullBrandingGenerator:
    """Complete branding art generator for Kid Memory Template"""
    
    def __init__(self, output_dir: str = "complete_branding"):
        self.generator = ArtGenerator(output_dir=output_dir)
        self.output_dir = Path(output_dir)
        self.branding_specs = self._create_branding_specs()
        self.generation_log = []
        
    def _create_branding_specs(self) -> Dict[str, List[ArtSpec]]:
        """Create comprehensive branding specifications"""
        return {
            'app_branding': self._get_app_branding_specs(),
            'ui_elements': self._get_ui_elements_specs(),
            'module_assets': self._get_all_module_specs(),
            'marketing': self._get_marketing_specs(),
            'variants': self._get_variant_specs(),
        }
    
    def _get_app_branding_specs(self) -> List[ArtSpec]:
        """App-level branding assets"""
        return [
            # Main app icon
            ArtSpec(
                name="app_icon_512",
                prompt="memory game app icon, brain puzzle pieces, educational, child-friendly, bright colors, modern design, simple, clean",
                width=512,
                height=512,
                background="transparent"
            ),
            ArtSpec(
                name="app_icon_256",
                prompt="memory game app icon, brain puzzle pieces, educational, child-friendly, bright colors, modern design, simple, clean",
                width=256,
                height=256,
                background="transparent"
            ),
            ArtSpec(
                name="app_icon_128",
                prompt="memory game app icon, brain puzzle pieces, educational, child-friendly, bright colors, modern design, simple, clean",
                width=128,
                height=128,
                background="transparent"
            ),
            ArtSpec(
                name="app_icon_64",
                prompt="memory game app icon, brain puzzle pieces, educational, child-friendly, bright colors, modern design, simple, clean",
                width=64,
                height=64,
                background="transparent"
            ),
            
            # Splash screen
            ArtSpec(
                name="splash_screen",
                prompt="memory game splash screen, colorful background, educational theme, child-friendly, welcoming, bright colors, clean design",
                width=1920,
                height=1080,
                background="colorful"
            ),
            
            # Logo variations
            ArtSpec(
                name="logo_horizontal",
                prompt="Kid Memory horizontal logo, educational game, child-friendly, bright colors, modern typography, clean design",
                width=800,
                height=200,
                background="transparent"
            ),
            ArtSpec(
                name="logo_vertical",
                prompt="Kid Memory vertical logo, educational game, child-friendly, bright colors, modern typography, clean design",
                width=400,
                height=600,
                background="transparent"
            ),
        ]
    
    def _get_ui_elements_specs(self) -> List[ArtSpec]:
        """UI elements and components"""
        return [
            # Card back designs
            ArtSpec(
                name="card_back_primary",
                prompt="memory game card back, educational theme, child-friendly, bright colors, simple pattern, stars and shapes",
                width=512,
                height=512,
                background="colorful"
            ),
            ArtSpec(
                name="card_back_secondary",
                prompt="memory game card back, educational theme, child-friendly, pastel colors, simple pattern, geometric shapes",
                width=512,
                height=512,
                background="colorful"
            ),
            
            # Button designs
            ArtSpec(
                name="button_primary",
                prompt="educational game button, rounded corners, bright colors, child-friendly, simple design, no text",
                width=200,
                height=60,
                background="transparent"
            ),
            ArtSpec(
                name="button_secondary",
                prompt="educational game button, rounded corners, pastel colors, child-friendly, simple design, no text",
                width=200,
                height=60,
                background="transparent"
            ),
            
            # Background patterns
            ArtSpec(
                name="background_pattern_1",
                prompt="educational game background pattern, subtle, child-friendly, bright colors, geometric shapes, clean design",
                width=1920,
                height=1080,
                background="colorful"
            ),
            ArtSpec(
                name="background_pattern_2",
                prompt="educational game background pattern, subtle, child-friendly, pastel colors, organic shapes, clean design",
                width=1920,
                height=1080,
                background="colorful"
            ),
            
            # Progress indicators
            ArtSpec(
                name="progress_star",
                prompt="golden star, educational game progress indicator, bright, shiny, child-friendly, simple design",
                width=64,
                height=64,
                background="transparent"
            ),
            ArtSpec(
                name="progress_heart",
                prompt="red heart, educational game progress indicator, bright, child-friendly, simple design",
                width=64,
                height=64,
                background="transparent"
            ),
        ]
    
    def _get_all_module_specs(self) -> List[ArtSpec]:
        """All module assets combined"""
        all_specs = []
        
        # Get specs from all modules
        modules = ['shapes', 'colors', 'animals', 'jobs', 'farm', 'family']
        for module in modules:
            module_specs = getattr(self.generator, f'_get_{module}_specs')()
            all_specs.extend(module_specs)
            
        return all_specs
    
    def _get_marketing_specs(self) -> List[ArtSpec]:
        """Marketing and promotional materials"""
        return [
            # App store screenshots
            ArtSpec(
                name="screenshot_main_menu",
                prompt="memory game main menu screenshot, colorful interface, child-friendly, educational theme, bright colors, clean design",
                width=1920,
                height=1080,
                background="colorful"
            ),
            ArtSpec(
                name="screenshot_gameplay",
                prompt="memory game gameplay screenshot, cards on screen, child-friendly, educational theme, bright colors, clean design",
                width=1920,
                height=1080,
                background="colorful"
            ),
            ArtSpec(
                name="screenshot_modules",
                prompt="memory game module selection screenshot, colorful grid, child-friendly, educational theme, bright colors, clean design",
                width=1920,
                height=1080,
                background="colorful"
            ),
            
            # Social media assets
            ArtSpec(
                name="social_media_post",
                prompt="memory game social media post, educational theme, child-friendly, bright colors, engaging design, square format",
                width=1080,
                height=1080,
                background="colorful"
            ),
            ArtSpec(
                name="banner_web",
                prompt="memory game web banner, educational theme, child-friendly, bright colors, horizontal format, clean design",
                width=1200,
                height=400,
                background="colorful"
            ),
        ]
    
    def _get_variant_specs(self) -> List[ArtSpec]:
        """Alternative color schemes and variants"""
        return [
            # Dark theme variants
            ArtSpec(
                name="app_icon_dark",
                prompt="memory game app icon, dark theme, brain puzzle pieces, educational, child-friendly, dark colors, modern design",
                width=512,
                height=512,
                background="transparent"
            ),
            ArtSpec(
                name="card_back_dark",
                prompt="memory game card back, dark theme, educational, child-friendly, dark colors, simple pattern",
                width=512,
                height=512,
                background="colorful"
            ),
            
            # Monochrome variants
            ArtSpec(
                name="app_icon_mono",
                prompt="memory game app icon, monochrome, brain puzzle pieces, educational, child-friendly, black and white, modern design",
                width=512,
                height=512,
                background="transparent"
            ),
        ]
    
    def generate_complete_branding(self) -> Dict[str, Any]:
        """Generate all branding assets"""
        print("🎨 Starting complete branding generation...")
        print(f"📁 Output directory: {self.output_dir}")
        
        # Create output directories
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        results = {}
        total_assets = 0
        successful_assets = 0
        
        for category, specs in self.branding_specs.items():
            print(f"\n📂 Generating {category} assets...")
            category_dir = self.output_dir / category
            category_dir.mkdir(exist_ok=True)
            
            # Generate assets for this category
            category_results = self.generator.client.generate_batch(specs, str(category_dir))
            
            # Count results
            category_success = sum(1 for success in category_results.values() if success)
            category_total = len(category_results)
            
            results[category] = {
                'assets': category_results,
                'success_count': category_success,
                'total_count': category_total,
                'success_rate': category_success / category_total if category_total > 0 else 0
            }
            
            total_assets += category_total
            successful_assets += category_success
            
            print(f"✅ {category}: {category_success}/{category_total} assets generated")
            
            # Log generation details
            self.generation_log.append({
                'category': category,
                'timestamp': datetime.now().isoformat(),
                'success_count': category_success,
                'total_count': category_total,
                'assets': list(category_results.keys())
            })
        
        # Generate summary
        summary = {
            'generation_time': datetime.now().isoformat(),
            'total_assets': total_assets,
            'successful_assets': successful_assets,
            'success_rate': successful_assets / total_assets if total_assets > 0 else 0,
            'categories': results,
            'log': self.generation_log
        }
        
        # Save generation report
        report_path = self.output_dir / 'generation_report.json'
        with open(report_path, 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"\n🎉 Complete branding generation finished!")
        print(f"📊 Total: {successful_assets}/{total_assets} assets generated successfully")
        print(f"📈 Success rate: {summary['success_rate']:.1%}")
        print(f"📄 Report saved to: {report_path}")
        
        return summary
    
    def generate_asset_manifest(self) -> None:
        """Generate a manifest file listing all assets and their purposes"""
        manifest = {
            'app_name': 'Kid Memory Template',
            'version': '1.0.0',
            'generated_at': datetime.now().isoformat(),
            'asset_categories': {
                'app_branding': {
                    'description': 'Main app branding assets including icons, logos, and splash screens',
                    'assets': [
                        'app_icon_512.png - Main app icon (512x512)',
                        'app_icon_256.png - App icon (256x256)',
                        'app_icon_128.png - App icon (128x128)',
                        'app_icon_64.png - App icon (64x64)',
                        'splash_screen.png - App splash screen (1920x1080)',
                        'logo_horizontal.png - Horizontal logo (800x200)',
                        'logo_vertical.png - Vertical logo (400x600)',
                    ]
                },
                'ui_elements': {
                    'description': 'UI components and interface elements',
                    'assets': [
                        'card_back_primary.png - Primary card back design (512x512)',
                        'card_back_secondary.png - Secondary card back design (512x512)',
                        'button_primary.png - Primary button design (200x60)',
                        'button_secondary.png - Secondary button design (200x60)',
                        'background_pattern_1.png - Background pattern 1 (1920x1080)',
                        'background_pattern_2.png - Background pattern 2 (1920x1080)',
                        'progress_star.png - Progress star indicator (64x64)',
                        'progress_heart.png - Progress heart indicator (64x64)',
                    ]
                },
                'module_assets': {
                    'description': 'Educational module assets (shapes, colors, animals, jobs, farm, family)',
                    'modules': {
                        'shapes': 'Geometric shapes learning module',
                        'colors': 'Color recognition learning module',
                        'animals': 'Animal identification learning module',
                        'jobs': 'Profession recognition learning module',
                        'farm': 'Farm animal learning module',
                        'family': 'Family member recognition learning module',
                    }
                },
                'marketing': {
                    'description': 'Marketing and promotional materials',
                    'assets': [
                        'screenshot_main_menu.png - Main menu screenshot (1920x1080)',
                        'screenshot_gameplay.png - Gameplay screenshot (1920x1080)',
                        'screenshot_modules.png - Module selection screenshot (1920x1080)',
                        'social_media_post.png - Social media post (1080x1080)',
                        'banner_web.png - Web banner (1200x400)',
                    ]
                },
                'variants': {
                    'description': 'Alternative color schemes and theme variants',
                    'assets': [
                        'app_icon_dark.png - Dark theme app icon (512x512)',
                        'card_back_dark.png - Dark theme card back (512x512)',
                        'app_icon_mono.png - Monochrome app icon (512x512)',
                    ]
                }
            },
            'usage_instructions': {
                'integration': 'Copy generated assets to the appropriate directories in the Flutter project',
                'optimization': 'Consider optimizing images for mobile devices using tools like TinyPNG',
                'testing': 'Test all assets on different screen sizes and orientations',
                'accessibility': 'Ensure sufficient contrast and readability for children',
            }
        }
        
        manifest_path = self.output_dir / 'asset_manifest.json'
        with open(manifest_path, 'w') as f:
            json.dump(manifest, f, indent=2)
        
        print(f"📋 Asset manifest saved to: {manifest_path}")

def main():
    """Main function for command-line usage"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Generate complete branding for Kid Memory Template')
    parser.add_argument('--output', '-o', default='complete_branding', help='Output directory')
    parser.add_argument('--manifest', '-m', action='store_true', help='Generate asset manifest')
    
    args = parser.parse_args()
    
    # Generate complete branding
    generator = FullBrandingGenerator(output_dir=args.output)
    results = generator.generate_complete_branding()
    
    # Generate manifest if requested
    if args.manifest:
        generator.generate_asset_manifest()
    
    return results

if __name__ == "__main__":
    main()