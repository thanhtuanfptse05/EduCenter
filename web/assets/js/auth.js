/**
 * EduCenter ERP — Interactive UI Script
 * Handles password visibility, demo accounts autofill, and accessible modal interactions.
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

    // 2. Demo account chips autofill for PRJ301 evaluation
    var demoChips = document.querySelectorAll('[data-demo-email]');
    demoChips.forEach(function (chip) {
      chip.addEventListener('click', function (e) {
        e.preventDefault();
        var email = chip.getAttribute('data-demo-email');
        var emailInput = document.getElementById('login-email');
        var passwordInput = document.getElementById('login-password');
        if (emailInput) {
          emailInput.value = email;
        }
        if (passwordInput) {
          passwordInput.value = '123456';
        }
      });
    });

    // 3. Register role selector cards
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

    // 4. Modal handling (ADM-18 role modal and status modal)
    window.EduCenterModal = {
      open: function (modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
          modal.classList.add('active');
          document.body.style.overflow = 'hidden';
          // Trap focus on first focusable element
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
