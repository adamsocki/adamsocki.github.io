---
title: "Added project-specific blogs and post types"
date: 2026-04-07
type: devlog
project: this-blog
description: "New features: project-filtered blog feeds, short-form post types (devlog, TIL, update), and a zero-friction post creator."
---

## What I worked on

Added a system for linking blog posts to specific projects. Now every project page shows its related blog posts, and the blog archive lets you filter by project and post type.

Also added support for different post types beyond full articles:

- **devlog** — quick entries about what I worked on
- **til** — short "today I learned" notes
- **update** — status updates on a project

And built two ways to create new posts with zero friction:

1. A shell script (`./new-post.sh`) that scaffolds a post with all the frontmatter pre-filled
2. A web-based post creator at `/new-post/` where you fill in fields and download the markdown file

## What I learned

The main barrier to writing isn't the writing itself — it's the overhead of remembering how to set up the frontmatter, what fields to include, and where to put the file. Removing those decisions makes it way easier to just start typing.

## Next up

- Write more devlogs as I work on projects
- Add git commit summaries to project pages
