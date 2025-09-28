#!/usr/bin/env bash
# smart-switch.sh - Intelligent NixOS workflow with Git integration
# Handles formatting, git commits, and NixOS configuration switching

set -euo pipefail

# Global debug flag
DEBUG=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            DEBUG=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [-v|--verbose] [-h|--help]"
            echo "  -v, --verbose    Enable debug output"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Logging functions
info() { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warning() { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*"; }
debug() { 
    if [[ "$DEBUG" == "true" ]]; then
        echo -e "${CYAN}🐛${NC} DEBUG: $*" >&2
    fi
}

# Check if we're in a git repository
# Exits with code 1 if not in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        error "Not in a Git repository"
        error "Initialize Git first: git init && git add . && git commit -m 'feat: initial NixOS configuration'"
        exit 1
    fi
}

is_conventional_commit() {
    local commit="$1"
    
    if echo "$commit" | rg -q "^(feat|fix|docs|style|refactor|perf|test|chore)(\(.+\))?: .+"; then
        return 0
    else
        return 1
    fi
}

# Global variables
COMMIT_MESSAGE=""
GIT_WORKFLOW_ACTION=""  # "SWITCH", "TEST_ONLY", "NO_ACTION"

# Interactive commit helper - sets global COMMIT_MESSAGE variable
commit_helper() {
    debug "Entering commit_helper function"
    echo ""
    info "Commit Type Examples:"
    echo "  feat     - New features"
    echo "  fix      - Bug fixes"  
    echo "  refactor - Code restructuring"
    echo "  chore    - Maintenance, updates"
    echo ""
    
    debug "Displaying commit type selection menu"
    echo "Select commit type:"
    echo "1) feat      - New feature or capability"
    echo "2) fix       - Bug fix or correction"
    echo "3) refactor  - Code restructuring" 
    echo "4) perf      - Performance improvement"
    echo "5) chore     - Maintenance, updates, cleanup"
    echo "6) docs      - Documentation changes"
    echo "7) style     - Formatting, whitespace"
    echo "8) revert    - Revert previous changes"
    echo ""
    
    debug "Starting commit type selection loop"
    while true; do
        printf "Enter choice (1-8): "
        if read -r type_choice < /dev/tty; then
            debug "User selected type choice: '$type_choice'"
        else
            debug "Failed to read input from terminal"
            error "Failed to read input. Please ensure script is run interactively."
            return 1
        fi
        case $type_choice in
            1) commit_type='feat'; debug "Selected commit type: feat"; break ;;
            2) commit_type='fix'; debug "Selected commit type: fix"; break ;;
            3) commit_type='refactor'; debug "Selected commit type: refactor"; break ;;
            4) commit_type='perf'; debug "Selected commit type: perf"; break ;;
            5) commit_type='chore'; debug "Selected commit type: chore"; break ;;
            6) commit_type='docs'; debug "Selected commit type: docs"; break ;;
            7) commit_type='style'; debug "Selected commit type: style"; break ;;
            8) commit_type='revert'; debug "Selected commit type: revert"; break ;;
            *) debug "Invalid choice: '$type_choice'"; warning "Invalid choice. Please select 1-8." ;;
        esac
    done
    
    debug "Commit type selected: $commit_type"
    echo ""
    info "Common scopes: specialisation, home-manager, kernel, audio, nvidia, desktop, services"
    printf "Enter scope (optional): "
    if read -r scope < /dev/tty; then
        debug "User entered scope: '$scope'"
    else
        debug "Failed to read scope input"
        scope=""
    fi
    
    echo ""
    printf "Enter description: "
    if read -r description < /dev/tty; then
        debug "User entered description: '$description'"
    else
        debug "Failed to read description input"
        error "Failed to read commit description. Aborting."
        return 1
    fi
    
    # Build commit message
    if [ -n "$scope" ]; then
        commit_msg="$commit_type($scope): $description"
    else
        commit_msg="$commit_type: $description"
    fi
    
    debug "Built commit message: '$commit_msg'"
    echo ""
    info "Generated commit message:"
    echo "  $commit_msg"
    echo ""
    
    printf "Open in editor for extended message? (y/N): "
    if read -r editor_choice < /dev/tty; then
        debug "User chose editor option: '$editor_choice'"
    else
        debug "Failed to read editor choice, defaulting to 'N'"
        editor_choice="N"
    fi
    
    if [[ "$editor_choice" =~ ^[Yy]$ ]]; then
        debug "Opening editor for extended commit message"
        temp_file=$(mktemp)
        debug "Created temp file: $temp_file"
        echo "$commit_msg" > "$temp_file"
        echo "" >> "$temp_file"
        echo "# Extended description (optional)" >> "$temp_file"
        echo "# - What: Detailed explanation of changes" >> "$temp_file"
        echo "# - Why: Reasoning behind this change" >> "$temp_file"
        echo "# - Impact: What this affects or improves" >> "$temp_file"
        echo "# Lines starting with # will be ignored" >> "$temp_file"
        
        debug "About to launch editor: ${EDITOR:-nvim}"
        info "Opening editor..."
        if ${EDITOR:-nvim} "$temp_file" </dev/tty >/dev/tty 2>&1; then
            debug "Editor exited successfully, processing commit message"
            # Clean up the commit message (remove comments and trim)
            commit_msg=$(grep -v '^#' "$temp_file" | sed '/^$/d' | head -c 500)
            debug "Processed commit message: '$commit_msg'"
        else
            debug "Editor failed or was cancelled"
            warning "Editor cancelled or failed, using original message"
        fi
        debug "Removing temp file: $temp_file"
        rm -f "$temp_file"
    else
        debug "User declined editor, using basic commit message"
    fi
    
    debug "Final commit message: '$commit_msg'"
    COMMIT_MESSAGE="$commit_msg"
    debug "Set global COMMIT_MESSAGE: '$COMMIT_MESSAGE'"
}

# Format Nix files
format_nix_files() {
    info "Step 1: Format Nix files"
    printf "Format Nix configuration files? (y/N): "
    read -r format_confirm < /dev/tty
    
    if [[ "$format_confirm" =~ ^[Yy]$ ]]; then
        info "Formatting Nix files..."
        if command -v nixfmt >/dev/null 2>&1; then
            info "Using nixfmt..."
            find . -name "*.nix" -not -path "./.git/*" -exec nixfmt {} \; 2>/dev/null || true
            success "Nix files formatted with nixfmt"
        elif command -v nixpkgs-fmt >/dev/null 2>&1; then
            info "Using nixpkgs-fmt..."
            find . -name "*.nix" -not -path "./.git/*" -exec nixpkgs-fmt {} \; 2>/dev/null || true
            success "Nix files formatted with nixpkgs-fmt"
        else
            warning "No Nix formatter available (nixfmt or nixpkgs-fmt)"
            warning "Install with: nix-env -iA nixpkgs.nixfmt"
        fi
    else
        info "Skipping code formatting"
    fi
}

# Analyze git status and handle commits
# Sets global GIT_WORKFLOW_ACTION: "SWITCH", "TEST_ONLY", "NO_ACTION"
# Returns: 0=success, 1=error/user declined
handle_git_workflow() {
    info "Step 2: Analyze Git status and handle commits"
    
    # Get git status information
    local status_output
    status_output=$(git status --porcelain)
    local staged_files
    staged_files=$(echo "$status_output" | rg '^[MADRC]' || true)
    local unstaged_files  
    unstaged_files=$(echo "$status_output" | rg '^.[MD]' || true)
    local untracked_files
    untracked_files=$(echo "$status_output" | rg '^\?\?' || true)
    
    if [ -n "$untracked_files" ]; then
        # Untracked files present - never switch
        info "You have untracked files:"
        git status --short
        echo ""
        warning "Please stage files first:"
        warning "  git add <files>  # Add specific files"
        warning "  git add .        # Add all files"
        GIT_WORKFLOW_ACTION="NO_ACTION"
        return 1
        
    elif [ -z "$status_output" ]; then
        # Clean repository
        info "Repository is clean, checking last commit format..."
        local last_commit
        last_commit=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "")
        
        if is_conventional_commit "$last_commit"; then
            success "Last commit follows Conventional Commits format"
            success "Ready to switch!"
            GIT_WORKFLOW_ACTION="SWITCH"
            return 0
        else
            warning "Last commit does not follow Conventional Commits format"
            printf "Fix commit message and then switch? (y/N): "
            read -r confirm < /dev/tty
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Fixing commit message..."
                commit_helper
                local new_commit_msg="$COMMIT_MESSAGE"
                
                if [[ -z "$new_commit_msg" ]]; then
                    error "Commit amendment failed: Empty commit message"
                    GIT_WORKFLOW_ACTION="NO_ACTION"
                    return 1
                fi
                
                if git commit --amend -m "$new_commit_msg"; then
                    success "Commit message fixed"
                    GIT_WORKFLOW_ACTION="SWITCH"
                    return 0
                else
                    error "Git commit amend failed"
                    GIT_WORKFLOW_ACTION="NO_ACTION"
                    return 1
                fi
            else
                GIT_WORKFLOW_ACTION="NO_ACTION"
                return 1
            fi
        fi
        
    elif [ -n "$staged_files" ] && [ -z "$unstaged_files" ] && [ -z "$untracked_files" ]; then
        # All changes staged (has staged, no unstaged, no untracked)
        info "All changes are staged:"
        git status --short
        echo ""
        printf "Commit staged changes and switch? (y/N): "
        read -r confirm < /dev/tty
        debug "User confirm choice: '$confirm'"
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            debug "User confirmed commit, starting commit helper"
            info "Generating commit message..."
            commit_helper
            local commit_msg="$COMMIT_MESSAGE"
            debug "Commit helper returned: '$commit_msg'"
            
            if [[ -z "$commit_msg" ]]; then
                debug "Commit message is empty, aborting"
                error "Commit failed: Empty commit message"
                GIT_WORKFLOW_ACTION="NO_ACTION"
                return 1
            fi
            
            debug "Executing git commit with message: '$commit_msg'"
            info "Committing changes..."
            if git commit -m "$commit_msg"; then
                debug "Git commit succeeded"
                success "Changes committed successfully"
                GIT_WORKFLOW_ACTION="SWITCH"
                return 0
            else
                debug "Git commit failed"
                error "Git commit failed"
                GIT_WORKFLOW_ACTION="NO_ACTION"
                return 1
            fi
        else
            debug "User declined to commit"
            GIT_WORKFLOW_ACTION="NO_ACTION"
            return 1
        fi
        
    elif [ -n "$staged_files" ] && [ -n "$unstaged_files" ]; then
        # Mixed staged/unstaged (has staged, has unstaged)
        debug "Detected mixed staged/unstaged changes"
        info "You have both staged and unstaged changes:"
        git status --short
        echo ""
        warning "Unstaged changes won't be committed."
        printf "Commit staged changes only? (y/N): "
        read -r commit_confirm < /dev/tty
        debug "User commit_confirm choice: '$commit_confirm'"
        if [[ "$commit_confirm" =~ ^[Yy]$ ]]; then
            debug "User confirmed commit for staged changes only, starting commit helper"
            info "Generating commit message..."
            commit_helper
            local commit_msg="$COMMIT_MESSAGE"
            debug "Commit helper returned: '$commit_msg'"
            
            if [[ -z "$commit_msg" ]]; then
                debug "Commit message is empty, aborting"
                error "Commit failed: Empty commit message"
            else
                debug "Executing git commit with message: '$commit_msg'"
                info "Committing staged changes..."
                if git commit -m "$commit_msg"; then
                    debug "Git commit succeeded"
                    success "Staged changes committed successfully"
                else
                    debug "Git commit failed"
                    error "Git commit failed"
                fi
            fi
        else
            debug "User declined to commit staged changes"
        fi
        debug "Mixed staged/unstaged section complete"
        debug "About to return TEST_ONLY"
        GIT_WORKFLOW_ACTION="TEST_ONLY"
        return 0  # Success, but only test available
        
    elif [ -z "$staged_files" ] && [ -n "$unstaged_files" ]; then
        # Unstaged changes only (no staged, has unstaged)
        info "You have unstaged changes:"
        git status --short
        echo ""
        warning "Please stage changes first: git add <files> or git add ."
        GIT_WORKFLOW_ACTION="TEST_ONLY"
        return 0  # Success, but only test available
        
    else
        warning "Complex Git status detected:"
        git status --short
        echo ""
        warning "Please resolve Git status manually."
        GIT_WORKFLOW_ACTION="NO_ACTION"
        return 1
    fi
}

# Handle NixOS operations based on Git workflow action
handle_nixos_operations() {
    local git_workflow_action="$1"
    
    echo ""
    info "Step 3: NixOS Operations"
    
    case $git_workflow_action in
        "SWITCH")  # Ready to switch
            info "About to test and apply NixOS configuration..."
            printf "Proceed with safe-switch (test + switch)? (y/N): "
            read -r confirm < /dev/tty
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Testing NixOS configuration..."
                if nh os test .; then
                    success "Configuration test passed"
                    info "Applying NixOS configuration..."
                    if nh os switch .; then
                        success "NixOS configuration applied successfully"
                        echo ""
                        success "🎉 Smart switch completed successfully!"
                        echo ""
                        info "Current system information:"
                        nh os info | head -n 5
                        return 0
                    else
                        error "Failed to apply NixOS configuration"
                        return 1
                    fi
                else
                    error "Configuration test failed"
                    return 1
                fi
            else
                info "NixOS switch cancelled by user"
                return 1
            fi
            ;;
        "TEST_ONLY")  # Can test but shouldn't switch
            printf "Test NixOS configuration? (y/N): "
            read -r confirm < /dev/tty
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Testing NixOS configuration..."
                if nh os test .; then
                    success "✓ Configuration test completed"
                    return 0
                else
                    error "Configuration test failed"
                    return 1
                fi
            else
                info "Configuration test skipped"
                return 1
            fi
            ;;
        *)  # NO_ACTION: Git issues prevent any NixOS operations
            info "No further actions available."
            info "Resolve Git status and run again when ready."
            return 1
            ;;
    esac
}

# Main function
main() {
    debug "Starting smart-switch with DEBUG=$DEBUG"
    echo "Smart Switch - Analyzing repository status..."
    echo ""
    
    debug "Checking if we're in a git repository"
    check_git_repo
    
    debug "Starting format phase"
    format_nix_files
    echo ""
    
    debug "Starting git workflow analysis"
    if handle_git_workflow; then
        debug "Git workflow completed successfully, action: $GIT_WORKFLOW_ACTION"
    else
        debug "Git workflow failed or was declined, action: $GIT_WORKFLOW_ACTION"
    fi
    debug "Continuing with main function..."
    
    # Always show what happens next
    if [[ "$GIT_WORKFLOW_ACTION" == "TEST_ONLY" ]]; then
        echo ""
        echo "Git workflow completed. Continuing to NixOS operations..."
    fi
    echo ""
    
    debug "About to start NixOS operations with action: $GIT_WORKFLOW_ACTION"
    handle_nixos_operations "$GIT_WORKFLOW_ACTION"
    debug "NixOS operations completed"
}

# Run main function
main "$@"