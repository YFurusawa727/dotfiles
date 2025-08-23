#!/bin/bash

# Validation script for dotfiles - checks configuration before installation
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output  
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

# Main validation function
main() {
    local exit_code=0

    echo "🔍 Validating dotfiles configuration..."
    echo "======================================"

    # Check system requirements
    log_check "Checking system requirements..."
    
    if ! command -v curl >/dev/null 2>&1; then
        log_error "curl is required but not installed"
        exit_code=1
    else
        log_info "✓ curl is available"
    fi

    if [ "$(uname)" != "Darwin" ]; then
        log_warn "This dotfiles setup is optimized for macOS"
    else
        log_info "✓ Running on macOS"
    fi

    # Check file structure
    log_check "Checking file structure..."
    
    required_files=(
        "install"
        "Brewfile"
        "packages/git/.gitconfig"
        "packages/zsh/.zshrc"
        "packages/bash/.bashrc"
        "packages/asdf/.tool-versions"
    )

    for file in "${required_files[@]}"; do
        if [ -f "$SCRIPT_DIR/$file" ]; then
            log_info "✓ $file exists"
        else
            log_error "✗ Required file missing: $file"
            exit_code=1
        fi
    done

    # Check executable permissions
    log_check "Checking executable permissions..."
    
    executables=(
        "install"
        "page_display"
        "test_install.sh"
        "validate.sh"
    )

    for script in "${executables[@]}"; do
        if [ -x "$SCRIPT_DIR/$script" ]; then
            log_info "✓ $script is executable"
        else
            log_warn "Making $script executable..."
            chmod +x "$SCRIPT_DIR/$script"
        fi
    done

    # Validate Brewfile syntax
    log_check "Validating Brewfile syntax..."
    
    if grep -q "^tap\|^brew\|^cask" "$SCRIPT_DIR/Brewfile"; then
        log_info "✓ Brewfile syntax looks correct"
    else
        log_error "✗ Brewfile appears to have syntax issues"
        exit_code=1
    fi

    # Check for sensitive information
    log_check "Checking for sensitive information..."
    
    sensitive_patterns=(
        "password"
        "secret"
        "key"
        "token"
        "api_key"
    )

    for pattern in "${sensitive_patterns[@]}"; do
        if grep -ri "$pattern" "$SCRIPT_DIR" --exclude-dir=.git --exclude="README.md" --exclude="validate.sh" >/dev/null 2>&1; then
            log_warn "Found potential sensitive information: $pattern"
        fi
    done

    # Validate stow packages structure
    log_check "Validating stow package structure..."
    
    if [ -d "$SCRIPT_DIR/packages" ]; then
        for package in "$SCRIPT_DIR/packages"/*; do
            if [ -d "$package" ]; then
                package_name=$(basename "$package")
                log_info "✓ Package directory found: $package_name"
                
                # Check if package has at least one configuration file
                if find "$package" -type f | grep -q .; then
                    log_info "  ✓ Contains configuration files"
                else
                    log_warn "  ⚠ Package $package_name is empty"
                fi
            fi
        done
    else
        log_error "✗ packages/ directory not found"
        exit_code=1
    fi

    # Check environment variables setup
    log_check "Checking environment variables setup..."
    
    if [ -f "$SCRIPT_DIR/.env.example" ]; then
        log_info "✓ .env.example file exists"
    else
        log_warn "⚠ .env.example file not found - users may need guidance on environment variables"
    fi

    # Final summary
    echo ""
    echo "======================================"
    if [ $exit_code -eq 0 ]; then
        log_info "🎉 All validations passed! Dotfiles are ready for installation."
    else
        log_error "❌ Some validations failed. Please fix the issues before proceeding."
    fi
    
    return $exit_code
}

# Run main function
main "$@"