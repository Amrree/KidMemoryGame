# 🎨 CLI Art Generator Tool

A powerful command-line interface for all art generation needs. Perfect for batch operations, automation, and integration with build systems.

## 🚀 Quick Start

```bash
# List available modules
python cli_tool.py --list-modules

# Generate entire module
python cli_tool.py --module shapes

# Generate specific asset
python cli_tool.py --module shapes --asset circle

# Generate custom asset
python cli_tool.py --custom "my_asset" --prompt "a cute elephant"
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

3. **Make executable:**
   ```bash
   chmod +x cli_tool.py
   ```

4. **Run installation script:**
   ```bash
   ./install.sh
   ```

## 🎯 Features

- **Command-line Interface**: Easy-to-use CLI for all operations
- **Module Management**: List and generate educational modules
- **Asset Management**: Generate specific assets or entire modules
- **Custom Generation**: Create custom assets with user prompts
- **Batch Operations**: Efficient batch processing
- **Flexible Output**: Customizable output directories and formats

## 📁 Files

- `cli_tool.py` - Main CLI tool script
- `install.sh` - Installation script
- `requirements.txt` - Python dependencies
- `README.md` - This documentation

## 🔧 Usage Examples

### List Available Modules
```bash
python cli_tool.py --list-modules
```

### List Assets for Module
```bash
python cli_tool.py --list-assets --module shapes
```

### Generate Entire Module
```bash
python cli_tool.py --module shapes
```

### Generate Specific Asset
```bash
python cli_tool.py --module shapes --asset circle
```

### Generate Custom Asset
```bash
python cli_tool.py --custom "my_elephant" --prompt "a cute cartoon elephant"
```

### Generate with Custom Dimensions
```bash
python cli_tool.py --module shapes --asset circle --width 256 --height 256
```

### Generate All Modules
```bash
python cli_tool.py --module all
```

## 📋 Command Options

### Basic Options
- `--list-modules` - List all available modules
- `--list-assets` - List assets for a module
- `--module <name>` - Specify module to generate
- `--asset <name>` - Specify asset to generate
- `--custom <name>` - Generate custom asset
- `--prompt <text>` - Custom generation prompt

### Output Options
- `--output <path>` - Custom output directory
- `--width <pixels>` - Custom width
- `--height <pixels>` - Custom height
- `--format <format>` - Output format (png, jpg)

### Control Options
- `--verbose` - Verbose output
- `--quiet` - Quiet mode
- `--dry-run` - Show what would be generated
- `--force` - Overwrite existing files

## 🎨 Available Modules

- **shapes** - Basic geometric shapes
- **colors** - Color recognition
- **animals** - Animal recognition
- **jobs** - Profession recognition
- **farm** - Farm animal recognition
- **family** - Family member recognition

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
└── custom/
    └── my_elephant.png
```

## 🔍 Troubleshooting

### Common Issues

1. **Permission Errors**: Run `chmod +x cli_tool.py`
2. **Import Errors**: Ensure `pollinations_client.py` is present
3. **API Issues**: Check internet connection and rate limits
4. **File Permissions**: Ensure output directory is writable

### Debug Mode

```bash
export DEBUG=1
python cli_tool.py --module shapes
```

### Verbose Output

```bash
python cli_tool.py --verbose --module shapes
```

## ⚡ Performance Tips

- **Batch Operations**: Use `--module all` for efficient batch generation
- **Custom Dimensions**: Specify dimensions to optimize file sizes
- **Output Directory**: Use SSD storage for faster file operations
- **Rate Limiting**: Built-in rate limiting prevents API issues

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see main project LICENSE file for details.

---

**Powerful CLI for all art generation needs! 🎨✨**