(function () {
  'use strict';
  document.addEventListener('DOMContentLoaded', function () {
    var reset = document.querySelector('[data-reset-seconds]');
    if (reset) {
      var deadline = Date.now() + Number(reset.dataset.resetSeconds) * 1000;
      var tick = function () {
        var left = Math.max(0, Math.ceil((deadline - Date.now()) / 1000));
        document.getElementById('reset-time-left').textContent = Math.floor(left / 60) + ':' + String(left % 60).padStart(2, '0');
        if (left === 0) {
          reset.textContent = 'Liên kết đã hết hạn. Vui lòng yêu cầu liên kết mới.';
          var submit = document.querySelector('[data-reset-form] button[type=submit]'); if (submit) submit.disabled = true;
          clearInterval(resetTimer);
        }
      };
      var resetTimer = setInterval(tick, 1000); tick();
    }
    var menuButton = document.querySelector('[data-site-menu]');
    var menu = document.getElementById('site-mobile-menu');
    function closeMenu() { if (menu) menu.hidden = true; if (menuButton) menuButton.setAttribute('aria-expanded', 'false'); }
    if (menuButton && menu) {
      menuButton.addEventListener('click', function () {
        menu.hidden = !menu.hidden;
        menuButton.setAttribute('aria-expanded', String(!menu.hidden));
        if (!menu.hidden) menu.querySelector('a').focus();
      });
      menu.querySelectorAll('a').forEach(function (link) { link.addEventListener('click', closeMenu); });
    }
    var drawerButton = document.querySelector('[data-app-menu]');
    var sidebar = document.querySelector('.admin-sidebar');
    var backdrop = document.querySelector('[data-drawer-backdrop]');
    function closeDrawer() {
      if (sidebar) sidebar.classList.remove('drawer-open');
      if (backdrop) backdrop.hidden = true;
      if (drawerButton) drawerButton.setAttribute('aria-expanded', 'false');
    }
    if (drawerButton && sidebar && backdrop) {
      drawerButton.addEventListener('click', function () {
        var open = sidebar.classList.toggle('drawer-open');
        backdrop.hidden = !open; drawerButton.setAttribute('aria-expanded', String(open));
        if (open) sidebar.querySelector('a').focus();
      });
      backdrop.addEventListener('click', closeDrawer);
    }
    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') { closeMenu(); closeDrawer(); }
    });
    document.querySelectorAll('.alert-close-btn').forEach(function (button) {
      button.addEventListener('click', function () { var alert = button.closest('.alert'); if (alert) alert.remove(); });
    });
    document.querySelectorAll('[data-role-editor]').forEach(function (button) {
      button.addEventListener('click', function () {
        window.openRoleModal(button.dataset.userId, button.dataset.userName, button.dataset.userEmail, button.dataset.userRoles);
      });
    });
  });
})();
