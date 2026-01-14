module.exports = function(eleventyConfig) {
  // Copy CSS and any static assets
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/assets");

  // Add projects collection
  eleventyConfig.addCollection("projects", function(collection) {
    return collection.getFilteredByGlob("src/_projects/*.md");
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
