# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A static blog/portfolio site built with Eleventy (11ty) for sharing projects and learnings while "building in public". Features a retro k-punk aesthetic with a sidebar navigation layout.

## Development Commands

```bash
# Install dependencies
npm install

# Start dev server with live reload at http://localhost:8080
npm start

# Build static site to _site/ directory
npm run build
```

## Architecture

### Build System
- **Eleventy** (11ty v2.0.1) - Static site generator configured in `.eleventy.js`
- **Input directory**: `src/`
- **Output directory**: `_site/` (git-ignored)
- **Template engine**: Nunjucks (Eleventy default)

### Directory Structure
```
src/
├── _layouts/          # Nunjucks templates
│   └── base.html      # Main layout with banner, sidebar, and content area
├── _projects/         # Project markdown files (for projects collection)
├── blog/              # Blog post markdown files (tagged with 'post')
├── css/
│   └── style.css      # k-punk inspired retro styling (Win98-ish aesthetic)
├── assets/            # Static assets (images, etc.)
├── home.html          # Homepage (displays recent posts in reverse chronological order)
├── blog-list.html     # Blog listing page (shows all posts with dates)
└── projects-list.html # Projects grid (uses collections.projects)
```

### Collections
Eleventy automatically creates collections:
- **`collections.post`**: All files tagged with `tags: post` (blog posts)
- **`collections.projects`**: All files in `src/_projects/*.md` (defined in `.eleventy.js`)

### Content Format

**Blog posts** (`src/blog/*.md`):
```yaml
---
layout: base.html
title: Your Post Title
description: Brief description
date: 2025-12-26
tags: post  # REQUIRED for sidebar archives and homepage display
---
```
- Posts appear in sidebar archives and on homepage in reverse chronological order
- Date format is used for display (e.g., "December 26, 2025")

**Project files** (`src/_projects/*.md`):
```yaml
---
title: "Project Title"
description: "One-liner description for projects page"
status: "Active"  # or "Learning", "Planning", "Archived"
tags:
  - "JavaScript"
  - "React"
repoUrl: "https://github.com/username/repo"
demoUrl: "https://demo-url.com"
blogPost: "/blog/project-writeup/"
---
```
- Projects are displayed in `src/projects-list.html` using the `collections.projects` collection
- Status badges have predefined styles in CSS (`.status-active`, `.status-learning`, `.status-planning`, `.status-archived`)

### Templating & Layout
- Main layout: `src/_layouts/base.html`
  - Banner section with site title "building in public"
  - Sidebar with navigation, blog archives (from `collections.post | reverse`), and meta info
  - Main content area where `{{ content }}` is injected
- Nunjucks filters: `| url`, `| date`, `| reverse`
- Homepage (`src/home.html`) iterates over `collections.post | reverse` to show recent posts

### Static Assets
The Eleventy config uses `addPassthroughCopy` to copy these unchanged:
- `src/css` → `_site/css`
- `src/assets` → `_site/assets`

### Design System
The CSS (`src/css/style.css`) implements a k-punk aesthetic:
- Monospace font: `"Courier New", Courier, monospace`
- Color palette: Beige/gray tones (#d4d0c8 background, #e8e4dc content areas)
- Bordered sections with 2px solid borders
- Status badges with color coding (green for active, yellow for learning, blue for planning, gray for archived)
- Responsive: Sidebar stacks vertically on mobile (<640px)

## Deployment

The site is configured for multiple deployment targets:

- **GitHub Pages**: Auto-deploys via `.github/workflows/deploy.yml` on push to `master` branch
  - Uses `peaceiris/actions-gh-pages@v3` to publish `_site/` directory
- **Netlify**: Auto-detects settings from `netlify.toml`
  - Build command: `npm run build`
  - Publish directory: `_site`
  - Includes SPA-style redirect for all routes
- **Vercel**: Manual configuration needed
  - Build command: `npm run build`
  - Output directory: `_site`
