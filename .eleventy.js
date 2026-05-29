module.exports = function(eleventyConfig) {
  // Copy CSS and any static assets
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/assets");

  const newestFirst = (a, b) => {
    const dateDiff = b.date - a.date;
    if (dateDiff !== 0) return dateDiff;
    return (b.inputPath || "").localeCompare(a.inputPath || "");
  };

  // Add projects collection
  eleventyConfig.addCollection("projects", function(collection) {
    return collection.getFilteredByGlob("src/_projects/*.md").sort(newestFirst);
  });

  // Add posts collection sorted by frontmatter date, newest first
  eleventyConfig.addCollection("posts", function(collection) {
    return collection.getFilteredByTag("post").sort(newestFirst);
  });

  // Add a collection of all unique project slugs used in blog posts
  eleventyConfig.addCollection("projectSlugs", function(collection) {
    const slugs = new Set();
    collection.getFilteredByTag("post").forEach(post => {
      if (post.data.project) {
        slugs.add(post.data.project);
      }
    });
    return [...slugs].sort();
  });

  // For each project that has blog posts, create a filtered collection
  // accessible as collections.projectPosts_<slug>
  eleventyConfig.addCollection("postsByProject", function(collection) {
    const map = {};
    collection.getFilteredByTag("post").forEach(post => {
      if (post.data.project) {
        const slug = post.data.project;
        if (!map[slug]) map[slug] = [];
        map[slug].push(post);
      }
    });
    // Sort each project's posts by date descending
    for (const slug of Object.keys(map)) {
      map[slug].sort(newestFirst);
    }
    return map;
  });

  // Add skills collection
  eleventyConfig.addCollection("skills", function(collection) {
    return collection.getFilteredByGlob("src/_skills/*.md").sort(function(a, b) {
      return (a.data.title || "").localeCompare(b.data.title || "");
    });
  });

  // Add experience collection
  eleventyConfig.addCollection("experience", function(collection) {
    return collection.getFilteredByGlob("src/_experience/*.md").sort(function(a, b) {
      return new Date(b.data.startDate || 0) - new Date(a.data.startDate || 0);
    });
  });

  // Add a collection of all unique skill categories
  eleventyConfig.addCollection("skillCategories", function(collection) {
    const cats = new Set();
    collection.getFilteredByGlob("src/_skills/*.md").forEach(item => {
      if (item.data.category) cats.add(item.data.category);
    });
    return [...cats].sort();
  });

  // Add a collection of all unique tags (excluding the system "post" tag)
  eleventyConfig.addCollection("tagList", function(collection) {
    const tagSet = new Set();
    collection.getAll().forEach(item => {
      if (item.data.tags) {
        let tags = item.data.tags;
        if (typeof tags === "string") tags = [tags];
        tags.forEach(tag => {
          if (tag !== "post" && tag !== "skill" && tag !== "experience") tagSet.add(tag);
        });
      }
    });
    return [...tagSet].sort();
  });

  // Sort collections from newest to oldest without mutating Eleventy's arrays.
  eleventyConfig.addFilter("newestFirst", function(arr) {
    return [...arr].sort(newestFirst);
  });

  // Slug filter for use in templates
  eleventyConfig.addFilter("slug", function(str) {
    return str.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  });

  // Filter posts by project
  eleventyConfig.addFilter("byProject", function(posts, projectSlug) {
    if (!projectSlug) return posts;
    return posts.filter(p => p.data.project === projectSlug);
  });

  // Limit filter
  eleventyConfig.addFilter("limit", function(arr, limit) {
    return arr.slice(0, limit);
  });

  // Set input and output directories
  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      layouts: "_layouts"
    }
  };
};
