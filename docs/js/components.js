/**
 * TTBaseUIKit Docs — Shared Components Renderer
 * Renders header, sidebar, and footer across all pages.
 * [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
 */

const SITE = {
    name: 'TTBaseUIKit',
    version: '2.1.0',
    iosTarget: 'iOS 14+',
    github: 'https://github.com/tqtuan1201/TTBaseUIKit',
    author: 'https://tqtuan1201.github.io/'
};

/* ── Navigation Structure ── */
const NAV_SECTIONS = [
    {
        title: 'Introduction',
        items: [
            { label: 'Getting Started', href: 'getting-started.html', icon: '📖' },
            { label: 'Apps Showcase', href: 'showcase.html', icon: '🚀' },
            { label: 'Project Demo', href: 'demo.html', icon: '🎬' },
            { label: 'Blog', href: 'blog.html', icon: '📝' }
        ]
    },
    {
        title: 'UIKit',
        items: [
            { label: 'All Components', href: 'uikit/index.html', icon: '🧱' },
            { label: 'Base Views', href: 'uikit/index.html#base-views', icon: '' },
            { label: 'Layout', href: 'uikit/index.html#layout', icon: '' },
            { label: 'Input', href: 'uikit/index.html#input', icon: '' },
            { label: 'Display', href: 'uikit/index.html#display', icon: '' },
            { label: 'Panels', href: 'uikit/index.html#panels', icon: '' },
            { label: 'ViewControllers', href: 'uikit/index.html#viewcontrollers', icon: '' },
            { label: 'Utilities', href: 'uikit/index.html#utilities', icon: '' }
        ]
    },
    {
        title: 'SwiftUI',
        items: [
            { label: 'All Components', href: 'swiftui/index.html', icon: '🎨' },
            { label: 'Base Views', href: 'swiftui/index.html#base-views', icon: '' },
            { label: 'Layout', href: 'swiftui/index.html#layout', icon: '' },
            { label: 'Navigation', href: 'swiftui/index.html#navigation', icon: '' },
            { label: 'Modifiers & Styles', href: 'swiftui/index.html#modifiers', icon: '' },
            { label: 'Animations', href: 'swiftui/index.html#animations', icon: '' },
            { label: 'Extensions', href: 'swiftui/index.html#extensions', icon: '' }
        ]
    },
    {
        title: 'AI Agents',
        items: [
            { label: 'Overview', href: 'ai-agents/index.html', icon: '✨' },
            { label: 'GitHub Copilot', href: 'ai-agents/copilot.html', icon: '' },
            { label: 'Claude Code', href: 'ai-agents/claude-code.html', icon: '' },
            { label: 'Xcode Agent Skills', href: 'ai-agents/xcode-agent-skills.html', icon: '' },
            { label: 'OpenAI Codex', href: 'ai-agents/codex.html', icon: '' },
            { label: 'Google Gemini', href: 'ai-agents/gemini.html', icon: '' }
        ]
    }
];

/**
 * Get the base path prefix for resolving URLs.
 * Pages at root level use '', subdirectory pages use '../'
 */
function getBase() {
    return window.TTBase || '';
}

/**
 * Resolve a nav href relative to current page depth.
 * All hrefs in NAV_SECTIONS are relative to docs root (no leading /).
 */
function resolveHref(href) {
    const base = getBase();
    if (base === '') return href;
    // base is '..' for subdirectory pages
    return base + '/' + href;
}

/* ── Detect active page ── */
function isActive(href) {
    const current = window.location.pathname;
    const hrefBase = href.split('#')[0];
    // Check if current path ends with the href base
    if (current.endsWith('/' + hrefBase) || current.endsWith(hrefBase)) return true;
    return false;
}

/* ── Render Header ── */
function renderHeader() {
    const el = document.getElementById('site-header');
    if (!el) return;

    el.innerHTML = `
    <header class="fixed top-0 z-50 w-full backdrop-blur transition-colors duration-500 border-b border-slate-900/10 dark:border-slate-50/[0.06] bg-white/95 dark:bg-slate-900/75" style="background-color: rgba(255,255,255,0.95);">
        <div class="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
            <div class="flex items-center gap-4">
                <button id="mobile-menu-btn" class="mobile-menu-btn lg:hidden" aria-label="Open navigation menu">
                    <svg id="menu-icon-open" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                    <svg id="menu-icon-close" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="display:none;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
                <a href="${resolveHref('index.html')}" class="flex items-center gap-2 text-xl font-bold dark:text-white" style="text-decoration: none;">
                    <span style="background: linear-gradient(to right, #3b82f6, #06b6d4); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">⚡</span> ${SITE.name}
                </a>
                <span class="hidden sm:inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200">v${SITE.version} • ${SITE.iosTarget}</span>
            </div>
            <div class="flex items-center gap-4">
                <nav class="hidden lg:flex gap-6 text-sm font-semibold text-slate-700 dark:text-slate-200">
                    <a href="${resolveHref('getting-started.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">Docs</a>
                    <a href="${resolveHref('uikit/index.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">UIKit</a>
                    <a href="${resolveHref('swiftui/index.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">SwiftUI</a>
                    <a href="${resolveHref('ai-agents/index.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">AI Agents</a>
                    <a href="${resolveHref('showcase.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">Showcase</a>
                    <a href="${resolveHref('demo.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">Demo</a>
                    <a href="${resolveHref('blog.html')}" class="hover:text-blue-500 transition-colors" style="text-decoration:none;">Blog</a>
                </nav>
                <button id="search-btn" class="search-btn-header flex items-center gap-2 px-3 py-1.5 text-sm text-slate-400 border border-slate-200 dark:border-slate-700 rounded-lg hover:border-blue-500 hover:text-blue-500 transition-colors" title="Search (⌘K)">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                    <span class="hidden sm:inline">Search</span>
                    <kbd class="hidden sm:inline-flex items-center px-1.5 py-0.5 text-xs bg-slate-100 dark:bg-slate-800 rounded">⌘K</kbd>
                </button>
                <div class="hidden lg:flex items-center gap-3 border-l pl-4 border-slate-200 dark:border-slate-800">
                    <a href="${SITE.github}" target="_blank" class="text-slate-400 hover:text-slate-500 dark:hover:text-slate-300 transition-colors" title="GitHub">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/></svg>
                    </a>
                    <button id="theme-toggle-desktop" class="text-slate-400 hover:text-slate-500 dark:hover:text-slate-300 transition-colors" title="Toggle theme">
                        <svg class="w-5 h-5 hidden dark:block" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                        <svg class="w-5 h-5 dark:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path></svg>
                    </button>
                </div>
            </div>
        </div>
    </header>`;

    // Apply dark mode styles inline
    if (document.documentElement.classList.contains('dark')) {
        const header = el.querySelector('header');
        if (header) header.style.backgroundColor = 'rgba(15,23,42,0.75)';
    }
}

/* ── Render Sidebar ── */
function renderSidebar() {
    const el = document.getElementById('site-sidebar');
    if (!el) return;

    let html = `<aside id="sidebar" class="hidden lg:block w-72 shrink-0 border-r border-slate-200 dark:border-slate-800 pt-6 pb-10 px-5 overflow-y-auto" style="position: sticky; top: 4rem; height: calc(100vh - 4rem); background: var(--bg-color);">
        <nav class="space-y-6 text-sm">`;

    NAV_SECTIONS.forEach(section => {
        html += `<div>
            <h3 class="font-semibold text-xs uppercase tracking-wider text-slate-400 dark:text-slate-500 mb-3 px-3">${section.title}</h3>
            <ul class="space-y-1">`;

        section.items.forEach(item => {
            const href = resolveHref(item.href);
            const active = isActive(item.href);
            const indent = item.icon === '' ? 'padding-left: 2rem;' : 'padding-left: 0.75rem;';
            const iconSpan = item.icon ? `<span class="mr-2">${item.icon}</span>` : '';
            const activeStyle = active
                ? 'color: #3b82f6; font-weight: 600; background: rgba(59,130,246,0.1); border-left: 3px solid #3b82f6;'
                : 'color: var(--text-secondary);';
            html += `<li><a href="${href}" style="${indent} ${activeStyle} display: block; padding-top: 0.375rem; padding-bottom: 0.375rem; border-radius: 0.5rem; text-decoration: none; transition: all 0.15s;" onmouseover="this.style.background='var(--card-hover-bg)'" onmouseout="this.style.background='${active ? 'rgba(59,130,246,0.1)' : 'transparent'}'">${iconSpan}${item.label}</a></li>`;
        });

        html += `</ul></div>`;
    });

    html += `</nav></aside>`;
    el.innerHTML = html;
}

/* ── Render Footer ── */
function renderFooter() {
    const el = document.getElementById('site-footer');
    if (!el) return;
    el.innerHTML = `
    <footer class="py-12 border-t border-slate-200 dark:border-slate-800" style="background: var(--bg-color);">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div>
                    <h4 class="font-bold text-slate-900 dark:text-white mb-3">TTBaseUIKit</h4>
                    <p class="text-sm text-slate-500 dark:text-slate-400">Build iOS apps faster with production-ready base views for UIKit & SwiftUI.</p>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 dark:text-white mb-3">Resources</h4>
                    <ul class="space-y-2 text-sm text-slate-500 dark:text-slate-400" style="list-style:none;padding:0;">
                        <li><a href="${SITE.github}" target="_blank" class="hover:text-blue-500 transition-colors" style="text-decoration:none;color:inherit;">GitHub Repository</a></li>
                        <li><a href="${SITE.author}" target="_blank" class="hover:text-blue-500 transition-colors" style="text-decoration:none;color:inherit;">Author Website</a></li>
                        <li><a href="${SITE.github}/releases" target="_blank" class="hover:text-blue-500 transition-colors" style="text-decoration:none;color:inherit;">Release Notes</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 dark:text-white mb-3">Community</h4>
                    <ul class="space-y-2 text-sm text-slate-500 dark:text-slate-400" style="list-style:none;padding:0;">
                        <li><a href="mailto:truongquangtuanit@gmail.com" class="hover:text-blue-500 transition-colors" style="text-decoration:none;color:inherit;">Contact Author</a></li>
                        <li><a href="https://tqtuan1201.github.io/posts/job/cv/ourteam/" target="_blank" class="hover:text-blue-500 transition-colors" style="text-decoration:none;color:inherit;">Meet Our Team</a></li>
                        <li><a href="https://tqtuan1201.github.io/portfolio/" target="_blank" class="hover:text-blue-500 transition-colors" style="text-decoration:none;color:inherit;">Portfolio</a></li>
                    </ul>
                </div>
            </div>
            <div class="mt-8 pt-8 border-t border-slate-200 dark:border-slate-800 text-center text-sm text-slate-400 dark:text-slate-500">
                <p>© ${new Date().getFullYear()} TTBaseUIKit. Built with ❤️ by Truong Quang Tuan • v${SITE.version} • ${SITE.iosTarget}</p>
            </div>
        </div>
    </footer>`;
}

/* ── Render Search Modal ── */
function renderSearchModal() {
    const existing = document.getElementById('search-modal');
    if (existing) return;
    const modal = document.createElement('div');
    modal.id = 'search-modal';
    modal.className = 'fixed inset-0 z-[100] hidden';
    modal.style.cssText = 'display:none;';
    modal.innerHTML = `
        <div class="search-modal-overlay absolute inset-0" onclick="closeSearch()"></div>
        <div class="search-modal-content relative max-w-2xl mx-auto mt-16 sm:mt-20 rounded-2xl overflow-hidden" style="background:var(--card-bg);">
            <div class="flex items-center px-4 gap-3" style="border-bottom:1px solid var(--border-color);">
                <svg class="w-5 h-5 text-slate-400 shrink-0 animate-float" style="animation-duration:2s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                <input id="search-input" type="text" placeholder="Search components, functions, utilities..." autocomplete="off" spellcheck="false" style="width:100%;padding:1rem 0.5rem;background:transparent;color:var(--text-color);border:none;outline:none;font-size:1.0625rem;font-weight:500;">
                <kbd style="padding:0.25rem 0.5rem;font-size:0.6875rem;background:var(--code-bg);color:var(--text-muted);border-radius:0.375rem;border:1px solid var(--border-color);font-family:'Inter',sans-serif;white-space:nowrap;">ESC</kbd>
            </div>
            <div id="search-results" style="max-height:26rem;overflow-y:auto;padding:0.5rem;scroll-behavior:smooth;"></div>
        </div>`;
    document.body.appendChild(modal);
}

/* ── Render Mobile Navigation Overlay ── */
function renderMobileNav() {
    const existing = document.getElementById('mobile-nav-overlay');
    if (existing) return;

    const overlay = document.createElement('div');
    overlay.id = 'mobile-nav-overlay';
    overlay.className = 'mobile-nav-overlay';

    let navHtml = '<nav class="mobile-nav-inner">';

    NAV_SECTIONS.forEach(section => {
        navHtml += `<div class="mobile-nav-section">`;
        navHtml += `<h3 class="mobile-nav-section-title">${section.title}</h3>`;
        navHtml += '<ul class="mobile-nav-list">';
        section.items.forEach(item => {
            const href = resolveHref(item.href);
            const active = isActive(item.href);
            const iconSpan = item.icon ? `<span class="mobile-nav-icon">${item.icon}</span>` : '';
            const activeClass = active ? ' mobile-nav-link-active' : '';
            const indent = item.icon === '' ? ' mobile-nav-link-indent' : '';
            navHtml += `<li><a href="${href}" class="mobile-nav-link${activeClass}${indent}">${iconSpan}<span>${item.label}</span></a></li>`;
        });
        navHtml += '</ul></div>';
    });

    // Bottom section: GitHub + Theme toggle
    const isDark = document.documentElement.classList.contains('dark');
    navHtml += `
    <div class="mobile-nav-bottom">
        <a href="${SITE.github}" target="_blank" class="mobile-nav-bottom-link">
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/></svg>
            <span>GitHub</span>
        </a>
        <button id="theme-toggle-mobile" class="mobile-nav-bottom-link" title="Toggle theme">
            <svg class="mobile-theme-sun w-5 h-5 hidden dark:block" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
            <svg class="mobile-theme-moon w-5 h-5 dark:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path></svg>
            <span>${isDark ? 'Light Mode' : 'Dark Mode'}</span>
        </button>
    </div>`;

    navHtml += '</nav>';
    overlay.innerHTML = navHtml;
    document.body.appendChild(overlay);
}

/* ── Search Controls ── */
function openSearch() {
    const modal = document.getElementById('search-modal');
    if (modal) {
        modal.style.display = 'block';
        modal.classList.remove('hidden');
        // Trigger initial empty state render
        const resultsEl = document.getElementById('search-results');
        if (resultsEl && typeof performSearch === 'function') {
            performSearch('');
        }
        requestAnimationFrame(() => {
            const input = document.getElementById('search-input');
            if (input) { input.value = ''; input.focus(); }
        });
    }
}
function closeSearch() {
    const modal = document.getElementById('search-modal');
    if (modal) {
        modal.style.display = 'none';
        modal.classList.add('hidden');
    }
}

/* ── Scroll to Top Button ── */
function renderScrollTop() {
    const btn = document.createElement('button');
    btn.id = 'scroll-top-btn';
    btn.style.cssText = 'position:fixed;bottom:1.5rem;right:1.5rem;z-index:50;width:2.5rem;height:2.5rem;background:#3b82f6;color:white;border-radius:9999px;border:none;cursor:pointer;box-shadow:0 4px 6px rgba(0,0,0,0.1);display:flex;align-items:center;justify-content:center;opacity:0;pointer-events:none;transition:all 0.3s;';
    btn.innerHTML = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"></path></svg>';
    btn.onclick = () => window.scrollTo({ top: 0, behavior: 'smooth' });
    btn.onmouseover = () => { btn.style.transform = 'translateY(-2px)'; btn.style.boxShadow = '0 8px 15px rgba(0,0,0,0.15)'; };
    btn.onmouseout = () => { btn.style.transform = ''; btn.style.boxShadow = '0 4px 6px rgba(0,0,0,0.1)'; };
    document.body.appendChild(btn);

    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            btn.style.opacity = '1';
            btn.style.pointerEvents = 'auto';
        } else {
            btn.style.opacity = '0';
            btn.style.pointerEvents = 'none';
        }
    });
}

/* ── Copy to Clipboard ── */
function addCopyButtons() {
    document.querySelectorAll('pre').forEach(pre => {
        if (pre.querySelector('.copy-btn')) return;
        const btn = document.createElement('button');
        btn.className = 'copy-btn';
        btn.textContent = 'Copy';
        btn.onclick = (e) => {
            e.stopPropagation();
            const code = pre.querySelector('code')?.textContent || pre.textContent;
            navigator.clipboard.writeText(code).then(() => {
                btn.textContent = 'Copied!';
                btn.style.background = '#16a34a';
                btn.style.color = 'white';
                setTimeout(() => {
                    btn.textContent = 'Copy';
                    btn.style.background = '';
                    btn.style.color = '';
                }, 2000);
            }).catch(() => {
                // Fallback for file:// protocol
                const textarea = document.createElement('textarea');
                textarea.value = code;
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand('copy');
                document.body.removeChild(textarea);
                btn.textContent = 'Copied!';
                setTimeout(() => { btn.textContent = 'Copy'; }, 2000);
            });
        };
        pre.style.position = 'relative';
        pre.appendChild(btn);
    });
}

/* ── Mobile Nav Controls ── */
function openMobileNav() {
    const overlay = document.getElementById('mobile-nav-overlay');
    const iconOpen = document.getElementById('menu-icon-open');
    const iconClose = document.getElementById('menu-icon-close');
    if (!overlay) return;

    overlay.style.display = 'block';
    document.body.style.overflow = 'hidden';
    // Toggle icons
    if (iconOpen) iconOpen.style.display = 'none';
    if (iconClose) iconClose.style.display = 'block';
    // Trigger animation
    requestAnimationFrame(() => {
        requestAnimationFrame(() => {
            overlay.classList.add('mobile-nav-open');
        });
    });
}

function closeMobileNav() {
    const overlay = document.getElementById('mobile-nav-overlay');
    const iconOpen = document.getElementById('menu-icon-open');
    const iconClose = document.getElementById('menu-icon-close');
    if (!overlay) return;

    overlay.classList.remove('mobile-nav-open');
    document.body.style.overflow = '';
    // Toggle icons
    if (iconOpen) iconOpen.style.display = 'block';
    if (iconClose) iconClose.style.display = 'none';
    // Hide after transition
    setTimeout(() => {
        if (!overlay.classList.contains('mobile-nav-open')) {
            overlay.style.display = 'none';
        }
    }, 350);
}

function toggleMobileNav() {
    const overlay = document.getElementById('mobile-nav-overlay');
    if (!overlay) return;
    const isOpen = overlay.classList.contains('mobile-nav-open');
    if (isOpen) {
        closeMobileNav();
    } else {
        openMobileNav();
    }
}

/* ── Theme Toggle Handler ── */
function handleThemeToggle() {
    document.documentElement.classList.toggle('dark');
    const isDark = document.documentElement.classList.contains('dark');
    localStorage.theme = isDark ? 'dark' : 'light';
    document.documentElement.style.backgroundColor = '';
    // Update header bg
    const header = document.querySelector('#site-header header');
    if (header) {
        header.style.backgroundColor = isDark ? 'rgba(15,23,42,0.75)' : 'rgba(255,255,255,0.95)';
    }
    // Update mobile theme label
    const mobileThemeLabel = document.querySelector('#theme-toggle-mobile span');
    if (mobileThemeLabel) {
        mobileThemeLabel.textContent = isDark ? 'Light Mode' : 'Dark Mode';
    }
}

/* ── Initialize ── */
function initComponents() {
    renderHeader();
    renderSidebar();
    renderFooter();
    renderSearchModal();
    renderMobileNav();
    renderScrollTop();

    setTimeout(() => {
        // Desktop theme toggle
        const themeBtnDesktop = document.getElementById('theme-toggle-desktop');
        if (themeBtnDesktop) {
            themeBtnDesktop.addEventListener('click', handleThemeToggle);
        }

        // Mobile theme toggle
        const themeBtnMobile = document.getElementById('theme-toggle-mobile');
        if (themeBtnMobile) {
            themeBtnMobile.addEventListener('click', handleThemeToggle);
        }

        // Mobile menu toggle
        const mobileBtn = document.getElementById('mobile-menu-btn');
        if (mobileBtn) {
            mobileBtn.addEventListener('click', toggleMobileNav);
        }

        // Close mobile nav on link click
        const mobileNavLinks = document.querySelectorAll('#mobile-nav-overlay .mobile-nav-link');
        mobileNavLinks.forEach(link => {
            link.addEventListener('click', () => {
                closeMobileNav();
            });
        });

        // Search
        const searchBtn = document.getElementById('search-btn');
        if (searchBtn) searchBtn.addEventListener('click', openSearch);

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
                e.preventDefault();
                openSearch();
            }
            if (e.key === 'Escape') {
                closeSearch();
                closeMobileNav();
            }
        });

        // Copy buttons
        addCopyButtons();
    }, 150);
}

// Auto-init on DOMContentLoaded
document.addEventListener('DOMContentLoaded', initComponents);
