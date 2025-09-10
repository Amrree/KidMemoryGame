#!/usr/bin/env python3
"""
Test script for Pollinations API integration
Tests the API connection and generates a simple test image
"""

import sys
import os
from pathlib import Path

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pollinations_client import PollinationsClient, ArtSpec

def test_api_connection():
    """Test basic API connection"""
    print("🔍 Testing Pollinations API connection...")
    
    client = PollinationsClient()
    
    # Create a simple test spec
    test_spec = ArtSpec(
        name="test_image",
        prompt="simple red circle, educational, child-friendly, clean design",
        width=256,
        height=256,
        background="transparent"
    )
    
    print("📡 Generating test image...")
    image_data = client.generate_image(test_spec)
    
    if image_data:
        # Save test image
        test_dir = Path("test_output")
        test_dir.mkdir(exist_ok=True)
        
        test_path = test_dir / "test_image.png"
        with open(test_path, 'wb') as f:
            f.write(image_data)
        
        print(f"✅ API test successful! Test image saved to: {test_path}")
        print(f"📊 Image size: {len(image_data)} bytes")
        return True
    else:
        print("❌ API test failed - no image data received")
        return False

def test_batch_generation():
    """Test batch generation"""
    print("\n🔍 Testing batch generation...")
    
    client = PollinationsClient()
    
    # Create test specs
    test_specs = [
        ArtSpec(
            name="test_circle",
            prompt="simple red circle, educational, child-friendly, clean design",
            width=128,
            height=128,
            background="transparent"
        ),
        ArtSpec(
            name="test_square",
            prompt="simple blue square, educational, child-friendly, clean design",
            width=128,
            height=128,
            background="transparent"
        ),
    ]
    
    print("📡 Generating test batch...")
    results = client.generate_batch(test_specs, "test_output/batch")
    
    success_count = sum(1 for success in results.values() if success)
    total_count = len(results)
    
    print(f"✅ Batch test completed: {success_count}/{total_count} images generated")
    
    for filename, success in results.items():
        status = "✅" if success else "❌"
        print(f"  {status} {filename}")
    
    return success_count == total_count

def main():
    """Run all tests"""
    print("🧪 Starting Pollinations API tests...\n")
    
    # Test 1: Basic API connection
    test1_passed = test_api_connection()
    
    # Test 2: Batch generation
    test2_passed = test_batch_generation()
    
    # Summary
    print(f"\n📊 Test Summary:")
    print(f"  API Connection: {'✅ PASS' if test1_passed else '❌ FAIL'}")
    print(f"  Batch Generation: {'✅ PASS' if test2_passed else '❌ FAIL'}")
    
    if test1_passed and test2_passed:
        print("\n🎉 All tests passed! The art generation system is ready to use.")
        return 0
    else:
        print("\n❌ Some tests failed. Please check the error messages above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())