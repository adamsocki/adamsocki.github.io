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

# Create a new blog post (interactive)
npm run new

# Quick short-form posts
npm run devlog        # devlog entry
npm run til           # today I learned
npm run update        # status update

# Create a new project page
npm run project

# Unified content menu for posts, projects, and publishing
npm run content

# Or use the shell script directly
./new-post.sh "My Post Title"
./new-post.sh --devlog "What I worked on"
./new-post.sh --til "Something I learned"
./new-project.sh "My Project"
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
├── _layouts/          # Liquid templates
│   ├── base.html      # Main layout with banner, sidebar, and content area
│   ├── blog.html      # Blog post layout (shows type badge, project link, summary)
│   └── project.html   # Project detail layout (shows related blog posts)
├── _projects/         # Project markdown files (for projects collection)
├── blog/              # Blog post markdown files
│   └── blog.11tydata.js  # Default frontmatter for posts (layout, tags, type, project)
├── css/
│   └── style.css      # k-punk inspired retro styling (Win98-ish aesthetic)
├── assets/            # Static assets (images, etc.)
├── index.html         # Homepage (displays recent posts in reverse chronological order)
├── blog-list.html     # Blog listing page with type/project filters
├── new-post.html      # Web-based post creator (fill in fields, download .md)
└── projects-list.html # Projects grid (uses collections.projects)
```

### Collections
Eleventy automatically creates collections:
- **`collections.post`**: All files tagged with `tags: post` (blog posts)
- **`collections.projects`**: All files in `src/_projects/*.md` (defined in `.eleventy.js`)
- **`collections.projectSlugs`**: Unique project slugs used across blog posts (for filters)
- **`collections.postsByProject`**: Map of project slug → posts (for project pages)

### Content Format

**Blog posts** (`src/blog/*.md`):
```yaml
---
title: Your Post Title
description: Brief description
date: 2025-12-26
type: article       # article (default), devlog, til, or update
project: my-project # optional: links post to a project by slug
---
```
- `layout`, `tags: post` are set automatically via `blog.11tydata.js` — no need to specify them
- Posts appear in sidebar archives and on homepage in reverse chronological order
- The `project` field links a post to a project (must match a project's `projectSlug`)
- Post types: `article` (full writeup), `devlog` (work log), `til` (today I learned), `update` (status note)
- The blog list page (`/blog-list/`) has filters for both post type and project

**Project files** (`src/_projects/*.md`):
```yaml
---
title: "Project Title"
description: "One-liner description for projects page"
status: "Active"  # or "Learning", "Planning", "Archived"
projectSlug: "my-project"  # used to link blog posts to this project
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
- If a project has a `projectSlug`, its page will automatically show all blog posts tagged with that project

### Creating New Posts
There are several ways to create content, designed to minimize friction:
0. **Unified menu**: `npm run content` - choose article, devlog, TIL, update, project, or publish
1. **Shell script**: `./new-post.sh` or `npm run new` — interactive, scaffolds all frontmatter
2. **Quick commands**: `npm run devlog`, `npm run til`, `npm run update` — for short-form posts
3. **Project script**: `./new-project.sh` or `npm run project` - scaffolds a project page in `src/_projects/`
4. **Web interface**: Visit `/new-post/` on the site — fill in fields, download the .md file

### Templating & Layout
- Main layout: `src/_layouts/base.html`
  - Banner section with site title "building in public"
  - Sidebar with navigation, blog archives (from `collections.post | reverse`), and meta info
  - Main content area where `{{ content }}` is injected
- Nunjucks filters: `| url`, `| date`, `| reverse`
- Homepage (`src/index.html`) iterates over `collections.post | reverse` to show recent posts

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
