/**
 * EduCenter ERP — Interactive Authentication UI Script
 * Handles password visibility, live password strength meter (4 bars & rules checklist),
 * role segmented selectors (STUDENT / PARENT), password match confirmation, countdown timer, and tab navigation.
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

    // 2. Register role selector buttons (STUDENT or PARENT per FR-001)
    var roleBtns = document.querySelectorAll('.role-segmented-btn');
    var roleInput = document.getElementById('roleCodeInput');

    if (roleBtns.length > 0) {
      roleBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
          var role = btn.getAttribute('data-role');
          roleBtns.forEach(function (b) { b.classList.remove('active'); });
          btn.classList.add('active');

          if (roleInput) {
            roleInput.value = role;
          }
        });
      });
    }

    // Legacy card selectors compatibility
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

    // 3. Live Password Strength Meter (Continuous bar + 4-Segment Bars & Rules Checklist)
    var passInputs = [
      document.getElementById('password'),
      document.getElementById('reg-pass'),
      document.getElementById('newPassword'),
      document.getElementById('reset-pass'),
      document.getElementById('new_pass')
    ].filter(Boolean);

    passInputs.forEach(function (pwdInput) {
      pwdInput.addEventListener('input', function () {
        var val = pwdInput.value || '';
        var hasLen = val.length >= 6;
        var hasUpper = /[A-Z]/.test(val);
        var hasNum = /[0-9]/.test(val);
        var hasSpecial = /[^A-Za-z0-9]/.test(val);

        // Update 4 rules checklist items
        updateChecklistRule('rule-len', hasLen);
        updateChecklistRule('rule-upper', hasUpper);
        updateChecklistRule('rule-num', hasNum);
        updateChecklistRule('rule-special', hasSpecial);

        // 4-bar segments
        var score = [hasLen, hasUpper, hasNum, hasSpecial].filter(Boolean).length;
        var bars = [
          document.getElementById('bar-1'),
          document.getElementById('bar-2'),
          document.getElementById('bar-3'),
          document.getElementById('bar-4')
        ];
        var strengthLabel = document.getElementById('pwd-strength-label') || document.getElementById('strength-label');

        bars.forEach(function (b) {
          if (b) b.style.backgroundColor = 'var(--border)';
        });

        if (strengthLabel) {
          if (val.length === 0) {
            strengthLabel.textContent = 'Chưa nhập';
            strengthLabel.style.color = 'var(--text-muted)';
          } else if (score <= 1) {
            strengthLabel.textContent = 'Yếu';
            strengthLabel.style.color = 'var(--danger)';
            if (bars[0]) bars[0].style.backgroundColor = 'var(--danger)';
          } else if (score === 2) {
            strengthLabel.textContent = 'Trung bình';
            strengthLabel.style.color = 'var(--warning)';
            if (bars[0]) bars[0].style.backgroundColor = 'var(--warning)';
            if (bars[1]) bars[1].style.backgroundColor = 'var(--warning)';
          } else if (score === 3) {
            strengthLabel.textContent = 'Khá';
            strengthLabel.style.color = 'var(--primary)';
            if (bars[0]) bars[0].style.backgroundColor = 'var(--primary)';
            if (bars[1]) bars[1].style.backgroundColor = 'var(--primary)';
            if (bars[2]) bars[2].style.backgroundColor = 'var(--primary)';
          } else {
            strengthLabel.textContent = 'Rất mạnh';
            strengthLabel.style.color = 'var(--success)';
            bars.forEach(function (b) {
              if (b) b.style.backgroundColor = 'var(--success)';
            });
          }
        }

        // Continuous progress bar fallback if present
        var strengthBar = document.getElementById('password-strength-bar');
        var strengthText = document.getElementById('password-strength-text');
        if (strengthBar && strengthText) {
          var percent = Math.min(100, Math.round((score / 4) * 100));
          var color = score <= 1 ? '#ef4444' : score === 2 ? '#f59e0b' : score === 3 ? '#3b82f6' : '#10b981';
          strengthBar.style.width = (val.length === 0 ? '0%' : percent + '%');
          strengthBar.style.backgroundColor = color;
          strengthText.textContent = (val.length === 0 ? '' : 'Độ bảo mật: ' + (score <= 1 ? 'Yếu' : score === 2 ? 'Trung bình' : score === 3 ? 'Khá' : 'Rất mạnh'));
          strengthText.style.color = color;
        }

        triggerMatchCheck();
      });
    });

    function updateChecklistRule(ruleId, isValid) {
      var elem = document.getElementById(ruleId);
      if (!elem) return;
      if (isValid) {
        elem.classList.add('valid');
        var icon = elem.querySelector('svg');
        if (icon) {
          icon.innerHTML = '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline>';
          icon.style.color = 'var(--success)';
        }
      } else {
        elem.classList.remove('valid');
        var icon = elem.querySelector('svg');
        if (icon) {
          icon.innerHTML = '<circle cx="12" cy="12" r="10"></circle>';
          icon.style.color = 'var(--text-muted)';
        }
      }
    }

    // 4. Password confirmation matching
    var confirmInputs = [
      document.getElementById('confirm-password'),
      document.getElementById('confirmPassword'),
      document.getElementById('confirmNewPassword'),
      document.getElementById('reg-confirm-pass'),
      document.getElementById('reset-confirm'),
      document.getElementById('confirm_pass')
    ].filter(Boolean);

    confirmInputs.forEach(function (confInput) {
      confInput.addEventListener('input', triggerMatchCheck);
    });

    function triggerMatchCheck() {
      var pwdInput = document.getElementById('password') || document.getElementById('reg-pass') ||
                     document.getElementById('newPassword') || document.getElementById('reset-pass') ||
                     document.getElementById('new_pass');
      var confInput = document.getElementById('confirm-password') || document.getElementById('confirmPassword') ||
                      document.getElementById('confirmNewPassword') || document.getElementById('reg-confirm-pass') ||
                      document.getElementById('reset-confirm') || document.getElementById('confirm_pass');
      var indicator = document.getElementById('match-indicator') || document.getElementById('match-status');
      var errorElem = document.getElementById('match-error');

      if (!pwdInput || !confInput) return;
      var pwd = pwdInput.value || '';
      var conf = confInput.value || '';

      if (conf.length > 0) {
        if (pwd === conf) {
          if (indicator) {
            indicator.style.opacity = '1';
            indicator.style.display = 'inline-flex';
          }
          if (errorElem) errorElem.style.display = 'none';
        } else {
          if (indicator) {
            indicator.style.opacity = '0';
          }
          if (errorElem) errorElem.style.display = 'inline-flex';
        }
      } else {
        if (indicator) indicator.style.opacity = '0';
        if (errorElem) errorElem.style.display = 'none';
      }
    }

    // 5. Countdown Timer for Reset Password (15 minutes token lifetime)
    var countdownEl = document.getElementById('countdown-timer');
    if (countdownEl) {
      var remaining = 14 * 60 + 59;
      var timerInterval = setInterval(function () {
        if (remaining <= 0) {
          clearInterval(timerInterval);
          countdownEl.textContent = '00:00';
          var tokenBadge = document.getElementById('token-valid-badge');
          if (tokenBadge) {
            tokenBadge.innerHTML = '<span style="color: var(--danger); font-weight: 700;">TOKEN HẾT HẠN</span>';
          }
          return;
        }
        remaining--;
        var m = Math.floor(remaining / 60);
        var s = remaining % 60;
        countdownEl.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
      }, 1000);
    }

    // 6. Tab Navigation for Profile & Settings
    var tabPills = document.querySelectorAll('.profile-tab-pill, [data-tab-target]');
    tabPills.forEach(function (pill) {
      pill.addEventListener('click', function (e) {
        e.preventDefault();
        var targetId = pill.getAttribute('data-tab-target');
        var targetPane = document.getElementById(targetId);
        if (!targetPane) return;

        tabPills.forEach(function (p) { p.classList.remove('active'); });
        pill.classList.add('active');

        var allPanes = document.querySelectorAll('.tab-pane');
        allPanes.forEach(function (pane) { pane.classList.remove('active'); });
        targetPane.classList.add('active');
      });
    });

    // 7. Accessible Modal handling
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
