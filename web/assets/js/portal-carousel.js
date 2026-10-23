/**
 * EduCenter ERP — Interactive Drag & Touch Swipe Carousel Engine
 * Vanilla JavaScript (Zero external dependencies).
 * Supports mouse drag, touch swipe, prev/next navigation, and pagination dots.
 */
(function () {
  'use strict';

  function initCarousel(wrapper) {
    if (!wrapper) return;

    const viewport = wrapper.querySelector('.carousel-viewport');
    const track = wrapper.querySelector('.carousel-track');
    const prevBtn = wrapper.querySelector('.carousel-btn-prev');
    const nextBtn = wrapper.querySelector('.carousel-btn-next');
    const dotsContainer = wrapper.querySelector('.carousel-dots');
    const cards = track ? Array.from(track.querySelectorAll('.carousel-card')) : [];

    if (!viewport || !track || cards.length === 0) return;

    let isDown = false;
    let startX = 0;
    let scrollStart = 0;
    let hasDragged = false;
    let activeIndex = 0;

    // Build pagination dots if container exists
    if (dotsContainer) {
      dotsContainer.innerHTML = '';
      cards.forEach((_, idx) => {
        const dot = document.createElement('button');
        dot.type = 'button';
        dot.className = 'carousel-dot' + (idx === 0 ? ' active' : '');
        dot.setAttribute('aria-label', 'Chuyển đến mục ' + (idx + 1));
        dot.addEventListener('click', () => {
          scrollToIndex(idx);
        });
        dotsContainer.appendChild(dot);
      });
    }

    const dots = dotsContainer ? Array.from(dotsContainer.querySelectorAll('.carousel-dot')) : [];

    function getCardWidth() {
      const card = cards[0];
      if (!card) return 300;
      const style = window.getComputedStyle(track);
      const gap = parseFloat(style.gap) || 20;
      return card.offsetWidth + gap;
    }

    function updateNavState() {
      const maxScroll = viewport.scrollWidth - viewport.clientWidth;
      const currentScroll = viewport.scrollLeft;

      if (prevBtn) {
        prevBtn.disabled = currentScroll <= 2;
        prevBtn.setAttribute('aria-disabled', prevBtn.disabled ? 'true' : 'false');
      }
      if (nextBtn) {
        nextBtn.disabled = currentScroll >= maxScroll - 2;
        nextBtn.setAttribute('aria-disabled', nextBtn.disabled ? 'true' : 'false');
      }

      // Update active dot
      const cardW = getCardWidth();
      const newIndex = Math.min(cards.length - 1, Math.max(0, Math.round(currentScroll / cardW)));
      if (newIndex !== activeIndex) {
        activeIndex = newIndex;
        dots.forEach((d, i) => {
          d.classList.toggle('active', i === activeIndex);
        });
      }
    }

    function scrollToIndex(idx) {
      const cardW = getCardWidth();
      viewport.scrollTo({
        left: idx * cardW,
        behavior: 'smooth'
      });
    }

    if (prevBtn) {
      prevBtn.addEventListener('click', (e) => {
        e.preventDefault();
        const cardW = getCardWidth();
        viewport.scrollBy({
          left: -cardW,
          behavior: 'smooth'
        });
      });
    }

    if (nextBtn) {
      nextBtn.addEventListener('click', (e) => {
        e.preventDefault();
        const cardW = getCardWidth();
        viewport.scrollBy({
          left: cardW,
          behavior: 'smooth'
        });
      });
    }

    // Mouse drag handlers
    viewport.addEventListener('mousedown', (e) => {
      // Don't drag if clicking a button or link explicitly
      if (e.target.closest('button') && !e.target.closest('.carousel-card')) return;

      isDown = true;
      hasDragged = false;
      viewport.classList.add('is-dragging');
      startX = e.pageX - viewport.offsetLeft;
      scrollStart = viewport.scrollLeft;
    });

    window.addEventListener('mouseup', () => {
      if (!isDown) return;
      isDown = false;
      viewport.classList.remove('is-dragging');
      setTimeout(() => { hasDragged = false; }, 50);
    });

    viewport.addEventListener('mouseleave', () => {
      if (!isDown) return;
      isDown = false;
      viewport.classList.remove('is-dragging');
      setTimeout(() => { hasDragged = false; }, 50);
    });

    viewport.addEventListener('mousemove', (e) => {
      if (!isDown) return;
      e.preventDefault();
      const x = e.pageX - viewport.offsetLeft;
      const walk = (x - startX) * 1.3;
      if (Math.abs(walk) > 4) {
        hasDragged = true;
      }
      viewport.scrollLeft = scrollStart - walk;
    });

    // Prevent click on links inside cards if dragged
    track.addEventListener('click', (e) => {
      if (hasDragged) {
        e.preventDefault();
        e.stopPropagation();
      }
    }, true);

    // Scroll listener for buttons and dots
    let scrollTimeout;
    viewport.addEventListener('scroll', () => {
      if (scrollTimeout) cancelAnimationFrame(scrollTimeout);
      scrollTimeout = requestAnimationFrame(updateNavState);
    }, { passive: true });

    // Initial check
    updateNavState();
    window.addEventListener('resize', updateNavState);
  }

  // Initialize all carousels on page load
  function initAll() {
    document.querySelectorAll('.portal-carousel').forEach(initCarousel);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAll);
  } else {
    initAll();
  }

  window.EduCenterCarousel = {
    init: initCarousel,
    initAll: initAll
  };
})();
