#!/usr/bin/env python3
"""
Setup script for Kid Memory Template Art Generator
"""

from setuptools import setup, find_packages

with open("requirements.txt", "r") as f:
    requirements = f.read().splitlines()

setup(
    name="kid-memory-art-generator",
    version="1.0.0",
    description="Art generation tools for Kid Memory Template using Pollinations API",
    author="Kid Memory Template Team",
    author_email="team@kidmemorytemplate.com",
    packages=find_packages(),
    install_requires=requirements,
    entry_points={
        "console_scripts": [
            "kid-memory-art=cli_tool:main",
            "kid-memory-branding=full_branding_generator:main",
        ],
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    python_requires=">=3.8",
)