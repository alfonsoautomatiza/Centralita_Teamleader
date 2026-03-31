/**
 * language-selector.js - Enhanced language selector for Centralita Teamleader
 * Provides better UX for language switching
 */

document.addEventListener('DOMContentLoaded', function() {
  // Language selector logic
  const languageSelector = document.querySelector('[data-md-component="language-selector"]');
  
  if (languageSelector) {
    console.log('language-selector.js loaded - Enhanced language selector ready');

    // Add custom behavior if needed
    languageSelector.addEventListener('click', function(e) {
      // Add any custom language switching logic here
      console.log('Language selector clicked');
    });
  }

  // Auto-detect browser language and redirect if appropriate
  const currentPath = window.location.pathname;
  const browserLang = navigator.language || navigator.userLanguage;
  const primaryLang = browserLang.split('-')[0]; // Get primary language (e.g., 'es' from 'es-ES')

  // Only redirect if on root page and language differs
  if (currentPath === '/' || currentPath === '/index.html') {
    if (primaryLang === 'en') {
      // window.location.href = '/en/';
    } else if (primaryLang === 'fr') {
      // window.location.href = '/fr/';
    }
  }
});
