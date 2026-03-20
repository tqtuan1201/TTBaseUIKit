/**
 * TTBaseUIKit Docs — Main JS
 * Page transitions & utilities
 * [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
 *
 * NOTE: Theme init is handled by theme-init.js loaded in <head>.
 * Do NOT duplicate theme logic here.
 */

/* ── Page Transition System ── */
const PageTransition = {

    /** Trigger page-enter animation on load */
    enter() {
        // Ensure dark bg stays locked (theme-init.js set it, but CSS might override)
        // We clear the inline style AFTER CSS has applied dark background via .dark class
        const html = document.documentElement;
        if (html.classList.contains('dark')) {
            // Keep bg locked until paint is done, then let CSS take over
            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    // Two rAFs = after browser has painted at least one frame with dark CSS
                    html.style.backgroundColor = '';
                    html.style.colorScheme = '';
                });
            });
        } else {
            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    html.style.backgroundColor = '';
                    html.style.colorScheme = '';
                });
            });
        }

        // Page enter animation on main content
        document.body.classList.add('page-entering');
        const main = document.querySelector('main');
        if (main) {
            main.addEventListener('animationend', () => {
                document.body.classList.remove('page-entering');
            }, { once: true });
        } else {
            setTimeout(() => document.body.classList.remove('page-entering'), 600);
        }
    },

    /**
     * Navigate to a URL with a smooth CSS exit animation.
     *
     * We deliberately do NOT use document.startViewTransition() for cross-document
     * navigation. Calling startViewTransition(() => { window.location.href = url })
     * is a misuse of the API — the callback must do synchronous DOM manipulation,
     * not trigger a full page load. This misuse causes the browser to composite a
     * white layer under the transition snapshot, which appears as a flash in dark mode.
     *
     * Instead we use a simple, reliable CSS animation on <main> only.
     */
    navigate(url) {
        // Respect user preference for reduced motion
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            window.location.href = url;
            return;
        }

        // Lock background color before navigation so the new page inherits it
        // via theme-init.js. This ensures NO white flash on the outgoing page.
        const isDark = document.documentElement.classList.contains('dark');
        if (isDark) {
            document.documentElement.style.backgroundColor = '#0b1120';
        }

        // JS exit animation → navigate
        document.body.classList.add('page-exiting');
        const main = document.querySelector('main');

        const doNav = () => { window.location.href = url; };

        if (main) {
            // Navigate when exit animation finishes (or after timeout as safety)
            main.addEventListener('animationend', doNav, { once: true });
            setTimeout(doNav, 300); // safety fallback
        } else {
            setTimeout(doNav, 200);
        }
    },

    /** Intercept all internal link clicks for animated navigation */
    interceptLinks() {
        document.addEventListener('click', (e) => {
            const anchor = e.target.closest('a');
            if (!anchor) return;

            const href = anchor.getAttribute('href');
            if (!href) return;

            // Skip: external, hash-only, special protocols, new-tab, modifier keys
            if (
                href.startsWith('http') ||
                href.startsWith('//') ||
                href.startsWith('#') ||
                href.startsWith('mailto:') ||
                href.startsWith('javascript:') ||
                anchor.target === '_blank' ||
                anchor.hasAttribute('download') ||
                e.metaKey || e.ctrlKey || e.shiftKey || e.altKey
            ) return;

            if (href === '#') return;

            e.preventDefault();

            const resolvedUrl = new URL(href, window.location.href).href;

            // Don't animate same-page navigation
            if (resolvedUrl === window.location.href) return;

            this.navigate(resolvedUrl);
        }, true); // capture phase catches all links including header/sidebar
    }
};

document.addEventListener('DOMContentLoaded', () => {
    PageTransition.enter();
    PageTransition.interceptLinks();
});
