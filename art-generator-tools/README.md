# 🎨 Art Generator Tools

A comprehensive suite of art generation tools for the Kid Memory Template project. Each tool is designed for specific use cases and can be used independently or together.

## 🛠️ Available Tools

### 1. 🎨 [Cursor Art Generator](./cursor-art-generator/)
**Perfect for Cursor IDE integration**
- On-the-fly art generation during development
- Lightweight and easy to import
- Quick asset generation for testing and prototyping

### 2. 🎨 [Full Branding Generator](./full-branding-generator/)
**Complete branding solution**
- Generates all assets for entire application
- Batch processing for large asset sets
- Comprehensive branding package creation

### 3. 🎨 [CLI Tool](./cli-tool/)
**Command-line interface for automation**
- Perfect for build systems and automation
- Batch operations and scripting
- Flexible command-line options

### 4. 🔧 [Shared Components](./shared-components/)
**Common utilities and dependencies**
- Pollinations API client
- Common utilities and helpers
- Shared dependencies

## 🚀 Quick Start

### For Cursor IDE Users
```python
# Navigate to cursor-art-generator/
from cursor_art_generator import quick_generate
quick_generate("my_asset", "a cute elephant", 256, 256)
```

### For Complete Branding
```bash
# Navigate to full-branding-generator/
python full_branding_generator.py
```

### For CLI Automation
```bash
# Navigate to cli-tool/
python cli_tool.py --module shapes
```

## 📦 Installation

Each tool has its own installation instructions. Navigate to the specific tool folder and follow the README.

### Common Dependencies
All tools require:
- Python 3.7+
- requests>=2.31.0
- Pillow>=10.0.0
- pathlib>=1.0.1

## 🎯 Use Cases

### Development Workflow
1. **Cursor Art Generator** - Quick asset generation during development
2. **CLI Tool** - Batch generation for testing
3. **Full Branding Generator** - Complete asset package for release

### Production Workflow
1. **Full Branding Generator** - Generate all production assets
2. **CLI Tool** - Automated asset updates
3. **Cursor Art Generator** - Quick fixes and updates

## 📊 Tool Comparison

| Feature | Cursor Art Generator | Full Branding Generator | CLI Tool |
|---------|---------------------|------------------------|----------|
| **Use Case** | Development | Production | Automation |
| **Interface** | Python Import | Python Script | Command Line |
| **Batch Processing** | ❌ | ✅ | ✅ |
| **Custom Assets** | ✅ | ❌ | ✅ |
| **Module Generation** | ✅ | ✅ | ✅ |
| **Automation** | ❌ | ❌ | ✅ |
| **IDE Integration** | ✅ | ❌ | ❌ |

## 🔧 Shared Components

The `shared-components/` folder contains:
- `pollinations_client.py` - API client for art generation
- `requirements.txt` - Common dependencies
- Common utilities and helpers

## 🎨 Art Specifications

All tools generate assets with these specifications:
- **Format**: PNG with transparent background
- **Style**: Child-friendly, educational, cartoon
- **Quality**: High-resolution, optimized for mobile
- **Colors**: Bright, engaging, accessible

## 📁 Output Structure

```
generated_assets/
├── shapes/
│   ├── shapes_icon.png
│   ├── shapes_background.png
│   ├── shapes_circle.png
│   └── ...
├── colors/
├── animals/
├── jobs/
├── farm/
├── family/
├── ui/
└── custom/
```

## 🔍 Troubleshooting

### Common Issues

1. **Import Errors**: Ensure shared components are copied to tool directories
2. **API Issues**: Check internet connection and API rate limits
3. **File Permissions**: Ensure output directories are writable
4. **Dependencies**: Install requirements.txt for each tool

### Getting Help

1. Check the specific tool's README
2. Review the troubleshooting section
3. Check generated error logs
4. Create an issue on GitHub

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see main project LICENSE file for details.

## 🆘 Support

For issues and questions:
- Check the specific tool's README
- Review the troubleshooting section
- Create an issue on GitHub

---

**Choose the right tool for your needs! 🎨✨**