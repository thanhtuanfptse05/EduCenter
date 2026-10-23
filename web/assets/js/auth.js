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

          var studentWrapper = document.getElementById('grade-student-wrapper');
          var parentWrapper = document.getElementById('grade-parent-wrapper');
          if (studentWrapper && parentWrapper) {
            var isParent = (role === 'PARENT');
            studentWrapper.style.display = isParent ? 'none' : 'block';
            parentWrapper.style.display = isParent ? 'block' : 'none';
            var studentSelect = document.getElementById('grade-student');
            var parentSelect = document.getElementById('grade-parent');
            if (studentSelect) studentSelect.disabled = isParent;
            if (parentSelect) parentSelect.disabled = !isParent;
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
          var lblEmpty = strengthLabel.getAttribute('data-empty') || 'Ch\u01B0a nh\u1EADp';
          var lblWeak = strengthLabel.getAttribute('data-weak') || 'Y\u1EBFu';
          var lblMed = strengthLabel.getAttribute('data-medium') || 'Trung b\u00ECnh';
          var lblGood = strengthLabel.getAttribute('data-good') || 'Kh\u00E1';
          var lblStrong = strengthLabel.getAttribute('data-strong') || 'R\u1EA5t m\u1EA1nh';

          if (val.length === 0) {
            strengthLabel.textContent = lblEmpty;
            strengthLabel.style.color = 'var(--text-muted)';
          } else if (score <= 1) {
            strengthLabel.textContent = lblWeak;
            strengthLabel.style.color = 'var(--danger)';
            if (bars[0]) bars[0].style.backgroundColor = 'var(--danger)';
          } else if (score === 2) {
            strengthLabel.textContent = lblMed;
            strengthLabel.style.color = 'var(--warning)';
            if (bars[0]) bars[0].style.backgroundColor = 'var(--warning)';
            if (bars[1]) bars[1].style.backgroundColor = 'var(--warning)';
          } else if (score === 3) {
            strengthLabel.textContent = lblGood;
            strengthLabel.style.color = 'var(--primary)';
            if (bars[0]) bars[0].style.backgroundColor = 'var(--primary)';
            if (bars[1]) bars[1].style.backgroundColor = 'var(--primary)';
            if (bars[2]) bars[2].style.backgroundColor = 'var(--primary)';
          } else {
            strengthLabel.textContent = lblStrong;
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
          var curLabel = (val.length === 0 ? '' : (score <= 1 ? 'Y\u1EBFu' : score === 2 ? 'Trung b\u00ECnh' : score === 3 ? 'Kh\u00E1' : 'R\u1EA5t m\u1EA1nh'));
          strengthText.textContent = (val.length === 0 ? '' : '\u0110\u1ED9 b\u1EA3o m\u1EADt: ' + curLabel);
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
            tokenBadge.innerHTML = '<span style="color: var(--danger); font-weight: 700;">TOKEN H\\u1EBE\\u0054 H\\u1EA0\\u004E</span>';
          }
          var expiredCard = document.getElementById('token-expired-card');
          var resetForm = document.getElementById('reset-password-form') || document.querySelector('[data-reset-form]');
          if (expiredCard) {
            expiredCard.style.display = 'flex';
          }
          if (resetForm) {
            resetForm.style.opacity = '0.35';
            resetForm.style.pointerEvents = 'none';
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

    // 8. Avatar Studio: Live preview, auto-normalize, preset selection, clipboard paste, clear
    var avatarInput = document.getElementById('prof-avatar');
    var headerAvatarImg = document.getElementById('headerOverviewAvatarImg');
    var headerAvatarInitial = document.getElementById('headerOverviewAvatarInitial');
    var statusBadge = document.getElementById('avatarStatusBadge');
    var btnPaste = document.getElementById('btnPasteAvatar');
    var btnClear = document.getElementById('btnClearAvatar');
    var presetBtns = document.querySelectorAll('.avatar-preset-btn');

    if (avatarInput) {
      function normalizeUrl(url) {
        if (!url) return '';
        var t = url.trim();
        if (!t) return '';
        if (t.startsWith('//')) return 'https:' + t;
        if (!t.startsWith('http://') && !t.startsWith('https://') && !t.startsWith('/') && !t.startsWith('data:image/')) {
          if (t.indexOf('.') !== -1 && t.indexOf(' ') === -1) {
            return 'https://' + t;
          }
        }
        return t;
      }

      function resolveBrowserUrl(url) {
        if (!url) return '';
        var t = normalizeUrl(url);
        if (t.startsWith('http://') || t.startsWith('https://') || t.startsWith('data:') || t.startsWith('blob:')) {
          return t;
        }
        var ctx = window.location.pathname.split('/')[1];
        if (ctx && ctx !== 'profile' && ctx !== 'login' && ctx !== 'courses' && ctx !== 'assets') {
          var prefix = '/' + ctx;
          if (t.startsWith('/') && !t.startsWith(prefix + '/')) {
            return prefix + t;
          }
        }
        return t;
      }

      function updateAvatarPreview(url) {
        var norm = normalizeUrl(url);
        var browserUrl = resolveBrowserUrl(norm);
        var previewImg = document.getElementById('avatarPreviewImg');
        var previewInitials = document.getElementById('avatarPreviewInitials');

        // Check matching preset button
        presetBtns.forEach(function (b) {
          var bUrl = b.getAttribute('data-url');
          if (bUrl && (bUrl === norm || bUrl === (url || '').trim())) {
            b.classList.add('active');
          } else {
            b.classList.remove('active');
          }
        });

        if (!norm) {
          if (previewImg) previewImg.style.display = 'none';
          if (previewInitials) previewInitials.style.display = 'flex';
          if (headerAvatarImg) headerAvatarImg.style.display = 'none';
          if (headerAvatarInitial) headerAvatarInitial.style.display = 'inline-flex';
          if (statusBadge) {
            statusBadge.className = 'avatar-status-pill neutral';
            statusBadge.textContent = 'D\u00F9ng ch\u1EEF c\u00E1i m\u1EB7c \u0111\u1ECBnh';
          }
          return;
        }

        // Test loading the image
        var testImg = new Image();
        testImg.onload = function () {
          if (previewImg) {
            previewImg.src = browserUrl;
            previewImg.style.display = 'block';
          }
          if (previewInitials) previewInitials.style.display = 'none';
          if (headerAvatarImg) {
            headerAvatarImg.src = browserUrl;
            headerAvatarImg.style.display = 'block';
          }
          if (headerAvatarInitial) headerAvatarInitial.style.display = 'none';
          if (statusBadge) {
            statusBadge.className = 'avatar-status-pill valid';
            statusBadge.innerHTML = '<svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width:12px;height:12px;"><polyline points="20 6 9 17 4 12"></polyline></svg> \u1EA3nh h\u1EE3p l\u1EC7';
          }
        };
        testImg.onerror = function () {
          if (previewImg) previewImg.style.display = 'none';
          if (previewInitials) previewInitials.style.display = 'flex';
          if (headerAvatarImg) headerAvatarImg.style.display = 'none';
          if (headerAvatarInitial) headerAvatarInitial.style.display = 'inline-flex';
          if (statusBadge) {
            statusBadge.className = 'avatar-status-pill error';
            statusBadge.textContent = 'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c \u1EA3nh, d\u00F9ng ch\u1EEF c\u00E1i';
          }
        };
        testImg.src = browserUrl;
      }

      // Input event listener
      avatarInput.addEventListener('input', function () {
        updateAvatarPreview(avatarInput.value);
      });

      avatarInput.addEventListener('blur', function () {
        var norm = normalizeUrl(avatarInput.value);
        if (norm && norm !== avatarInput.value) {
          avatarInput.value = norm;
        }
      });

      // Preset buttons click
      presetBtns.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
          e.preventDefault();
          var chosenUrl = btn.getAttribute('data-url');
          avatarInput.value = chosenUrl;
          updateAvatarPreview(chosenUrl);
        });
      });

      // Clear button
      if (btnClear) {
        btnClear.addEventListener('click', function (e) {
          e.preventDefault();
          avatarInput.value = '';
          updateAvatarPreview('');
          avatarInput.focus();
        });
      }

      // Paste button
      if (btnPaste) {
        btnPaste.addEventListener('click', function (e) {
          e.preventDefault();
          if (navigator.clipboard && navigator.clipboard.readText) {
            navigator.clipboard.readText().then(function (text) {
              if (text) {
                avatarInput.value = text.trim();
                updateAvatarPreview(text.trim());
              }
            }).catch(function () {
              avatarInput.focus();
              avatarInput.select();
            });
          } else {
            avatarInput.focus();
            avatarInput.select();
          }
        });
      }

      // Initial run if already has value
      if (avatarInput.value) {
        updateAvatarPreview(avatarInput.value);
      }
    }
  });
})();
