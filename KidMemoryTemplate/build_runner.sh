#!/bin/bash

# Build runner script for Kid Memory Template
# This script generates Hive adapters and runs the Flutter app

echo "🚀 Building Kid Memory Template..."

# Generate Hive adapters
echo "📦 Generating Hive adapters..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Get dependencies
echo "📥 Getting dependencies..."
flutter pub get

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

# Run tests (if any)
echo "🧪 Running tests..."
flutter test

echo "✅ Build complete! Run 'flutter run' to start the app."