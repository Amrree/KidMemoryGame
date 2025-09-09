#!/usr/bin/env python3
"""
Test script for Pollinations API integration
"""

import urllib.request
import urllib.parse
import json

def test_pollinations_api():
    """Test Pollinations API with proper parameters."""
    
    # Test with proper API parameters - using correct format
    base_url = "https://pollinations.ai"
    prompt = "simple test image"
    
    # Replace spaces with underscores for URL
    url_prompt = prompt.replace(' ', '_')
    
    # Add parameters
    params = {
        'width': '512',
        'height': '512',
        'model': 'flux'
    }
    
    # Build URL with parameters
    param_string = '&'.join([f"{k}={v}" for k, v in params.items()])
    full_url = f"{base_url}/p/{url_prompt}?{param_string}"
    
    print(f"Testing URL: {full_url}")
    
    try:
        # Create request with proper headers
        request = urllib.request.Request(full_url)
        request.add_header('User-Agent', 'MemoryMatchArtGenerator/1.0')
        
        response = urllib.request.urlopen(request, timeout=60)
        
        if response.status == 200:
            data = response.read()
            print(f"✅ Pollinations API is working!")
            print(f"Response size: {len(data)} bytes")
            print(f"Content type: {response.headers.get('Content-Type', 'Unknown')}")
            
            # Save test image
            with open('test_image.png', 'wb') as f:
                f.write(data)
            print("✅ Test image saved as 'test_image.png'")
            return True
        else:
            print(f"❌ API returned status: {response.status}")
            return False
            
    except Exception as e:
        print(f"❌ API test failed: {e}")
        return False

if __name__ == "__main__":
    print("🧪 Testing Pollinations API...")
    success = test_pollinations_api()
    
    if success:
        print("\n🎉 API test successful! The art generation tools should work.")
    else:
        print("\n❌ API test failed. Please check your internet connection and try again.")