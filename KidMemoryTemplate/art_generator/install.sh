#!/bin/bash

# Kid Memory Template Art Generator Installation Script

echo "🎨 Installing Kid Memory Template Art Generator..."

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3.8 or higher and try again."
    exit 1
fi

# Check Python version
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
required_version="3.8"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "❌ Python 3.8 or higher is required. Found: $python_version"
    exit 1
fi

echo "✅ Python $python_version found"

# Install requirements
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x *.py

# Create output directories
echo "📁 Creating output directories..."
mkdir -p generated_assets
mkdir -p test_output

# Run API test
echo "🧪 Testing API connection..."
python3 test_api.py

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Installation completed successfully!"
    echo ""
    echo "📚 Quick Start:"
    echo "  # Generate all art:"
    echo "  python3 cli_tool.py --module all"
    echo ""
    echo "  # Generate specific module:"
    echo "  python3 cli_tool.py --module shapes"
    echo ""
    echo "  # Generate custom asset:"
    echo "  python3 cli_tool.py --custom my_asset --prompt 'a cute elephant'"
    echo ""
    echo "  # List available modules:"
    echo "  python3 cli_tool.py --list-modules"
    echo ""
    echo "📖 For more information, see README.md"
else
    echo "⚠️  Installation completed but API test failed."
    echo "The tools are installed but may not work properly."
    echo "Please check your internet connection and try running:"
    echo "  python3 test_api.py"
fi