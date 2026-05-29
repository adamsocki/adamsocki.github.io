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

Use these to create markdown files in the content folders.

```bash
# Menu for all content actions
npm run content

# Create a blog post
npm run new
npm run devlog
npm run til
npm run update

# Create a project page
npm run project

# Create a skill page
npm run skill

# Create an employment entry
npm run employment
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

Skill pages live in `src/_skills/`. Layout, tags, and permalink are set
automatically by `src/_skills/skills.11tydata.js`:

```markdown
---
title: "React"
category: "Frontend Framework"
proficiency: "Intermediate"
skillSlug: "react"
tags:
  - "JavaScript"
  - "React"
  - "Frontend"
---

# React

## Notes
```

Proficiency levels are `Beginner`, `Intermediate`, `Advanced`, `Expert`.
Skill pages auto-link to projects and posts that share the same tags.

Employment entries live in `src/_employment/`. Layout, tags, and permalink are
set automatically by `src/_employment/employment.11tydata.js`:

```markdown
---
company: "Acme Corp"
title: "Software Engineer"
start: 2024-01
end: 2025-06
location: "Remote"
tags:
  - employment
  - React
  - TypeScript
---

## What I Did
```

Leave `end` empty (or omit it) for a current position. The `employment` tag is
added automatically.

## Local Drafting Tools

These open local-only browser tools from the `tools/` folder. They do not run a
dev server and they are not published as site pages.

```bash
npm run postTool
npm run projectTool
npm run skillTool
```

The tools generate markdown you can copy or download, then place in
`src/blog/`, `src/_projects/`, or `src/_skills/`.

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
│   ├── _layouts/         # Base, blog, project, skill, and employment layouts
│   ├── _projects/        # Project markdown pages
│   ├── _skills/          # Skill/technology markdown pages
│   ├── _employment/      # Employment history markdown entries
│   ├── blog/             # Blog markdown posts
│   ├── css/              # Site styles
│   ├── about.html        # Portfolio page (experience, skills, projects)
│   ├── blog-list.html    # Blog archive and filters
│   ├── index.html        # Homepage
│   ├── projects-list.html
│   ├── skills-list.html
│   └── tags.html         # Auto-generated tag index pages
├── tools/
│   ├── post-tool.html
│   ├── project-tool.html
│   └── skill-tool.html
├── content.sh            # Unified content creation menu
├── new-post.sh
├── new-project.sh
├── new-skill.sh
├── new-employment.sh
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
- Edit `src/_layouts/skill.html` for individual skill pages.
- Edit `src/_layouts/employment.html` for individual employment entries.
- Edit `src/blog-list.html` and `src/projects-list.html` for archive pages.
- Edit `src/skills-list.html` for the skills listing page.
- Edit `src/about.html` for the portfolio/about page.
