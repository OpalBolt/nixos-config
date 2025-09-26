#!/usr/bin/env bash
# smart-switch.sh - Intelligent NixOS workflow with Git integration
# Handles formatting, git commits, and NixOS configuration switching

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
info() { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warning() { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*"; }

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

# Interactive commit helper
commit_helper() {
    echo ""
    info "Commit Type Examples:"
    echo "  feat     - New features"
    echo "  fix      - Bug fixes"  
    echo "  refactor - Code restructuring"
    echo "  chore    - Maintenance, updates"
    echo ""
    
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
    
    while true; do
        printf "Enter choice (1-8): "
        read -r type_choice
        case $type_choice in
            1) commit_type='feat'; break ;;
            2) commit_type='fix'; break ;;
            3) commit_type='refactor'; break ;;
            4) commit_type='perf'; break ;;
            5) commit_type='chore'; break ;;
            6) commit_type='docs'; break ;;
            7) commit_type='style'; break ;;
            8) commit_type='revert'; break ;;
            *) warning "Invalid choice. Please select 1-8." ;;
        esac
    done
    
    echo ""
    info "Common scopes: specialisation, home-manager, kernel, audio, nvidia, desktop, services"
    printf "Enter scope (optional): "
    read -r scope
    
    echo ""
    printf "Enter description: "
    read -r description
    
    # Build commit message
    if [ -n "$scope" ]; then
        commit_msg="$commit_type($scope): $description"
    else
        commit_msg="$commit_type: $description"
    fi
    
    echo ""
    info "Generated commit message:"
    echo "  $commit_msg"
    echo ""
    
    printf "Open in editor for extended message? (y/N): "
    read -r editor_choice
    
    if [[ "$editor_choice" =~ ^[Yy]$ ]]; then
        temp_file=$(mktemp)
        echo "$commit_msg" > "$temp_file"
        echo "" >> "$temp_file"
        echo "# Extended description (optional)" >> "$temp_file"
        echo "# - What: Detailed explanation of changes" >> "$temp_file"
        echo "# - Why: Reasoning behind this change" >> "$temp_file"
        echo "# - Impact: What this affects or improves" >> "$temp_file"
        
        ${EDITOR:-vim} "$temp_file"
        commit_msg=$(cat "$temp_file")
        rm -f "$temp_file"
    fi
    
    printf '%s' "$commit_msg"
}

# Format Nix files
format_nix_files() {
    info "Step 1: Format Nix files"
    printf "Format Nix configuration files? (y/N): "
    read -r format_confirm
    
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
# Returns:
#   0 = Ready to switch (clean repo with valid commit OR successful commit made)
#   2 = Test only (has unstaged changes, can test but shouldn't switch)
#   3 = No actions (any other case - must resolve manually)
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
        return 3  # No actions available
        
    elif [ -z "$status_output" ]; then
        # Clean repository
        info "Repository is clean, checking last commit format..."
        local last_commit
        last_commit=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "")
        
        if is_conventional_commit "$last_commit"; then
            success "Last commit follows Conventional Commits format"
            success "Ready to switch!"
            return 0  # Proceed with switch
        else
            warning "Last commit does not follow Conventional Commits format"
            printf "Fix commit message and then switch? (y/N): "
            read -r confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Fixing commit message..."
                local new_commit_msg
                new_commit_msg=$(commit_helper)
                git commit --amend -m "$new_commit_msg"
                success "Commit message fixed"
                return 0  # Proceed with switch
            else
                return 3  # No actions - user declined
            fi
        fi
        
    elif [ -n "$staged_files" ] && [ -z "$unstaged_files" ] && [ -z "$untracked_files" ]; then
        # All changes staged (has staged, no unstaged, no untracked)
        info "All changes are staged:"
        git status --short
        echo ""
        printf "Commit staged changes and switch? (y/N): "
        read -r confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            local commit_msg
            commit_msg=$(commit_helper)
            git commit -m "$commit_msg"
            success "Changes committed successfully"
            return 0  # Proceed with switch
        else
            return 3  # No actions - user declined
        fi
        
    elif [ -n "$staged_files" ] && [ -n "$unstaged_files" ]; then
        # Mixed staged/unstaged (has staged, has unstaged)
        info "You have both staged and unstaged changes:"
        git status --short
        echo ""
        warning "Unstaged changes won't be committed."
        printf "Commit staged changes only? (y/N): "
        read -r commit_confirm
        if [[ "$commit_confirm" =~ ^[Yy]$ ]]; then
            local commit_msg
            commit_msg=$(commit_helper)
            git commit -m "$commit_msg"
            success "Staged changes committed successfully"
        fi
        return 2  # Offer test only
        
    elif [ -z "$staged_files" ] && [ -n "$unstaged_files" ]; then
        # Unstaged changes only (no staged, has unstaged)
        info "You have unstaged changes:"
        git status --short
        echo ""
        warning "Please stage changes first: git add <files> or git add ."
        return 2  # Offer test only
        
    else
        warning "Complex Git status detected:"
        git status --short
        echo ""
        warning "Please resolve Git status manually."
        return 3  # No actions available
    fi
}

# Handle NixOS operations based on Git workflow result
handle_nixos_operations() {
    local git_workflow_result=$1
    
    info "Step 3: NixOS Operations"
    
    case $git_workflow_result in
        0)  # READY_TO_SWITCH: Repository clean and ready
            info "About to test and apply NixOS configuration..."
            printf "Proceed with safe-switch (test + switch)? (y/N): "
            read -r confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Testing NixOS configuration..."
                if nh os test; then
                    success "Configuration test passed"
                    info "Applying NixOS configuration..."
                    if nh os switch; then
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
        2)  # TEST_ONLY: Can test but shouldn't switch
            printf "Test NixOS configuration? (y/N): "
            read -r confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Testing NixOS configuration..."
                if nh os test; then
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
        *)  # NO_ACTIONS: Git issues prevent any NixOS operations
            info "No further actions available."
            info "Resolve Git status and run again when ready."
            return 1
            ;;
    esac
}

# Main function
main() {
    echo "Smart Switch - Analyzing repository status..."
    echo ""
    
    check_git_repo
    
    format_nix_files
    echo ""
    
    local git_workflow_result
    handle_git_workflow
    git_workflow_result=$?  # Capture return code: 0=ready to switch, 2=test only, 3=no actions
    echo ""
    
    handle_nixos_operations $git_workflow_result
}

# Run main function
main "$@"