#!/usr/bin/env bash
# smart-switch.sh - Intelligent NixOS workflow with Git integration
# Handles formatting, git commits, and NixOS configuration switching

set -euo pipefail

# Global debug flag
DEBUG=false

# Check if gum is available
if ! command -v gum >/dev/null 2>&1; then
    echo "❌ Error: gum is not installed or not in PATH"
    echo "💡 To install gum, ensure you're in a nix develop shell or add it to your system packages"
    echo "   Run: nix develop"
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            DEBUG=true
            shift
            ;;
        -h|--help)
            gum style \
                --foreground 109 \
                --border-foreground 102 \
                --border double \
                --align center \
                --width 50 \
                --margin "1 2" \
                --padding "2 4" \
                "Smart Switch" "NixOS Workflow Tool"
            
            echo ""
            gum format -- "**Usage:** $0 [-v|--verbose] [-h|--help]"
            echo ""
            gum format -- "**Options:**"
            gum format -- "  -v, --verbose    Enable debug output"
            gum format -- "  -h, --help       Show this help message"
            echo ""
            gum format -- "**Description:**"
            gum format -- "Intelligent NixOS workflow that handles:"
            gum format -- "• Code formatting with nixfmt"
            gum format -- "• Git commits with Conventional Commits"
            gum format -- "• Safe NixOS configuration switching"
            exit 0
            ;;
        *)
            gum style --foreground 167 "❌ Unknown option: $1"
            gum format -- "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Logging functions - now using gum with Kanagawa/OneDark inspired colors
info() { gum style --foreground 109 "ℹ️ $*"; }      # Muted blue-gray
success() { gum style --foreground 107 "✅ $*"; }   # Soft green  
warning() { gum style --foreground 179 "⚠️  $*"; }  # Warm yellow
error() { gum style --foreground 167 "❌ $*"; }     # Soft red
debug() { 
    if [[ "$DEBUG" == "true" ]]; then
        gum style --foreground 102 --faint "🐛 DEBUG: $*"  # Muted gray
    fi
}

# Pretty header function
show_header() {
    gum style \
        --foreground 109 \
        --border-foreground 102 \
        --border double \
        --align center \
        --width 60 \
        --margin "1 2" \
        --padding "1 4" \
        "🚀 Smart Switch" \
        "NixOS Configuration Workflow"
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
    
    gum style --border normal --margin "1 2" --padding "1 2" \
        "📝 **Commit Message Builder**" \
        "" \
        "Building a Conventional Commit message..." \
        "Format: type(scope): description"
    
    debug "Displaying commit type selection menu"
    
    # Commit type selection with gum filter for fuzzy search
    commit_type=$(gum filter \
        --header "🏷️ Select commit type (fuzzy search enabled):" \
        --height 10 \
        --placeholder "Type to search..." \
        --limit 1 \
        "feat     - New feature or capability" \
        "fix      - Bug fix or correction" \
        "refactor - Code restructuring" \
        "perf     - Performance improvement" \
        "chore    - Maintenance, updates, cleanup" \
        "docs     - Documentation changes" \
        "style    - Formatting, whitespace" \
        "test     - Adding or fixing tests" \
        "revert   - Revert previous changes" \
        "ci       - CI/CD changes" \
        "build    - Build system changes")
    
    # Extract just the type name
    commit_type=$(echo "$commit_type" | cut -d' ' -f1)
    debug "Selected commit type: $commit_type"
    
    # Scope input with gum
    gum style --foreground 109 "🎯 Common scopes: specialisation, home-manager, kernel, audio, nvidia, desktop, services"
    scope=$(gum input \
        --placeholder "Enter scope (optional)" \
        --prompt "Scope: " \
        --width 50 || echo "")
    debug "User entered scope: '$scope'"
    
    # Description input with gum
    description=$(gum input \
        --placeholder "Enter a clear, concise description" \
        --prompt "Description: " \
        --width 80)
    
    if [[ -z "$description" ]]; then
        error "Description cannot be empty"
        return 1
    fi
    debug "User entered description: '$description'"
    
    # Build commit message
    if [ -n "$scope" ]; then
        commit_msg="$commit_type($scope): $description"
    else
        commit_msg="$commit_type: $description"
    fi
    
    debug "Built commit message: '$commit_msg'"
    
    # Show preview
    gum style --border normal --margin "1 2" --padding "1 2" \
        "📄 **Generated commit message:**" \
        "" \
        "$commit_msg"
    
    # Ask about extended message
    if gum confirm "📝 Open editor for extended commit message?"; then
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
        if ${EDITOR:-nvim} "$temp_file"; then
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
    gum style --foreground 109 "📝 Step 1: Format Nix files"
    
    if gum confirm "Format Nix configuration files?"; then
        # Check if there are any staged changes first
        local has_staged_changes=false
        if git diff --cached --quiet; then
            has_staged_changes=false
        else
            has_staged_changes=true
        fi
        
        if [[ "$has_staged_changes" == "true" ]]; then
            warning "You have staged changes. Formatting will only affect unstaged files."
            if ! gum confirm "Continue with formatting?"; then
                info "Skipping code formatting"
                return 0
            fi
        fi
        
        # Get list of Nix files that are either unstaged or untracked
        local nix_files_to_format
        nix_files_to_format=$(find . -name "*.nix" -not -path "./.git/*" -type f | while read -r file; do
            # Check if file has unstaged changes or is untracked
            if ! git diff --quiet "$file" 2>/dev/null || ! git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
                echo "$file"
            fi
        done)
        
        if [[ -z "$nix_files_to_format" ]]; then
            info "No Nix files need formatting"
            return 0
        fi
        
        # Show which files will be formatted
        local file_count
        file_count=$(echo "$nix_files_to_format" | wc -l)
        local preview_text
        preview_text=$(echo "$nix_files_to_format" | head -10)
        if [[ $file_count -gt 10 ]]; then
            preview_text="$preview_text"$'\n'"... and $(( file_count - 10 )) more files"
        fi
        
        gum style --border normal --margin "1 2" --padding "1 2" \
            "📝 **Files to be formatted:**" \
            "" \
            "$preview_text"
        
        if gum confirm "Proceed with formatting these files?"; then
            gum spin --spinner dot --title "Formatting Nix files..." -- bash -c "
                if command -v nixfmt >/dev/null 2>&1; then
                    echo '$nix_files_to_format' | xargs -r nixfmt 2>/dev/null || true
                    echo 'nixfmt-rfc-style'
                elif command -v nixpkgs-fmt >/dev/null 2>&1; then
                    echo '$nix_files_to_format' | xargs -r nixpkgs-fmt 2>/dev/null || true
                    echo 'nixpkgs-fmt'
                else
                    echo 'none'
                fi
            " | {
                read formatter
                case $formatter in
                    "nixfmt-rfc-style")
                        success "Nix files formatted with nixfmt (RFC style)"
                        ;;
                    "nixpkgs-fmt")
                        success "Nix files formatted with nixpkgs-fmt"
                        ;;
                    "none")
                        warning "No Nix formatter available (nixfmt or nixpkgs-fmt)"
                        warning "Run 'nix develop' to access nixfmt-rfc-style formatter"
                        ;;
                esac
            }
        else
            info "Formatting cancelled"
        fi
    else
        info "Skipping code formatting"
    fi
}

# Analyze git status and handle commits
# Sets global GIT_WORKFLOW_ACTION: "SWITCH", "TEST_ONLY", "NO_ACTION"
# Returns: 0=success, 1=error/user declined
handle_git_workflow() {
    gum style --foreground 109 "🔍 Step 2: Analyze Git status and handle commits"
    
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
        gum style --border normal --margin "1 2" --padding "1 2" \
            "📂 **Untracked files detected:**" \
            "" \
            "$(git status --short)"
        
        warning "Please stage files first:"
        gum format -- "• \`git add <files>\`  - Add specific files"
        gum format -- "• \`git add .\`        - Add all files"
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
            gum style --border normal --margin "1 2" --padding "1 2" \
                "📝 **Current commit message:**" \
                "" \
                "$last_commit"
            
            if gum confirm "Fix commit message and then switch?"; then
                info "Fixing commit message..."
                commit_helper
                local new_commit_msg="$COMMIT_MESSAGE"
                
                if [[ -z "$new_commit_msg" ]]; then
                    error "Commit amendment failed: Empty commit message"
                    GIT_WORKFLOW_ACTION="NO_ACTION"
                    return 1
                fi
                
                if gum spin --spinner dot --title "Amending commit message..." -- git commit --amend -m "$new_commit_msg"; then
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
        gum style --border normal --margin "1 2" --padding "1 2" \
            "📋 **All changes are staged:**" \
            "" \
            "$(git status --short)"
        
        if gum confirm "Commit staged changes and switch?"; then
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
            if gum spin --spinner dot --title "Committing changes..." -- git commit -m "$commit_msg"; then
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
        gum style --border normal --margin "1 2" --padding "1 2" \
            "⚡ **Mixed staged and unstaged changes:**" \
            "" \
            "$(git status --short)"
        
        warning "Unstaged changes won't be committed."
        if gum confirm "Commit staged changes only?"; then
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
                if gum spin --spinner dot --title "Committing staged changes..." -- git commit -m "$commit_msg"; then
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
        gum style --border normal --margin "1 2" --padding "1 2" \
            "📝 **Unstaged changes detected:**" \
            "" \
            "$(git status --short)"
        
        warning "Please stage changes first:"
        gum format -- "• \`git add <files>\` - Add specific files"
        gum format -- "• \`git add .\`       - Add all files"
        GIT_WORKFLOW_ACTION="TEST_ONLY"
        return 0  # Success, but only test available
        
    else
        gum style --border normal --margin "1 2" --padding "1 2" \
            "🔍 **Complex Git status detected:**" \
            "" \
            "$(git status --short)"
        
        warning "Please resolve Git status manually."
        GIT_WORKFLOW_ACTION="NO_ACTION"
        return 1
    fi
}

# Perform full NixOS configuration switch
nixos_switch_operation() {
    gum style --border normal --margin "1 2" --padding "1 2" \
        "🚀 **Ready for NixOS Configuration Switch**" \
        "" \
        "This will:" \
        "• Test the configuration" \
        "• Apply changes if test passes" \
        "• Switch to new generation"
    
    if gum confirm "Proceed with safe-switch (test + switch)?"; then
        info "Testing NixOS configuration..."
        echo ""  # Add some spacing
        if nh os test .; then
            echo ""  # Add spacing after output
            success "Configuration test passed"
            info "Applying NixOS configuration..."
            echo ""  # Add some spacing
            if nh os switch .; then
                echo ""  # Add spacing after output
                success "NixOS configuration applied successfully"
                
                # Show success banner
                gum style \
                    --foreground 107 \
                    --border double \
                    --border-foreground 107 \
                    --align center \
                    --width 60 \
                    --margin "1 2" \
                    --padding "1 4" \
                    "🎉 Smart Switch Complete!" \
                    "Configuration applied successfully"
                
                gum style --border normal --margin "1 2" --padding "1 2" \
                    "📊 **System Information:**" \
                    "" \
                    "$(nh os info | head -n 5)"
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
}

# Test NixOS configuration only
nixos_test_operation() {
    gum style --border normal --margin "1 2" --padding "1 2" \
        "🧪 **Configuration Testing Available**" \
        "" \
        "Git status prevents switching, but you can:" \
        "• Test configuration for syntax errors" \
        "• Verify build succeeds" \
        "• Check for conflicts"
    
    if gum confirm "Test NixOS configuration?"; then
        info "Testing NixOS configuration..."
        echo ""  # Add some spacing
        if nh os test .; then
            echo ""  # Add spacing after output
            success "✅ Configuration test completed successfully"
            gum style --border normal --padding "1 2" --margin "1 2" \
                "✨ **Next steps:**" \
                "• Commit or stage your changes" \
                "• Run smart-switch again to apply"
            return 0
        else
            error "Configuration test failed"
            return 1
        fi
    else
        info "Configuration test skipped"
        return 1
    fi
}

# Show no actions available message
nixos_no_action() {
    gum style --border normal --margin "1 2" --padding "1 2" \
        "⚠️ **No Actions Available**" \
        "" \
        "Git status needs attention:" \
        "• Fix untracked files" \
        "• Stage or commit changes" \
        "• Resolve any conflicts"
    
    info "Resolve Git status and run again when ready."
    return 1
}

# Handle NixOS operations based on Git workflow action
handle_nixos_operations() {
    local git_workflow_action="$1"
    
    gum style --foreground 109 "🏗️ Step 3: NixOS Operations"
    
    case $git_workflow_action in
        "SWITCH")
            nixos_switch_operation
            ;;
        "TEST_ONLY")
            nixos_test_operation
            ;;
        *)
            nixos_no_action
            ;;
    esac
}

# Main function
main() {
    debug "Starting smart-switch with DEBUG=$DEBUG"
    
    # Show header
    show_header
    
    # Show repository status overview
    gum style --border normal --margin "1 2" --padding "1 2" \
        "📋 **Repository Analysis**" \
        "" \
        "Working directory: $(pwd)" \
        "Current branch: $(git branch --show-current 2>/dev/null || echo 'No branch')"
    
    debug "Checking if we're in a git repository"
    check_git_repo
    
    debug "Starting format phase"
    format_nix_files
    
    debug "Starting git workflow analysis"
    if handle_git_workflow; then
        debug "Git workflow completed successfully, action: $GIT_WORKFLOW_ACTION"
    else
        debug "Git workflow failed or was declined, action: $GIT_WORKFLOW_ACTION"
    fi
    debug "Continuing with main function..."
    
    # Always show what happens next
    if [[ "$GIT_WORKFLOW_ACTION" == "TEST_ONLY" ]]; then
        gum style --foreground 179 "⚡ Git workflow completed. Continuing to NixOS operations..."
    fi
    
    debug "About to start NixOS operations with action: $GIT_WORKFLOW_ACTION"
    handle_nixos_operations "$GIT_WORKFLOW_ACTION"
    debug "NixOS operations completed"
}

# Run main function
main "$@"