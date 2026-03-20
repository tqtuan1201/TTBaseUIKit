/**
 * TTBaseUIKit Docs — Homepage Animations (Enhanced)
 * Premium animations: particles, parallax, typing, counter, scroll reveal, 3D tilt, magnetic
 * Zero external deps — pure vanilla JS + CSS
 * [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
 */

const Homepage = {

    /* ═══════════════════════════════════════════
     * §1  PARTICLE CANVAS (Enhanced)
     * ═══════════════════════════════════════════ */
    particles: {
        canvas: null,
        ctx: null,
        dots: [],
        mouse: { x: -1000, y: -1000 },
        raf: null,
        COUNT: 55,
        MAX_DIST: 140,

        init() {
            if (window.innerWidth < 768) return;
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

            this.canvas = document.getElementById('hero-particles');
            if (!this.canvas) return;

            this.ctx = this.canvas.getContext('2d');
            this.resize();
            this.spawn();
            this.listen();
            this.loop();
        },

        resize() {
            const hero = this.canvas.parentElement;
            this.canvas.width = hero.offsetWidth;
            this.canvas.height = hero.offsetHeight;
        },

        spawn() {
            this.dots = [];
            for (let i = 0; i < this.COUNT; i++) {
                this.dots.push({
                    x: Math.random() * this.canvas.width,
                    y: Math.random() * this.canvas.height,
                    vx: (Math.random() - 0.5) * 0.5,
                    vy: (Math.random() - 0.5) * 0.5,
                    r: Math.random() * 2.5 + 0.8,       // Varied sizes
                    opacity: Math.random() * 0.5 + 0.25,
                    pulse: Math.random() * Math.PI * 2   // Phase offset for pulsing
                });
            }
        },

        listen() {
            const hero = this.canvas.parentElement;
            hero.addEventListener('mousemove', (e) => {
                const rect = this.canvas.getBoundingClientRect();
                this.mouse.x = e.clientX - rect.left;
                this.mouse.y = e.clientY - rect.top;
            });
            hero.addEventListener('mouseleave', () => {
                this.mouse.x = -1000;
                this.mouse.y = -1000;
            });

            let resizeTimer;
            window.addEventListener('resize', () => {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(() => {
                    this.resize();
                    this.spawn();
                }, 200);
            });
        },

        loop() {
            const isDark = document.documentElement.classList.contains('dark');
            const dotColor = isDark ? '148, 163, 184' : '59, 130, 246';
            const lineColor = isDark ? '100, 116, 139' : '147, 197, 253';
            const time = performance.now() * 0.001;

            this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

            this.dots.forEach((d, i) => {
                // Move
                d.x += d.vx;
                d.y += d.vy;

                // Bounce
                if (d.x < 0 || d.x > this.canvas.width) d.vx *= -1;
                if (d.y < 0 || d.y > this.canvas.height) d.vy *= -1;

                // Mouse interaction — attract gently + repel when close
                const dx = d.x - this.mouse.x;
                const dy = d.y - this.mouse.y;
                const dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 80) {
                    // Repel when very close
                    d.x += dx * 0.03;
                    d.y += dy * 0.03;
                } else if (dist < 200) {
                    // Gentle attraction when in range
                    d.x -= dx * 0.003;
                    d.y -= dy * 0.003;
                }

                // Pulsing opacity
                const pulseOp = d.opacity + Math.sin(time * 1.5 + d.pulse) * 0.1;

                // Draw dot with glow in dark mode
                if (isDark && d.r > 1.5) {
                    this.ctx.shadowBlur = 8;
                    this.ctx.shadowColor = `rgba(${dotColor}, ${pulseOp * 0.5})`;
                }
                this.ctx.beginPath();
                this.ctx.arc(d.x, d.y, d.r, 0, Math.PI * 2);
                this.ctx.fillStyle = `rgba(${dotColor}, ${pulseOp})`;
                this.ctx.fill();
                this.ctx.shadowBlur = 0;

                // Connect nearby dots
                for (let j = i + 1; j < this.dots.length; j++) {
                    const d2 = this.dots[j];
                    const ddx = d.x - d2.x;
                    const ddy = d.y - d2.y;
                    const dd = Math.sqrt(ddx * ddx + ddy * ddy);
                    if (dd < this.MAX_DIST) {
                        const alpha = (1 - dd / this.MAX_DIST) * 0.18;
                        this.ctx.beginPath();
                        this.ctx.moveTo(d.x, d.y);
                        this.ctx.lineTo(d2.x, d2.y);
                        this.ctx.strokeStyle = `rgba(${lineColor}, ${alpha})`;
                        this.ctx.lineWidth = 0.6;
                        this.ctx.stroke();
                    }
                }
            });

            this.raf = requestAnimationFrame(() => this.loop());
        },

        destroy() {
            if (this.raf) cancelAnimationFrame(this.raf);
        }
    },

    /* ═══════════════════════════════════════════
     * §2  MOUSE PARALLAX (Hero)
     * ═══════════════════════════════════════════ */
    parallax: {
        _raf: null,
        init() {
            if (window.innerWidth < 768) return;
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

            const hero = document.querySelector('.hero-gradient');
            const content = document.querySelector('.hero-content');
            if (!hero || !content) return;

            let targetX = 0, targetY = 0, currentX = 0, currentY = 0;

            hero.addEventListener('mousemove', (e) => {
                const rect = hero.getBoundingClientRect();
                targetX = ((e.clientX - rect.left) / rect.width - 0.5) * -8;
                targetY = ((e.clientY - rect.top) / rect.height - 0.5) * -6;
            });

            hero.addEventListener('mouseleave', () => {
                targetX = 0; targetY = 0;
            });

            const lerp = () => {
                currentX += (targetX - currentX) * 0.08;
                currentY += (targetY - currentY) * 0.08;
                content.style.transform = `translate(${currentX}px, ${currentY}px)`;
                this._raf = requestAnimationFrame(lerp);
            };
            lerp();
        },
        destroy() {
            if (this._raf) cancelAnimationFrame(this._raf);
        }
    },

    /* ═══════════════════════════════════════════
     * §3  TYPING EFFECT
     * ═══════════════════════════════════════════ */
    typing: {
        el: null,
        phrases: [
            'Build iOS Apps Faster.',
            '100+ Production-Ready Components.',
            'AI Agent Compatible.',
            'UIKit & SwiftUI Ready.',
            'Clean Architecture Built-In.'
        ],
        phraseIdx: 0,
        charIdx: 0,
        isDeleting: false,
        timer: null,

        init() {
            this.el = document.getElementById('typing-text');
            if (!this.el) return;
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
                this.el.textContent = this.phrases[0];
                return;
            }
            this.tick();
        },

        tick() {
            const phrase = this.phrases[this.phraseIdx];

            if (this.isDeleting) {
                this.charIdx--;
            } else {
                this.charIdx++;
            }

            this.el.textContent = phrase.substring(0, this.charIdx);

            let delay = this.isDeleting ? 25 : 55;

            if (!this.isDeleting && this.charIdx === phrase.length) {
                delay = 2200;
                this.isDeleting = true;
            } else if (this.isDeleting && this.charIdx === 0) {
                this.isDeleting = false;
                this.phraseIdx = (this.phraseIdx + 1) % this.phrases.length;
                delay = 350;
            }

            this.timer = setTimeout(() => this.tick(), delay);
        },

        destroy() {
            if (this.timer) clearTimeout(this.timer);
        }
    },

    /* ═══════════════════════════════════════════
     * §4  NUMBER COUNTER (Spring easing)
     * ═══════════════════════════════════════════ */
    counter: {
        animated: false,

        init() {
            const statsSection = document.querySelector('.stats-grid');
            if (!statsSection) return;

            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
                return;
            }

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting && !this.animated) {
                        this.animated = true;
                        this.animateAll(statsSection);
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.3 });

            observer.observe(statsSection);
        },

        animateAll(container) {
            container.querySelectorAll('.stat-number').forEach((el, i) => {
                const text = el.textContent.trim();
                const hasPlus = text.includes('+');
                const target = parseInt(text.replace(/[^0-9]/g, ''), 10);
                if (isNaN(target)) return;

                el.textContent = '0' + (hasPlus ? '+' : '');

                setTimeout(() => {
                    this.countUp(el, 0, target, hasPlus, 1400);
                }, i * 150); // tighter stagger
            });
        },

        countUp(el, current, target, hasPlus, duration) {
            const start = performance.now();
            const step = (now) => {
                const elapsed = now - start;
                const progress = Math.min(elapsed / duration, 1);
                // Spring-like ease-out
                const eased = 1 - Math.pow(1 - progress, 4);
                const value = Math.round(eased * target);
                el.textContent = value + (hasPlus ? '+' : '');

                if (progress < 1) {
                    requestAnimationFrame(step);
                } else {
                    el.textContent = target + (hasPlus ? '+' : '');
                    el.classList.add('counter-done');
                }
            };
            requestAnimationFrame(step);
        }
    },

    /* ═══════════════════════════════════════════
     * §5  SCROLL REVEAL (Direction variety)
     * ═══════════════════════════════════════════ */
    scrollReveal: {
        init() {
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
                document.querySelectorAll('[data-reveal]').forEach(el => el.classList.add('revealed'));
                return;
            }

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const el = entry.target;
                        el.classList.add('revealed');

                        // Stagger children with smoother cascade
                        if (el.hasAttribute('data-reveal-stagger')) {
                            const children = el.querySelectorAll('[data-reveal-child]');
                            children.forEach((child, i) => {
                                child.style.transitionDelay = `${i * 100}ms`;
                                child.classList.add('revealed');
                            });
                        }

                        observer.unobserve(el);
                    }
                });
            }, {
                threshold: 0.08,
                rootMargin: '0px 0px -40px 0px'
            });

            document.querySelectorAll('[data-reveal]').forEach(el => observer.observe(el));
        }
    },

    /* ═══════════════════════════════════════════
     * §6  3D CARD TILT
     * ═══════════════════════════════════════════ */
    cardTilt: {
        init() {
            if (window.innerWidth < 768) return;
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

            document.querySelectorAll('[data-tilt]').forEach(card => {
                card.addEventListener('mousemove', (e) => {
                    const rect = card.getBoundingClientRect();
                    const x = (e.clientX - rect.left) / rect.width;
                    const y = (e.clientY - rect.top) / rect.height;
                    const rotateX = (0.5 - y) * 10;
                    const rotateY = (x - 0.5) * 10;

                    card.style.transform = `perspective(800px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-4px) scale(1.02)`;
                    card.style.transition = 'transform 0.1s ease-out';

                    // Glare effect
                    const glare = card.querySelector('.card-glare');
                    if (glare) {
                        glare.style.background = `radial-gradient(circle at ${x * 100}% ${y * 100}%, rgba(255,255,255,0.18) 0%, transparent 55%)`;
                    }
                });

                card.addEventListener('mouseleave', () => {
                    card.style.transform = '';
                    card.style.transition = 'transform 0.5s cubic-bezier(0.23, 1, 0.32, 1)';
                    const glare = card.querySelector('.card-glare');
                    if (glare) glare.style.background = '';
                });
            });
        }
    },

    /* ═══════════════════════════════════════════
     * §7  CTA BUTTON RIPPLE
     * ═══════════════════════════════════════════ */
    ripple: {
        init() {
            document.querySelectorAll('.btn-ripple').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const rect = btn.getBoundingClientRect();
                    const ripple = document.createElement('span');
                    ripple.className = 'ripple-effect';
                    ripple.style.left = `${e.clientX - rect.left}px`;
                    ripple.style.top = `${e.clientY - rect.top}px`;
                    btn.appendChild(ripple);
                    ripple.addEventListener('animationend', () => ripple.remove());
                });
            });
        }
    },

    /* ═══════════════════════════════════════════
     * §8  HERO WORD STAGGER (Tighter timing)
     * ═══════════════════════════════════════════ */
    heroStagger: {
        init() {
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

            document.querySelectorAll('.hero-word').forEach((word, i) => {
                word.style.animationDelay = `${0.1 + i * 0.08}s`;
            });
        }
    },

    /* ═══════════════════════════════════════════
     * §9  MAGNETIC BUTTONS
     * ═══════════════════════════════════════════ */
    magneticBtns: {
        init() {
            if (window.innerWidth < 768) return;
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

            document.querySelectorAll('.btn-magnetic').forEach(btn => {
                btn.addEventListener('mousemove', (e) => {
                    const rect = btn.getBoundingClientRect();
                    const cx = rect.left + rect.width / 2;
                    const cy = rect.top + rect.height / 2;
                    const dx = (e.clientX - cx) * 0.15;
                    const dy = (e.clientY - cy) * 0.15;
                    btn.style.transform = `translate(${dx}px, ${dy}px) scale(1.04)`;
                });

                btn.addEventListener('mouseleave', () => {
                    btn.style.transform = '';
                });
            });
        }
    },

    /* ═══════════════════════════════════════════
     * §10 FLOATING CODE SNIPPETS
     * ═══════════════════════════════════════════ */
    floatingCode: {
        snippets: [
            'setupViewCodable()',
            'TTBaseUIButton(type: .DEFAULT)',
            'BaseSUIView { }',
            'ViewConfig.buttonBgDef',
            'onTouchHandler = { }',
            'SizeConfig.H_BUTTON',
            'import TTBaseUIKit',
            '.setFullContraints()',
            'FontConfig.TITLE_H',
            'TTBaseSUIText(.TITLE)'
        ],

        init() {
            if (window.innerWidth < 768) return;
            if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

            const hero = document.querySelector('.hero-gradient');
            if (!hero) return;

            this.snippets.forEach((code, i) => {
                const el = document.createElement('span');
                el.className = 'hero-float-code';
                el.textContent = code;
                el.style.setProperty('--float-duration', `${16 + Math.random() * 12}s`);
                el.style.setProperty('--float-delay', `${i * 2.5}s`);
                el.style.left = `${5 + Math.random() * 88}%`;
                el.style.bottom = `-${20 + Math.random() * 30}px`;
                hero.appendChild(el);
            });
        }
    },

    /* ═══════════════════════════════════════════
     * INIT
     * ═══════════════════════════════════════════ */
    init() {
        this.particles.init();
        this.parallax.init();
        this.typing.init();
        this.counter.init();
        this.scrollReveal.init();
        this.cardTilt.init();
        this.ripple.init();
        this.heroStagger.init();
        this.magneticBtns.init();
        this.floatingCode.init();
    }
};

document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => Homepage.init(), 80);
});
