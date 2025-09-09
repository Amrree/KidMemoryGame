#!/usr/bin/env python3
"""
Memory Match Art CLI - Complete art generation toolkit
A comprehensive CLI tool for generating all art assets for the Memory Match game.
"""

import argparse
import sys
import os
from pathlib import Path
from typing import List, Optional

# Import our art generation modules
from art_generator import MemoryMatchThemeGenerator
from quick_art_generator import QuickArtGenerator
from complete_branding_generator import CompleteBrandingGenerator

class MemoryMatchArtCLI:
    """Main CLI interface for Memory Match art generation."""
    
    def __init__(self):
        self.quick_generator = QuickArtGenerator()
        self.theme_generator = MemoryMatchThemeGenerator()
        self.branding_generator = CompleteBrandingGenerator()
    
    def interactive_mode(self):
        """Interactive mode for guided art generation."""
        print("🎨 Memory Match Art Generation Toolkit")
        print("=" * 50)
        
        while True:
            print("\nWhat would you like to do?")
            print("1. 🎯 Quick Art Generation (single images)")
            print("2. 🎨 Generate Complete Theme")
            print("3. 🚀 Complete Branding (all themes)")
            print("4. 📋 List Available Themes")
            print("5. 🔄 Regenerate Existing Themes")
            print("6. 🆕 Generate New Themes Only")
            print("7. ❓ Help")
            print("8. 🚪 Exit")
            
            choice = input("\nEnter your choice (1-8): ").strip()
            
            if choice == "8":
                print("Goodbye! 👋")
                break
            
            try:
                if choice == "1":
                    self._quick_art_interactive()
                elif choice == "2":
                    self._theme_generation_interactive()
                elif choice == "3":
                    self._complete_branding_interactive()
                elif choice == "4":
                    self._list_themes()
                elif choice == "5":
                    self._regenerate_existing()
                elif choice == "6":
                    self._generate_new_themes()
                elif choice == "7":
                    self._show_help()
                else:
                    print("❌ Invalid choice. Please try again.")
            
            except KeyboardInterrupt:
                print("\n\n👋 Operation cancelled. Goodbye!")
                break
            except Exception as e:
                print(f"❌ Error: {e}")
    
    def _quick_art_interactive(self):
        """Interactive quick art generation."""
        print("\n🎯 Quick Art Generation")
        print("-" * 30)
        
        while True:
            print("\nWhat type of art do you want to generate?")
            print("1. Card (for memory matching)")
            print("2. Background (for theme)")
            print("3. Icon (for theme selection)")
            print("4. Mascot (for background decoration)")
            print("5. Custom image")
            print("6. Back to main menu")
            
            choice = input("Enter your choice (1-6): ").strip()
            
            if choice == "6":
                break
            
            try:
                if choice == "1":
                    item = input("Enter item name for the card: ").strip()
                    if item:
                        style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                        output = self.quick_generator.generate_card(item, style)
                        print(f"✅ Card generated: {output}")
                
                elif choice == "2":
                    theme = input("Enter theme name: ").strip()
                    if theme:
                        style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                        output = self.quick_generator.generate_background(theme, style)
                        print(f"✅ Background generated: {output}")
                
                elif choice == "3":
                    item = input("Enter item name for the icon: ").strip()
                    if item:
                        style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                        output = self.quick_generator.generate_icon(item, style)
                        print(f"✅ Icon generated: {output}")
                
                elif choice == "4":
                    item = input("Enter item name for the mascot: ").strip()
                    if item:
                        style = input("Enter style (default: child-friendly cartoon): ").strip() or "child-friendly cartoon"
                        output = self.quick_generator.generate_mascot(item, style)
                        print(f"✅ Mascot generated: {output}")
                
                elif choice == "5":
                    prompt = input("Enter custom prompt: ").strip()
                    if prompt:
                        width = int(input("Enter width (default: 512): ").strip() or "512")
                        height = int(input("Enter height (default: 512): ").strip() or "512")
                        output = self.quick_generator.generate_image(prompt, width, height)
                        print(f"✅ Custom image generated: {output}")
                
                else:
                    print("❌ Invalid choice. Please try again.")
            
            except Exception as e:
                print(f"❌ Error: {e}")
    
    def _theme_generation_interactive(self):
        """Interactive theme generation."""
        print("\n🎨 Complete Theme Generation")
        print("-" * 35)
        
        themes = self.theme_generator.list_available_themes()
        print("Available themes:")
        for i, theme in enumerate(themes, 1):
            print(f"  {i}. {theme}: {self.theme_generator.themes[theme]['name']}")
        
        try:
            choice = input(f"\nSelect theme (1-{len(themes)}) or enter theme ID: ").strip()
            
            if choice.isdigit():
                theme_id = themes[int(choice) - 1]
            else:
                theme_id = choice
            
            if theme_id in themes:
                custom_cards = input("Enter custom card names (comma-separated, or press Enter for default): ").strip()
                cards_list = [card.strip() for card in custom_cards.split(",")] if custom_cards else None
                
                output_dir = input("Enter output directory (default: generated_themes): ").strip() or "generated_themes"
                
                print(f"\n🎨 Generating theme: {theme_id}")
                self.theme_generator.generate_theme(theme_id, cards_list)
                print(f"✅ Theme generated in: {output_dir}/{theme_id}")
            else:
                print(f"❌ Theme '{theme_id}' not found.")
        
        except Exception as e:
            print(f"❌ Error: {e}")
    
    def _complete_branding_interactive(self):
        """Interactive complete branding generation."""
        print("\n🚀 Complete Branding Generation")
        print("-" * 40)
        
        print("This will generate ALL themes (existing + new).")
        backup = input("Backup existing themes first? (y/n, default: y): ").strip().lower()
        backup = backup != 'n'
        
        output_dir = input("Enter output directory (default: themes): ").strip() or "themes"
        
        print(f"\n🚀 Starting complete branding generation...")
        print(f"📁 Output directory: {output_dir}")
        print(f"💾 Backup existing: {'Yes' if backup else 'No'}")
        
        confirm = input("\nProceed? (y/n): ").strip().lower()
        if confirm == 'y':
            self.branding_generator.generate_all_themes(output_dir, backup)
        else:
            print("❌ Operation cancelled.")
    
    def _list_themes(self):
        """List all available themes."""
        print("\n📋 Available Themes")
        print("-" * 20)
        
        # Quick generator themes
        print("\n🎯 Quick Generator Themes:")
        themes = self.theme_generator.list_available_themes()
        for theme in themes:
            print(f"  - {theme}: {self.theme_generator.themes[theme]['name']}")
        
        # Complete branding themes
        print("\n🚀 Complete Branding Themes:")
        all_themes = self.branding_generator.list_available_themes()
        for theme in all_themes:
            print(f"  - {theme}: {self.branding_generator.all_themes[theme]['name']}")
    
    def _regenerate_existing(self):
        """Regenerate existing themes."""
        print("\n🔄 Regenerating Existing Themes")
        print("-" * 35)
        
        output_dir = input("Enter output directory (default: themes): ").strip() or "themes"
        
        print(f"\n🔄 Regenerating existing themes in: {output_dir}")
        self.branding_generator.regenerate_existing_themes(output_dir)
        print("✅ Existing themes regenerated!")
    
    def _generate_new_themes(self):
        """Generate only new themes."""
        print("\n🆕 Generating New Themes Only")
        print("-" * 35)
        
        output_dir = input("Enter output directory (default: themes): ").strip() or "themes"
        
        print(f"\n🆕 Generating new themes in: {output_dir}")
        new_themes = ["space_adventure", "jungle_animals", "fairy_tale", "construction_site", "underwater_world", "weather"]
        
        for theme_id in new_themes:
            try:
                print(f"\n🎨 Generating: {theme_id}")
                self.branding_generator.generate_theme(theme_id, output_dir)
            except Exception as e:
                print(f"❌ Error generating theme {theme_id}: {e}")
        
        print("✅ New themes generated!")
    
    def _show_help(self):
        """Show help information."""
        print("\n❓ Help - Memory Match Art Generation Toolkit")
        print("=" * 50)
        print("""
This toolkit provides three main art generation capabilities:

1. 🎯 Quick Art Generation
   - Generate individual images (cards, backgrounds, icons, mascots)
   - Perfect for testing or creating specific assets
   - Uses Pollinations API for high-quality generation

2. 🎨 Complete Theme Generation
   - Generate entire theme packages with all assets
   - Includes backgrounds, cards, icons, and mascots
   - Creates proper theme.json structure

3. 🚀 Complete Branding
   - Generate all themes at once (existing + new)
   - Backup existing themes before regeneration
   - Update main themes.json file

Available Themes:
- Existing: sea, dinosaurs, fruit, colours, farm_animals, city_vehicles, zoo
- New: space_adventure, jungle_animals, fairy_tale, construction_site, underwater_world, weather

All generated art uses child-friendly cartoon style optimized for the Memory Match game.
        """)

def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Memory Match Art Generation Toolkit",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python memory_match_art_cli.py --interactive
  python memory_match_art_cli.py --quick-card "dinosaur" --output "my_cards"
  python memory_match_art_cli.py --theme "space_adventure"
  python memory_match_art_cli.py --complete-branding --output "themes"
        """
    )
    
    # Quick art generation
    parser.add_argument("--quick-card", help="Generate a card for the given item")
    parser.add_argument("--quick-background", help="Generate a background for the given theme")
    parser.add_argument("--quick-icon", help="Generate an icon for the given item")
    parser.add_argument("--quick-mascot", help="Generate a mascot for the given item")
    parser.add_argument("--quick-custom", help="Generate a custom image with the given prompt")
    
    # Theme generation
    parser.add_argument("--theme", help="Generate a complete theme")
    parser.add_argument("--theme-cards", nargs="+", help="Custom card names for theme")
    
    # Complete branding
    parser.add_argument("--complete-branding", action="store_true", help="Generate all themes")
    parser.add_argument("--regenerate-existing", action="store_true", help="Regenerate existing themes only")
    parser.add_argument("--new-themes", action="store_true", help="Generate new themes only")
    
    # General options
    parser.add_argument("--interactive", "-i", action="store_true", help="Start interactive mode")
    parser.add_argument("--list", "-l", action="store_true", help="List available themes")
    parser.add_argument("--output", "-o", default="generated_art", help="Output directory")
    parser.add_argument("--width", type=int, default=512, help="Image width for quick generation")
    parser.add_argument("--height", type=int, default=512, help="Image height for quick generation")
    parser.add_argument("--no-backup", action="store_true", help="Skip backing up existing themes")
    
    args = parser.parse_args()
    
    cli = MemoryMatchArtCLI()
    
    try:
        if args.interactive:
            cli.interactive_mode()
        elif args.list:
            cli._list_themes()
        elif args.quick_card:
            output = cli.quick_generator.generate_card(args.quick_card)
            print(f"Card generated: {output}")
        elif args.quick_background:
            output = cli.quick_generator.generate_background(args.quick_background)
            print(f"Background generated: {output}")
        elif args.quick_icon:
            output = cli.quick_generator.generate_icon(args.quick_icon)
            print(f"Icon generated: {output}")
        elif args.quick_mascot:
            output = cli.quick_generator.generate_mascot(args.quick_mascot)
            print(f"Mascot generated: {output}")
        elif args.quick_custom:
            output = cli.quick_generator.generate_image(args.quick_custom, args.width, args.height)
            print(f"Custom image generated: {output}")
        elif args.theme:
            cli.theme_generator.generate_theme(args.theme, args.theme_cards)
        elif args.complete_branding:
            cli.branding_generator.generate_all_themes(args.output, not args.no_backup)
        elif args.regenerate_existing:
            cli.branding_generator.regenerate_existing_themes(args.output)
        elif args.new_themes:
            cli._generate_new_themes()
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