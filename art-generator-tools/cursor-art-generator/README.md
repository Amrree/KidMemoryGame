# 🎨 Cursor Art Generator

A lightweight, on-the-fly art generation tool designed for seamless integration with Cursor IDE. Perfect for generating individual assets during development.

## 🚀 Quick Start

```python
# Import in Cursor
from cursor_art_generator import quick_generate, generate_module, generate_card

# Generate a single custom asset
quick_generate("my_asset", "a cute elephant", width=256, height=256)

# Generate an entire module
generate_module("shapes")

# Generate a specific card
generate_card("animals", "elephant", width=512, height=512)
```

## 📦 Installation

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Copy shared components:**
   ```bash
   cp ../shared-components/pollinations_client.py .
   ```

## 🎯 Features

- **Quick Generation**: Generate individual assets on-demand
- **Module Support**: Generate complete educational modules
- **Custom Assets**: Create custom assets with user-defined prompts
- **Multiple Formats**: PNG with transparent backgrounds
- **Educational Focus**: Optimized for child-friendly content

## 📁 Files

- `cursor_art_generator.py` - Main generator module
- `example_usage.py` - Usage examples and demonstrations
- `test_api.py` - API testing and validation
- `requirements.txt` - Python dependencies
- `README.md` - This documentation

## 🔧 Usage Examples

### Generate Single Asset
```python
from cursor_art_generator import quick_generate

# Generate a simple asset
quick_generate("elephant", "a cute cartoon elephant", 256, 256)
```

### Generate Module
```python
from cursor_art_generator import generate_module

# Generate all assets for shapes module
generate_module("shapes")
```

### Generate Specific Card
```python
from cursor_art_generator import generate_card

# Generate a specific card
generate_card("animals", "elephant", 512, 512)
```

## 🎨 Art Specifications

- **Format**: PNG with transparent background
- **Style**: Child-friendly, educational, cartoon
- **Quality**: High-resolution, optimized for mobile
- **Colors**: Bright, engaging, accessible

## 🔍 Troubleshooting

### Common Issues

1. **Import Errors**: Ensure `pollinations_client.py` is in the same directory
2. **API Issues**: Check internet connection and API rate limits
3. **File Permissions**: Ensure output directory is writable

### Debug Mode

```python
import os
os.environ['DEBUG'] = '1'
# Then run your generation code
```

## 📊 Output

Generated assets are saved to:
- `generated_assets/custom/` - Custom generated assets
- `generated_assets/{module}/` - Module-specific assets

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see main project LICENSE file for details.

---

**Perfect for Cursor IDE integration! 🎨✨**