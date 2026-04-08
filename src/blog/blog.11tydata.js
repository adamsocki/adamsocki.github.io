module.exports = {
  permalink: ({ page }) => `/posts/${page.fileSlug}/index.html`,
  layout: "blog.html",
  tags: "post",
  type: "article",  // default type; also supports: devlog, til, update
  project: "",       // optional: link post to a project slug (e.g. "urban-at-home", "ephemris")
};
