# Blog - Building in Public

A simple blog and portfolio for sharing ongoing projects and learnings.

## Getting Started

```bash
# Install dependencies
npm install

# Start dev server (with live reload)
npm start

# Build for production
npm run build
```

Visit `http://localhost:8080` to see your blog.

## Writing Content

### Blog Posts (Markdown)

Create a new file in `src/blog/` with this format:

```markdown
---
layout: base.html
title: Your Post Title
description: Brief description
date: 2025-12-26
tags: post
---

# Your Post Title

Your content here...
```

### Project Pages (HTML or Markdown)

Create files in `src/projects/` using either HTML or Markdown format.

### Homepage

Edit `src/index.html` to update your projects list and intro text.

## Deployment

### GitHub Pages

1. Push your code to GitHub
2. Go to Settings > Pages
3. Source: GitHub Actions
4. The workflow in `.github/workflows/deploy.yml` will auto-deploy on push to main

### Netlify

1. Push your code to GitHub
2. Go to [Netlify](https://netlify.com)
3. Click "New site from Git"
4. Select your repo
5. Netlify will auto-detect settings from `netlify.toml`

### Vercel

1. Push your code to GitHub
2. Go to [Vercel](https://vercel.com)
3. Import your repository
4. Build command: `npm run build`
5. Output directory: `_site`

## Structure

```
src/
├── _layouts/       # HTML layouts
│   └── base.html   # Main layout
├── blog/           # Blog posts (markdown)
├── projects/       # Project pages
├── css/            # Stylesheets
└── index.html      # Homepage
```

## Customization

- Edit `src/css/style.css` for styling
- Modify `src/_layouts/base.html` for layout changes
- Update navigation in the base layout
