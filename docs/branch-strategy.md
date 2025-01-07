# Branch Strategy

## Overview
This document outlines the branch strategy for the Macro Meal Planner project. We follow a trunk-based development approach with two main branches and feature branches for development.

## Branch Structure

### Main Branch (`main`)
- Production-ready code
- Deploys to production environment
- Protected with strict rules:
  - Requires pull request reviews
  - Requires status checks to pass
  - Enforces linear history
  - Includes administrator enforcement
  - No direct pushes allowed
  - No force pushes allowed
  - No deletions allowed

### Development Branch (`develop`)
- Integration branch for features
- Deploys to staging environment
- Protected with moderate rules:
  - Requires pull request reviews
  - Requires status checks to pass
  - Allows force pushes for CI
  - No deletions allowed

### Feature Branches
- Created from: `develop`
- Merge into: `develop`
- Naming convention: `feature/[issue-number]-descriptive-name`
- Example: `feature/123-add-meal-planning`

### Hotfix Branches
- Created from: `main`
- Merge into: `main` and `develop`
- Naming convention: `hotfix/[issue-number]-descriptive-name`
- Example: `hotfix/456-fix-authentication`

## Workflow

1. **Feature Development**
   - Create feature branch from `develop`
   - Develop and test feature
   - Create PR to merge into `develop`
   - PR must pass:
     - Code review
     - Automated tests
     - Build checks
   - Merge into `develop`

2. **Release Process**
   - Create PR from `develop` to `main`
   - PR must pass:
     - Code review
     - All status checks
     - QA verification
   - Merge into `main`
   - Automated deployment to production

3. **Hotfix Process**
   - Create hotfix branch from `main`
   - Fix critical issue
   - Create PR to `main`
   - After merge to `main`, create PR to `develop`

## CI/CD Integration

- **Feature Branches**
  - Run tests and builds
  - Deploy to preview environment

- **Develop Branch**
  - Run tests and builds
  - Deploy to staging environment
  - Run integration tests

- **Main Branch**
  - Run tests and builds
  - Deploy to production
  - Run smoke tests

## Best Practices

1. **Commit Messages**
   - Follow conventional commits
   - Include issue number
   - Be descriptive and concise

2. **Pull Requests**
   - Include description of changes
   - Link related issues
   - Add tests for new features
   - Update documentation

3. **Code Review**
   - Review within 24 hours
   - Check for:
     - Code quality
     - Test coverage
     - Documentation
     - Security concerns

4. **Branch Hygiene**
   - Delete feature branches after merge
   - Keep branches up to date with base
   - Resolve conflicts promptly

## Tools and Automation

- GitHub Actions for CI/CD
- Branch protection rules
- Automated PR labeling
- Status checks integration
- Deployment automation
