#!/bin/bash

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No branch name provided${NC}"
    echo "Usage: $0 <branch-name>"
    echo "Example: $0 test-branch (removes feature/test-branch)"
    exit 1
fi

BRANCH_NAME="$1"

# Check if on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}Error: This script must be run from the main branch${NC}"
    echo "Current branch: $CURRENT_BRANCH"
    echo ""
    echo "Please switch to main first:"
    echo "  git checkout main"
    exit 1
fi

# Handle branch name with or without feature/ prefix
if [[ "$BRANCH_NAME" != feature/* ]]; then
    FULL_BRANCH_NAME="feature/$BRANCH_NAME"
else
    FULL_BRANCH_NAME="$BRANCH_NAME"
    BRANCH_NAME="${BRANCH_NAME#feature/}"
fi

# Prevent deleting main branch
if [ "$FULL_BRANCH_NAME" == "main" ]; then
    echo -e "${RED}Error: Cannot delete the main branch${NC}"
    exit 1
fi

# Check if branch exists
if ! git show-ref --verify --quiet "refs/heads/$FULL_BRANCH_NAME"; then
    echo -e "${RED}Error: Branch '$FULL_BRANCH_NAME' does not exist${NC}"
    echo ""
    echo "Available feature branches:"
    git branch | grep "feature/" | sed 's/feature\///' | sed 's/^[[:space:]]*//'
    exit 1
fi

# Convert branch name to snake_case to find worktree directory
WORKTREE_DIR=$(echo "$BRANCH_NAME" | tr '-' '_')
WORKTREE_PATH="../wishing_well_feature_branches/$WORKTREE_DIR"

# Find worktree (it might be at different path)
WORKTREE_LIST=$(git worktree list)
if ! echo "$WORKTREE_LIST" | grep -q "$FULL_BRANCH_NAME"; then
    echo -e "${RED}Error: No worktree found for branch '$FULL_BRANCH_NAME'${NC}"
    echo ""
    echo "Existing worktrees:"
    git worktree list
    exit 1
fi

# Get the actual worktree path
WORKTREE_ACTUAL_PATH=$(git worktree list | grep "$FULL_BRANCH_NAME" | awk '{print $1}')

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}⚠️  WARNING: This action cannot be undone${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""
echo -e "${CYAN}Branch to remove:${NC} $FULL_BRANCH_NAME"
echo -e "${CYAN}Worktree to remove:${NC} $WORKTREE_ACTUAL_PATH"
echo ""
echo -e "${RED}This will permanently delete:${NC}"
echo "  - The branch '$FULL_BRANCH_NAME'"
echo "  - All commits and changes in that branch"
echo "  - The worktree directory at '$WORKTREE_ACTUAL_PATH'"
echo ""
echo -e "${YELLOW}ALL UNPUSHED AND UNCOMMITTED CHANGES WILL BE LOST!${NC}"
echo ""

# Prompt for confirmation
read -p "Are you sure you want to proceed? (yes/no): " confirm
confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

if [ "$confirm" != "yes" ]; then
    echo -e "${YELLOW}Operation cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}Removing branch and worktree...${NC}"
echo ""

# Remove worktree
echo "Removing worktree at: $WORKTREE_ACTUAL_PATH"
git worktree remove "$WORKTREE_ACTUAL_PATH"
echo -e "${GREEN}✓ Worktree removed successfully${NC}"
echo ""

# Remove branch
echo "Removing branch: $FULL_BRANCH_NAME"
git branch -D "$FULL_BRANCH_NAME"
echo -e "${GREEN}✓ Branch removed successfully${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Branch cleanup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Removed:"
echo "  - Branch: $FULL_BRANCH_NAME"
echo "  - Worktree: $WORKTREE_ACTUAL_PATH"
