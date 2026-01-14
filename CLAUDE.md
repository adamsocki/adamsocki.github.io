# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a simple static blog/portfolio built with Eleventy (11ty) for sharing projects and learnings while "building in public". The site generates static HTML from Markdown blog posts and HTML pages.

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
- **Eleventy** (11ty v2.0.1) - Static site generator
- **Input directory**: `src/`
- **Output directory**: `_site/`
- **Config file**: `.eleventy.js`

### Directory Structure
```
src/
├── _layouts/          # Nunjucks templates
│   └── base.html      # Main layout with sidebar navigation
├── blog/              # Markdown blog posts (tagged with 'post')
├── projects/          # Project pages (HTML or Markdown)
├── css/               # Stylesheets (copied to output)
├── assets/            # Static assets (copied to output)
└── index.html         # Homepage
```

### Content Format

**Blog posts** (`src/blog/*.md`):
- Use YAML frontmatter with: `layout`, `title`, `description`, `date`, `tags: post`
- The `tags: post` is required for posts to appear in the sidebar archives
- Posts are automatically sorted by date and displayed in the sidebar

**Pages**: Can be HTML or Markdown files with appropriate frontmatter

### Templating
- Layout engine: Nunjucks (Eleventy default)
- Main layout: `src/_layouts/base.html`
- Sidebar shows: navigation, blog post archives (from `collections.post`), and meta info
- Content is injected via `{{ content }}` variable

### Static Assets
The Eleventy config (`addPassthroughCopy`) copies these directories unchanged:
- `src/css` → `_site/css`
- `src/assets` → `_site/assets`

## Deployment

The site is configured for multiple deployment options:

- **GitHub Pages**: Auto-deploys via `.github/workflows/deploy.yml` on push to main
- **Netlify**: Auto-detects settings from `netlify.toml`
- **Vercel**: Build command `npm run build`, output directory `_site`
