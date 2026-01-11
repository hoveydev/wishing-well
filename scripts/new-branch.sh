#!/bin/bash

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No branch name provided${NC}"
    echo "Usage: $0 <branch-name>"
    echo "Example: $0 test-branch"
    exit 1
fi

BRANCH_NAME="$1"

# Check if on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}Error: This script must be run from the main branch${NC}"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Validate branch name
if [[ "$BRANCH_NAME" == */* ]]; then
    echo -e "${RED}Error: Branch name cannot contain '/'${NC}"
    echo "The 'feature/' prefix will be added automatically"
    exit 1
fi

# Check for spaces in branch name
if [[ "$BRANCH_NAME" == *" "* ]]; then
    echo -e "${RED}Error: Branch name cannot contain spaces${NC}"
    echo "Please use '-' instead of spaces"
    exit 1
fi

# Check for special characters (allow only alphanumeric and hyphens)
if [[ ! "$BRANCH_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
    echo -e "${RED}Error: Branch name contains invalid characters${NC}"
    echo "Branch names can only contain letters, numbers, and hyphens (-)"
    exit 1
fi

# Check if branch name starts with hyphen
if [[ "$BRANCH_NAME" == -* ]]; then
    echo -e "${RED}Error: Branch name cannot start with a hyphen${NC}"
    exit 1
fi

# Full branch name with feature/ prefix
FULL_BRANCH_NAME="feature/$BRANCH_NAME"

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$FULL_BRANCH_NAME"; then
    echo -e "${RED}Error: Branch '$FULL_BRANCH_NAME' already exists${NC}"
    exit 1
fi

# Convert branch name to snake_case for worktree directory
WORKTREE_DIR=$(echo "$BRANCH_NAME" | tr '-' '_')

# Worktree path
WORKTREE_PATH="../wishing_well_feature_branches/$WORKTREE_DIR"

# Check if worktree directory already exists
if [ -d "$WORKTREE_PATH" ]; then
    echo -e "${RED}Error: Worktree directory already exists at $WORKTREE_PATH${NC}"
    exit 1
fi

echo -e "${GREEN}Creating new feature branch workflow...${NC}"
echo ""
echo -e "${YELLOW}Branch name will be: $FULL_BRANCH_NAME${NC}"
echo "Note: The 'feature/' prefix is added automatically"
echo ""

# Create new branch
echo "Creating branch: $FULL_BRANCH_NAME"
git branch "$FULL_BRANCH_NAME"
echo -e "${GREEN}✓ Branch created successfully${NC}"
echo ""

# Create worktree
echo "Creating worktree at: $WORKTREE_PATH"
git worktree add "$WORKTREE_PATH" "$FULL_BRANCH_NAME"
echo -e "${GREEN}✓ Worktree created successfully${NC}"
echo ""

# Copy .env files
if [ -f ".env.development" ] && [ -f ".env.test" ]; then
    echo "Copying .env files to worktree..."
    cp ".env.development" "$WORKTREE_PATH/.env.development"
    cp ".env.test" "$WORKTREE_PATH/.env.test"
    echo -e "${GREEN}✓ .env files copied successfully${NC}"
else
    echo -e "${YELLOW}Warning: .env.development or .env.test not found in current directory${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Feature branch workflow complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Branch: $FULL_BRANCH_NAME"
echo "Worktree: $WORKTREE_PATH"
echo ""
echo "You can now work in the new branch:"
echo "  cd $WORKTREE_PATH"
