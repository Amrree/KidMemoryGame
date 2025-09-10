# Kid Memory Template Art Generator

A comprehensive art generation system for the Kid Memory Template using the Pollinations API. This system provides three different tools for generating all the visual assets needed for the educational memory game.

## 🎨 Features

- **Complete Art Generation**: Generate all assets for the entire application
- **Module-Specific Generation**: Generate art for individual educational modules
- **On-the-fly Generation**: Generate specific assets as needed during development
- **CLI Tool**: Command-line interface for batch operations
- **Custom Asset Support**: Generate custom assets with user-defined prompts
- **Multiple Output Formats**: PNG with transparent backgrounds
- **Educational Focus**: Optimized prompts for child-friendly educational content

## 🛠️ Tools

### 1. On-the-fly Art Generator (`cursor_art_generator.py`)
Perfect for generating individual assets during development in Cursor.

**Usage:**
```python
# In Cursor, you can import and use:
from cursor_art_generator import quick_generate, generate_module, generate_card

# Generate a single custom asset
quick_generate("my_asset", "a cute elephant", width=256, height=256)

# Generate an entire module
generate_module("shapes")

# Generate a specific card
generate_card("animals", "elephant", width=512, height=512)
```

### 2. Full Branding Generator (`full_branding_generator.py`)
Generates complete branding assets for the entire application.

**Usage:**
```bash
# Generate all branding assets
python full_branding_generator.py

# Generate with custom output directory
python full_branding_generator.py --output my_branding

# Generate with manifest
python full_branding_generator.py --manifest
```

### 3. CLI Tool (`cli_tool.py`)
Command-line interface for all art generation needs.

**Usage:**
```bash
# List available modules
python cli_tool.py --list-modules

# List assets for a module
python cli_tool.py --list-assets --module shapes

# Generate entire module
python cli_tool.py --module shapes

# Generate specific asset
python cli_tool.py --module shapes --asset circle

# Generate custom asset
python cli_tool.py --custom "my_asset" --prompt "a cute elephant"

# Generate with custom dimensions
python cli_tool.py --module shapes --asset circle --width 256 --height 256
```

## 📦 Installation

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.py
   ```

3. **Optional: Install as package:**
   ```bash
   pip install -e .
   ```

## 🎯 Asset Specifications

### Module Assets
Each educational module includes:
- **Icon**: 256x256px module icon
- **Background**: 1920x1080px background image
- **Cards**: 512x512px individual learning cards

### UI Assets
- **App Icons**: Multiple sizes (64x64, 128x128, 256x256, 512x512)
- **Card Backs**: 512x512px card back designs
- **Buttons**: 200x60px UI button designs
- **Backgrounds**: 1920x1080px background patterns

### Marketing Assets
- **Screenshots**: 1920x1080px app screenshots
- **Social Media**: 1080x1080px social media posts
- **Web Banners**: 1200x400px web banners

## 🎨 Art Styles

All generated art follows these principles:
- **Child-friendly**: Bright, engaging colors and simple designs
- **Educational**: Clear, recognizable objects and concepts
- **Consistent**: Unified style across all assets
- **Accessible**: High contrast and clear visual hierarchy
- **Modern**: Clean, contemporary design aesthetic

## 📁 Output Structure

```
generated_assets/
├── shapes/
│   ├── shapes_icon.png
│   ├── shapes_background.png
│   ├── shapes_circle.png
│   ├── shapes_square.png
│   └── ...
├── colors/
│   ├── colors_icon.png
│   ├── colors_background.png
│   ├── colors_red.png
│   └── ...
├── animals/
├── jobs/
├── farm/
├── family/
├── ui/
└── custom/
```

## 🔧 Customization

### Custom Prompts
You can customize the generation prompts by modifying the `_create_prompt()` method in `cli_tool.py` or the individual module spec methods in `pollinations_client.py`.

### Style Variations
Available styles:
- `cartoon` (default)
- `realistic`
- `minimalist`
- `watercolor`
- `digital_art`

### Background Options
- `transparent` (default)
- `white`
- `colorful`

## 🚀 Quick Start

1. **Generate all art:**
   ```bash
   python cli_tool.py --module all
   ```

2. **Generate specific module:**
   ```bash
   python cli_tool.py --module shapes
   ```

3. **Generate custom asset:**
   ```bash
   python cli_tool.py --custom "my_elephant" --prompt "a cute cartoon elephant, educational, child-friendly"
   ```

## 📊 Generation Reports

The full branding generator creates detailed reports:
- `generation_report.json`: Complete generation statistics
- `asset_manifest.json`: Asset catalog with descriptions

## 🔍 Troubleshooting

### Common Issues

1. **API Rate Limiting**: The tools include built-in rate limiting. If you encounter issues, try reducing batch sizes or adding delays.

2. **Network Issues**: Ensure stable internet connection for API calls.

3. **File Permissions**: Make sure the output directory is writable.

4. **Memory Issues**: For large batches, consider generating modules individually.

### Debug Mode

Enable debug output by setting the environment variable:
```bash
export DEBUG=1
python cli_tool.py --module shapes
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the main project LICENSE file for details.

## 🆘 Support

For issues and questions:
- Check the troubleshooting section
- Review the generated reports
- Create an issue on GitHub

---

**Happy art generating! 🎨✨**