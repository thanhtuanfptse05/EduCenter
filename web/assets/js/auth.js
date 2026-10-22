/**
 * EduCenter ERP — Interactive UI Script
 * Handles password visibility, live password strength meter, tabs, and accessible modal interactions.
 */

(function () {
  'use strict';

  document.addEventListener('DOMContentLoaded', function () {
    // 1. Password reveal toggles
    var passwordToggles = document.querySelectorAll('[data-password-toggle]');
    passwordToggles.forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        var targetId = btn.getAttribute('data-password-toggle');
        var input = document.getElementById(targetId);
        if (!input) return;

        var isPassword = input.type === 'password';
        input.type = isPassword ? 'text' : 'password';

        var eyeIcon = btn.querySelector('.icon-eye');
        var eyeOffIcon = btn.querySelector('.icon-eye-off');
        if (eyeIcon && eyeOffIcon) {
          eyeIcon.style.display = isPassword ? 'none' : 'inline-block';
          eyeOffIcon.style.display = isPassword ? 'inline-block' : 'none';
        }
      });
    });

    // 2. Register role selector cards
    var roleCards = document.querySelectorAll('.role-selector-card');
    roleCards.forEach(function (card) {
      card.addEventListener('click', function () {
        var radio = card.querySelector('input[type="radio"]');
        if (radio) {
          radio.checked = true;
          roleCards.forEach(function (c) { c.classList.remove('selected'); });
          card.classList.add('selected');
        }
      });
    });

    // 3. Live Password Strength Meter (for register and password change)
    var newPasswordInput = document.getElementById('reg-pass') || document.getElementById('newPassword');
    var strengthBar = document.getElementById('password-strength-bar');
    var strengthText = document.getElementById('password-strength-text');

    if (newPasswordInput && strengthBar && strengthText) {
      newPasswordInput.addEventListener('input', function () {
        var val = newPasswordInput.value || '';
        var score = 0;
        if (val.length >= 6) score += 1;
        if (val.length >= 8) score += 1;
        if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score += 1;
        if (/[0-9]/.test(val)) score += 1;
        if (/[^A-Za-z0-9]/.test(val)) score += 1;

        var percent = Math.min(100, Math.round((score / 5) * 100));
        var label = 'Rất yếu';
        var color = '#ef4444';

        if (score === 1) {
          label = 'Yếu';
          color = '#ef4444';
        } else if (score === 2) {
          label = 'Trung bình';
          color = '#f59e0b';
        } else if (score >= 3 && score <= 4) {
          label = 'Khá mạnh';
          color = '#3b82f6';
        } else if (score >= 5) {
          label = 'Rất mạnh';
          color = '#10b981';
        }

        strengthBar.style.width = (val.length === 0 ? '0%' : percent + '%');
        strengthBar.style.backgroundColor = color;
        strengthText.textContent = (val.length === 0 ? '' : 'Độ bảo mật: ' + label);
        strengthText.style.color = color;
      });
    }

    // 4. Tab Navigation for Profile & Settings
    var tabTriggers = document.querySelectorAll('[data-tab-target]');
    tabTriggers.forEach(function (trigger) {
      trigger.addEventListener('click', function (e) {
        e.preventDefault();
        var targetId = trigger.getAttribute('data-tab-target');
        var targetPane = document.getElementById(targetId);
        if (!targetPane) return;

        tabTriggers.forEach(function (t) { t.classList.remove('active'); });
        trigger.classList.add('active');

        var allPanes = document.querySelectorAll('.tab-pane');
        allPanes.forEach(function (pane) { pane.classList.remove('active'); });
        targetPane.classList.add('active');
      });
    });

    // 5. Accessible Modal handling (ADM-18 role modal and status modal)
    window.EduCenterModal = {
      open: function (modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
          modal.classList.add('active');
          document.body.style.overflow = 'hidden';
          var focusable = modal.querySelector('button, [href], input, select, textarea');
          if (focusable) focusable.focus();
        }
      },
      close: function (modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
          modal.classList.remove('active');
          document.body.style.overflow = '';
        }
      }
    };

    // Close modal on escape key or clicking backdrop
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        var activeModals = document.querySelectorAll('.modal-backdrop.active');
        activeModals.forEach(function (m) {
          m.classList.remove('active');
        });
        document.body.style.overflow = '';
      }
    });

    var modalBackdrops = document.querySelectorAll('.modal-backdrop');
    modalBackdrops.forEach(function (backdrop) {
      backdrop.addEventListener('click', function (e) {
        if (e.target === backdrop) {
          backdrop.classList.remove('active');
          document.body.style.overflow = '';
        }
      });
    });

    var modalCloseBtns = document.querySelectorAll('[data-modal-close]');
    modalCloseBtns.forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        var modalId = btn.getAttribute('data-modal-close');
        window.EduCenterModal.close(modalId);
      });
    });
  });
})();
