/**
 * removeCredits.js - Remove footer credits from MkDocs Material theme
 * This file removes or modifies the "Made with Material for MkDocs" footer
 */

document.addEventListener('DOMContentLoaded', function() {
  // Attempt to remove the footer credits
  setTimeout(function() {
    const footer = document.querySelector('.md-footer-meta');
    if (footer) {
      // Option 1: Remove the entire footer meta section
      // footer.remove();

      // Option 2: Modify the credits only
      const credits = footer.querySelector('.md-footer-meta__inner .md-footer-copyright');
      if (credits) {
        // Keep copyright, remove "Made with Material for MkDocs"
        credits.innerHTML = credits.innerHTML.replace(/<a[^>]*>Made with Material for MkDocs<\/a>/g, '');
        credits.innerHTML = credits.innerHTML.replace(/· Made with Material for MkDocs/g, '');
      }
    }
  }, 100); // Small delay to ensure the footer is rendered
});
