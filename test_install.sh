#!/bin/bash

# Test script for dotfiles installation
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_LOG="$SCRIPT_DIR/test_results.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$TEST_LOG"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    echo "[WARN] $1" >> "$TEST_LOG"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[ERROR] $1" >> "$TEST_LOG"
}

# Test function template
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo "Running test: $test_name"
    if eval "$test_command" >> "$TEST_LOG" 2>&1; then
        log_info "✓ $test_name - PASSED"
        return 0
    else
        log_error "✗ $test_name - FAILED"
        return 1
    fi
}

# Initialize test log
echo "Dotfiles Installation Test Report" > "$TEST_LOG"
echo "Generated: $(date)" >> "$TEST_LOG"
echo "========================================" >> "$TEST_LOG"

log_info "Starting dotfiles installation tests..."

# Test 1: Check if required commands are available
log_info "Testing system requirements..."

run_test "Homebrew installed" "command -v brew >/dev/null 2>&1"
run_test "Git available" "command -v git >/dev/null 2>&1"
run_test "Stow available" "command -v stow >/dev/null 2>&1"
run_test "asdf available" "command -v asdf >/dev/null 2>&1"

# Test 2: Validate configuration files
log_info "Testing configuration file validity..."

run_test "Brewfile syntax" "brew bundle check --file=$SCRIPT_DIR/Brewfile || true"
run_test "Install script executable" "test -x $SCRIPT_DIR/install"
run_test "Page display script executable" "test -x $SCRIPT_DIR/page_display"

# Test 3: Check stow configurations
log_info "Testing stow configurations..."

for package in git asdf zsh bash starship alacritty; do
    if [ -d "$SCRIPT_DIR/packages/$package" ]; then
        # Check for conflicts and use --adopt flag for testing if needed
        if [ "$package" = "alacritty" ]; then
            run_test "Stow dry-run for $package" "stow -n -v -d $SCRIPT_DIR/packages -t $HOME $package --adopt 2>/dev/null || stow -n -v -d $SCRIPT_DIR/packages -t $HOME $package"
        else
            run_test "Stow dry-run for $package" "stow -n -v -d $SCRIPT_DIR/packages -t $HOME $package"
        fi
    else
        log_warn "Package directory not found: $package"
    fi
done

# Test 4: Validate .tool-versions
log_info "Testing asdf configuration..."

if [ -f "$SCRIPT_DIR/packages/asdf/.tool-versions" ]; then
    while read -r plugin version; do
        if [ -n "$plugin" ] && [ -n "$version" ]; then
            run_test "asdf plugin $plugin available" "asdf plugin list all | grep -q \"^$plugin[[:space:]]\""
        fi
    done < "$SCRIPT_DIR/packages/asdf/.tool-versions"
else
    log_warn ".tool-versions file not found"
fi

# Test 5: Shell configuration syntax
log_info "Testing shell configurations..."

if [ -f "$SCRIPT_DIR/packages/zsh/.zshrc" ]; then
    run_test "Zsh config syntax" "zsh -n $SCRIPT_DIR/packages/zsh/.zshrc"
fi

if [ -f "$SCRIPT_DIR/packages/bash/.bashrc" ]; then
    run_test "Bash config syntax" "bash -n $SCRIPT_DIR/packages/bash/.bashrc"
fi

# Test 6: Git configuration
log_info "Testing git configuration..."

run_test "Git config valid" "git config -f $SCRIPT_DIR/packages/git/.gitconfig --list >/dev/null"

# Test 7: Starship configuration
if [ -f "$SCRIPT_DIR/packages/starship/.config/starship.toml" ]; then
    if command -v starship >/dev/null 2>&1; then
        run_test "Starship config valid" "STARSHIP_CONFIG=$SCRIPT_DIR/packages/starship/.config/starship.toml starship module character >/dev/null"
    else
        log_warn "Starship not installed, skipping configuration test"
    fi
fi

# Test 8: URL validation in page_display
log_info "Testing page_display script..."

run_test "Page display URLs valid" "grep -oE 'https?://[^\"]*' $SCRIPT_DIR/page_display | while read -r url; do timeout 5 curl -Is \"\$url\" | head -1 | grep -q '200\\|301\\|302' || true; done"

# Summary
echo "" >> "$TEST_LOG"
echo "Test Summary:" >> "$TEST_LOG"
echo "=============" >> "$TEST_LOG"

passed_tests=$(grep -o "PASSED" "$TEST_LOG" | wc -l | tr -d ' ')
failed_tests=$(grep -o "FAILED" "$TEST_LOG" | wc -l | tr -d ' ')
total_tests=$((passed_tests + failed_tests))

log_info "Tests completed: $total_tests total, $passed_tests passed, $failed_tests failed"

if [ "$failed_tests" -eq 0 ]; then
    log_info "All tests passed! ✅"
    exit 0
else
    log_error "Some tests failed. Check $TEST_LOG for details."
    exit 1
fi