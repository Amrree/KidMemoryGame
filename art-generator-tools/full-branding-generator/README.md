# 🎨 Full Branding Generator

A comprehensive art generation tool that creates complete branding assets for the entire Kid Memory Template application. Generates all visual assets needed for a complete app launch.

## 🚀 Quick Start

```bash
# Generate all branding assets
python full_branding_generator.py

# Generate with custom output directory
python full_branding_generator.py --output my_branding

# Generate with manifest
python full_branding_generator.py --manifest
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

3. **Optional: Install as package:**
   ```bash
   pip install -e .
   ```

## 🎯 Features

- **Complete Branding**: Generates all assets for entire application
- **Module Assets**: Creates icons, backgrounds, and cards for all modules
- **UI Assets**: Generates app icons, buttons, and interface elements
- **Marketing Assets**: Creates screenshots, social media posts, and web banners
- **Manifest Generation**: Creates detailed asset catalogs and reports
- **Batch Processing**: Efficient generation of large asset sets

## 📁 Files

- `full_branding_generator.py` - Main generator script
- `setup.py` - Package installation script
- `requirements.txt` - Python dependencies
- `README.md` - This documentation

## 🔧 Usage Examples

### Generate All Assets
```bash
python full_branding_generator.py
```

### Custom Output Directory
```bash
python full_branding_generator.py --output /path/to/output
```

### Generate with Manifest
```bash
python full_branding_generator.py --manifest
```

### Verbose Output
```bash
python full_branding_generator.py --verbose
```

## 🎨 Generated Assets

### Module Assets
- **Icons**: 256x256px module icons
- **Backgrounds**: 1920x1080px background images
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

## 📊 Output Structure

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
├── marketing/
└── custom/
```

## 📋 Generation Reports

The tool creates detailed reports:
- `generation_report.json` - Complete generation statistics
- `asset_manifest.json` - Asset catalog with descriptions
- `error_log.txt` - Any generation errors or warnings

## 🎨 Art Styles

All generated art follows these principles:
- **Child-friendly**: Bright, engaging colors and simple designs
- **Educational**: Clear, recognizable objects and concepts
- **Consistent**: Unified style across all assets
- **Accessible**: High contrast and clear visual hierarchy
- **Modern**: Clean, contemporary design aesthetic

## 🔍 Troubleshooting

### Common Issues

1. **API Rate Limiting**: Built-in rate limiting prevents issues
2. **Network Issues**: Ensure stable internet connection
3. **File Permissions**: Make sure output directory is writable
4. **Memory Issues**: For large batches, consider generating modules individually

### Debug Mode

```bash
export DEBUG=1
python full_branding_generator.py
```

## ⚡ Performance

- **Batch Processing**: Efficient generation of multiple assets
- **Rate Limiting**: Built-in API rate limiting
- **Progress Tracking**: Real-time generation progress
- **Error Recovery**: Automatic retry for failed generations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see main project LICENSE file for details.

---

**Complete branding solution! 🎨✨**