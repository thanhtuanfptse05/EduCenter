/**
 * EduCenter ERP — Theme Manager
 * Implements strict compliance with design.md Section 3:
 * 1. First visit with no saved preference -> ALWAYS LIGHT (even if OS prefers dark).
 * 2. Only switches to dark if explicit localStorage['educenter-theme'] === 'dark'.
 * 3. Applied before CSS in <head> to prevent theme flash.
 */

(function () {
  'use strict';

  var currentTheme = 'light';
  try {
    if (localStorage.getItem('educenter-theme') === 'dark') {
      currentTheme = 'dark';
    }
  } catch (e) {
    // localStorage may be disabled in private browsing; safely fallback to light
  }

  document.documentElement.setAttribute('data-theme', currentTheme);

  // Expose global functions once DOM is interactive
  window.EduCenterTheme = {
    getTheme: function () {
      return document.documentElement.getAttribute('data-theme') || 'light';
    },

    setTheme: function (theme) {
      var next = theme === 'dark' ? 'dark' : 'light';
      document.documentElement.setAttribute('data-theme', next);
      try {
        localStorage.setItem('educenter-theme', next);
      } catch (e) {}

      // Update any toggle buttons on the page
      var buttons = document.querySelectorAll('[data-theme-toggle]');
      buttons.forEach(function (btn) {
        btn.setAttribute('aria-label', next === 'dark' ? 'Chuyển sang giao diện sáng' : 'Chuyển sang giao diện tối');
        var sunIcon = btn.querySelector('.theme-icon-sun');
        var moonIcon = btn.querySelector('.theme-icon-moon');
        if (sunIcon && moonIcon) {
          if (next === 'dark') {
            sunIcon.style.display = 'inline-block';
            moonIcon.style.display = 'none';
          } else {
            sunIcon.style.display = 'none';
            moonIcon.style.display = 'inline-block';
          }
        }
      });

      // Dispatch custom event for widgets that need to repaint
      window.dispatchEvent(new CustomEvent('educenter:themechange', { detail: { theme: next } }));
    },

    toggle: function () {
      var current = this.getTheme();
      this.setTheme(current === 'dark' ? 'light' : 'dark');
    }
  };

  document.addEventListener('DOMContentLoaded', function () {
    var buttons = document.querySelectorAll('[data-theme-toggle]');
    var activeTheme = window.EduCenterTheme.getTheme();
    buttons.forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        window.EduCenterTheme.toggle();
      });

      // Initial icon state
      var sunIcon = btn.querySelector('.theme-icon-sun');
      var moonIcon = btn.querySelector('.theme-icon-moon');
      if (sunIcon && moonIcon) {
        if (activeTheme === 'dark') {
          sunIcon.style.display = 'inline-block';
          moonIcon.style.display = 'none';
        } else {
          sunIcon.style.display = 'none';
          moonIcon.style.display = 'inline-block';
        }
      }
    });
  });
})();
