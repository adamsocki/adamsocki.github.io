# Blog - Building in Public

A small Eleventy blog and project portfolio for writing about ongoing work.

## Commands

```bash
# Install dependencies
npm install

# Preview locally at http://localhost:8080
npm start

# Build the production site into _site/
npm run build
```

## Content Workflow

Use these for posts and project pages. These commands create markdown files in
the content folders.

```bash
# Menu for content actions
npm run content

# Create a blog post
npm run new
npm run devlog
npm run til
npm run update

# Create a project page
npm run project
```

Blog posts live in `src/blog/`. They use defaults from
`src/blog/blog.11tydata.js`, so new posts only need frontmatter like this:

```markdown
---
title: "Post title"
date: 2026-05-22
type: article
project: trader
description: "Optional one-line summary"
---

# Post title
```

Supported post types are `article`, `devlog`, `til`, and `update`.
The `project` field is optional. When used, it should match a project slug from
`src/_projects/`.

Project pages live in `src/_projects/` and use this shape:

```markdown
---
layout: project.html
title: "Project title"
description: "One-line description"
date: 2026-05-22
status: "Active"
projectSlug: "project-slug"
tags:
  - "Project"
blogPost: ""
---

# Project title
```

Posts and projects are sorted newest first by frontmatter `date`.

## Local Drafting Tools

These open local-only browser tools from the `tools/` folder. They do not run a
dev server and they are not published as site pages.

```bash
npm run postTool
npm run projectTool
```

The tools generate markdown you can copy or download, then place in
`src/blog/` or `src/_projects/`.

## Publishing

This site deploys through Netlify. `netlify.toml` runs:

```bash
npm run build
```

and publishes `_site/`.

Use the publish commands based on what changed:

```bash
# Commit and push content changes from src/blog/ and src/_projects/
npm run publish

# Commit and push site code, layout, style, script, and tool changes
npm run codeAdjust
```

Both commands build before committing. After pushing, Netlify rebuilds the live
site from the GitHub repo.

## Project Structure

```text
.
├── .eleventy.js          # Eleventy collections, filters, and build config
├── netlify.toml          # Netlify build settings
├── src/
│   ├── _includes/        # Shared template partials
│   ├── _layouts/         # Base, blog, and project layouts
│   ├── _projects/        # Project markdown pages
│   ├── blog/             # Blog markdown posts
│   ├── css/              # Site styles
│   ├── blog-list.html    # Blog archive and filters
│   ├── index.html        # Homepage
│   └── projects-list.html
├── tools/
│   ├── post-tool.html
│   └── project-tool.html
├── content.sh
├── new-post.sh
├── new-project.sh
├── post-tool.sh
├── project-tool.sh
├── publish.sh
└── code-adjust.sh
```

## Editing Notes

- Edit `src/css/style.css` for visual changes.
- Edit `src/_layouts/base.html` for global page chrome and navigation.
- Edit `src/_layouts/blog.html` for individual blog posts.
- Edit `src/_layouts/project.html` for individual project pages.
- Edit `src/blog-list.html` and `src/projects-list.html` for archive pages.
